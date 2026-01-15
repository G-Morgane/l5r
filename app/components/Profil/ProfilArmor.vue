<template>
  <div class="relative p-2 border-4 border-amber-800 bg-amber-50/30 px-6 py-6 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
    <div class="relative z-10 flex justify-between items-center mb-4">
        <h2 class="text-xs font-bold text-red-900 font-sakurata">🛡️ Armures</h2>
        <div class="flex gap-2">
          <button
            v-if="modeEditionArmures"
            @click="$emit('add-armor')"
            class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-xs border-2 border-green-950 font-katana"
          >
            +
          </button>
        </div>
      </div>
      <div class="space-y-3 max-h-96 overflow-y-auto pr-1">
        <!-- Mode édition -->
        <template v-if="modeEditionArmures">
          <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-2 bg-white/60">
            <div class="flex justify-between items-start mb-2">
              <input
                v-model="armure.name"
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
            <div class="grid grid-cols-2 gap-2 text-xs">
              <div>
                <label class="text-xs text-stone-600 font-semibold font-montserrat">ND Armure</label>
                <input
                  v-model.number="armure.armor_rating"
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
          <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-2 bg-white/60">
            <div class="font-bold text-xs font-montserrat mb-1">{{ armure.name || 'Sans nom' }}</div>
            <div class="flex gap-4 text-xs text-stone-700">
              <div><span class="font-semibold">ND Armure:</span> {{ armure.armor_rating || '-' }}</div>
            </div>
          </div>
        </template>
        <div v-if="armures.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
          Aucune armure
        </div>
      </div>
  </div>
</template>

<script setup>
const props = defineProps({
  armures: {
    type: Array,
    default: () => []
  }
})

const modeEditionArmures = ref(false)
</script>
