<template>
  <div class="px-6 pt-6 pb-3 relative overflow-hidden">
    <div class="absolute inset-0" style="background-image: url('/parchemin_side_side.png'); background-size: 100% 100%;"></div>
    <div class="relative z-10">
      <div class="flex flex-wrap justify-between gap-4 px-12">
        <!-- Terre -->
        <div class="flex flex-col items-center w-36">
          <div class="relative mb-2">
            <div class="w-28 h-28 rounded-full flex items-center justify-center shadow-xl">
              <img :src="terreSvg" alt="Terre" class="w-24 h-24" />
            </div>
            <input
              v-model.number="personnageData.terre"
              type="number"
              @blur="$emit('save')"
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-amber-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat appearance-none"
            />
          </div>
          <div class="w-full space-y-0 text-xs">
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Constitution</label>
              <input
                v-model.number="personnageData.constitution"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Volonté</label>
              <input
                v-model.number="personnageData.volonte"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
          </div>
        </div>

        <!-- Eau -->
        <div class="flex flex-col items-center w-36">
          <div class="relative mb-2">
            <div class="w-28 h-28 rounded-full flex items-center justify-center shadow-xl">
              <img :src="eauSvg" alt="Eau" class="w-24 h-24" />
            </div>
            <input
              v-model.number="personnageData.eau"
              type="number"
              @blur="$emit('save')"
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-blue-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat appearance-none"
            />
          </div>
          <div class="w-full space-y-0 text-xs">
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Force</label>
              <input
                v-model.number="personnageData.force"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Perception</label>
              <input
                v-model.number="personnageData.perception"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
          </div>
        </div>

        <!-- Feu -->
        <div class="flex flex-col items-center w-36">
          <div class="relative mb-2">
            <div class="w-28 h-28 rounded-full flex items-center justify-center shadow-xl">
              <img :src="feuSvg" alt="Feu" class="w-24 h-24" />
            </div>
            <input
              v-model.number="personnageData.feu"
              type="number"
              @blur="$emit('save')"
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-red-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat appearance-none"
            />
          </div>
          <div class="w-full space-y-0 text-xs">
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Intelligence</label>
              <input
                v-model.number="personnageData.intelligence"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Agilité</label>
              <input
                v-model.number="personnageData.agilite"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
          </div>
        </div>

        <!-- Air -->
        <div class="flex flex-col items-center w-36">
          <div class="relative mb-2">
            <div class="w-28 h-28 rounded-full flex items-center justify-center shadow-xl">
              <img :src="airSvg" alt="Air" class="w-24 h-24" />
            </div>
            <input
              v-model.number="personnageData.air"
              type="number"
              @blur="$emit('save')"
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-gray-700 rounded-full text-center font-bold text-base shadow-lg font-montserrat appearance-none"
            />
          </div>
          <div class="w-full space-y-0 text-xs">
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Réflexes</label>
              <input
                v-model.number="personnageData.reflexes"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
            <div class="flex items-center justify-between px-4">
              <label class="font-semibold font-montserrat text-[10px]">Intuition</label>
              <input
                v-model.number="personnageData.intuition"
                type="number"
                @blur="$emit('save')"
                class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat appearance-none"
              />
            </div>
          </div>
        </div>

        <!-- Vide -->
        <div class="flex flex-col items-center w-36">
          <div class="relative mb-2">
            <div class="w-28 h-28 rounded-full flex items-center justify-center shadow-xl">
              <img :src="videSvg" alt="Vide" class="w-24 h-24" />
            </div>
            <input
              v-model.number="personnageData.vide"
              type="number"
              @blur="$emit('save')"
              class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-purple-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat appearance-none"
            />
          </div>
          <p class="text-[10px] text-center text-stone-600 italic font-montserrat">Points de Vide</p>
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
  }
})

defineEmits(['save'])

// Chemins des images SVG depuis le dossier public
const terreSvg = computed(() => '/terre.png')
const eauSvg = computed(() => '/eau.png')
const feuSvg = computed(() => '/feu.png')
const airSvg = computed(() => '/air.png')
const videSvg = computed(() => '/vide.png')
</script>