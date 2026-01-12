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

    <div class="container mx-auto px-4 py-8 relative z-10 h-screen flex flex-col">
      <!-- En-tête -->
      <div class="mb-8 flex-shrink-0 w-full">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">📖 Journal de bord</h1>
          <NuxtLink 
            to="/"
            class="px-4 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white"
          >
            <span class="text-red-800 font-bold relative z-10 font-katana">← Retour</span>
          </NuxtLink>
        </div>

        <!-- Bouton créer nouvelle entrée et Barre de recherche -->
        <div class="mb-8 flex gap-4 items-center">
          <!-- Barre de recherche -->
          <div class="relative flex-1">
            <input 
              v-model="searchQuery"
              type="text"
              placeholder="🔍 Rechercher par titre, contenu ou tag..."
              class="w-full bg-white/90 border-2 border-amber-800/60 ring-4 ring-amber-900/30 focus:border-amber-700 rounded-xl px-5 py-3 pr-12 transition-all outline-none text-stone-900 placeholder:text-stone-500 font-montserrat shadow-xl"
            />
            <button 
              v-if="searchQuery"
              @click="searchQuery = ''"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-stone-500 hover:text-stone-900 transition-colors text-xl font-bold"
            >
              ×
            </button>
          </div>

          <!-- Bouton nouvelle entrée -->
          <button
            @click="afficherFormulaire = true"
            class="px-6 py-3 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden flex-shrink-0"
          >
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <span class="text-lg text-red-800 font-bold relative z-10 drop-shadow-sm whitespace-nowrap font-katana">✚ Nouvelle entrée</span>
          </button>
        </div>
      </div>

      <!-- Liste des entrées -->
      <div class="flex-1 overflow-y-auto pr-4">
        <div v-if="entriesFiltrees.length === 0 && searchQuery" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
              <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
            </div>
          </div>
        </div>
        <div v-else-if="entries.length === 0" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune entrée pour le moment</p>
              <p class="text-stone-600 font-montserrat">Commencez à documenter vos aventures !</p>
            </div>
          </div>
        </div>

        <div v-else class="space-y-6">
          <div
            v-for="entry in entriesFiltrees"
            :key="entry.id"
            class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white/80 cursor-pointer"
            @click="selectEntry(entry)"
          >
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <div class="flex justify-between items-start mb-3">
                <h3 class="text-2xl font-bold text-stone-900 font-manga">{{ entry.titre }}</h3>
                <span class="text-sm text-stone-600 font-montserrat">{{ formatDate(entry.date_session) }}</span>
              </div>
              <div v-if="entry.tags && entry.tags.length > 0" class="flex flex-wrap gap-2 mb-3">
                <span 
                  v-for="(tag, index) in entry.tags" 
                  :key="index"
                  class="inline-flex items-center gap-1 px-2 py-1 bg-amber-200/70 text-stone-800 rounded-md font-montserrat text-xs font-medium"
                >
                  🏷️ {{ tag }}
                </span>
              </div>
              <p class="text-stone-700 line-clamp-3 font-montserrat" v-html="entry.contenu"></p>
            </div>
          </div>
        </div>
      </div>

      <!-- Modal formulaire -->
      <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherFormulaire = false">
        <div class="bg-amber-50 rounded-2xl max-w-5xl w-full border-4 border-amber-900/40 shadow-2xl max-h-[95vh] overflow-hidden flex flex-col relative">
          <!-- En-tête avec fond -->
          <div class="relative overflow-hidden border-b-4 border-amber-900/20">
            <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
            <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
              <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                <span class="text-xl">{{ entreeEnEdition ? '✏️' : '📖' }}</span>
                {{ entreeEnEdition ? 'Modifier l\'entrée' : 'Nouvelle entrée de journal' }}
              </h3>
              <button 
                @click="afficherFormulaire = false" 
                class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
                type="button"
              >
                ×
              </button>
            </div>
          </div>

          <!-- Contenu scrollable -->
          <div class="overflow-y-auto flex-1 p-8 bg-amber-50/80">
            <form @submit.prevent="creerEntree" class="space-y-6">
              <div class="grid md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📜 Titre de la session *</label>
                  <input 
                    v-model="nouvelleEntree.titre" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-lg shadow-sm" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat shadow-sm"
                  />
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">🏷️ Tags (Personnages, Lieux, Événements)</label>
                <div class="relative flex gap-2 mb-3">
                  <div class="relative flex-1 suggestions-container">
                    <input 
                      v-model="nouveauTag" 
                      type="text" 
                      @keyup.enter="ajouterTag"
                      @input="filtrerSuggestions"
                      @focus="afficherSuggestions = true"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat shadow-sm" 
                      placeholder="Ajouter un tag (ex: Hida Takeshi, Château du Crabe...)"
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
                        <span v-if="suggestion.type === 'wiki'" class="text-xs text-stone-500 font-katana">Wiki</span>
                        <span v-else class="text-xs text-stone-500 font-katana">Tag</span>
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
                <div v-if="nouvelleEntree.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
                  <span 
                    v-for="(tag, index) in nouvelleEntree.tags" 
                    :key="index"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-amber-200 text-stone-800 rounded-lg font-montserrat text-sm font-medium"
                  >
                    🏷️ {{ tag }}
                    <button 
                      type="button"
                      @click="retirerTag(index)"
                      class="hover:text-red-700 transition-colors font-bold"
                    >
                      ×
                    </button>
                  </span>
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">✍️ Récit de la session *</label>
                <RichTextEditor 
                  v-model="nouvelleEntree.contenu" 
                  placeholder="Racontez votre aventure... Utilisez les outils pour formater votre texte, ajouter des titres, des listes, etc."
                />
              </div>

              <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
                <button 
                  type="submit" 
                  class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 shadow-lg hover:shadow-red-900/50 text-amber-50 flex items-center justify-center gap-2 font-katana"
                >
                  <span class="text-xl">📝</span>
                  Enregistrer l'entrée
                </button>
                <button 
                  type="button" 
                  @click="afficherFormulaire = false" 
                  class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
                >
                  Annuler
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Modal détail -->
      <div v-if="entreeSelectionnee" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="entreeSelectionnee = null">
        <div class="bg-amber-50 rounded-2xl max-w-4xl w-full border-4 border-amber-900/40 shadow-2xl max-h-[95vh] overflow-hidden flex flex-col">
          <!-- En-tête -->
          <div class="relative overflow-hidden border-b-4 border-amber-900/20">
            <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
            <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
              <div>
                <h3 class="text-3xl font-bold text-stone-900 font-manga mb-2">{{ entreeSelectionnee.titre }}</h3>
                <p class="text-sm text-stone-700 font-montserrat mb-2">📅 {{ formatDate(entreeSelectionnee.date_session) }}</p>
                <div v-if="entreeSelectionnee.tags && entreeSelectionnee.tags.length > 0" class="flex flex-wrap gap-2">
                  <span 
                    v-for="(tag, index) in entreeSelectionnee.tags" 
                    :key="index"
                    class="inline-flex items-center gap-1 px-3 py-1 bg-amber-300/70 text-stone-800 rounded-lg font-montserrat text-sm font-medium"
                  >
                    🏷️ {{ tag }}
                  </span>
                </div>
              </div>
              <button 
                @click="entreeSelectionnee = null" 
                class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
              >
                ×
              </button>
            </div>
          </div>

          <!-- Contenu -->
          <div class="overflow-y-auto flex-1 p-8 bg-amber-50/80">
            <div class="prose prose-stone max-w-none text-stone-900 font-montserrat leading-relaxed" v-html="entreeSelectionnee.contenu"></div>
          </div>

          <!-- Actions -->
          <div class="p-6 border-t-2 border-amber-900/20 flex gap-4 bg-amber-50/80">
            <button 
              @click="modifierEntree(entreeSelectionnee)" 
              class="px-6 py-3 bg-amber-700 hover:bg-amber-600 rounded-xl font-bold transition-all duration-300 text-white flex items-center gap-2 shadow-lg font-katana"
            >
              <span class="text-lg">✏️</span>
              Modifier
            </button>
            <button 
              @click="supprimerEntree(entreeSelectionnee.id)" 
              class="px-6 py-3 bg-red-700 hover:bg-red-600 rounded-xl font-bold transition-all duration-300 text-white flex items-center gap-2 shadow-lg font-katana"
            >
              <span class="text-lg">🗑️</span>
              Supprimer
            </button>
            <button 
              @click="entreeSelectionnee = null" 
              class="flex-1 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 px-6 py-3 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
            >
              Fermer
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const route = useRoute()

