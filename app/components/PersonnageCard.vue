<template>
  <div class="group relative">
    <!-- Carte avec cadre.png comme fond -->
    <div class="shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-2 relative w-full rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent" style="background-image: url('/cadre.png'); background-position: center;">
      
      <div class="p-4 relative z-10 h-full flex flex-col">
        <!-- Image du personnage (placeholder avec initiale) -->
        <div 
          class="relative mb-4 aspect-[4/3] rounded-lg shadow-inner overflow-hidden border-2 border-amber-900"
          :style="imageStyle"
        >
          <div v-if="personnage.nom !== 'Shiba Shizuku'" class="absolute inset-0 flex items-center justify-center text-8xl font-bold text-amber-100 text-shadow-lg">
            {{ personnage.nom[0] }}
          </div>
          <!-- Overlay décoratif -->
          <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
        </div>
        
        <!-- Info personnage -->
        <div class="text-center mb-3">
          <h3 class="text-2xl font-bold text-stone-900 mb-1 font-sigokae">{{ personnage.nom }}</h3>
          <div class="h-px bg-gradient-to-r from-transparent via-red-800 to-transparent mb-2"></div>
          <p class="text-sm text-red-800 font-semibold font-montserrat">Clan: {{ personnage.clan || 'Inconnu' }}</p>
          <p class="text-xs text-stone-600 font-medium font-montserrat">Statut: <span :class="personnage.statut === 'vivant' ? 'text-green-700' : 'text-red-700'">{{ personnage.statut || 'Actif' }}</span></p>
        </div>
        
        <!-- Bouton Choisir -->
        <button
          @click="$emit('select', personnage)"
          class="w-full bg-gradient-to-b from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-amber-50 py-3 rounded-lg font-bold transition-all duration-300 shadow-md border-2 border-red-950"
        >
          Choisir
        </button>
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
  if (props.personnage.nom === 'Shiba Shizuku') {
    return {
      backgroundImage: 'url(/shizuku.png)',
      backgroundSize: '200%',
      backgroundPosition: 'center 20%'
    }
  }
  return {
    background: 'linear-gradient(to bottom right, rgb(68 64 60), rgb(87 83 78), rgb(41 37 36))'
  }
})
</script>
