<template>
  <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/30"></div>
    <div class="relative z-10">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-bold text-red-900 font-sakurata">✨ Avantages</h2>
        <div class="flex gap-2">
          <button
            @click="modeEditionAvantages = !modeEditionAvantages"
            :class="modeEditionAvantages ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'"
            class="px-3 py-1 text-white rounded font-bold text-sm border-2 border-blue-950 font-katana transition-colors"
          >
            {{ modeEditionAvantages ? '✓ Valider' : '✎ Éditer' }}
          </button>
          <button
            v-if="modeEditionAvantages"
            @click="$emit('add-advantage')"
            class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-sm border-2 border-green-950 font-katana"
          >
            +
          </button>
        </div>
      </div>
      <div class="space-y-2 max-h-96 overflow-y-auto pr-2">
        <!-- Mode édition -->
        <template v-if="modeEditionAvantages">
          <div v-for="avantage in avantages" :key="avantage.id" class="border-b border-amber-800/30 pb-2 bg-white/40 px-2 py-2 rounded">
            <div class="flex items-center gap-2">
              <input
                v-model="avantage.nom"
                @blur="$emit('save-advantage', avantage)"
                class="flex-1 border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                placeholder="Nom"
              />
              <select
                v-model="avantage.type"
                @change="$emit('save-advantage', avantage)"
                class="border border-stone-300 rounded px-2 py-1 bg-white font-bold"
              >
                <option value="avantage">+</option>
                <option value="desavantage">-</option>
              </select>
              <input
                v-model.number="avantage.rang"
                type="number"
                @blur="$emit('save-advantage', avantage)"
                class="w-16 border border-stone-300 rounded px-2 py-1 text-center bg-white font-bold font-montserrat"
                placeholder="Rang"
              />
              <button
                @click="$emit('open-description-modal', avantage)"
                class="px-2 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded text-sm font-bold"
                title="Éditer la description"
              >
                📝
              </button>
              <button
                @click="$emit('delete-advantage', avantage.id)"
                class="text-red-600 hover:text-red-800"
              >
                ✕
              </button>
            </div>
          </div>
        </template>
        <!-- Mode lecture -->
        <template v-else>
          <div v-for="avantage in avantagesTries" :key="avantage.id" class="border-b border-amber-800/30 pb-2 bg-white/40 px-3 py-2 rounded">
            <div class="flex items-center gap-3">
              <div class="flex-1 font-semibold font-montserrat">{{ avantage.nom || 'Sans nom' }}</div>
              <div class="flex items-center gap-2">
                <div class="font-bold text-lg" :class="avantage.type === 'avantage' ? 'text-green-700' : 'text-red-700'">
                {{ avantage.type === 'avantage' ? '+' : '-' }}{{ avantage.rang || 0 }}
                </div>
                <div class="text-xs font-semibold font-montserrat" :class="avantage.type === 'avantage' ? 'text-green-600' : 'text-red-600'">
                  ({{ avantage.type === 'avantage' ? '-' : '+' }}{{ avantage.rang || 0 }} XP)
                </div>
              </div>
            </div>
            <div v-if="avantage.description" class="mt-1 text-xs text-stone-600 italic font-montserrat">
              {{ avantage.description }}
            </div>
          </div>
        </template>
        <div v-if="avantages.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
          Aucun avantage/désavantage
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const modeEditionAvantages = ref(false)

defineProps({
  avantages: {
    type: Array,
    required: true
  },
  avantagesTries: {
    type: Array,
    required: true
  }
})

defineEmits(['add-advantage', 'save-advantage', 'open-description-modal', 'delete-advantage'])
</script>