<template>
  <div class="grid grid-cols-1 lg:grid-cols-[2.25fr_1fr] gap-6">
    <!-- Honneur, Gloire, Statut, Souillure -->
    <div class="relative px-2 py-2 border-4 border-amber-800 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
      <div class="relative z-10 px-4 py-2">
        <div class="flex flex-row flex-wrap gap-4 justify-between">
          <div>
            <div class="flex items-center gap-2 mb-0.5">
              <label class="text-xs font-bold font-sigokae">Honneur</label>
              <button
                @mouseenter="showTooltip('honneur'); updateTooltipPosition($event)"
                @mouseleave="hideTooltip"
                class="w-4 h-4 rounded-full bg-amber-600 hover:bg-amber-700 text-white flex items-center justify-center text-xs font-montserrat font-bold"
                title="Historique des changements d'honneur"
              >
                ?
              </button>
            </div>
            <div class="flex items-center gap-1">
              <img src="/profil/honneur.png" alt="Honneur" class="w-10 h-10" />
              <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 cursor-pointer transition-all hover:scale-110 relative overflow-hidden"
                :style="{ borderColor: '#B84601' }"
                @click="personnageData.honneur = personnageData.honneur === i ? i - 0.5 : i; $emit('save')"
              >
                <div
                  class="absolute inset-0 transition-all"
                  :style="{ backgroundColor: '#FFCD41', clipPath: personnageData.honneur >= i ? 'inset(0 0 0 0)' : personnageData.honneur >= i - 0.5 ? 'inset(0 50% 0 0)' : 'inset(0 100% 0 0)' }"
                ></div>
              </div>
            </div>
          </div>
          <div>
            <div class="flex items-center gap-2 mb-0.5">
              
              <label class="text-xs font-bold font-sigokae">Gloire</label>
              <button
                @mouseenter="showTooltip('gloire'); updateTooltipPosition($event)"
                @mouseleave="hideTooltip"
                class="w-4 h-4 rounded-full bg-amber-600 hover:bg-amber-700 text-white flex items-center justify-center text-xs font-bold"
                title="Historique des changements de gloire"
              >
                ?
              </button>
            </div>
            <div class="flex items-center gap-1">
              <img src="/profil/gloire.png" alt="Gloire" class="w-10 h-10" />
              <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 cursor-pointer transition-all hover:scale-110"
                :style="{ borderColor: '#BB1103', backgroundColor: i <= personnageData.gloire ? '#F23805' : 'transparent' }"
                @click="personnageData.gloire = i; $emit('save')"
              ></div>
            </div>
          </div>
          <div>
            <div class="flex items-center gap-2 mb-0.5">
              <label class="text-xs font-bold font-sigokae">Statut</label>
              <button
                @mouseenter="showTooltip('statut'); updateTooltipPosition($event)"
                @mouseleave="hideTooltip"
                class="w-4 h-4 rounded-full bg-amber-600 hover:bg-amber-700 text-white flex items-center justify-center text-xs font-bold"
                title="Historique des changements de statut"
              >
                ?
              </button>
            </div>
            <div class="flex items-center gap-1">
              <img src="/profil/statut.png" alt="Statut" class="w-10 h-10" />
              <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 cursor-pointer transition-all hover:scale-110"
                :style="{ borderColor: '#A29181', backgroundColor: i <= personnageData.statut_social ? '#B6A38D' : 'transparent' }"
                @click="personnageData.statut_social = i; $emit('save')"
              ></div>
            </div>
          </div>
          <div>
            <div class="flex items-center gap-2 mb-0.5">
              <label class="text-xs font-bold font-sigokae">Souillure</label>
              <button
                @mouseenter="showTooltip('souillure'); updateTooltipPosition($event)"
                @mouseleave="hideTooltip"
                class="w-4 h-4 rounded-full bg-amber-600 hover:bg-amber-700 text-white flex items-center justify-center text-xs font-bold"
                title="Historique des changements de souillure"
              >
                ?
              </button>
            </div>
            <div class="flex items-center gap-1">
              <img src="/profil/souillure.png" alt="Souillure" class="w-10 h-10" />
              <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 cursor-pointer transition-all hover:scale-110"
                :style="{ borderColor: '#470602', backgroundColor: i <= personnageData.souillure ? '#8B1503' : 'transparent' }"
                @click="personnageData.souillure = personnageData.souillure === i ? 0 : i; $emit('save')"
              ></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Initiative & XP -->
    <div class="relative px-2 pt-1 border-4 border-amber-800 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
      <div class="relative z-10 px-6 py-2 space-y-3 flex flex-col h-full py-8 justify-between">
        <div>
          <div class="grid grid-cols-3 gap-2">
            <div>
              <div class="flex items-center justify-center gap-1 mb-1">
                <label class="text-xs text-center block font-montserrat">XP Total</label>
                <button
                  @mouseenter="showTooltip('xp'); updateTooltipPosition($event)"
                  @mouseleave="hideTooltip"
                  class="w-4 h-4 rounded-full bg-amber-600 hover:bg-amber-700 text-white flex items-center justify-center text-xs font-bold"
                  title="Historique des changements d'XP"
                >
                  ?
                </button>
              </div>
              <input
                :value="personnageData.experience_points"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">XP Dépensé</label>
              <div class="flex items-center justify-center gap-1">
                <input
                  :value="experienceDepenseAuto"
                  type="number"
                  readonly
                  class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
                <button
                  @click="$emit('open-xp-modal')"
                  class="w-5 h-5 rounded-full bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center text-xs font-bold ml-1"
                  title="Détail des dépenses d'XP"
                >
                  ?
                </button>
              </div>
            </div>
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">XP Restant</label>
              <input
                :value="experienceRestant"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
          </div>
        </div>
        <div>
          <div class="grid grid-cols-2 gap-2">
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Réputation Pts</label>
              <input
                :value="reputationPoints"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Rang</label>
              <input
                :value="rangReputation"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Tooltip d'historique -->
  <div
    v-if="tooltipVisible"
    class="fixed z-50 bg-stone-50 text-white rounded-lg p-3 shadow-xl border border-red-900 max-w-xs pointer-events-none font-montserrat"
    :style="{ left: tooltipPosition.x + 'px', top: tooltipPosition.y + 'px' }"
  >
    <div class="space-y-1 max-h-64 overflow-y-auto">
      <div
        v-for="(item, index) in tooltipContent"
        :key="item.titre + item.date"
        :class="[
          'text-xs flex flex-row gap-3 items-center justify-between py-1 px-2 rounded',
          index < tooltipContent.length - 1 ? 'border-b border-stone-300' : ''
        ]"
      >
        <div class="font-semibold text-red-900 truncate flex-1">{{ item.titre }}</div>
        <div :class="item.valeur > 0 ? 'text-green-700' : 'text-red-800'">{{ item.valeur > 0 ? '+' : '' }}{{ item.valeur }}</div>
        <div class="text-xs text-stone-400">{{ item.date }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  personnageData: {
    type: Object,
    required: true
  },
  minimumExperiencePoints: {
    type: Number,
    required: true
  },
  experienceDepenseAuto: {
    type: Number,
    required: true
  },
  experienceRestant: {
    type: Number,
    required: true
  },
  reputationPoints: {
    type: Number,
    required: true
  },
  rangReputation: {
    type: Number,
    required: true
  },
  historiqueChangements: {
    type: Array,
    default: () => []
  }
})

