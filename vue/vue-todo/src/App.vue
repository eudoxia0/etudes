<script setup lang="ts">
import { TodoStore, useTodoStore } from "./stores/todos";
import TodoInput from "./components/TodoInput.vue";
import TodoList from "./components/TodoList.vue";

const store: TodoStore = useTodoStore();
</script>

<template>
    <main class="app">
        <h1>Todo</h1>
        <TodoInput />
        <TodoList />
        <p v-if="store.todos.length" class="status">
            {{ store.remaining }} remaining
        </p>
    </main>
</template>

<style scoped>
.app {
    max-width: 32rem;
    margin: 3rem auto;
    padding: 0 1rem;
}

h1 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
}

.status {
    margin-top: 1rem;
    color: #666;
    font-size: 0.9rem;
}
</style>
