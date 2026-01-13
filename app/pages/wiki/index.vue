<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img 
        src="/background.png" 
        alt="Japanese room background" 
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10 h-screen flex flex-col">
      <!-- En-tête -->
      <div class="mb-8 flex-shrink-0 w-full">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">📚 Wiki</h1>
          <BackButton @click="$router.push('/')" class="mb-0" blanc>← Retour</BackButton>
        </div>


        <!-- Onglets de catégories -->
        <div class="flex gap-4 mb-8">
          <button
            v-for="cat in categories"
            :key="cat.id"
            @click="categorieActive = cat.id"
            :class="categorieActive === cat.id ? 'bg-gradient-to-r from-amber-400 to-amber-300 border-amber-900 ring-amber-700/80 scale-105 shadow-2xl' : 'bg-white/70 border-amber-800/60 ring-amber-900/30 hover:scale-102'"
            class="px-4 py-2 rounded-xl border-2 ring-4 transition-all duration-300 hover:-translate-y-1 relative overflow-hidden flex-1 shadow-xl font-katana font-bold text-sm"
          >
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div :class="categorieActive === cat.id ? 'bg-amber-100/50' : 'bg-amber-50/30'" class="absolute inset-0"></div>
            <span :class="categorieActive === cat.id ? 'text-amber-950 drop-shadow-sm' : 'text-stone-800'" class="relative z-10">{{ cat.emoji }} {{ cat.nom }}</span>
          </button>
        </div>

        <!-- Bouton créer nouvelle entrée -->
        <div class="mb-8 flex justify-between items-center gap-4">
          <div class="relative flex-1">
            <input 
              v-model="searchQuery"
              type="text"
              :placeholder="`🔍 Rechercher dans ${categories.find(c => c.id === categorieActive)?.nom}...`"
              class="w-full bg-white/90 border-2 border-amber-800/60 ring-4 ring-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 pr-12 transition-all outline-none text-stone-900 placeholder:text-stone-500 font-montserrat shadow-xl"
            />
            <button 
              v-if="searchQuery"
              @click="searchQuery = ''"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-stone-500 hover:text-stone-900 transition-colors text-xl font-bold"
            >
              ×
            </button>
          </div>
          
          <button
            @click="afficherFormulaire = true"
            class="px-5 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden flex-shrink-0"
          >
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <span class="text-lg text-red-800 font-bold relative z-10 drop-shadow-sm whitespace-nowrap font-katana">✚ Nouvelle entrée</span>
          </button>
        </div>
      </div>

      <!-- Liste des entrées -->
      <div class="flex-1 overflow-y-auto pr-4">
        <div v-if="itemsFiltres.length === 0 && searchQuery" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
              <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
            </div>
          </div>
        </div>
        <div v-else-if="categorieActive !== 'tout' && items.filter(i => i.categorie === categorieActive).length === 0" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune entrée pour le moment</p>
              <p class="text-stone-600 font-montserrat">Commencez à documenter votre univers !</p>
            </div>
          </div>
        </div>

        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <NuxtLink
            v-for="item in itemsFiltres"
            :key="item.id"
            :to="`/wiki/${item.slug}`"
            class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white/80 cursor-pointer"
          >
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <h3 class="text-2xl font-bold text-stone-900 font-manga mb-2">{{ item.nom }}</h3>
              <p class="text-stone-700 text-sm font-montserrat line-clamp-3 mb-3" v-html="item.description || 'Aucune description'"></p>
              <div v-if="item.tags && item.tags.length > 0" class="flex flex-wrap gap-1">
                <span 
                  v-for="(tag, index) in item.tags.slice(0, 3)" 
                  :key="index"
                  class="inline-flex items-center gap-1 px-2 py-0.5 bg-amber-200/70 text-stone-800 rounded-md font-montserrat text-xs"
                >
                  🔗 {{ tag }}
                </span>
                <span v-if="item.tags.length > 3" class="inline-flex items-center px-2 py-0.5 text-stone-600 font-montserrat text-xs">
                  +{{ item.tags.length - 3 }}
                </span>
              </div>
            </div>
          </NuxtLink>
        </div>
      </div>

      <!-- Modal formulaire -->
      <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="fermerFormulaire">
        <div class="bg-amber-50 rounded-2xl max-w-2xl w-full border-4 border-amber-900/40 shadow-2xl max-h-[95vh] overflow-hidden flex flex-col relative">
          <!-- En-tête -->
          <div class="relative overflow-hidden border-b-4 border-amber-900/20">
            <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
            <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
              <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                <span class="text-xl">📝</span>
                Nouvelle entrée wiki
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
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Catégorie *</label>
                <select 
                  v-model="nouvelItem.categorie" 
                  required 
                  class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat shadow-sm"
                >
                  <option v-for="cat in categories.filter(c => c.id !== 'tout')" :key="cat.id" :value="cat.id">{{ cat.emoji }} {{ cat.nom }}</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Nom *</label>
                <input 
                  v-model="nouvelItem.nom" 
                  type="text" 
                  required 
                  class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-lg shadow-sm" 
                  placeholder="Nom du lieu, personnage ou clan..."
                />
              </div>

              <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
                <button 
                  type="submit" 
                  class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 shadow-lg text-amber-50 font-katana"
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
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const router = useRouter()

const items = ref([])
const afficherFormulaire = ref(false)
const categorieActive = ref('tout')
const searchQuery = ref('')
const nouvelItem = ref({
  nom: '',
  categorie: 'lieux'
})

const categories = [
  { id: 'tout', nom: 'Tout', emoji: '📑' },
  { id: 'lieux', nom: 'Lieux', emoji: '🏯' },
  { id: 'personnages', nom: 'Personnages', emoji: '👤' },
  { id: 'clans', nom: 'Clans', emoji: '⚔️' },
  { id: 'autre', nom: 'Autre', emoji: '📦' }
]

// Rediriger si pas de personnage actif
onMounted(() => {
  if (!personnageActif.value) {
    navigateTo('/')
  } else {
    chargerItems()
  }
})

const chargerItems = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('nom', { ascending: true })
  
  items.value = data || []
}

const itemsFiltres = computed(() => {
  // Si "Tout" est sélectionné, afficher tous les items
  const itemsCategorie = categorieActive.value === 'tout' 
    ? items.value 
    : items.value.filter(i => i.categorie === categorieActive.value)
  
  if (!searchQuery.value.trim()) return itemsCategorie
  
  const query = searchQuery.value.toLowerCase()
  return itemsCategorie.filter(item => {
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
  
  const { data, error } = await client
    .from('wiki_items')
    .insert([{
      personnage_id: personnageActif.value.id,
      ...nouvelItem.value,
      slug,
      description: '',
      tags: []
    }])
    .select()
    .single()

  if (!error && data) {
    items.value.push(data)
    router.push(`/wiki/${data.slug}`)
    fermerFormulaire()
  }
}

const fermerFormulaire = () => {
  afficherFormulaire.value = false
  nouvelItem.value = {
    nom: '',
    categorie: categorieActive.value
  }
}

watch(categorieActive, (newVal) => {
  // Ne pas mettre 'tout' comme catégorie pour un nouvel item
  if (newVal !== 'tout') {
    nouvelItem.value.categorie = newVal
  }
})
</script>
