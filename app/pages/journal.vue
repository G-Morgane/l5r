<template>
  <div class="relative overflow-hidden h-screen">
    <!-- Fond image japonaise -->
    <div class="h-screen absolute inset-0" style="background-image: url('/fond_long.png'); background-position: top, bottom; background-repeat: no-repeat; background-size: 100% auto, 100% auto;">
          <div class="absolute inset-0 bg-black/10"></div>

    </div>

    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- En-tête personnage -->
      <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="changeCharacter()"
        />

      <div class="flex flex-col">

        <!-- Bouton créer nouvelle entrée et Barre de recherche -->
        <div class="mb-8 flex gap-4 items-center px-12">
          <div class="relative flex-1">
            <div class="relative rounded-xl overflow-hidden">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <input 
                v-model="searchQuery"
                type="text"
                placeholder="🔍 Rechercher..."
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
           <BackButton @click="startCreation">Nouveau</BackButton>
        </div>
      </div>

      <!-- Liste des entrées -->
      <div class="flex-1 overflow-y-auto pr-4">
        <div v-if="entriesFiltrees.length === 0 && searchQuery" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
              <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
            </div>
          </div>
        </div>
        <div v-else-if="entries.length === 0" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune entrée pour le moment</p>
              <p class="text-stone-600 font-montserrat">Commencez à documenter vos aventures !</p>
            </div>
          </div>
        </div>
        <div v-else class="space-y-6 px-12 max-h-[40vh] overflow-y-auto">
          <div
            v-for="(entry, index) in entriesFiltrees"
            :key="entry.id"
            class="rounded-xl p-10 relative overflow-hidden cursor-pointer"
            @click="selectEntry(entry)"
          >
            <div class="absolute inset-0" :style="`background-image: url('${getRandomJournalImage(index)}'); background-size: 100% 100%; background-position: center;`"></div>
            <div class="relative z-10">
              <div class="flex flex-col items-center mb-3">
                <h3 class="text-2xl font-bold text-black font-manga text-center">{{ entry.titre }}</h3>
                <span class="text-sm text-black font-montserrat">{{ formatDate(entry.date_session) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Modal formulaire -->
      <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherFormulaire = false">
        <div class="bg-amber-50 rounded-2xl max-w-5xl w-full border-4 border-amber-900/40 flex flex-col relative">
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
          <div class="overflow-y-auto flex-1 p-8">
            <form @submit.prevent="creerEntree" class="space-y-6">
              <div class="grid md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📜 Titre de la session *</label>
                  <input 
                    v-model="nouvelleEntree.titre" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-lg" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat"
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
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat" 
                      placeholder="Ajouter un tag (ex: Hida Takeshi, Château du Crabe...)"
                    />
                    <!-- Suggestions dropdown -->
                    <div 
                      v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                      class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-xl overflow-y-auto"
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
                    class="px-4 py-2 bg-amber-700 hover:bg-amber-600 text-white rounded-xl font-semibold transition-colors font-katana"
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
                  class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 text-amber-50 flex items-center justify-center gap-2 font-katana"
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

      <!-- Drawer détail -->
      <div v-if="entreeSelectionnee || createMode" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50" @click.self="closeDrawer">
        <div class="absolute right-0 top-0 bottom-0 w-full max-w-2xl overflow-y-auto flex flex-col" style="background-image: url('/drawer.png'); background-size: cover; background-position: center;">
          <!-- En-tête -->
          <div class="relative overflow-hidden">
            <div class="relative px-6 py-4 flex items-center justify-between">
              <div v-if="drawerMode === 'view'" class="pl-36 pt-24">
                <h3 class="text-3xl font-bold text-stone-900 font-manga mb-2">{{ entreeSelectionnee.titre }}</h3>
                <p class="text-sm text-stone-700 font-montserrat mb-2">📅 {{ formatDate(entreeSelectionnee.date_session) }}</p>
                <div v-if="entreeSelectionnee.tags && entreeSelectionnee.tags.length > 0" class="flex flex-wrap gap-2">
                  <NuxtLink
                    v-for="(tag, index) in entreeSelectionnee.tags" 
                    :key="index"
                    :to="getWikiItemByName(tag)?.slug ? `/wiki/${getWikiItemByName(tag).slug}` : `/wiki?create=${encodeURIComponent(tag)}`"
                    class="inline-flex items-center gap-1 px-3 py-1 bg-amber-300/70 hover:bg-amber-400 text-stone-800 rounded-lg font-montserrat text-sm font-medium transition-all"
                  >
                    🏷️ {{ tag }}
                  </NuxtLink>
                </div>
              </div>
              <div v-else-if="createMode">
                <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                  <span class="text-xl">📖</span>
                  Nouvelle entrée
                </h3>
              </div>
              <button 
                @click="closeDrawer" 
                class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
              >
                ×
              </button>
            </div>
          </div>

          <!-- Contenu -->
          <div v-if="drawerMode === 'view'" class="overflow-y-auto flex-1 px-24">
            <div class="prose prose-stone max-w-none text-stone-900 font-montserrat leading-relaxed journal-content" v-html="formatContent(entreeSelectionnee.contenu)"></div>
          </div>

          <!-- Formulaire d'édition -->
          <div v-else class="overflow-y-auto flex-1 px-24">
            <form id="edit-form" @submit.prevent="creerEntree" class="space-y-4">
              <div class="grid md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">📜 Titre de la session *</label>
                  <input 
                    v-model="nouvelleEntree.titre" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-sm" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 font-montserrat text-sm"
                  />
                </div>
              </div>
              <div>
                <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">🏷️ Tags</label>
                <div class="relative suggestions-container">
                  <div class="flex gap-2">
                    <input 
                      v-model="nouveauTag" 
                      @keydown.enter.prevent="ajouterTag"
                      @input="filtrerSuggestions"
                      @focus="afficherSuggestions = true"
                      type="text" 
                      class="flex-1 bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-sm" 
                      placeholder="Ajouter un tag..."
                    />
                  </div>
                  <!-- Suggestions dropdown -->
                  <div 
                    v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                    class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-lg overflow-y-auto"
                  >
                    <button
                      v-for="(suggestion, index) in suggestionsFiltrees"
                      :key="index"
                      type="button"
                      @click="selectionnerSuggestion(suggestion)"
                      class="w-full px-2 py-1 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-2 border-b border-amber-900/10 last:border-b-0 text-xs"
                    >
                      <span class="text-xs">{{ suggestion.emoji }}</span>
                      <span class="flex-1">{{ suggestion.nom }}</span>
                      <span v-if="suggestion.type === 'wiki'" class="text-xs text-stone-500 font-katana">Wiki</span>
                      <span v-else class="text-xs text-stone-500 font-katana">Tag</span>
                    </button>
                  </div>
                </div>
                <div v-if="nouvelleEntree.tags.length > 0" class="flex flex-wrap gap-2 mt-2">
                  <span 
                    v-for="(tag, index) in nouvelleEntree.tags" 
                    :key="index"
                    class="inline-flex items-center gap-1 px-1 py-0.5 bg-amber-300/70 text-stone-800 rounded font-montserrat text-xs font-medium"
                  >
                    {{ tag }}
                    <button @click="retirerTag(index)" class="text-stone-600 hover:text-stone-800 ml-1">×</button>
                  </span>
                </div>
              </div>
              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📖 Contenu *</label>
                <RichTextEditor v-model="nouvelleEntree.contenu" />
              </div>
            </form>
          </div>

          <!-- Actions -->
          <div v-if="drawerMode === 'view'" class="flex w-full gap-8 content-center justify-center pb-12">
            <button 
              @click="modifierEntree(entreeSelectionnee)" 
              class="px-6 py-3 bg-amber-700 hover:bg-amber-600 rounded-xl font-bold transition-all duration-300 text-white flex items-center gap-2 font-katana"
            >
              <span class="text-lg">✏️</span>
            </button>
            <button 
              @click="supprimerEntree(entreeSelectionnee.id)" 
              class="px-6 py-3 bg-red-700 hover:bg-red-600 rounded-xl font-bold transition-all duration-300 text-white flex items-center gap-2 font-katana"
            >
              <span class="text-lg">🗑️</span>
            </button>
          </div>

          <!-- Actions édition -->
          <div v-else class="flex w-full gap-8 content-center justify-center pb-12">
            <button 
              @click="creerEntree"
              class="px-6 py-3 bg-green-700 hover:bg-green-600 rounded-xl font-bold transition-all duration-300 text-white flex items-center gap-2 font-katana"
            >
              <span class="text-lg">💾</span>
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
const drawerMode = ref('view') // 'view' or 'edit'
const createMode = ref(false)
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
    const dateMatch = formatDate(entry.date_session)?.toLowerCase().includes(query)
    return titreMatch || contenuMatch || tagsMatch || dateMatch
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

  console.log('coucou')
  
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
      drawerMode.value = 'view'
      entreeSelectionnee.value = data
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
      closeDrawer()
      // Recharger pour mettre à jour les tags existants
      await chargerEntrees()
    }
  }
}

