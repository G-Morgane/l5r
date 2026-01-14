<template>
  <div class=" px-4 py-2 relative overflow-hidden">
    <div class="absolute inset-0" style="background-image: url('/fond_bouton.png'); background-size: 100% 100%;"></div>
    <div class="relative z-10 px-12 py-4">
      <div class="space-y-3">
        <div>
          <label class="block font-bold mb-2 font-katana">Koku <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap"> = {{ ressources.koku * 5 }} bu & {{ ressources.koku * 50 }} zeni</span>
            </label>

          <div class="flex items-center gap-3">
            <input
              v-model.number="ressources.koku"
              type="number"
              @blur="$emit('save-resources')"
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-xs font-montserrat"
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
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-xs font-montserrat"
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
              class="bg-white/100 flex-1 border-2 border-stone-300 rounded px-2 py-0.5 font-bold text-xs font-montserrat"
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