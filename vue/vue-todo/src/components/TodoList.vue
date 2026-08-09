<script setup lang="ts">
import { TodoStore, useTodoStore } from "../stores/todos";
import TodoItem from "./TodoItem.vue";

const store: TodoStore = useTodoStore();
</script>

<template>
  <p v-if="store.todos.length === 0" class="empty">No tasks.</p>
  <ul v-else class="todo-list">
    <TodoItem v-for="todo in store.todos" :key="todo.id" :todo="todo" />
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
