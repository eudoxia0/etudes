import { ref, computed, Ref, ComputedRef } from "vue";
import { defineStore } from "pinia";
import type { Todo } from "../types";

let nextId: number = 1;

export const useTodoStore = defineStore("todos", () => {
  // Store state.
  const todos: Ref<Todo[]> = ref<Todo[]>([]);

  // Readers.
  const remaining: ComputedRef<number> = computed(
    () => todos.value.filter((t) => !t.done).length,
  );

  // Mutations.
  function add(text: string): void {
    const trimmed = text.trim();
    if (!trimmed) return;
    todos.value.push({ id: nextId++, text: trimmed, done: false });
  }

  function toggle(id: number): void {
    const todo = todos.value.find((t) => t.id === id);
    if (todo) todo.done = !todo.done;
  }

  function remove(id: number): void {
    todos.value = todos.value.filter((t) => t.id !== id);
  }

  return { todos, remaining, add, toggle, remove };
});

export type TodoStore = ReturnType<typeof useTodoStore>;
