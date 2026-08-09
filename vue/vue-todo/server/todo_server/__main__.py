"""Command-line entry point: run with `python -m todo_server` or `todo-server`."""

from __future__ import annotations

import argparse

from .app import TodoHTTPServer, TodoRequestHandler, TodoStore


def main() -> None:
    parser = argparse.ArgumentParser(description="In-memory todo list backend")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()

    server = TodoHTTPServer((args.host, args.port), TodoRequestHandler, TodoStore())
    print(f"todo-server listening on http://{args.host}:{args.port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
