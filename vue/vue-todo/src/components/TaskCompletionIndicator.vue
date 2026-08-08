<script setup lang="ts">
defineProps<{ completed: boolean }>();
</script>

<template>
    <div class="indicator" v-if="completed">✓</div>
    <div class="indicator" v-else></div>
</template>

<style scoped>
.indicator {
    width: 24px;
    height: 24px;
    font-size: 20px;
    background: white;
    border: 1px solid #888;
    border-top-color: #555;
    border-left-color: #555;
    box-shadow:
        inset 1px 1px 0 #d4d4d4,
        inset -1px -1px 0 #fff;
    padding: 0;
    color: #333;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
