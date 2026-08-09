<script setup lang="ts">
import { computed, ComputedRef } from "vue";
import { TodoStore, useTodoStore } from "../stores/todos";
import TodoItem from "./TodoItem.vue";

const store: TodoStore = useTodoStore();

const emptyMessage: ComputedRef<string> = computed(() => {
  switch (store.view) {
    case "today":
      return "No tasks due today.";
    case "tomorrow":
      return "No tasks due tomorrow.";
    default:
      return "No tasks.";
  }
});
</script>

<template>
  <p v-if="store.filteredTodos.length === 0" class="empty">
    {{ emptyMessage }}
  </p>
  <ul v-else class="todo-list">
    <TodoItem v-for="todo in store.filteredTodos" :key="todo.id" :todo="todo" />
  </ul>
</template>

<style scoped>
.todo-list {
  list-style: none;
}

.empty {
  color: gray;
  font-style: italic;
}
</style>
