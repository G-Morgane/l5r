<template>
  <div class="grid grid-cols-1 lg:grid-cols-[1.5fr_1fr] gap-6">
    <!-- Honneur, Gloire, Statut, Souillure -->
    <div class="rounded-xl px-4 py-2 relative overflow-hidden max-w-md">
      <div class="absolute inset-0" style="background-image: url('/square_2.png'); background-size: 100% 100%;"></div>
      <div class="relative z-10 pl-12 py-12">
        <div class="space-y-3">
          <div>
            <div class="flex items-center gap-2 mb-0.5">
              <label class="text-xs font-bold font-sigokae">Honneur</label>
              <input
                v-model.number="personnageData.honneur"
                type="number"
                step="0.1"
                min="0"
                max="10"
                @blur="$emit('save')"
                class="text-center font-bold text-xs font-montserrat"
                :style="{ color: '#B84601' }"
              />
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
              <input
                v-model.number="personnageData.gloire"
                type="number"
                step="0.1"
                min="0"
                max="10"
                @blur="$emit('save')"
                class="text-center font-bold text-xs font-montserrat"
                :style="{ color: '#BB1103' }"
              />
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
              <input
                v-model.number="personnageData.statut_social"
                type="number"
                step="0.1"
                min="0"
                max="10"
                @blur="$emit('save')"
                class="text-center font-bold text-xs font-montserrat"
                :style="{  color: '#A29181' }"
              />
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
              <input
                v-model.number="personnageData.souillure"
                type="number"
                step="0.1"
                min="0"
                max="10"
                @blur="$emit('save')"
                class="text-center font-bold text-xs font-montserrat"
                :style="{ borderColor: '#470602', color: '#470602' }"
              />
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
    <div class="rounded-xl p-4 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
      <div class="absolute inset-0" style="background-image: url('/parchemin_side.png'); background-size: cover; background-position: center;"></div>
      <div class="absolute inset-0 bg-amber-50/30"></div>
      <div class="relative z-10 space-y-3">
        <div>
          <label class="text-sm font-bold text-center block mb-1 font-katana">INITIATIVE</label>
          <input
            v-model.number="personnageData.initiative"
            type="number"
            @blur="$emit('save')"
            class="w-full border-2 border-stone-300 rounded px-2 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
          />
        </div>
        <div>
          <label class="text-sm font-bold text-center block mb-1 font-katana">EXPÉRIENCE</label>
          <div class="grid grid-cols-3 gap-2">
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Total</label>
              <input
                v-model.number="personnageData.experience_points"
                type="number"
                :min="minimumExperiencePoints"
                @blur="if (personnageData.experience_points < minimumExperiencePoints) personnageData.experience_points = minimumExperiencePoints; $emit('save')"
                class="w-full border-2 border-stone-300 rounded px-2 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
              />
            </div>
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Dépensé</label>
              <div class="flex items-center justify-center gap-1">
                <input
                  :value="experienceDepenseAuto"
                  type="number"
                  readonly
                  class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
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
              <label class="text-xs text-center block mb-1 font-montserrat">Restant</label>
              <input
                :value="experienceRestant"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
          </div>
        </div>
        <div>
          <label class="text-sm font-bold text-center block mb-1 font-katana">RÉPUTATION</label>
          <div class="grid grid-cols-2 gap-2">
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Points</label>
              <input
                :value="reputationPoints"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
            <div>
              <label class="text-xs text-center block mb-1 font-montserrat">Rang</label>
              <input
                :value="rangReputation"
                type="number"
                readonly
                class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
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
  }
})

defineEmits(['save', 'open-xp-modal'])
</script>