defineEmits(['save', 'open-xp-modal'])

const tooltipVisible = ref(false)
const tooltipContent = ref([])
const tooltipPosition = ref({ x: 0, y: 0 })

const showTooltip = (statType) => {
  const changements = props.historiqueChangements.filter(entry => {
    switch (statType) {
      case 'honneur':
        return entry.honneur_change !== 0
      case 'gloire':
        return entry.gloire_change !== 0
      case 'statut':
        return entry.statut_change !== 0
      case 'souillure':
        return entry.souillure_change !== 0
      case 'xp':
        return entry.xp_change !== 0
      default:
        return false
    }
  }).slice(0, 10) // Limiter à 10 entrées les plus récentes

  if (changements.length > 0) {
    tooltipContent.value = changements.map(entry => ({
      titre: entry.titre,
      date: new Date(entry.created_at).toLocaleDateString('fr-FR'),
      valeur: statType === 'xp' ? entry.xp_change :
              statType === 'honneur' ? entry.honneur_change :
              statType === 'gloire' ? entry.gloire_change :
              statType === 'statut' ? entry.statut_change :
              entry.souillure_change
    }))
    tooltipVisible.value = true
  }
}

const hideTooltip = () => {
  tooltipVisible.value = false
  tooltipContent.value = []
}

const updateTooltipPosition = (event) => {
  tooltipPosition.value = {
    x: event.clientX + 10,
    y: event.clientY + 10
  }
}
</script>