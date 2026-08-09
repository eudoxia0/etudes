<script setup lang="ts">
import { TodoStore, useTodoStore } from "../stores/todos";
import type { View } from "../types";

const store: TodoStore = useTodoStore();

const views: { id: View; label: string; key: string }[] = [
  { id: "today", label: "Today", key: "1" },
  { id: "tomorrow", label: "Tomorrow", key: "2" },
  { id: "all", label: "All Tasks", key: "3" },
];
</script>

<template>
  <nav class="view-switcher">
    <button
      v-for="v in views"
      :key="v.id"
      type="button"
      class="view-tab"
      :class="{ active: store.view === v.id }"
      @click="store.setView(v.id)"
    >
      <span class="view-key">{{ v.key }}</span>
      {{ v.label }}
    </button>
  </nav>
</template>

<style scoped>
.view-switcher {
  display: flex;
  gap: 4px;
  margin-bottom: 12px;
}

.view-tab {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  font-size: 14px;
  background: #f0f0f0;
  border: 1px solid #999;
  cursor: pointer;
}

.view-tab.active {
  background: #eef4ff;
  border-color: #3b6fe0;
  color: #3b6fe0;
  font-weight: bold;
}

.view-key {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  font-size: 11px;
  background: white;
  border: 1px solid #ccc;
  color: #666;
}
</style>
