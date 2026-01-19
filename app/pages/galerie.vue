<template>
  <PageWrapper :loading="loading" loading-message="Chargement de la galerie...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

    <div class="flex flex-col px-12 mt-8">
      <!-- En-tête -->
      <div class="mb-6 flex items-center justify-between">
        <h1 class="text-2xl font-bold text-stone-900 font-manga">Galerie</h1>
        <p class="text-stone-600 font-montserrat text-sm">{{ totalImages }} image{{ totalImages > 1 ? 's' : '' }}</p>
      </div>

      <!-- Grille d'images -->
      <div v-if="allImages.length > 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
        <div
          v-for="(item, index) in allImages"
          :key="index"
          class="aspect-square  overflow-hidden border-2 border-amber-800/30 cursor-pointer hover:border-amber-600 hover:shadow-lg transition-all group relative"
          @click="ouvrirImageModal(item)"
        >
          <img :src="item.url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
          <div class="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/70 to-transparent p-2 opacity-0 group-hover:opacity-100 transition-opacity">
            <p class="text-white text-xs font-montserrat truncate">{{ item.entree.titre }}</p>
          </div>
        </div>
      </div>

      <!-- État vide -->
      <div v-else class="text-center py-16">
        <div class="inline-block  p-8 border-2 border-amber-800/30 bg-amber-50/50">
          <p class="text-5xl mb-4">🖼️</p>
          <p class="text-stone-700 font-montserrat text-lg mb-2">Aucune image dans la galerie</p>
          <p class="text-stone-500 font-montserrat text-sm">Ajoutez des images à vos entrées de journal pour les voir ici</p>
          <NuxtLink
            to="/journal"
            class="inline-block mt-4 px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium  font-montserrat text-sm"
          >
            Aller au journal
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- Image Modal -->
    <div v-if="imageModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center" @click.self="fermerImageModal">
      <div @click="fermerImageModal" class="absolute inset-0 bg-black/80"></div>
      <div class="relative max-w-[60vw] max-h-[90vh] flex flex-col bg-amber-50  overflow-hidden border-4 border-amber-800">
        <!-- Image -->
        <div class="flex-1 overflow-hidden flex items-center justify-center p-4">
          <img :src="imageModalItem?.url" class="max-w-full max-h-[60vh] object-contain " />
        </div>

        <!-- Info entrée -->
        <div v-if="imageModalItem?.entree" class="p-4 border-t-2 border-amber-800/30 bg-amber-50/80">
          <h3 class="font-bold text-lg text-stone-900 font-manga mb-1">{{ imageModalItem.entree.titre }}</h3>
          <p class="text-xs text-stone-600 font-montserrat mb-2">{{ formatDate(imageModalItem.entree.date_session) }}</p>

          <!-- Résumé -->
          <p v-if="imageModalItem.entree.resume" class="text-sm text-stone-700 font-montserrat">
            {{ imageModalItem.entree.resume }}
          </p>
          <p v-else class="text-sm text-stone-500 font-montserrat italic">
            Pas de résumé disponible
          </p>

          <!-- Tags -->
          <div v-if="imageModalItem.entree.tags && imageModalItem.entree.tags.length > 0" class="flex flex-wrap gap-1 mt-3">
            <span
              v-for="(tag, idx) in imageModalItem.entree.tags"
              :key="idx"
              class="px-2 py-0.5 text-stone-800 font-montserrat text-xs"
              :style="{ backgroundColor: getTagColor(tag) }"
            >
              {{ tag }}
            </span>
          </div>

          <NuxtLink
            :to="`/journal?entry=${imageModalItem.entree.id}`"
            class="inline-block mt-4 px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium  font-montserrat text-sm"
          >
            Voir l'entrée complète
          </NuxtLink>
        </div>

        <!-- Navigation -->
        <div class="absolute top-1/2 -translate-y-1/2 left-2">
          <button
            v-if="currentImageIndex > 0"
            @click.stop="navigateImage(-1)"
            class="w-10 h-10 flex items-center justify-center text-stone-800 shadow-lg"
          >
            ←
          </button>
        </div>
        <div class="absolute top-1/2 -translate-y-1/2 right-2">
          <button
            v-if="currentImageIndex < allImages.length - 1"
            @click.stop="navigateImage(1)"
            class="w-10 h-10  flex items-center justify-center text-stone-800 shadow-lg"
          >
            →
          </button>
        </div>

      </div>
    </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const loading = ref(true)
const entries = ref([])
const allImages = ref([])
const wikiItems = ref([])

// Modal state
const imageModalOpen = ref(false)
const imageModalItem = ref(null)
const currentImageIndex = ref(0)

const categoryColors = {
  clans: '#AAABCF',
  lieux: '#ACD4CD',
  personnages: '#F1C5A9',
  autre: '#CDAFCE'
}

const totalImages = computed(() => allImages.value.length)

onMounted(async () => {
  if (!personnageActif.value) {
    navigateTo('/')
    return
  }

  try {
    await Promise.all([chargerEntrees(), chargerWikiItems()])
    extraireImages()
  } finally {
    loading.value = false
  }
})

const chargerEntrees = async () => {
  if (!personnageActif.value?.id) return

  const { data } = await client
    .from('journal_entries')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('date_session', { ascending: false })

  entries.value = data || []
}

const chargerWikiItems = async () => {
  if (!personnageActif.value?.id) return

  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  wikiItems.value = data || []
}

const extraireImages = () => {
  const images = []

  for (const entree of entries.value) {
    if (entree.images && entree.images.length > 0) {
      for (const url of entree.images) {
        images.push({
          url,
          entree
        })
      }
    }
  }

  allImages.value = images
}

const getTagColor = (tagName) => {
  const wikiItem = wikiItems.value.find(i => i.nom === tagName)
  if (wikiItem) {
    return categoryColors[wikiItem.categorie] || '#CDAFCE'
  }
  return '#CDAFCE'
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const ouvrirImageModal = (item) => {
  imageModalItem.value = item
  currentImageIndex.value = allImages.value.findIndex(i => i.url === item.url)
  imageModalOpen.value = true
}

const fermerImageModal = () => {
  imageModalOpen.value = false
  imageModalItem.value = null
}

const navigateImage = (direction) => {
  const newIndex = currentImageIndex.value + direction
  if (newIndex >= 0 && newIndex < allImages.value.length) {
    currentImageIndex.value = newIndex
    imageModalItem.value = allImages.value[newIndex]
  }
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>
