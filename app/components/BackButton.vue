<template>
  <button class="button-89" :class="{ 'button-89-blanc': props.blanc }" @click="$emit('click')" role="button">
    <slot></slot>
  </button>
</template>

<script setup lang="ts">
defineEmits(['click'])
const props = defineProps({
  blanc: {
    type: Boolean,
    default: false
  }
})
</script>

<style scoped>
.button-89 {
  --b: 3px;   /* border thickness */
  --s: .45em; /* size of the corner */
  --color: #000000; /* black color */
  
  padding: calc(.5em + var(--s)) calc(.9em + var(--s));
  color: var(--color);
  --_p: var(--s);
  background:
    conic-gradient(from 90deg at var(--b) var(--b),#0000 90deg,var(--color) 0)
    var(--_p) var(--_p)/calc(100% - var(--b) - 2*var(--_p)) calc(100% - var(--b) - 2*var(--_p));
  transition: all 0.3s ease;
  outline: var(--b) solid #0000;
  outline-offset: .6em;
  font-size: 16px;
  font-weight: bold;
  border: 0;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  transform: scale(1);
}

.button-89-blanc {
  --color: #ffffff; /* white color */
  
}
.button-89:hover,
.button-89:focus-visible{
  --_p: 0px;
  outline-color: var(--color);
  outline-offset: .05em;
  transform: scale(1.05);
}

.button-89:active {
  background: var(--color);
  color: #fff;
  transform: scale(0.95);
}
</style>