const entries = ref([])
const afficherFormulaire = ref(false)
const entreeSelectionnee = ref(null)
const entreeEnEdition = ref(null)
const nouveauTag = ref('')
const searchQuery = ref('')
const afficherSuggestions = ref(false)
const wikiItems = ref([])
const tagsExistants = ref([])
const nouvelleEntree = ref({
  titre: '',
  contenu: '',
  date_session: new Date().toISOString().split('T')[0],
  tags: []
})

// Rediriger si pas de personnage actif
onMounted(() => {
  if (!personnageActif.value) {
    navigateTo('/')
  } else {
    chargerEntrees()
    chargerWikiItems()
    
    // Fermer les suggestions au clic en dehors
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.suggestions-container')) {
        afficherSuggestions.value = false
      }
    })
  }
})

const chargerEntrees = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('journal_entries')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('created_at', { ascending: false })
  
  entries.value = data || []
  
  // Extraire tous les tags uniques des entrées
  const allTags = new Set()
  entries.value.forEach(entry => {
    if (entry.tags) {
      entry.tags.forEach(tag => allTags.add(tag))
    }
  })
  tagsExistants.value = Array.from(allTags)
  
  // Si on a un paramètre entry dans l'URL, ouvrir cette entrée
  const entryId = route.query.entry
  if (entryId) {
    const entry = entries.value.find(e => e.id === entryId)
    if (entry) {
      entreeSelectionnee.value = entry
    }
  }
}

