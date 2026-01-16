<template>
  <PageWrapper :loading="loading" loading-message="Chargement de la page wiki...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif || {}"
        @deselect="changeCharacter()"
        class="mb-6"
      />
    </template>

    <div v-if="item">

      <!-- En-tête -->
      <div class="mb-8 w-full px-24">
        <div class="flex items-center justify-between mb-6">
          <div class="flex gap-4">
            <BackButton @click="$router.push('/wiki')" class="mb-0" blanc>← Retour au Wiki</BackButton>
            <BackButton @click="supprimerItem">Supprimer</BackButton>
            <BackButton v-if="!modeEdition && !modeEditionCategorie" @click="activerModeEdition">✏️ Modifier</BackButton>
            <BackButton v-if="modeEdition || modeEditionCategorie" @click="sauvegarderTout">💾 Sauvegarder</BackButton>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 px-24">
        <!-- Description -->
        <div class="h-[100vh] lg:col-span-2 relative border-4 border-amber-800 bg-amber-50/60  before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
          <div class="relative z-10 p-4">
            <div v-if="!modeEdition" class="prose max-w-none ">
              <!-- Informations complètes -->
              <div class="space-y-2 max-h-[95vh] overflow-y-auto">
                <!-- Description principale -->
                <div v-if="item.description" class="text-stone-800 font-montserrat text-sm">
                  <div v-html="formatDescription(item.description)" class="leading-relaxed"></div>
                </div>
                
                <!-- Métadonnées -->
                <div class="border-t border-amber-800/30 pt-2 space-y-1">
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                    <div>
                      <span class="font-semibold text-stone-700 font-montserrat">Catégorie:</span>
                      <span class="ml-2 text-stone-800">{{ categories.find(c => c.id === item.categorie)?.emoji }} {{ categories.find(c => c.id === item.categorie)?.nom }}</span>
                    </div>
                    <div>
                      <span class="font-semibold text-stone-700 font-montserrat">Créé le:</span>
                      <span class="ml-2 text-stone-800 font-montserrat">{{ new Date(item.created_at).toLocaleDateString('fr-FR') }}</span>
                    </div>
                    <div v-if="item.updated_at && item.updated_at !== item.created_at">
                      <span class="font-semibold text-stone-700 font-montserrat">Modifié le:</span>
                      <span class="ml-2 text-stone-800">{{ new Date(item.updated_at).toLocaleDateString('fr-FR') }}</span>
                    </div>
                    <div v-if="item.tags && item.tags.length > 0">
                      <span class="font-semibold text-stone-700 font-montserrat">Tags:</span>
                      <span class="ml-2 text-stone-800">{{ item.tags.join(', ') }}</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <p v-if="!item.description" class="text-stone-500 italic font-montserrat">Aucune description pour le moment...</p>
            </div>

            <div v-else>
              <div class="prose max-w-none max-h-[95vh] overflow-y-auto bg-black/20 rounded-lg p-4">
                <div class="space-y-4">
                  <RichTextEditor v-model="description" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Liens (Wiki + Journal) -->
        <div class="h-[100vh] w-full relative overflow-hidden px-6 pt-16" style="background-image: url('/parchemin_side.png'); background-size: 100% 100%; background-position: center; background-repeat: no-repeat;">
          <div class="relative z-10 ml-8">          
          <!-- Champ d'ajout de liens wiki -->
          <div class="mb-6">
            <div class="relative flex gap-2 mb-3">
              <div class="relative flex-1 suggestions-container">
                <input 
                  v-model="nouveauTag" 
                  type="text" 
                  @keyup.enter="ajouterTag"
                  @input="filtrerSuggestions"
                  @focus="afficherSuggestions = true"
                  class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat shadow-sm" 
                  placeholder="Links..."
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
            </div>
          </div>
          
          <!-- Tous les liens regroupés -->
          <div class="space-y-1">
            <!-- Liens Wiki sortants -->
            <div v-if="item.tags && item.tags.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-0.5">Pages Wiki liées</h3>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="(tag, index) in item.tags"
                  :key="index"
                  @click="handleTagClick(tag)"
                  class="inline-flex items-center gap-2 px-3 py-1 text-stone-800 font-montserrat text-sm font-medium transition-all group cursor-pointer"
                  :style="{ backgroundColor: '#EFB6A6' }"
                  onMouseOver="this.style.backgroundColor='#E5B999'"
                  onMouseOut="this.style.backgroundColor='#EFB6A6'"
                >
                  {{ emojiParCategorie[getWikiItemByName(tag)?.categorie] || '🔗' }} {{ tag }}
                  <button
                    type="button"
                    @click.prevent.stop="retirerTag(index)"
                    class="hover:text-red-700 transition-colors font-bold"
                  >
                    ×
                  </button>
                </button>
              </div>
            </div>

            <!-- Liens Wiki entrants (Mentionné dans) -->
            <div v-if="itemsLies.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-0.5">Mentionné dans</h3>
              <div class="flex flex-wrap gap-2">
                <NuxtLink
                  v-for="itemLie in itemsLies"
                  :key="itemLie.id"
                  :to="`/wiki/${itemLie.slug}`"
                  class="inline-flex items-center gap-2 px-3 py-1 text-stone-800 font-montserrat text-sm font-medium transition-all border"
                  :style="{ backgroundColor: '#EFB6A6', borderColor: '#EFB6A6' }"
                  onMouseOver="this.style.backgroundColor='#EFB6A6'"
                  onMouseOut="this.style.backgroundColor='#F1C5A9'"
                >
                  <span>{{ emojiParCategorie[itemLie.categorie] || '📦' }}</span>
                  {{ itemLie.nom }}
                </NuxtLink>
              </div>
            </div>

            <!-- Entrées de journal liées -->
            <div v-if="entreesLiees.length > 0">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-0.5">Entrées de journal</h3>
              <div class="flex flex-wrap gap-2">
                <NuxtLink
                  v-for="entree in entreesLiees"
                  :key="entree.id"
                  :to="`/journal?entry=${entree.id}`"
                  class="inline-flex items-center gap-2 px-3 py-1.5 bg-blue-100 hover:bg-blue-200 text-blue-900 font-montserrat text-sm font-medium transition-all
                  
                  "
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
    </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const route = useRoute()
