<script setup lang="ts">
import { onMounted, onUnmounted, ref, Ref } from "vue";
import { TodoStore, useTodoStore } from "./stores/todos";
import TodoInput from "./components/TodoInput.vue";
import TodoList from "./components/TodoList.vue";
import ViewSwitcher from "./components/ViewSwitcher.vue";

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
    case "d":
      event.preventDefault();
      store.removeSelected();
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
    case "1":
      event.preventDefault();
      store.setView("today");
      break;
    case "2":
      event.preventDefault();
      store.setView("tomorrow");
      break;
    case "3":
      event.preventDefault();
      store.setView("all");
      break;
  }
}

onMounted(() => {
  window.addEventListener("keydown", onKeydown);
  store.initialize();
});
onUnmounted(() => window.removeEventListener("keydown", onKeydown));
</script>

<template>
  <main class="app">
    <p v-if="store.error" class="error">
      Could not reach the server: {{ store.error }}
    </p>
    <ViewSwitcher />
    <p v-if="store.loading" class="loading">Loading…</p>
    <TodoList v-else />
    <TodoInput v-if="showInput" @close="showInput = false" />
  </main>
</template>

<style scoped>
.app {
  padding: 24px;
}

.error {
  padding: 8px 12px;
  margin-bottom: 12px;
  border: 1px solid #c00;
  background: #fdecec;
  color: #900;
}

.loading {
  color: gray;
  font-style: italic;
}
</style>
