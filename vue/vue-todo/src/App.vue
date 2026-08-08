<script setup lang="ts">
import { onMounted, onUnmounted, ref, Ref } from "vue";
import { TodoStore, useTodoStore } from "./stores/todos";
import TodoInput from "./components/TodoInput.vue";
import TodoList from "./components/TodoList.vue";

const store: TodoStore = useTodoStore();
const showInput: Ref<boolean> = ref(false);

function onKeydown(event: KeyboardEvent): void {
    if (showInput.value) return;
    if (event.ctrlKey || event.metaKey || event.altKey) return;

    switch (event.key) {
        case "a":
            event.preventDefault();
            showInput.value = true;
            break;
        case "j":
            event.preventDefault();
            store.selectNext();
            break;
        case "k":
            event.preventDefault();
            store.selectPrev();
            break;
        case "x":
            event.preventDefault();
            store.toggleSelected();
            break;
    }
}

onMounted(() => window.addEventListener("keydown", onKeydown));
onUnmounted(() => window.removeEventListener("keydown", onKeydown));
</script>

<template>
    <main class="app">
        <TodoList />
        <TodoInput v-if="showInput" @close="showInput = false" />
    </main>
</template>

<style scoped>
.app {
    margin: 24px;
    border: 1px solid black;
}
</style>
