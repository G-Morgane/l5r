<template>
  <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90 mb-6">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/30"></div>
    <div class="relative z-10">
      <div class="flex justify-between items-center mb-4">
        <div class="flex items-center gap-2">
          <h2 class="text-2xl font-bold text-red-900 font-sakurata">Compétences</h2>
          <button
            @click="$emit('open-nd-modal')"
            class="w-6 h-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center text-sm font-bold transition-all"
            title="Voir la table de référence des ND"
          >
            ?
          </button>
        </div>
        <div class="flex gap-2">
          <button
            @click="modeEditionCompetences = !modeEditionCompetences"
            class="px-4 py-2 bg-gradient-to-b from-blue-700 to-blue-900 hover:from-blue-600 hover:to-blue-800 text-white rounded-lg font-bold transition-all border-2 border-blue-950 shadow-lg font-katana"
          >
            {{ modeEditionCompetences ? '✓' : '✏️' }}
          </button>
          <button
            @click="$emit('add-skill')"
            class="px-4 py-2 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded-lg font-bold transition-all border-2 border-green-950 shadow-lg font-katana"
          >
            +
          </button>
        </div>
      </div>

      <div class="overflow-x-auto bg-white/60 rounded-lg p-4">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b-2 border-red-900">
              <th class="text-left py-2 px-2 font-bold font-katana">Compétence</th>
              <th class="text-center py-2 px-2 font-bold w-16 font-katana">Rang</th>
              <th class="text-center py-2 px-2 font-bold w-24 font-katana">Trait</th>
              <th class="text-center py-2 px-2 font-bold w-20 font-katana">Jet</th>
              <th class="text-center py-2 px-2 font-bold w-16 font-katana">Art</th>
              <th class="text-left py-2 px-2 font-bold font-katana">Spécialisations</th>
              <th class="text-center py-2 px-2 font-bold w-20 font-katana">Description</th>
              <th class="w-10"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="comp in competences" :key="comp.id" class="border-b border-stone-300 hover:bg-amber-50/30">
              <td class="py-2 px-2">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.nom"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
                <span v-else class="font-montserrat">{{ comp.nom }}</span>
              </td>
              <td class="py-2 px-2">
                <input
                  v-if="modeEditionCompetences"
                  v-model.number="comp.rang"
                  type="number"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-bold font-montserrat"
                />
                <span v-else class="font-montserrat font-bold text-center block">{{ comp.rang }}</span>
              </td>
              <td class="py-2 px-2">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.trait"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-montserrat"
                />
                <span v-else class="font-montserrat text-center block">{{ comp.trait }}</span>
              </td>
              <td class="py-2 px-2 text-center">
                <span class="font-montserrat font-bold text-green-700">{{ calculerJet(comp) }}</span>
              </td>
              <td class="py-2 px-2 text-center">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.art"
                  type="checkbox"
                  @change="$emit('save-skill', comp)"
                  class="w-5 h-5"
                />
                <span v-else class="font-montserrat">{{ comp.art ? '✓' : '' }}</span>
              </td>
              <td class="py-2 px-2">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.specialisations"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat text-xs"
                  placeholder="Séparées par ,"
                />
                <span v-else class="font-montserrat text-xs">{{ comp.specialisations }}</span>
              </td>
              <td class="py-2 px-2 text-center">
                <button
                  @click="$emit('open-description-modal', comp)"
                  class="px-2 py-1 text-white rounded text-xs font-bold font-katana"
                  title="Voir/Modifier la description"
                >
                  📝
                </button>
              </td>
              <td class="py-2 px-2">
                <button
                  v-if="modeEditionCompetences"
                  @click="$emit('delete-skill', comp.id)"
                  class="text-red-600 hover:text-red-800 font-bold text-lg"
                >
                  ✕
                </button>
              </td>
            </tr>
            <tr v-if="competences.length === 0">
              <td colspan="8" class="py-8 text-center text-stone-500 italic font-montserrat">
                Aucune compétence pour le moment
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
const modeEditionCompetences = ref(false)

defineProps({
  competences: {
    type: Array,
    required: true
  }
})

defineEmits(['open-nd-modal', 'add-skill', 'save-skill', 'open-description-modal', 'delete-skill'])

const calculerJet = (comp) => {
  // This function should be passed as a prop or computed in the parent
  return `${comp.rang}k${comp.rang}`
}
</script>