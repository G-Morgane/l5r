<template>
  <div class="rounded-xl py-24 px-20 mb-12 relative overflow-hidden w-full max-w-7xl mx-auto" style="min-height: 320px;">
    <div class="absolute inset-0" style="background-image: url('/parchemin_header.png'); background-size: 100% 100%; background-position: center; background-repeat: no-repeat;"></div>
    
  <div class="flex flex-col md:flex-row items-center justify-between gap-6 relative z-10" style="position:relative; top:-50px;">
      <div class="flex items-center gap-10">
        <div class="relative flex items-center justify-center w-40 h-40">
          <img
            src="/cadre_perso.png"
            alt="Cadre cercle"
            class="absolute inset-0 w-full h-full object-contain pointer-events-none z-10"
            draggable="false"
          />
          <div class="rounded-full overflow-hidden w-34 h-34 bg-stone-200 flex items-center justify-center z-0">
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
        <div>
          <h2 class="text-4xl font-black text-stone-900 mb-2 font-sakurata">{{ personnage.nom }}</h2>
          <p class="text-red-800 font-bold text-lg font-montserrat">{{ personnage.clan || 'Sans clan' }} • {{ personnage.famille || 'Sans famille' }}</p>
          <p class="text-stone-600 text-sm mt-1 font-montserrat">{{ personnage.ecole || 'Sans école' }} • Rang {{ personnage.rang }}</p>
        </div>
      </div>
      <BackButton @click="$emit('deselect')">← Changer de personnage</BackButton>
    </div>
  </div>
</template>

<script setup>
defineProps({
  personnage: {
    type: Object,
    required: true
  }
})

defineEmits(['deselect'])
</script>
