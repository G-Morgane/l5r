<template>
  <div class="rounded-xl px-4 py-2 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90 ">
    <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
    <div class="absolute inset-0 bg-amber-50/30"></div>
    <div class="relative z-10">
      <div class="space-y-3">
        <div>
          <label class="block font-bold mb-2 font-katana">Koku <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap"> = {{ ressources.koku * 5 }} bu & {{ ressources.koku * 50 }} zeni</span>
            </label>

          <div class="flex items-center gap-3">
            <input
              v-model.number="ressources.koku"
              type="number"
              @blur="$emit('save-resources')"
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-sm font-montserrat"
            />
          </div>
        </div>
        <div>
          <label class="block font-bold mb-2 font-katana">Bu <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap"> (Argent) = {{ ressources.bu * 10 }} zeni & {{ ressources.bu / 5 }} koku</span>
</label>
          <div class="flex items-center gap-3">
            <input
              v-model.number="ressources.bu"
              type="number"
              @blur="$emit('save-resources')"
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-sm font-montserrat"
            />
          </div>
        </div>
        <div>
          <label class="block font-bold mb-2 font-katana">Zeni <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap">(Cuivre) = {{ ressources.zeni / 10 }} bu & {{ ressources.zeni / 50 }} koku </span></label>
          <div class="flex items-center">
            <input
              v-model.number="ressources.zeni"
              type="number"
              @blur="$emit('save-resources')"
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-sm font-montserrat"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  ressources: {
    type: Object,
    required: true
  }
})

defineEmits(['save-resources'])
</script>