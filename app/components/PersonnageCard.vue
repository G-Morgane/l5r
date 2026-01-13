<template>
  <div
    class="flex flex-col items-center justify-center cursor-pointer group"
    @click="$emit('select', personnage)"
    style="width: 9rem;"
  >
    <div class="relative flex items-center justify-center w-58 h-58">
      <img
        src="/cadre_perso.png"
        alt="Cadre cercle"
        class="absolute inset-0 w-full h-full object-contain pointer-events-none z-10"
        draggable="false"
      />
      <div class="rounded-full overflow-hidden w-50 h-50 bg-stone-200 flex items-center justify-center z-0">
        <img
          v-if="personnage.nom === 'Shiba Shizuku'"
          src="/shizuku.png"
          alt="Portrait du personnage"
          class="object-cover w-full h-full"
        />
        <span
          v-else
          class="flex items-center justify-center w-full h-full text-6xl font-bold text-amber-900 select-none"
          style="user-select: none;"
        >
          {{ personnage.nom[0] }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  personnage: {
    type: Object,
    required: true
  }
})

defineEmits(['select'])

const imageStyle = computed(() => {
  return {
    background: 'none'
  }
})
</script>
