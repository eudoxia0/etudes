"""In-memory HTTP backend for the vue-todo app.

Implements a tiny REST API on top of the standard library only:

  GET    /api/todos      -> list all todos
  POST   /api/todos      -> create a todo, body: {text, dueDate}
  PATCH  /api/todos/<id> -> partially update a todo, body: any of {text, done, dueDate}
  DELETE /api/todos/<id> -> delete a todo
"""

from __future__ import annotations

import json
import re
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

TODO_ID_RE = re.compile(r"^/api/todos/(\d+)$")

PATCHABLE_FIELDS = {"text", "done", "dueDate"}


def _seed_todos() -> list[dict[str, Any]]:
    return [
        {"id": 1, "text": "Reply to client email", "done": False, "dueDate": "today"},
        {"id": 2, "text": "Fix login page bug", "done": False, "dueDate": "today"},
        {"id": 3, "text": "Write unit tests", "done": True, "dueDate": "today"},
        {
            "id": 4,
            "text": "Prepare slides for standup",
            "done": False,
            "dueDate": "tomorrow",
        },
        {"id": 5, "text": "Review pull request", "done": False, "dueDate": "tomorrow"},
        {"id": 6, "text": "Renew gym membership", "done": False, "dueDate": None},
        {"id": 7, "text": "Read a book chapter", "done": False, "dueDate": None},
        {"id": 8, "text": "Water the plants", "done": True, "dueDate": None},
    ]


class TodoStore:
    """Thread-safe in-memory collection of todos. Data does not survive a restart."""

    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._todos: list[dict[str, Any]] = _seed_todos()
        self._next_id = len(self._todos) + 1

    def list(self) -> list[dict[str, Any]]:
        with self._lock:
            return [dict(todo) for todo in self._todos]

    def create(self, text: str, due_date: str | None) -> dict[str, Any]:
        with self._lock:
            todo = {
                "id": self._next_id,
                "text": text,
                "done": False,
                "dueDate": due_date,
            }
            self._next_id += 1
            self._todos.append(todo)
            return dict(todo)

    def update(self, todo_id: int, patch: dict[str, Any]) -> dict[str, Any] | None:
        with self._lock:
            for todo in self._todos:
                if todo["id"] == todo_id:
                    todo.update(patch)
                    return dict(todo)
            return None

    def delete(self, todo_id: int) -> bool:
        with self._lock:
            for index, todo in enumerate(self._todos):
                if todo["id"] == todo_id:
                    del self._todos[index]
                    return True
            return False


class TodoHTTPServer(ThreadingHTTPServer):
    """A ThreadingHTTPServer that carries the todo store shared by every request."""

    def __init__(
        self,
        server_address: tuple[str, int],
        handler_class: type[BaseHTTPRequestHandler],
        store: TodoStore,
    ) -> None:
        self.store = store
        super().__init__(server_address, handler_class)


class TodoRequestHandler(BaseHTTPRequestHandler):
    server: TodoHTTPServer

    def _send_json(self, status: int, payload: Any = None) -> None:
        body = b"" if payload is None else json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        if body:
            self.wfile.write(body)

    def _read_json(self) -> Any:
        length = int(self.headers.get("Content-Length", 0))
        if length == 0:
            return {}
        return json.loads(self.rfile.read(length))

    def do_OPTIONS(self) -> None:  # noqa: N802
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header(
            "Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS"
        )
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self) -> None:  # noqa: N802
        if self.path == "/api/todos":
            self._send_json(200, self.server.store.list())
            return
        self._send_json(404, {"error": "not found"})

    def do_POST(self) -> None:  # noqa: N802
        if self.path != "/api/todos":
            self._send_json(404, {"error": "not found"})
            return
        data = self._read_json()
        text = str(data.get("text", "")).strip()
        if not text:
            self._send_json(400, {"error": "text is required"})
            return
        due_date = data.get("dueDate")
        self._send_json(201, self.server.store.create(text, due_date))

    def do_PATCH(self) -> None:  # noqa: N802
        match = TODO_ID_RE.match(self.path)
        if not match:
            self._send_json(404, {"error": "not found"})
            return
        patch = self._read_json()
        allowed = {k: v for k, v in patch.items() if k in PATCHABLE_FIELDS}
        todo = self.server.store.update(int(match.group(1)), allowed)
        if todo is None:
            self._send_json(404, {"error": "todo not found"})
            return
        self._send_json(200, todo)

    def do_DELETE(self) -> None:  # noqa: N802
        match = TODO_ID_RE.match(self.path)
        if not match:
            self._send_json(404, {"error": "not found"})
            return
        if self.server.store.delete(int(match.group(1))):
            self._send_json(204)
        else:
            self._send_json(404, {"error": "todo not found"})
