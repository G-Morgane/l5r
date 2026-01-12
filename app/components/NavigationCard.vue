<template>
  <NuxtLink :to="link" class="group relative rounded-xl p-8 hover:-translate-y-2 transition-all duration-300 shadow-2xl hover:shadow-3xl overflow-hidden border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/40"></div>
    
    <div class="relative z-10 text-center">
      <div class="text-6xl mb-4">{{ emoji }}</div>
      <h3 class="text-2xl font-bold mb-2 drop-shadow-sm font-katana text-stone-800">{{ title }}</h3>
      <p class="text-stone-700 font-semibold font-montserrat">{{ description }}</p>
    </div>
  </NuxtLink>
</template>

<script setup>
defineProps({
  link: {
    type: String,
    required: true
  },
  emoji: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  }
})
</script>
