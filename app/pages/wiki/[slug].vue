<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img 
        src="/background_selection.png" 
        alt="Japanese room background" 
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div v-if="item" class="container mx-auto px-4 py-8 relative z-10 h-screen flex flex-col">
      <!-- En-tête -->
      <div class="mb-8 flex-shrink-0 w-full">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">📖 {{ item.nom }}</h1>
          <div class="flex gap-4">
            <NuxtLink 
              to="/wiki"
              class="px-4 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white"
            >
              <span class="text-red-800 font-bold relative z-10 font-katana">← Retour au Wiki</span>
            </NuxtLink>
            <button 
              @click="supprimerItem"
              class="px-4 py-2 rounded-xl border-2 border-red-800/60 ring-4 ring-red-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white"
            >
              <span class="text-red-800 font-bold relative z-10 font-katana">🗑️ Supprimer</span>
            </button>
          </div>
        </div>

        <!-- Catégorie badge -->
        <div class="mb-6">
          <span class="inline-block px-4 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl bg-amber-100 font-katana font-bold text-stone-900">
            {{ categories.find(c => c.id === item.categorie)?.emoji }} {{ categories.find(c => c.id === item.categorie)?.nom }}
          </span>
        </div>
      </div>

      <div class="flex-1 overflow-y-auto pr-4 grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Description -->
        <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl bg-white/90 h-fit lg:col-span-2">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-2xl font-bold text-stone-900 font-manga">📝 Description</h2>
            <button 
              v-if="!modeEdition"
              @click="modeEdition = true"
              class="px-4 py-2 rounded-lg border-2 border-amber-800/60 ring-2 ring-amber-900/30 bg-amber-100 hover:bg-amber-200 transition-all font-katana font-bold text-stone-900"
            >
              ✏️ Modifier
            </button>
          </div>

          <div v-if="!modeEdition" class="prose max-w-none">
            <div 
              v-if="item.description" 
              v-html="item.description" 
              class="text-stone-800 font-montserrat"
            ></div>
            <p v-else class="text-stone-500 italic font-montserrat">Aucune description pour le moment...</p>
          </div>

          <div v-else>
            <RichTextEditor v-model="description" />
            <div class="flex gap-3 mt-4">
              <button 
                @click="enregistrerDescription"
                class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-3 rounded-xl font-bold transition-all duration-300 shadow-lg text-amber-50 font-katana"
              >
                💾 Enregistrer
              </button>
              <button 
                @click="annulerEdition"
                class="px-6 py-3 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
              >
                Annuler
              </button>
            </div>
          </div>
        </div>

        <!-- Liens (Wiki + Journal) -->
        <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl bg-white/90 h-fit">
          <h2 class="text-2xl font-bold text-stone-900 font-manga mb-4">🔗 Liens</h2>
          
          <!-- Champ d'ajout de liens wiki -->
          <div class="mb-6">
            <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Ajouter un lien wiki</label>
            <div class="relative flex gap-2 mb-3">
              <div class="relative flex-1 suggestions-container">
                <input 
                  v-model="nouveauTag" 
                  type="text" 
                  @keyup.enter="ajouterTag"
                  @input="filtrerSuggestions"
                  @focus="afficherSuggestions = true"
                  class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat shadow-sm" 
                  placeholder="Lier avec une autre page wiki..."
                />
                <!-- Suggestions dropdown -->
                <div 
                  v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                  class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-xl shadow-2xl max-h-60 overflow-y-auto"
                >
                  <button
                    v-for="(suggestion, index) in suggestionsFiltrees"
                    :key="index"
                    type="button"
                    @click="selectionnerSuggestion(suggestion)"
                    class="w-full px-4 py-2 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-2 border-b border-amber-900/10 last:border-b-0"
                  >
                    <span class="text-xs">{{ suggestion.emoji }}</span>
                    <span class="flex-1">{{ suggestion.nom }}</span>
                    <span class="text-xs text-stone-500 font-katana">{{ suggestion.categorie }}</span>
                  </button>
                </div>
              </div>
              <button 
                type="button"
                @click="ajouterTag"
                class="px-4 py-2 bg-amber-700 hover:bg-amber-600 text-white rounded-xl font-semibold transition-colors shadow-sm font-katana"
              >
                + Ajouter
              </button>
            </div>
          </div>
          
          <!-- Tous les liens regroupés -->
          <div class="space-y-4">
            <!-- Liens Wiki sortants -->
            <div v-if="item.tags && item.tags.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-2">🏷️ Pages Wiki liées</h3>
              <div class="flex flex-wrap gap-2">
                <NuxtLink
                  v-for="(tag, index) in item.tags" 
                  :key="index"
                  :to="getWikiItemByName(tag)?.slug ? `/wiki/${getWikiItemByName(tag).slug}` : '#'"
                  class="inline-flex items-center gap-2 px-3 py-1 bg-amber-200 hover:bg-amber-300 text-stone-800 rounded-lg font-montserrat text-sm font-medium transition-all group"
                >
                  🔗 {{ tag }}
                  <button 
                    type="button"
                    @click.prevent="retirerTag(index)"
                    class="hover:text-red-700 transition-colors font-bold"
                  >
                    ×
                  </button>
                </NuxtLink>
              </div>
            </div>

            <!-- Liens Wiki entrants (Mentionné dans) -->
            <div v-if="itemsLies.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-2">📖 Mentionné dans</h3>
              <div class="flex flex-wrap gap-2">
                <NuxtLink
                  v-for="itemLie in itemsLies"
                  :key="itemLie.id"
                  :to="`/wiki/${itemLie.slug}`"
                  class="inline-flex items-center gap-2 px-3 py-1 bg-amber-100 hover:bg-amber-200 text-stone-800 rounded-lg font-montserrat text-sm font-medium transition-all border border-amber-300"
                >
                  <span>{{ emojiParCategorie[itemLie.categorie] || '📦' }}</span>
                  {{ itemLie.nom }}
                </NuxtLink>
              </div>
            </div>

            <!-- Entrées de journal liées -->
            <div v-if="entreesLiees.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-2">📚 Entrées de journal</h3>
              <div class="flex flex-wrap gap-2">
                <NuxtLink
                  v-for="entree in entreesLiees"
                  :key="entree.id"
                  :to="`/journal?entry=${entree.id}`"
                  class="inline-flex items-center gap-2 px-3 py-1.5 bg-blue-100 hover:bg-blue-200 text-blue-900 rounded-lg font-montserrat text-sm font-medium transition-all border border-blue-300"
                  :title="entree.titre"
                >
                  📖 {{ entree.titre }}
                </NuxtLink>
              </div>
            </div>

            <!-- Message si aucun lien -->
            <p v-if="(!item.tags || item.tags.length === 0) && itemsLies.length === 0 && entreesLiees.length === 0" class="text-stone-500 italic text-sm font-montserrat text-center py-4">
              Aucun lien pour le moment
            </p>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="container mx-auto px-4 py-8 relative z-10 flex items-center justify-center h-screen">
      <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl bg-white/90">
        <p class="text-stone-800 text-xl font-manga">Chargement...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const route = useRoute()
