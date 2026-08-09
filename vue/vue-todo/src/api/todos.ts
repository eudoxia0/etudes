import type { DueDate, Todo } from "../types";

const BASE_URL = "/api/todos";

async function parseResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Request failed (${response.status}): ${body}`);
  }
  if (response.status === 204) {
    return undefined as T;
  }
  return (await response.json()) as T;
}

export function fetchTodos(): Promise<Todo[]> {
  return fetch(BASE_URL).then((res) => parseResponse<Todo[]>(res));
}

export function createTodo(text: string, dueDate: DueDate): Promise<Todo> {
  return fetch(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ text, dueDate }),
  }).then((res) => parseResponse<Todo>(res));
}

export function updateTodo(
  id: number,
  patch: Partial<Pick<Todo, "text" | "done" | "dueDate">>,
): Promise<Todo> {
  return fetch(`${BASE_URL}/${id}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(patch),
  }).then((res) => parseResponse<Todo>(res));
}

export function deleteTodo(id: number): Promise<void> {
  return fetch(`${BASE_URL}/${id}`, { method: "DELETE" }).then((res) =>
    parseResponse<void>(res),
  );
}
