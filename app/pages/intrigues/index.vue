<template>
  <PageWrapper :loading="loading" loading-message="Chargement des intrigues...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

    <div class="flex flex-col mt-8">
        <!-- Bouton creer nouvelle intrigue -->
        <div class="mb-6 flex gap-4 items-center justify-center">
          <BackButton @click="ouvrirModal()">Nouvelle intrigue</BackButton>
        </div>

        <!-- Liste des intrigues en cours -->
        <div v-if="intriguesEnCours.length > 0" class="mb-8">
          <div class="flex flex-wrap justify-center gap-6 px-12">
            <NuxtLink
              v-for="intrigue in intriguesEnCours"
              :key="intrigue.id"
              :to="`/intrigues/${intrigue.id}`"
              class="cursor-pointer transition-all duration-300 hover:scale-105 relative group"
            >
              <img
                :src="`/intrigues/${intrigue.image || 1}.png`"
                :alt="intrigue.titre"
                class="w-70 h-66 object-cover"
              />
              <div class="absolute inset-0 flex flex-col justify-end p-4">
                <h3 class="text-white font-bold text-lg font-sakurata">{{ intrigue.titre }}</h3>
                <span class="text-amber-300 text-xs font-montserrat">{{ getStatutLabel(intrigue.statut) }}</span>
              </div>
            </NuxtLink>
          </div>
        </div>

        <!-- Liste des intrigues resolues -->
        <div v-if="intriguesResolues.length > 0" class="mb-8">
          <h2 class="text-2xl font-bold text-stone-700 font-sakurata mb-4 text-center">Intrigues resolues</h2>
          <div class="flex flex-wrap justify-center gap-6 px-12">
            <NuxtLink
              v-for="intrigue in intriguesResolues"
              :key="intrigue.id"
              :to="`/intrigues/${intrigue.id}`"
              class="overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105 relative group opacity-70 hover:opacity-100"
            >
              <img
                :src="`/intrigues/${intrigue.image || 1}.png`"
                :alt="intrigue.titre"
                class="w-70 h-66 object-cover grayscale group-hover:grayscale-0 transition-all"
              />
              <div class="absolute inset-0 flex flex-col justify-end p-4">
                <h3 class="text-white font-bold text-lg font-sakurata">{{ intrigue.titre }}</h3>
                <span class="text-green-400 text-xs font-montserrat">Resolue</span>
              </div>
            </NuxtLink>
          </div>
        </div>

        <!-- Message si aucune intrigue -->
        <div v-if="intrigues.length === 0" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80 max-w-md mx-auto">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune intrigue pour le moment</p>
              <p class="text-stone-600 font-montserrat">Creez votre premiere intrigue !</p>
            </div>
          </div>
        </div>
    </div>

    <!-- Modal de creation/edition -->
    <div v-if="afficherModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherModal = false">
      <div class="bg-amber-50 rounded-2xl max-w-2xl w-full border-4 border-amber-900/40 flex flex-col relative">
        <!-- En-tete -->
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
          <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
            <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
              {{ intrigueEnEdition ? 'Modifier l\'intrigue' : 'Nouvelle intrigue' }}
            </h3>
            <button
              @click="afficherModal = false"
              class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
              type="button"
            >
              x
            </button>
          </div>
        </div>

        <!-- Contenu -->
        <div class="overflow-y-auto flex-1 p-6">
          <form @submit.prevent="sauvegarderIntrigue" class="space-y-6">
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Titre *</label>
              <input
                v-model="formulaire.titre"
                type="text"
                required
                class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-lg"
                placeholder="Le mysterieux messager..."
              />
            </div>

            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Description</label>
              <textarea
                v-model="formulaire.description"
                rows="4"
                class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat"
                placeholder="Decrivez l'intrigue..."
              ></textarea>
            </div>

            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Statut</label>
              <select
                v-model="formulaire.statut"
                class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat"
              >
                <option value="en_cours">En cours</option>
                <option value="en_pause">En pause</option>
                <option value="resolue">Resolue</option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Image</label>
              <div class="grid grid-cols-3 gap-4">
                <button
                  v-for="i in 6"
                  :key="i"
                  type="button"
                  @click="formulaire.image = i"
                  class="relative rounded-lg overflow-hidden transition-all duration-200"
                  :class="formulaire.image === i ? 'ring-4 ring-amber-600 scale-105' : 'opacity-70 hover:opacity-100'"
                >
                  <img
                    :src="`/intrigues/${i}.png`"
                    :alt="`Image ${i}`"
                    class="w-full h-20 object-cover"
                  />
                </button>
              </div>
            </div>

            <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
              <button
                type="submit"
                class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 text-amber-50 font-katana"
              >
                Enregistrer
              </button>
              <button
                type="button"
                @click="afficherModal = false"
                class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
              >
                Annuler
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const loading = ref(true)
const intrigues = ref([])
const afficherModal = ref(false)
const intrigueEnEdition = ref(null)
const formulaire = ref({
  titre: '',
  description: '',
  statut: 'en_cours',
  image: 1
})

// Rediriger si pas de personnage actif
onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await chargerIntrigues()
    } finally {
      loading.value = false
    }
  }
})

const chargerIntrigues = async () => {
  if (!personnageActif.value?.id) return

  const { data } = await client
    .from('intrigues')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('created_at', { ascending: false })

  intrigues.value = data || []
}

const intriguesEnCours = computed(() => {
  return intrigues.value.filter(i => i.statut !== 'resolue')
})

const intriguesResolues = computed(() => {
  return intrigues.value.filter(i => i.statut === 'resolue')
})

const getStatutLabel = (statut) => {
  const labels = {
    'en_cours': 'En cours',
    'en_pause': 'En pause',
    'resolue': 'Resolue'
  }
  return labels[statut] || statut
}

const ouvrirModal = (intrigue = null) => {
  if (intrigue) {
    intrigueEnEdition.value = intrigue
    formulaire.value = {
      titre: intrigue.titre,
      description: intrigue.description || '',
      statut: intrigue.statut || 'en_cours',
      image: intrigue.image || 1
    }
  } else {
    intrigueEnEdition.value = null
    formulaire.value = {
      titre: '',
      description: '',
      statut: 'en_cours',
      image: 1
    }
  }
  afficherModal.value = true
}

const sauvegarderIntrigue = async () => {
  if (!personnageActif.value?.id) return

  if (intrigueEnEdition.value) {
    const { error } = await client
      .from('intrigues')
      .update({
        titre: formulaire.value.titre,
        description: formulaire.value.description,
        statut: formulaire.value.statut,
        image: formulaire.value.image,
        updated_at: new Date().toISOString()
      })
      .eq('id', intrigueEnEdition.value.id)

    if (!error) {
      await chargerIntrigues()
      afficherModal.value = false
    }
  } else {
    const { error } = await client
      .from('intrigues')
      .insert([{
        personnage_id: personnageActif.value.id,
        titre: formulaire.value.titre,
        description: formulaire.value.description,
        statut: formulaire.value.statut,
        image: formulaire.value.image
      }])

    if (!error) {
      await chargerIntrigues()
      afficherModal.value = false
    }
  }
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>