const router = useRouter()

const item = ref(null)
const description = ref('')
const modeEdition = ref(false)
const entreesLiees = ref([])
const nouveauTag = ref('')
const afficherSuggestions = ref(false)
const tousLesItems = ref([])
const itemsLies = ref([])

const categories = [
  { id: 'lieux', nom: 'Lieux', emoji: '🏯' },
  { id: 'personnages', nom: 'Personnages', emoji: '👤' },
  { id: 'clans', nom: 'Clans', emoji: '⚔️' },
  { id: 'autre', nom: 'Autre', emoji: '📦' }
]

const emojiParCategorie = {
  'lieux': '🏯',
  'personnages': '👤',
  'clans': '⚔️',
  'autre': '📦'
}

// Rediriger si pas de personnage actif
onMounted(() => {
  if (!personnageActif.value) {
    navigateTo('/')
  } else {
    chargerItem()
    chargerEntreesLiees()
    chargerTousLesItems()
    
    // Fermer les suggestions au clic en dehors
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.suggestions-container')) {
        afficherSuggestions.value = false
      }
    })
  }
})

const chargerItem = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('slug', route.params.slug)
    .eq('personnage_id', personnageActif.value.id)
    .single()
  
  if (data) {
    item.value = data
    description.value = data.description || ''
    chargerItemsLies()
  } else {
    navigateTo('/wiki')
  }
}

