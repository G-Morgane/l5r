<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 font-montserrat" @click.self="$emit('close')">
    <div class="bg-white rounded-xl p-6 max-w-2xl w-full mx-4 shadow-2xl border-2 border-amber-800/60 max-h-[90vh] overflow-y-auto">
      <!-- Header -->
      <div class="flex justify-between items-center mb-6">
        <h3 class="text-2xl font-bold text-red-900 font-sakurata">
          {{ personnage ? 'Modifier le personnage' : 'Nouveau personnage' }}
        </h3>
        <button
          @click="$emit('close')"
          class="text-red-600 hover:text-red-800 font-bold text-3xl"
        >
          ×
        </button>
      </div>

      <form @submit.prevent="handleSubmit" class="space-y-5">
        <!-- Nom -->
        <div>
          <label class="block text-sm font-semibold mb-2 text-stone-700">Nom *</label>
          <input
            v-model="form.nom"
            type="text"
            required
            class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
            placeholder="Ex: Bayushi Aramoro"
          />
        </div>

        <!-- Clan et Famille sur la même ligne -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Clan</label>
            <select
              v-model="form.clan"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors cursor-pointer"
            >
              <option value="">-- Choisir un clan --</option>
              <option v-for="clan in clans" :key="clan.nom" :value="clan.nom">{{ clan.nom }}</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Famille</label>
            <select
              v-model="form.famille"
              :disabled="!form.clan"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed disabled:bg-stone-100"
            >
              <option value="">{{ form.clan ? '-- Choisir une famille --' : '-- Sélectionnez d\'abord un clan --' }}</option>
              <option v-for="famille in famillesDisponibles" :key="famille" :value="famille">{{ famille }}</option>
            </select>
          </div>
        </div>

        <!-- École -->
        <div>
          <label class="block text-sm font-semibold mb-2 text-stone-700">École</label>
          <input
            v-model="form.ecole"
            type="text"
            class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
            placeholder="Ex: École des courtisans Bayushi"
          />
        </div>

        <!-- Rang et XP sur la même ligne -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Rang</label>
            <input
              v-model.number="form.rang"
              type="number"
              min="1"
              max="10"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="1"
            />
          </div>
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Points d'expérience</label>
            <input
              v-model.number="form.experience_points"
              type="number"
              min="0"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="40"
            />
          </div>
        </div>

        <!-- Honneur, Gloire, Statut sur la même ligne -->
        <div class="grid grid-cols-3 gap-4">
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Honneur</label>
            <input
              v-model.number="form.honneur"
              type="number"
              min="0"
              max="10"
              step="0.1"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="5"
            />
          </div>
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Gloire</label>
            <input
              v-model.number="form.gloire"
              type="number"
              min="0"
              max="10"
              step="0.1"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="1"
            />
          </div>
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Statut</label>
            <input
              v-model.number="form.statut_social"
              type="number"
              min="0"
              max="10"
              step="0.1"
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="1"
            />
          </div>
        </div>

        <!-- Description -->
        <div>
          <label class="block text-sm font-semibold mb-2 text-stone-700">Description / Histoire</label>
          <textarea
            v-model="form.description"
            rows="4"
            class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors resize-none"
            placeholder="L'histoire et la personnalité du personnage..."
          ></textarea>
        </div>

        <!-- Boutons -->
        <div class="flex justify-end gap-3 pt-4 border-t border-stone-200">
          <button
            type="button"
            @click="$emit('close')"
            class="px-6 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-bold font-katana transition-colors"
          >
            Annuler
          </button>
          <button
            type="submit"
            class="px-6 py-2 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-white rounded-lg font-bold font-katana transition-all duration-300 shadow-lg"
          >
            {{ personnage ? 'Sauvegarder' : 'Créer le personnage' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  clans: {
    type: Array,
    required: true
  },
  personnage: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'submit'])

const getDefaultForm = () => ({
  nom: '',
  clan: '',
  famille: '',
  ecole: '',
  rang: 1,
  experience_points: 40,
  honneur: 5,
  gloire: 1,
  statut_social: 1,
  description: ''
})

const form = reactive(getDefaultForm())

// Initialiser le formulaire avec les données du personnage si en mode édition
watch(() => props.personnage, (newPersonnage) => {
  if (newPersonnage) {
    Object.assign(form, {
      nom: newPersonnage.nom || '',
      clan: newPersonnage.clan || '',
      famille: newPersonnage.famille || '',
      ecole: newPersonnage.ecole || '',
      rang: newPersonnage.rang || 1,
      experience_points: newPersonnage.experience_points || 40,
      honneur: newPersonnage.honneur || 5,
      gloire: newPersonnage.gloire || 1,
      statut_social: newPersonnage.statut_social || 1,
      description: newPersonnage.description || ''
    })
  } else {
    Object.assign(form, getDefaultForm())
  }
}, { immediate: true })

const famillesDisponibles = computed(() => {
  const clanSelectionne = props.clans.find(c => c.nom === form.clan)
  return clanSelectionne ? clanSelectionne.familles : []
})

watch(() => form.clan, (newClan, oldClan) => {
  // Ne réinitialiser la famille que si on change vraiment de clan
  if (oldClan && newClan !== oldClan) {
    form.famille = ''
  }
})

const handleSubmit = () => {
  emit('submit', { ...form })
}
</script>
