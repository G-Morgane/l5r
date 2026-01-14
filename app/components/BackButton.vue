<template>
  <button class="back-button font-sigokae" @click="$emit('click')" role="button">
    <slot></slot>
  </button>
</template>

<script setup lang="ts">
defineEmits(['click'])
</script>

<style scoped>
.back-button {
  background-image: url('/background_red_button.png');
  background-size: 100% 100%;
  background-position: center;
  background-repeat: no-repeat;
  padding: 0.5em 0.9em;
  color: black;
  font-size: 16px;
  font-weight: bold;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: transform 0.3s ease;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
}

.back-button:hover,
.back-button:focus-visible {
  transform: scale(1.05);
}

.font-sigokae {
  font-family: 'Japanatsuki', sans-serif;
}
</style>