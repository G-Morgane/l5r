<template>
  <div class="relative overflow-hidden min-h-screen">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0" style="background-image: url('/fond_long.png'), url('/bas_fond.png'); background-position: top, bottom; background-repeat: no-repeat; background-size: 100% auto, 100% auto;">
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- En-tête personnage -->
      <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="changeCharacter()"
        />

      <div class="flex flex-col">

        <!-- En-tête avec bouton retour -->
        <div class="mb-8 flex gap-4 items-center px-12">
          <div class="relative flex-1">
            <div class="relative rounded-xl overflow-hidden">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <input 
                v-model="searchQuery"
                type="text"
                :placeholder="`🔍 Rechercher dans ${categoryName}...`"
                class="relative z-10 w-full bg-transparent border-2 border-amber-800/60 focus:border-amber-700 rounded-xl px-4 py-2 pr-10 transition-all outline-none text-stone-900 placeholder:text-stone-500 font-montserrat text-sm"
              />
            </div>
            <button 
              v-if="searchQuery"
              @click="searchQuery = ''"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-stone-500 hover:text-stone-900 transition-colors text-xl font-bold z-20"
            >
              ×
            </button>
          </div>
           <BackButton @click="afficherFormulaire = true">Nouveau</BackButton>
        </div>

        <!-- Liste des entrées -->
        <div class="flex-1 overflow-y-auto">
          <div v-if="itemsFiltres.length === 0 && searchQuery" class="text-center py-12">
            <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <div class="relative z-10">
                <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
                <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
              </div>
            </div>
          </div>
          <div v-else-if="items.length === 0" class="text-center py-12">
            <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <div class="relative z-10">
                <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune entrée pour le moment</p>
                <p class="text-stone-600 font-montserrat">Commencez à documenter votre univers !</p>
              </div>
            </div>
          </div>
          <div v-else class="grid grid-cols-4 gap-4 px-12 max-h-[40vh] overflow-y-auto">
            <NuxtLink
              v-for="item in itemsFiltres"
              :key="item.id"
              :to="`/wiki/${item.slug}`"
              class="px-3 py-2 rounded-lg bg-amber-50/20 hover:bg-amber-100/50 transition-colors border border-amber-800/20 hover:border-amber-700 text-center"
            >
              <h3 class="text-sm font-bold text-stone-900 font-manga truncate">{{ item.nom }}</h3>
            </NuxtLink>
          </div>
        </div>

        <!-- Modal formulaire -->
        <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="fermerFormulaire">
          <div class="bg-amber-50 rounded-2xl max-w-2xl w-full border-4 border-amber-900/40 flex flex-col relative">
            <!-- En-tête -->
            <div class="relative overflow-hidden border-b-4 border-amber-900/20">
              <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
              <div class="relative px-8 py-6 flex items-center justify-between">
                <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                  <span class="text-xl">{{ categoryEmoji }}</span>
                  Nouvelle entrée {{ categoryName.toLowerCase() }}
                </h3>
                <button 
                  @click="fermerFormulaire" 
                  class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
                  type="button"
                >
                  ×
                </button>
              </div>
            </div>

            <!-- Contenu -->
            <div class="overflow-y-auto flex-1 p-8 bg-amber-50/80">
              <form @submit.prevent="creerItem" class="space-y-6">
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Nom *</label>
                  <input 
                    v-model="nouvelItem.nom" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-lg" 
                    :placeholder="`Nom du ${categoryName.toLowerCase().slice(0, -1)}...`"
                  />
                </div>

                <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
                  <button 
                    type="submit" 
                    class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 text-amber-50 font-katana"
                  >
                    Créer
                  </button>
                  <button 
                    type="button" 
                    @click="fermerFormulaire" 
                    class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
                  >
                    Annuler
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const router = useRouter()
const route = useRoute()

const items = ref([])
const afficherFormulaire = ref(false)
const searchQuery = ref('')
const nouvelItem = ref({
  nom: '',
  categorie: ''
})

const category = computed(() => route.params.category || 'clans')

const categoryConfig = {
  clans: { name: 'Clans', emoji: '⚔️' },
  lieux: { name: 'Lieux', emoji: '🏯' },
  personnages: { name: 'Personnages', emoji: '👤' },
  autre: { name: 'Autre', emoji: '📦' }
}

const categoryName = computed(() => categoryConfig[category.value]?.name || 'Catégorie')
const categoryEmoji = computed(() => categoryConfig[category.value]?.emoji || '📑')

// Rediriger si pas de personnage actif
onMounted(() => {
  if (!personnageActif.value) {
    navigateTo('/')
  } else {
    nouvelItem.value.categorie = category.value
    chargerItems()
  }
})

const chargerItems = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .eq('categorie', category.value)
    .order('nom', { ascending: true })
  
  items.value = data || []
}

const itemsFiltres = computed(() => {
  if (!searchQuery.value.trim()) return items.value
  
  const query = searchQuery.value.toLowerCase()
  return items.value.filter(item => {
    return item.nom?.toLowerCase().includes(query) || item.description?.toLowerCase().includes(query)
  })
})

const creerItem = async () => {
  if (!personnageActif.value?.id) return
  
  // Créer le slug à partir du nom
  const slug = nouvelItem.value.nom
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
  
  const { error } = await client
    .from('wiki_items')
    .insert([{
      personnage_id: personnageActif.value.id,
      ...nouvelItem.value,
      slug,
      description: '',
      tags: []
    }])

  if (!error) {
    // Recharger les items pour mettre à jour la liste
    await chargerItems()
    router.push(`/wiki/${slug}`)
    fermerFormulaire()
  }
}

const fermerFormulaire = () => {
  afficherFormulaire.value = false
  nouvelItem.value = {
    nom: '',
    categorie: category.value
  }
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>