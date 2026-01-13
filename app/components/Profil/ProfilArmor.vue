<template>
  <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/30"></div>
    <div class="relative z-10">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold text-red-900 font-sakurata">🛡️ Armures</h2>
        <div class="flex gap-2">
          <button
            @click="modeEditionArmures = !modeEditionArmures"
            :class="modeEditionArmures ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'"
            class="px-3 py-1 text-white rounded font-bold text-sm border-2 border-blue-950 font-katana transition-colors"
          >
            {{ modeEditionArmures ? '✓ Valider' : '✎ Éditer' }}
          </button>
          <button
            v-if="modeEditionArmures"
            @click="$emit('add-armor')"
            class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-sm border-2 border-green-950 font-katana"
          >
            +
          </button>
        </div>
      </div>
      <div class="space-y-3 max-h-96 overflow-y-auto pr-2">
        <!-- Mode édition -->
        <template v-if="modeEditionArmures">
          <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
            <div class="flex justify-between items-start mb-2">
              <input
                v-model="armure.nom"
                @blur="$emit('save-armor', armure)"
                class="flex-1 font-bold border-b border-stone-400 bg-transparent font-montserrat"
                placeholder="Nom de l'armure"
              />
              <button
                @click="$emit('delete-armor', armure.id)"
                class="text-red-600 hover:text-red-800 ml-2"
              >
                ✕
              </button>
            </div>
            <div class="grid grid-cols-2 gap-2 text-sm">
              <div>
                <label class="text-xs text-stone-600 font-semibold font-montserrat">ND Armure</label>
                <input
                  v-model.number="armure.nd_armure"
                  type="number"
                  @blur="$emit('save-armor', armure)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
              </div>
              <div>
                <label class="text-xs text-stone-600 font-semibold font-montserrat">Réduction</label>
                <input
                  v-model.number="armure.reduction"
                  type="number"
                  @blur="$emit('save-armor', armure)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
              </div>
            </div>
          </div>
        </template>
        <!-- Mode lecture -->
        <template v-else>
          <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
            <div class="font-bold text-lg font-montserrat mb-1">{{ armure.nom || 'Sans nom' }}</div>
            <div class="flex gap-4 text-sm text-stone-700">
              <div><span class="font-semibold">ND Armure:</span> {{ armure.nd_armure || '-' }}</div>
              <div><span class="font-semibold">Réduction:</span> {{ armure.reduction || '-' }}</div>
            </div>
          </div>
        </template>
        <div v-if="armures.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
          Aucune armure
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const modeEditionArmures = ref(false)

defineProps({
  armures: {
    type: Array,
    required: true
  }
})

defineEmits(['add-armor', 'save-armor', 'delete-armor'])
</script>