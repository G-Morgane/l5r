<template>
  <div class="rounded-xl p-8 mb-12 border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl relative overflow-hidden">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/30"></div>
    
    <div class="flex flex-col md:flex-row items-center justify-between gap-6 relative z-10">
      <div class="flex items-center gap-6">
        <div 
          v-if="personnage.nom === 'Shiba Shizuku'"
          class="w-24 h-24 rounded-full shadow-xl border-4 border-red-800 overflow-hidden bg-cover bg-center"
          style="background-image: url('/shizuku.png');"
        ></div>
        <div 
          v-else
          class="w-24 h-24 bg-gradient-to-br from-stone-700 via-stone-600 to-stone-800 rounded-full flex items-center justify-center text-4xl font-black text-amber-100 shadow-xl border-4 border-red-800"
        >
          {{ personnage.nom[0] }}
        </div>
        <div>
          <h2 class="text-4xl font-black text-stone-900 mb-2 font-sakurata">{{ personnage.nom }}</h2>
          <p class="text-red-800 font-bold text-lg font-montserrat">{{ personnage.clan || 'Sans clan' }} • {{ personnage.famille || 'Sans famille' }}</p>
          <p class="text-stone-600 text-sm mt-1 font-montserrat">{{ personnage.ecole || 'Sans école' }} • Rang {{ personnage.rang }}</p>
        </div>
      </div>
      <button
        @click="$emit('deselect')"
        class="bg-gradient-to-b from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-amber-50 border-2 border-red-950 px-6 py-3 rounded-lg font-bold transition-all duration-300 whitespace-nowrap shadow-lg"
      >
        ← Changer de personnage
      </button>
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
