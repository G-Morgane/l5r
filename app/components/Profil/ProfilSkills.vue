<template>
  <div class="relative mx-24 p-2 border-4 border-amber-800 bg-amber-50/30 mb-6 pt-6 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
    <div class="relative z-10 px-6 flex flex-row gap-4 items-center">
      <div class="overflow-x-auto max-h-[40vh] overflow-y-auto rounded-lg p-1 flex-1">
        <table class="w-full text-xs">
          <thead>
            <tr class="border-b-2 border-red-900">
              <th class="text-left py-1 px-1 font-bold w-40 font-katana">Compétence</th>
              <th class="text-center py-1 px-1 font-bold w-16 font-katana">Rang</th>
              <th class="text-center py-1 px-1 font-bold w-32 font-katana">Trait</th>
              <th class="text-center py-1 px-1 font-bold w-20 font-katana">Jet</th>
              <th class="text-left py-1 px-1 font-bold w-24 font-katana">Spécialisations</th>
              <th class="text-center py-1 px-1 font-bold w-20 font-katana">Description</th>
              <th class="w-10"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="comp in competences" :key="comp.id" class="border-b border-stone-300 hover:bg-amber-50/30">
              <td class="py-1 px-1">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.nom"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                />
                <span v-else class="font-montserrat">{{ comp.nom }}</span>
              </td>
              <td class="py-1 px-1">
                <input
                  v-if="modeEditionCompetences"
                  v-model.number="comp.rang"
                  type="number"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-bold font-montserrat"
                />
                <span v-else class="font-montserrat font-bold text-center block">{{ comp.rang }}</span>
              </td>
              <td class="py-1 px-1">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.trait"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-montserrat"
                />
                <span v-else class="font-montserrat text-center block">
                  {{ comp.trait }}{{ getTraitValue(comp.trait) ? ` (${getTraitValue(comp.trait)})` : '' }}
                </span>
              </td>
              <td class="py-1 px-1 text-center">
                <span class="font-montserrat font-bold text-green-700">{{ calculerJet(comp) }}</span>
              </td>
              <td class="py-1 px-1">
                <input
                  v-if="modeEditionCompetences"
                  v-model="comp.specialisations"
                  @blur="$emit('save-skill', comp)"
                  class="w-full border border-stone-300 rounded px-2 py-1 font-montserrat text-xs"
                  placeholder="Séparées par ,"
                />
                <span v-else class="font-montserrat text-xs">{{ comp.specialisations }}</span>
              </td>
              <td class="py-1 px-1 text-center">
                <button
                  @click="$emit('open-description-modal', comp)"
                  class="px-2 py-1 text-white rounded text-xs font-bold font-katana"
                  title="Voir/Modifier la description"
                >
                  📝
                </button>
              </td>
              <td class="py-1 px-1">
                <button
                  v-if="modeEditionCompetences"
                  @click="$emit('delete-skill', comp.id)"
                  class="text-red-600 hover:text-red-800 font-bold text-xs"
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
        <div class="flex flex-col gap-2 flex-shrink-0">
           <button
            @click="$emit('open-nd-modal')"
            class="px-4 py-2 bg-gradient-to-b from-orange-700 to-orange-900 text-white rounded-lg font-bold transition-all shadow-lg font-katana"
            title="Voir la table de référence des ND"
          >
            ?
          </button>
          <button
            @click="modeEditionCompetences = !modeEditionCompetences"
            class="px-4 py-2 bg-gradient-to-b from-blue-700 to-blue-900 text-white rounded-lg font-bold transition-all shadow-lg font-katana"
          >
            {{ modeEditionCompetences ? '✓' : '✏️' }}
          </button>
          <button
            @click="$emit('add-skill')"
            class="px-4 py-2 bg-gradient-to-b from-green-700 to-green-900 text-white rounded-lg font-bold transition-all shadow-lg font-katana"
          >
            +
          </button>
        </div>
    </div>
  </div>
</template>

<script setup>
const modeEditionCompetences = ref(false)

const props = defineProps({
  competences: {
    type: Array,
    required: true
  },
  personnageData: {
    type: Object,
    default: () => ({})
  }
})

defineEmits(['open-nd-modal', 'add-skill', 'save-skill', 'open-description-modal', 'delete-skill'])

const getTraitValue = (traitName) => {
  if (!traitName || !props.personnageData) return ''
  
  const traitMap = {
    'Constitution': props.personnageData.constitution,
    'Volonté': props.personnageData.volonte,
    'Force': props.personnageData.force,
    'Perception': props.personnageData.perception,
    'Intelligence': props.personnageData.intelligence,
    'Agilité': props.personnageData.agilite,
    'Réflexes': props.personnageData.reflexes,
    'Intuition': props.personnageData.intuition
  }
  
  return traitMap[traitName] || ''
}

const calculerJet = (comp) => {
  // This function should be passed as a prop or computed in the parent
  return `${comp.rang}k${comp.rang}`
}
</script>