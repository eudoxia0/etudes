import { ref, computed, Ref, ComputedRef } from "vue";
import { defineStore } from "pinia";
import type { DueDate, Todo, View } from "../types";
import * as api from "../api/todos";

export const useTodoStore = defineStore("todos", () => {
  // Store state.

  const todos: Ref<Todo[]> = ref<Todo[]>([]);
  const view: Ref<View> = ref<View>("today");
  const loading: Ref<boolean> = ref<boolean>(false);
  const error: Ref<string | null> = ref<string | null>(null);

  // Readers.

  const filteredTodos: ComputedRef<Todo[]> = computed(() => {
    const incomplete = todos.value.filter((t) => !t.done);
    if (view.value === "all") {
      return incomplete;
    }
    return incomplete.filter((t) => t.dueDate === view.value);
  });

  const selectedId: Ref<number | null> = ref<number | null>(null);

  const selectedIndex: ComputedRef<number> = computed(() =>
    filteredTodos.value.findIndex((t) => t.id === selectedId.value),
  );

  // Mutations.

  async function initialize(): Promise<void> {
    loading.value = true;
    error.value = null;
    try {
      todos.value = await api.fetchTodos();
      selectedId.value = filteredTodos.value[0]?.id ?? null;
    } catch (err) {
      error.value = (err as Error).message;
    } finally {
      loading.value = false;
    }
  }

  function setView(next: View): void {
    view.value = next;
    selectedId.value = filteredTodos.value[0]?.id ?? null;
  }

  async function add(text: string, dueDate: DueDate = null): Promise<void> {
    const trimmed = text.trim();
    if (!trimmed) {
      return;
    }
    try {
      const todo = await api.createTodo(trimmed, dueDate);
      todos.value.push(todo);
      selectedId.value = todo.id;
    } catch (err) {
      error.value = (err as Error).message;
    }
  }

  async function toggle(id: number): Promise<void> {
    const todo = todos.value.find((t) => t.id === id);
    if (!todo) {
      return;
    }
    try {
      const updated = await api.updateTodo(id, { done: !todo.done });
      todo.done = updated.done;
    } catch (err) {
      error.value = (err as Error).message;
    }
  }

  async function remove(id: number): Promise<void> {
    const index = todos.value.findIndex((t) => t.id === id);
    if (index === -1) {
      return;
    }
    if (selectedId.value === id) {
      const filteredIndex = filteredTodos.value.findIndex((t) => t.id === id);
      const remainingVisible = filteredTodos.value.filter((t) => t.id !== id);
      const next =
        remainingVisible[filteredIndex] ?? remainingVisible[filteredIndex - 1];
      selectedId.value = next ? next.id : null;
    }
    try {
      await api.deleteTodo(id);
      const currentIndex = todos.value.findIndex((t) => t.id === id);
      if (currentIndex !== -1) {
        todos.value.splice(currentIndex, 1);
      }
    } catch (err) {
      error.value = (err as Error).message;
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
    if (filteredTodos.value.length === 0) {
      return;
    }
    const index = selectedIndex.value;
    const next =
      index === -1 ? 0 : Math.min(index + 1, filteredTodos.value.length - 1);
    selectedId.value = filteredTodos.value[next].id;
  }

  function selectPrev(): void {
    if (filteredTodos.value.length === 0) {
      return;
    }
    const index = selectedIndex.value;
    const prev = index === -1 ? 0 : Math.max(index - 1, 0);
    selectedId.value = filteredTodos.value[prev].id;
  }

  function toggleSelected(): void {
    const id = selectedId.value;
    if (id === null) {
      return;
    }
    const todo = todos.value.find((t) => t.id === id);
    if (todo && !todo.done) {
      const filteredIndex = filteredTodos.value.findIndex((t) => t.id === id);
      const remainingVisible = filteredTodos.value.filter((t) => t.id !== id);
      const next =
        remainingVisible[filteredIndex] ?? remainingVisible[filteredIndex - 1];
      selectedId.value = next ? next.id : null;
    }
    toggle(id);
  }

  return {
    todos,
    selectedId,
    view,
    loading,
    error,
    filteredTodos,
    initialize,
    setView,
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
