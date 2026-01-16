<template>
  <div class="flex items-center justify-center py-24">
    <div class="flex flex-col items-center gap-4">
      <div class="relative">
        <img 
          src="/loader.png"
          alt="Loading icon"
          class="w-48 h-48 animate-spin"
        />
        <div class="absolute inset-0 flex items-center justify-center">
          <span class="text-xl">{{ icon }}</span>
        </div>
      </div>
      <p v-if="message" class="text-stone-600 font-sigokae text-base">{{ message }}</p>
    </div>
  </div>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: 'Chargement...'
  },
  icon: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
.animate-spin {
  animation: spin 10s linear infinite;
}
</style>
