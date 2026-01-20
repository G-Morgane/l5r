<template>
  <PageWrapper :loading="loading" loading-message="Chargement du wiki...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

    <div class="flex flex-col mt-12">
      <!-- Catégories principales -->
      <div class="flex flex-wrap justify-between px-18">
        <NuxtLink
          to="/wiki/category-clans"
          class=" overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
        >
          <img
            src="/wiki/clans.png"
            alt="Clans"
            class="w-66 h-42 object-cover"
          />
        </NuxtLink>

        <NuxtLink
          to="/wiki/category-lieux"
          class=" overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
        >
          <img
            src="/wiki/lieux.png"
            alt="Lieux"
            class="w-66 h-42 object-cover"
          />
        </NuxtLink>

        <NuxtLink
          to="/wiki/category-personnages"
          class=" overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
        >
          <img
            src="/wiki/personnages.png"
            alt="Personnages"
            class="w-66 h-42 object-cover"
          />
        </NuxtLink>

        <NuxtLink
          to="/wiki/category-autre"
          class=" overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
        >
          <img
            src="/wiki/autre.png"
            alt="Autre"
            class="w-66 h-42 object-cover"
          />
        </NuxtLink>
      </div>

      <!-- Barre de recherche et liste des entrées -->
      <div class="mt-12 px-18">
        <!-- Searchbar -->
        <div class="relative mb-6">
          <div class="relative overflow-hidden">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="🔍 Rechercher dans le wiki..."
              class="relative z-10 w-full bg-transparent border-2 border-amber-800/60 focus:border-amber-700 px-4 py-2 pr-10 transition-all outline-none text-stone-900 placeholder:text-stone-500 font-montserrat text-sm"
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

        <!-- Liste des entrées -->
        <div class="bg-amber-50/80 border-2 border-amber-900/30 p-4">
          <h3 class="text-lg font-bold text-stone-800 font-manga mb-4 flex items-center gap-2">
            <span>📚</span>
            Toutes les entrées
            <span class="text-sm font-normal text-stone-500">({{ itemsFiltres.length }})</span>
          </h3>

          <div v-if="itemsFiltres.length > 0" class="grid grid-cols-5 gap-2 max-h-[40vh] overflow-y-auto pr-2">
            <NuxtLink
              v-for="item in itemsFiltres"
              :key="item.id"
              :to="`/wiki/${item.slug}`"
              class="px-2 py-1.5 border-2 border-transparent hover:border-stone-400 transition-all font-montserrat text-xs font-bold text-stone-800 truncate flex items-center gap-1"
              :style="{ backgroundColor: categoryConfig[item.categorie]?.color || '#e5e5e5' }"
            >
              <span class="text-xs">{{ categoryConfig[item.categorie]?.emoji }}</span>
              <span class="truncate">{{ item.nom }}</span>
            </NuxtLink>
          </div>

          <div v-else-if="searchQuery" class="text-stone-500 text-center py-8 font-montserrat">
            Aucun résultat pour "{{ searchQuery }}"
          </div>

          <div v-else class="text-stone-500 text-center py-8 font-montserrat">
            Aucune entrée dans le wiki pour le moment.
          </div>
        </div>
      </div>
    </div>

    <!-- Modal de création -->
    <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="fermerFormulaire">
      <div class="bg-amber-50  max-w-2xl w-full border-4 border-amber-900/40 flex flex-col relative">
        <!-- En-tête -->
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
          <div class="relative px-8 py-6 flex items-center justify-between">
            <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
              <span class="text-xl">📝</span>
              Créer une entrée wiki
            </h3>
            <button
              @click="fermerFormulaire"
              class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 "
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
                class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-lg"
                placeholder="Nom de l'entrée..."
              />
            </div>

            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Catégorie *</label>
              <div class="grid grid-cols-2 gap-3">
                <button
                  v-for="(config, key) in categoryConfig"
                  :key="key"
                  type="button"
                  @click="nouvelItem.categorie = key"
                  class="px-4 py-3  border-2 transition-all font-montserrat flex items-center gap-2 justify-center"
                  :class="nouvelItem.categorie === key
                    ? 'border-stone-800 ring-2 ring-stone-400'
                    : 'border-transparent hover:border-stone-300'"
                  :style="{ backgroundColor: config.color }"
                >
                  <span>{{ config.emoji }}</span>
                  <span class="text-stone-800">{{ config.name }}</span>
                </button>
              </div>
            </div>

            <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
              <button
                type="submit"
                :disabled="!nouvelItem.categorie"
                class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4  font-bold text-lg transition-all duration-300 text-amber-50 font-katana disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Créer
              </button>
              <button
                type="button"
                @click="fermerFormulaire"
                class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30  font-semibold transition-all duration-300 text-stone-800 font-katana"
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
const route = useRoute()
const router = useRouter()

const loading = ref(false)
const afficherFormulaire = ref(false)
const searchQuery = ref('')
const items = ref([])
const nouvelItem = ref({
  nom: '',
  categorie: ''
})

const categoryConfig = {
  clans: { name: 'Clans', emoji: '⚔️', color: '#AAABCF' },
  lieux: { name: 'Lieux', emoji: '🏯', color: '#ACD4CD' },
  personnages: { name: 'Personnages', emoji: '👤', color: '#F1C5A9' },
  autre: { name: 'Autre', emoji: '📦', color: '#CDAFCE' }
}

// Filtrer les items selon la recherche
const itemsFiltres = computed(() => {
  if (!searchQuery.value.trim()) return items.value

  const query = searchQuery.value.toLowerCase()
  return items.value.filter(item => {
    return item.nom?.toLowerCase().includes(query) ||
           item.description?.toLowerCase().includes(query)
  })
})

// Charger les items du wiki
const chargerItems = async () => {
  if (!personnageActif.value?.id) return

  loading.value = true
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('nom', { ascending: true })

  items.value = data || []
  loading.value = false
}

// Rediriger si pas de personnage actif, ou ouvrir le formulaire si paramètre create
onMounted(async () => {
  if (!personnageActif.value) {
    navigateTo('/')
    return
  }

  await chargerItems()

  // Si on a un paramètre create dans l'URL, ouvrir le formulaire
  const createName = route.query.create
  if (createName) {
    nouvelItem.value.nom = decodeURIComponent(createName)
    afficherFormulaire.value = true
  }
})

const creerItem = async () => {
  if (!personnageActif.value?.id || !nouvelItem.value.categorie) return

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
      nom: nouvelItem.value.nom,
      categorie: nouvelItem.value.categorie,
      slug,
      description: '',
      tags: []
    }])

  if (!error) {
    router.push(`/wiki/${slug}`)
    fermerFormulaire()
  }
}

const fermerFormulaire = () => {
  afficherFormulaire.value = false
  nouvelItem.value = {
    nom: '',
    categorie: ''
  }
  // Nettoyer l'URL du paramètre create
  if (route.query.create) {
    router.replace('/wiki')
  }
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>
