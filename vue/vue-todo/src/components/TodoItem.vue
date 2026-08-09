<script setup lang="ts">
import type { Todo } from "../types";
import { TodoStore, useTodoStore } from "../stores/todos";
import TaskCompletionIndicator from "./TaskCompletionIndicator.vue";

defineProps<{ todo: Todo }>();

const store: TodoStore = useTodoStore();
</script>

<template>
  <li
    class="todo-item"
    :class="{ done: todo.done, selected: todo.id === store.selectedId }"
    @click="store.select(todo.id)"
  >
    <label>
      <TaskCompletionIndicator :completed="todo.done" />
      <span>{{ todo.text }}</span>
      <span v-if="todo.dueDate" class="due-date" :class="todo.dueDate">
        {{ todo.dueDate }}
      </span>
    </label>
    <button class="remove" type="button" @click.stop="store.remove(todo.id)">
      ✕
    </button>
  </li>
</template>

<style scoped>
.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 4px 8px;
  border-bottom: 1px solid #e0e0e0;
  border-left: 3px solid transparent;
  cursor: pointer;
}

.todo-item:last-child {
  border-bottom: 0;
}

.todo-item.selected {
  background: #eef4ff;
  border-left-color: #3b6fe0;
}

.todo-item label {
  display: flex;
  align-items: center;
  gap: 8px;
}

.todo-item.done span {
  color: #999;
}

.todo-item .remove {
  background: none;
  border: none;
  color: #999;
  cursor: pointer;
  font-size: 16px;
}

.todo-item .remove:hover {
  color: #c00;
}

.due-date {
  font-size: 11px;
  text-transform: uppercase;
  padding: 2px 6px;
  border: 1px solid #999;
  color: #666;
  background: #f0f0f0;
}

.due-date.today {
  border-color: #c08a00;
  color: #8a6200;
  background: #fff6e0;
}

.due-date.tomorrow {
  border-color: #3b6fe0;
  color: #2a52b3;
  background: #eef4ff;
}
</style>
