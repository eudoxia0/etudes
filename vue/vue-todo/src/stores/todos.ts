import { ref, computed, Ref, ComputedRef } from "vue";
import { defineStore } from "pinia";
import type { Todo } from "../types";

let nextId: number = 1;

export const useTodoStore = defineStore("todos", () => {
  // Store state.

  const todos: Ref<Todo[]> = ref<Todo[]>([]);
  const selectedId: Ref<number | null> = ref<number | null>(null);

  // Readers.

  const remaining: ComputedRef<number> = computed(
    () => todos.value.filter((t) => !t.done).length,
  );

  const selectedIndex: ComputedRef<number> = computed(() =>
    todos.value.findIndex((t) => t.id === selectedId.value),
  );

  // Mutations.

  function add(text: string): void {
    const trimmed = text.trim();
    if (!trimmed) {
      return;
    }
    const todo: Todo = { id: nextId++, text: trimmed, done: false };
    todos.value.push(todo);
    selectedId.value = todo.id;
  }

  function toggle(id: number): void {
    const todo = todos.value.find((t) => t.id === id);
    if (todo) {
      todo.done = !todo.done;
    }
  }

  function remove(id: number): void {
    const index = todos.value.findIndex((t) => t.id === id);
    if (index === -1) {
      return;
    }
    todos.value.splice(index, 1);
    if (selectedId.value === id) {
      const next = todos.value[index] ?? todos.value[index - 1];
      selectedId.value = next ? next.id : null;
    }
  }

  function removeSelected(): void {
    if (selectedId.value !== null) {
      remove(selectedId.value);
    }
  }

  function select(id: number): void {
    selectedId.value = id;
  }

  function selectNext(): void {
    if (todos.value.length === 0) {
      return;
    }
    const index = selectedIndex.value;
    const next = index === -1 ? 0 : Math.min(index + 1, todos.value.length - 1);
    selectedId.value = todos.value[next].id;
  }

  function selectPrev(): void {
    if (todos.value.length === 0) {
      return;
    }
    const index = selectedIndex.value;
    const prev = index === -1 ? 0 : Math.max(index - 1, 0);
    selectedId.value = todos.value[prev].id;
  }

  function toggleSelected(): void {
    if (selectedId.value !== null) {
      toggle(selectedId.value);
    }
  }

  return {
    todos,
    selectedId,
    remaining,
    add,
    toggle,
    remove,
    removeSelected,
    select,
    selectNext,
    selectPrev,
    toggleSelected,
  };
});

export type TodoStore = ReturnType<typeof useTodoStore>;