const router = useRouter()

const loading = ref(true)
const item = ref(null)
const description = ref('')
const modeEdition = ref(false)
const modeEditionCategorie = ref(false)
const nouvelleCategorie = ref('')
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
onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await Promise.all([
        chargerItem(),
        chargerEntreesLiees(),
        chargerTousLesItems()
      ])
    } finally {
      loading.value = false
    }

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
  
  const { data, error } = await client
    .from('wiki_items')
    .select('*')
    .eq('slug', route.params.slug)
    .eq('personnage_id', personnageActif.value.id)
  
  if (!error && data && data.length > 0) {
    item.value = data[0]
    description.value = data[0].description || ''
    nouvelleCategorie.value = data[0].categorie
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

const activerModeEdition = () => {
  modeEdition.value = true
  modeEditionCategorie.value = true
}

const sauvegarderTout = async () => {
  // Sauvegarder la description
  if (description.value !== item.value.description) {
    const { error: descError } = await client
      .from('wiki_items')
      .update({ description: description.value })
      .eq('id', item.value.id)
    
    if (!descError) {
      item.value.description = description.value
    }
  }

  // Sauvegarder la catégorie
  if (nouvelleCategorie.value !== item.value.categorie) {
    const { error: catError } = await client
      .from('wiki_items')
      .update({ categorie: nouvelleCategorie.value })
      .eq('id', item.value.id)
    
    if (!catError) {
      item.value.categorie = nouvelleCategorie.value
    }
  }

  // Désactiver les modes d'édition
  modeEdition.value = false
  modeEditionCategorie.value = false
}

const formatDescription = (text) => {
  if (!text) return ''
  
  // Fonction helper pour wrapper le contenu avec des classes Tailwind
  const wrapWithClass = (tag, className) => {
    return text.replace(new RegExp(`<${tag}(.*?)>(.*?)</${tag}>`, 'gis'), `<${tag}$1 class="${className}">$2</${tag}>`)
  }
  
  let formatted = text
  
  // Headings avec des tailles réduites et espacements compacts
  formatted = formatted.replace(/<h1(.*?)>(.*?)<\/h1>/gis, '<h1$1 class="text-2xl font-bold text-amber-900 font-sakurata mt-2 mb-2 border-b-2 border-amber-800/30 pb-1">$2</h1>')
  formatted = formatted.replace(/<h2(.*?)>(.*?)<\/h2>/gis, '<h2$1 class="text-xl font-bold text-amber-800 font-sakurata mt-2 mb-1">$2</h2>')
  formatted = formatted.replace(/<h3(.*?)>(.*?)<\/h3>/gis, '<h3$1 class="text-lg font-bold text-amber-700 font-sakurata mt-2 mb-1">$2</h3>')
  formatted = formatted.replace(/<h4(.*?)>(.*?)<\/h4>/gis, '<h4$1 class="text-base font-semibold text-amber-600 font-montserrat mt-1 mb-1">$2</h4>')
  formatted = formatted.replace(/<h5(.*?)>(.*?)<\/h5>/gis, '<h5$1 class="text-sm font-semibold text-stone-700 font-montserrat mt-1 mb-1">$2</h5>')
  formatted = formatted.replace(/<h6(.*?)>(.*?)<\/h6>/gis, '<h6$1 class="text-xs font-semibold text-stone-600 font-montserrat mt-1 mb-1">$2</h6>')
  
  // Citations avec un style spécial et espacement réduit
  formatted = formatted.replace(/<blockquote(.*?)>(.*?)<\/blockquote>/gis, '<blockquote$1 class="border-l-4 border-amber-600 pl-3 italic text-stone-700 bg-amber-50/50 py-1 my-2 rounded-r-lg">$2</blockquote>')
  
  // Listes avec espacement réduit
  formatted = formatted.replace(/<ul(.*?)>(.*?)<\/ul>/gis, '<ul$1 class="list-disc list-inside space-y-0.5 my-2 ml-4">$2</ul>')
  formatted = formatted.replace(/<ol(.*?)>(.*?)<\/ol>/gis, '<ol$1 class="list-decimal list-inside space-y-0.5 my-2 ml-4">$2</ol>')
  formatted = formatted.replace(/<li(.*?)>(.*?)<\/li>/gis, '<li$1 class="text-stone-800">$2</li>')
  
  // Texte formaté
  formatted = formatted.replace(/<strong(.*?)>(.*?)<\/strong>/gis, '<strong$1 class="font-bold text-stone-900">$2</strong>')
  formatted = formatted.replace(/<b(.*?)>(.*?)<\/b>/gis, '<b$1 class="font-bold text-stone-900">$2</b>')
  formatted = formatted.replace(/<em(.*?)>(.*?)<\/em>/gis, '<em$1 class="italic text-stone-700">$2</em>')
  formatted = formatted.replace(/<i(.*?)>(.*?)<\/i>/gis, '<i$1 class="italic text-stone-700">$2</i>')
  
  // Liens
  formatted = formatted.replace(/<a(.*?)>(.*?)<\/a>/gis, '<a$1 class="text-amber-700 hover:text-amber-900 underline transition-colors">$2</a>')
  
  // Paragraphes avec espacement très réduit
  formatted = formatted.replace(/<p(.*?)>(.*?)<\/p>/gis, '<p$1 class="mb-2 leading-snug text-stone-800 text-sm">$2</p>')
  
  // Code inline
  formatted = formatted.replace(/<code(.*?)>(.*?)<\/code>/gis, '<code$1 class="bg-stone-100 text-stone-900 px-1.5 py-0.5 rounded text-sm font-mono">$2</code>')
  
  // Blocs de code avec espacement réduit
  formatted = formatted.replace(/<pre(.*?)>(.*?)<\/pre>/gis, '<pre$1 class="bg-stone-100 text-stone-900 p-3 rounded-lg overflow-x-auto my-2 border-l-4 border-amber-600">$2</pre>')
  
  // Lignes horizontales avec espacement réduit
  formatted = formatted.replace(/<hr(.*?)>/gis, '<hr$1 class="border-amber-800/30 my-3">')
  
  return formatted
}

const handleTagClick = async (tagName) => {
  const existingItem = getWikiItemByName(tagName)
  
  if (existingItem) {
    // La page existe déjà, on redirige vers elle
    await navigateTo(`/wiki/${existingItem.slug}`)
  } else {
    // La page n'existe pas, on la crée automatiquement
    try {
      // Générer un slug à partir du nom
      const slug = tagName
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '') // Supprimer les accents
        .replace(/[^a-z0-9\s-]/g, '') // Supprimer les caractères spéciaux sauf espaces et tirets
        .trim()
        .replace(/\s+/g, '-') // Remplacer les espaces par des tirets
        .replace(/-+/g, '-') // Éviter les tirets multiples
      
      // Créer la nouvelle page wiki
      const { data, error } = await client
        .from('wiki_items')
        .insert([{
          personnage_id: personnageActif.value.id,
          nom: tagName,
          slug: slug,
          categorie: 'autre', // Catégorie par défaut
          description: `# ${tagName}\n\n*Page créée automatiquement depuis ${item.value.nom}*`,
          tags: []
        }])
        .select()
        .single()
      
      if (!error && data) {
        // Ajouter la nouvelle page à la liste des items
        tousLesItems.value.push(data)
        
        // Rediriger vers la nouvelle page
        await navigateTo(`/wiki/${data.slug}`)
      } else {
        console.error('Erreur lors de la création de la page wiki:', error)
        // En cas d'erreur, on pourrait afficher un message à l'utilisateur
      }
    } catch (error) {
      console.error('Erreur lors de la création de la page wiki:', error)
    }
  }
}

const getWikiItemByName = (nom) => {
  return tousLesItems.value.find(i => i.nom === nom)
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>
