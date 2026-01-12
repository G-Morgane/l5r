<template>
  <div class="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 z-50 animate-in fade-in duration-300">
    <div class="bg-gradient-to-br from-stone-900 to-red-950 rounded-2xl p-8 max-w-md w-full border-2 border-amber-900/50 shadow-2xl">
      <h3 class="text-3xl font-bold mb-8 text-amber-100 text-center">✨ Nouveau personnage</h3>
      <form @submit.prevent="handleSubmit" class="space-y-5">
        <div>
          <label class="block text-sm font-semibold mb-2 text-amber-200 font-montserrat">Nom *</label>
          <input v-model="form.nom" type="text" required class="w-full bg-stone-950/50 border-2 border-amber-900/30 focus:border-amber-600 rounded-lg px-4 py-3 transition-colors outline-none text-white" placeholder="Bayushi Aramoro" />
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2 text-amber-200 font-montserrat">Clan</label>
          <select v-model="form.clan" class="w-full bg-stone-950/50 border-2 border-amber-900/30 focus:border-amber-600 rounded-lg px-4 py-3 transition-colors outline-none text-white cursor-pointer">
            <option value="">-- Choisir un clan --</option>
            <option v-for="clan in clans" :key="clan.nom" :value="clan.nom">{{ clan.nom }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2 text-amber-200 font-montserrat">Famille</label>
          <select v-model="form.famille" :disabled="!form.clan" class="w-full bg-stone-950/50 border-2 border-amber-900/30 focus:border-amber-600 rounded-lg px-4 py-3 transition-colors outline-none text-white cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed">
            <option value="">{{ form.clan ? '-- Choisir une famille --' : '-- Sélectionnez d\'abord un clan --' }}</option>
            <option v-for="famille in famillesDisponibles" :key="famille" :value="famille">{{ famille }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2 text-amber-200 font-montserrat">École</label>
          <input v-model="form.ecole" type="text" class="w-full bg-stone-950/50 border-2 border-amber-900/30 focus:border-amber-600 rounded-lg px-4 py-3 transition-colors outline-none text-white" placeholder="École des courtisans" />
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2 text-amber-200 font-montserrat">Description</label>
          <textarea v-model="form.description" rows="3" class="w-full bg-stone-950/50 border-2 border-amber-900/30 focus:border-amber-600 rounded-lg px-4 py-3 transition-colors outline-none text-white resize-none" placeholder="Histoire du personnage..."></textarea>
        </div>
        <div class="flex gap-4 pt-4">
          <button type="submit" class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-4 py-3 rounded-xl font-bold transition-all duration-300 shadow-lg hover:shadow-red-900/50">
            ⚔ Créer
          </button>
          <button type="button" @click="$emit('close')" class="flex-1 bg-stone-800 hover:bg-stone-700 border-2 border-amber-900/30 px-4 py-3 rounded-xl font-semibold transition-all duration-300">
            Annuler
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
  }
})

const emit = defineEmits(['close', 'submit'])

const form = ref({
  nom: '',
  clan: '',
  famille: '',
  ecole: '',
  description: ''
})

const famillesDisponibles = computed(() => {
  const clanSelectionne = props.clans.find(c => c.nom === form.value.clan)
  return clanSelectionne ? clanSelectionne.familles : []
})

watch(() => form.value.clan, () => {
  form.value.famille = ''
})

const handleSubmit = () => {
  emit('submit', form.value)
  form.value = { nom: '', clan: '', famille: '', ecole: '', description: '' }
}
</script>