const chargerWikiItems = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
  
  wikiItems.value = data || []
}

const entriesFiltrees = computed(() => {
  if (!searchQuery.value.trim()) return entries.value
  
  const query = searchQuery.value.toLowerCase()
  return entries.value.filter(entry => {
    const titreMatch = entry.titre?.toLowerCase().includes(query)
    const contenuMatch = entry.contenu?.toLowerCase().includes(query)
    const tagsMatch = entry.tags?.some(tag => tag.toLowerCase().includes(query))
    return titreMatch || contenuMatch || tagsMatch
  })
})

// Emojis par catégorie
const emojiParCategorie = {
  'lieux': '🏯',
  'personnages': '👤',
  'clans': '⚔️',
  'autre': '📦'
}

// Suggestions combinées du wiki et des tags existants
const suggestionsFiltrees = computed(() => {
  const query = nouveauTag.value.toLowerCase().trim()
  
  if (!query) {
    // Si pas de recherche, afficher toutes les suggestions
    const suggestions = []
    
    // Ajouter les items du wiki
    wikiItems.value.forEach(item => {
      if (!nouvelleEntree.value.tags.includes(item.nom)) {
        suggestions.push({
          nom: item.nom,
          type: 'wiki',
          emoji: emojiParCategorie[item.categorie] || '🏷️'
        })
      }
    })
    
    // Ajouter les tags existants
    tagsExistants.value.forEach(tag => {
      if (!nouvelleEntree.value.tags.includes(tag) && !suggestions.find(s => s.nom === tag)) {
        suggestions.push({
          nom: tag,
          type: 'tag',
          emoji: '🏷️'
        })
      }
    })
    
    return suggestions.slice(0, 10)
  }
  
  const suggestions = []
  
  // Filtrer les items du wiki
  wikiItems.value.forEach(item => {
    if (item.nom.toLowerCase().includes(query) && !nouvelleEntree.value.tags.includes(item.nom)) {
      suggestions.push({
        nom: item.nom,
        type: 'wiki',
        emoji: emojiParCategorie[item.categorie] || '🏷️'
      })
    }
  })
  
  // Filtrer les tags existants
  tagsExistants.value.forEach(tag => {
    if (tag.toLowerCase().includes(query) && !nouvelleEntree.value.tags.includes(tag) && !suggestions.find(s => s.nom === tag)) {
      suggestions.push({
        nom: tag,
        type: 'tag',
        emoji: '🏷️'
      })
    }
  })
  
  return suggestions.slice(0, 10)
})

