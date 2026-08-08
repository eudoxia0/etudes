<script setup lang="ts">
import type { Todo } from "../types";
import { TodoStore, useTodoStore } from "../stores/todos";

defineProps<{ todo: Todo }>();

const store: TodoStore = useTodoStore();
</script>

<template>
    <li class="todo-item" :class="{ done: todo.done }">
        <label>
            <input
                type="checkbox"
                :checked="todo.done"
                @change="store.toggle(todo.id)"
            />
            <span>{{ todo.text }}</span>
        </label>
        <button class="remove" type="button" @click="store.remove(todo.id)">
            ✕
        </button>
    </li>
</template>

<style scoped>
.todo-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.4rem 0;
    border-bottom: 1px solid #e0e0e0;
}

.todo-item label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.todo-item.done span {
    text-decoration: line-through;
    color: #999;
}

.todo-item .remove {
    background: none;
    border: none;
    color: #999;
    cursor: pointer;
    font-size: 1rem;
}

.todo-item .remove:hover {
    color: #c00;
}
</style>
