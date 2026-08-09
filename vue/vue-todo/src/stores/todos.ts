import { ref, computed, Ref, ComputedRef } from "vue";
import { defineStore } from "pinia";
import type { Todo, View } from "../types";

let nextId: number = 1;

function dummyTodos(): Todo[] {
  return [
    {
      id: nextId++,
      text: "Reply to client email",
      done: false,
      dueDate: "today",
    },
    { id: nextId++, text: "Fix login page bug", done: false, dueDate: "today" },
    { id: nextId++, text: "Write unit tests", done: true, dueDate: "today" },
    {
      id: nextId++,
      text: "Prepare slides for standup",
      done: false,
      dueDate: "tomorrow",
    },
    {
      id: nextId++,
      text: "Review pull request",
      done: false,
      dueDate: "tomorrow",
    },
    { id: nextId++, text: "Renew gym membership", done: false, dueDate: null },
    { id: nextId++, text: "Read a book chapter", done: false, dueDate: null },
    { id: nextId++, text: "Water the plants", done: true, dueDate: null },
  ];
}

export const useTodoStore = defineStore("todos", () => {
  // Store state.

  const todos: Ref<Todo[]> = ref<Todo[]>(dummyTodos());
  const view: Ref<View> = ref<View>("today");

  // Readers.

  const filteredTodos: ComputedRef<Todo[]> = computed(() => {
    if (view.value === "all") {
      return todos.value;
    }
    return todos.value.filter((t) => t.dueDate === view.value);
  });

  const selectedId: Ref<number | null> = ref<number | null>(
    filteredTodos.value[0]?.id ?? null,
  );

  const selectedIndex: ComputedRef<number> = computed(() =>
    filteredTodos.value.findIndex((t) => t.id === selectedId.value),
  );

  // Mutations.

  function setView(next: View): void {
    view.value = next;
    selectedId.value = filteredTodos.value[0]?.id ?? null;
  }

  function add(text: string): void {
    const trimmed = text.trim();
    if (!trimmed) {
      return;
    }
    const todo: Todo = {
      id: nextId++,
      text: trimmed,
      done: false,
      dueDate: null,
    };
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
    if (selectedId.value === id) {
      const filteredIndex = filteredTodos.value.findIndex((t) => t.id === id);
      const remainingVisible = filteredTodos.value.filter((t) => t.id !== id);
      const next =
        remainingVisible[filteredIndex] ?? remainingVisible[filteredIndex - 1];
      selectedId.value = next ? next.id : null;
    }
    todos.value.splice(index, 1);
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
    if (selectedId.value !== null) {
      toggle(selectedId.value);
    }
  }

  return {
    todos,
    selectedId,
    view,
    filteredTodos,
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