const chargerTousLesItems = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('nom', { ascending: true })
  
  tousLesItems.value = data || []
}

const chargerItemsLies = async () => {
  if (!item.value?.nom) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .neq('id', item.value.id)
  
  if (data) {
    // Filtrer les items qui ont le nom de l'item actuel dans leurs tags
    itemsLies.value = data.filter(i => i.tags?.includes(item.value.nom))
  }
}

const chargerEntreesLiees = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('journal_entries')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('created_at', { ascending: false })
  
  if (data) {
    // Filtrer les entrées qui contiennent le nom de l'item dans les tags
    entreesLiees.value = data.filter(entree => {
      return entree.tags?.includes(item.value?.nom)
    })
  }
}

const enregistrerDescription = async () => {
  const { error } = await client
    .from('wiki_items')
    .update({ description: description.value })
    .eq('id', item.value.id)
  
  if (!error) {
    item.value.description = description.value
    modeEdition.value = false
  }
}

const annulerEdition = () => {
  description.value = item.value.description || ''
  modeEdition.value = false
}

const supprimerItem = async () => {
  if (!confirm(`Êtes-vous sûr de vouloir supprimer "${item.value.nom}" ?`)) return
  
  const { error } = await client
    .from('wiki_items')
    .delete()
    .eq('id', item.value.id)
  
  if (!error) {
    router.push('/wiki')
  }
}

const suggestionsFiltrees = computed(() => {
  const query = nouveauTag.value.toLowerCase().trim()
  const tagsActuels = item.value?.tags || []
  
  // Filtrer les items qui ne sont pas déjà dans les tags et qui ne sont pas l'item actuel
  const itemsDisponibles = tousLesItems.value.filter(i => 
    i.id !== item.value?.id && 
    !tagsActuels.includes(i.nom)
  )
  
  if (!query) {
    return itemsDisponibles.slice(0, 10).map(i => ({
      nom: i.nom,
      emoji: emojiParCategorie[i.categorie] || '📦',
      categorie: categories.find(c => c.id === i.categorie)?.nom || 'Autre'
    }))
  }
  
  return itemsDisponibles
    .filter(i => i.nom.toLowerCase().includes(query))
    .slice(0, 10)
    .map(i => ({
      nom: i.nom,
      emoji: emojiParCategorie[i.categorie] || '📦',
      categorie: categories.find(c => c.id === i.categorie)?.nom || 'Autre'
    }))
})

const ajouterTag = async () => {
  if (!nouveauTag.value.trim()) return
  
  const tags = item.value.tags || []
  if (!tags.includes(nouveauTag.value.trim())) {
    const nouveauxTags = [...tags, nouveauTag.value.trim()]
    
    const { error } = await client
      .from('wiki_items')
      .update({ tags: nouveauxTags })
      .eq('id', item.value.id)
    
    if (!error) {
      item.value.tags = nouveauxTags
      nouveauTag.value = ''
      afficherSuggestions.value = false
    }
  }
}

const selectionnerSuggestion = async (suggestion) => {
  const tags = item.value.tags || []
  if (!tags.includes(suggestion.nom)) {
    const nouveauxTags = [...tags, suggestion.nom]
    
    const { error } = await client
      .from('wiki_items')
      .update({ tags: nouveauxTags })
      .eq('id', item.value.id)
    
    if (!error) {
      item.value.tags = nouveauxTags
      nouveauTag.value = ''
      afficherSuggestions.value = false
    }
  }
}

const retirerTag = async (index) => {
  const nouveauxTags = [...(item.value.tags || [])]
  nouveauxTags.splice(index, 1)
  
  const { error } = await client
    .from('wiki_items')
    .update({ tags: nouveauxTags })
    .eq('id', item.value.id)
  
  if (!error) {
    item.value.tags = nouveauxTags
  }
}

const filtrerSuggestions = () => {
  afficherSuggestions.value = true
}

const getWikiItemByName = (nom) => {
  return tousLesItems.value.find(i => i.nom === nom)
}
</script>