const creerEntree = async () => {
  if (!personnageActif.value?.id) return
  
  // Fermer les suggestions
  afficherSuggestions.value = false
  
  // Si on est en mode édition
  if (entreeEnEdition.value) {
    const { data, error } = await client
      .from('journal_entries')
      .update(nouvelleEntree.value)
      .eq('id', entreeEnEdition.value.id)
      .select()
      .single()

    if (!error && data) {
      const index = entries.value.findIndex(e => e.id === data.id)
      if (index !== -1) entries.value[index] = data
      nouvelleEntree.value = {
        titre: '',
        contenu: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: []
      }
      afficherFormulaire.value = false
      entreeEnEdition.value = null
      // Recharger pour mettre à jour les tags existants
      await chargerEntrees()
    }
  } else {
    // Mode création
    const { data, error } = await client
      .from('journal_entries')
      .insert([{
        personnage_id: personnageActif.value.id,
        ...nouvelleEntree.value
      }])
      .select()
      .single()

    if (!error && data) {
      entries.value.unshift(data)
      nouvelleEntree.value = {
        titre: '',
        contenu: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: []
      }
      afficherFormulaire.value = false
      // Recharger pour mettre à jour les tags existants
      await chargerEntrees()
    }
  }
}

const selectEntry = (entry) => {
  entreeSelectionnee.value = entry
}

const modifierEntree = (entry) => {
  entreeEnEdition.value = entry
  nouvelleEntree.value = {
    titre: entry.titre,
    contenu: entry.contenu,
    date_session: entry.date_session,
    tags: entry.tags || []
  }
  entreeSelectionnee.value = null
  afficherFormulaire.value = true
  afficherSuggestions.value = false
}

const ajouterTag = () => {
  if (nouveauTag.value.trim() && !nouvelleEntree.value.tags.includes(nouveauTag.value.trim())) {
    nouvelleEntree.value.tags.push(nouveauTag.value.trim())
    nouveauTag.value = ''
    afficherSuggestions.value = false
  }
}

const selectionnerSuggestion = (suggestion) => {
  if (!nouvelleEntree.value.tags.includes(suggestion.nom)) {
    nouvelleEntree.value.tags.push(suggestion.nom)
    nouveauTag.value = ''
    afficherSuggestions.value = false
  }
}

const filtrerSuggestions = () => {
  afficherSuggestions.value = true
}

const retirerTag = (index) => {
  nouvelleEntree.value.tags.splice(index, 1)
}

const supprimerEntree = async (id) => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette entrée ?')) return
  
  const { error } = await client
    .from('journal_entries')
    .delete()
    .eq('id', id)

  if (!error) {
    entries.value = entries.value.filter(e => e.id !== id)
    entreeSelectionnee.value = null
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

// Fermer les suggestions quand le formulaire se ferme
watch(afficherFormulaire, (newVal) => {
  if (!newVal) {
    afficherSuggestions.value = false
    nouveauTag.value = ''
  }
})
</script>
