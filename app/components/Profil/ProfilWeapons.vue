<template>
   <div class="relative p-2 border-4 border-amber-800 bg-amber-50/30 px-6 py-6 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
    <div class="relative z-10 flex justify-between items-center mb-4">
        <h2 class="text-xs font-bold text-red-900 font-sakurata">⚔️ Armes</h2>
        <div class="flex gap-2">
          <button
            v-if="modeEditionArmes"
            @click="$emit('add-weapon')"
            class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-xs border-2 border-green-950 font-katana"
          >
            +
          </button>
        </div>
      </div>
      <div class="space-y-3 max-h-96 overflow-y-auto pr-1">
        <!-- Mode édition -->
        <template v-if="modeEditionArmes">
          <div v-for="arme in armes" :key="arme.id" class="border-2 border-amber-800/40 rounded-lg p-2 bg-white/60">
            <div class="flex justify-between items-start mb-2">
              <input
                v-model="arme.name"
                @blur="$emit('save-weapon', arme)"
                class="flex-1 font-bold border-b border-stone-400 bg-transparent font-montserrat"
                placeholder="Nom de l'arme"
              />
              <button
                @click="$emit('delete-weapon', arme.id)"
                class="text-red-600 hover:text-red-800 ml-2"
              >
                ✕
              </button>
            </div>
            <div class="grid grid-cols-2 gap-2 text-xs">
              <div>
                <label class="text-xs text-stone-600 font-semibold font-montserrat">Type</label>
                <input
                  v-model="arme.type"
                  @blur="$emit('save-weapon', arme)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
              </div>
              <div>
                <label class="text-xs text-stone-600 font-semibold font-montserrat">Dommages</label>
                <input
                  v-model="arme.damage"
                  @blur="$emit('save-weapon', arme)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
              </div>
            </div>
          </div>
        </template>
        <!-- Mode lecture -->
        <template v-else>
          <div v-for="arme in armes" :key="arme.id" class="border-2 border-amber-800/40 rounded-lg p-2 bg-white/60">
            <div class="font-bold text-xs font-montserrat mb-1">{{ arme.name || 'Sans nom' }}</div>
            <div class="flex gap-4 text-xs text-stone-700 font-montserrat">
              <div><span class="font-semibold">Type:</span> {{ arme.type || '-' }}</div>
              <div><span class="font-semibold">Dommages:</span> {{ arme.damage || '-' }}</div>
            </div>
          </div>
        </template>
        <div v-if="armes.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
          Aucune arme
        </div>
      </div>
  </div>
</template>

<script setup>
const modeEditionArmes = ref(false)

defineProps({
  armes: {
    type: Array,
    required: true
  }
})

defineEmits(['add-weapon', 'save-weapon', 'delete-weapon'])
</script>