const changeCharacter = () => {
  personnageActif.value = null
  navigateTo('/')
}

const startCreation = () => {
  createMode.value = true
  drawerMode.value = 'edit'
  entreeSelectionnee.value = null
  nouvelleEntree.value = {
    titre: '',
    contenu: '',
    date_session: new Date().toISOString().split('T')[0],
    tags: []
  }
  afficherSuggestions.value = false
  nouveauTag.value = ''
}

const selectEntry = (entry) => {
  entreeSelectionnee.value = entry
  drawerMode.value = 'view'
  createMode.value = false
}

const closeDrawer = () => {
  entreeSelectionnee.value = null
  createMode.value = false
  drawerMode.value = 'view'
}

const modifierEntree = (entry) => {
  entreeEnEdition.value = entry
  nouvelleEntree.value = {
    titre: entry.titre,
    contenu: entry.contenu,
    date_session: entry.date_session,
    tags: entry.tags || []
  }
  drawerMode.value = 'edit'
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

const getWikiItemByName = (name) => {
  return wikiItems.value.find(item => item.nom.toLowerCase() === name.toLowerCase())
}

const formatContent = (content) => {
  if (!content) return ''
  return content.replace(/\n/g, '<br>')
}

const getRandomJournalImage = (index) => {
  const images = ['/journal/arbre.png', '/journal/batiment.png', '/journal/drapeau.png', '/journal/oni.png']
  return images[index % images.length]
}
</script>

<style scoped>
.journal-content :deep(blockquote) {
  border-left: 4px solid rgb(180 83 9);
  padding-left: 1rem;
  font-style: italic;
  color: rgb(87 83 78);
  margin-top: 1rem;
  margin-bottom: 1rem;
  background: rgb(245 158 11 / 0.05);
  padding: 1rem;
  border-radius: 0.5rem;
}

.journal-content :deep(h2) {
  font-size: 1.5rem;
  font-weight: bold;
  color: rgb(28 25 23);
  margin-top: 1.5rem;
  margin-bottom: 0.75rem;
  font-family: 'Sakurata', cursive;
}

.journal-content :deep(h3) {
  font-size: 1.25rem;
  font-weight: bold;
  color: rgb(41 37 36);
  margin-top: 1rem;
  margin-bottom: 0.5rem;
  font-family: 'Katana', sans-serif;
}

.journal-content :deep(ul),
.journal-content :deep(ol) {
  padding-left: 1.5rem;
  margin-top: 1rem;
  margin-bottom: 1rem;
}

.journal-content :deep(ul li) {
  list-style-type: disc;
}

.journal-content :deep(ol li) {
  list-style-type: decimal;
}

.journal-content :deep(hr) {
  border-color: rgb(120 53 15 / 0.5);
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
}

.journal-content :deep(p) {
  margin-bottom: 0.75rem;
  line-height: 1.625;
}

.journal-content :deep(strong) {
  font-weight: bold;
  color: rgb(28 25 23);
}

.journal-content :deep(em) {
  font-style: italic;
}

.journal-content :deep(u) {
  text-decoration: underline;
}
</style>
