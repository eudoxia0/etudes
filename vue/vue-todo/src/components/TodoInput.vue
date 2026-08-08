<script setup lang="ts">
import { Ref, ref } from "vue";
import { TodoStore, useTodoStore } from "../stores/todos";

const store: TodoStore = useTodoStore();
const text: Ref<string> = ref("");

function submit(): void {
    store.add(text.value);
    text.value = "";
}
</script>

<template>
    <form class="todo-input" @submit.prevent="submit">
        <input
            v-model="text"
            type="text"
            placeholder="What needs doing?"
            autofocus
        />
        <button type="submit">Add</button>
    </form>
</template>

<style scoped>
.todo-input {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.todo-input input {
    flex: 1;
    padding: 0.5rem;
    font-size: 1rem;
}

.todo-input button {
    padding: 0.5rem 1rem;
}
</style>
