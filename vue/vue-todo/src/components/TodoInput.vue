<script setup lang="ts">
import { Ref, ref, onMounted } from "vue";
import { TodoStore, useTodoStore } from "../stores/todos";

const emit = defineEmits<{ close: [] }>();
const store: TodoStore = useTodoStore();
const text: Ref<string> = ref("");
const inputRef: Ref<HTMLInputElement | null> = ref(null);

function submit(): void {
    store.add(text.value);
    emit("close");
}

function cancel(): void {
    emit("close");
}

onMounted(() => {
    inputRef.value?.focus();
});
</script>

<template>
    <div class="modal-overlay" @click.self="cancel" @keydown.escape="cancel">
        <form class="modal" @submit.prevent="submit">
            <input ref="inputRef" v-model="text" type="text" />
            <div class="modal-actions">
                <button type="button" @click="cancel">Cancel</button>
                <button type="submit">Add</button>
            </div>
        </form>
    </div>
</template>

<style scoped>
.modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal {
    background: #fff;
    padding: 24px;
    border: 1px solid black;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.modal input {
    min-width: 400px;
    padding: 8px;
    font-size: 22px;
    border: 1px solid black;
    outline: 0;
}

.modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
}

.modal-actions button {
    padding: 4px 8px;
    font-size: 18px;
    border: 1px solid #666;
}
</style>
