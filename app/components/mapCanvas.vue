<template>
  <div class="flex h-screen font-montserrat" style="background-image: url('https://i.pinimg.com/1200x/a8/15/3f/a8153f187d02808faa8e65539bd92b5b.jpg'); background-size: cover; background-position: center; background-attachment: fixed;">
    <!-- Map section - 50vw -->
    <div class="w-[50vw] flex justify-center items-center p-4">
      <div class="relative overflow-hidden rounded-2xl shadow" :style="{ height: '100vh', aspectRatio: imageDimensions ? imageDimensions.width / imageDimensions.height : undefined }">
        <!-- Map image -->
        <img
          ref="imageRef"
          v-if="map.image_url"
          :src="map.image_url"
          class="absolute inset-0 w-full h-full object-contain bg-zinc-950/5"
          alt="Rokugan map"
          draggable="false"
          @load="onImageLoad"
        />

        <!-- Clickable grid overlay -->
        <div
          class="absolute inset-0 grid"
          :style="{
            gridTemplateColumns: `repeat(${cols}, minmax(0, 1fr))`,
            gridTemplateRows: `repeat(${rows}, minmax(0, 1fr))`,
          }"
        >
          <button
            v-for="i in cols * rows"
            :key="i"
            class="group relative"
            type="button"
            @click="onCellClick((i - 1) % cols, Math.floor((i - 1) / cols))"
          >
            <!-- hover hint -->
            <span class="absolute inset-0 group-hover:bg-white/10 transition"></span>
          </button>
        </div>

        <!-- Markers overlay -->
        <div v-if="showLocations" class="absolute inset-0 pointer-events-none">
          <button
            v-for="loc in locations"
            :key="loc.id"
            class="pointer-events-auto absolute -translate-x-1/2 -translate-y-1/2"
            :style="markerStyle(loc)"
            type="button"
            @click="emit('markerClick', loc)"
          >
            <div class="relative">
              <div :class="['h-3 w-3 rounded-full shadow transition-transform', hoveredLocationId === loc.id ? 'scale-125' : '']" :style="{ backgroundColor: hoveredLocationId === loc.id ? '#fbbf24' : typeColorHex[loc.location_type] || '#fbbf24' }"></div>
              <div class="absolute left-1/2 top-3 -translate-x-1/2 whitespace-nowrap text-xs px-2 py-1 rounded bg-black/60 text-white">
                {{ loc.name }}
              </div>
            </div>
          </button>
        </div>
      </div>
    </div>

    <!-- List section - 50vw -->
    <div class="w-[50vw] p-4 overflow-y-auto border-l relative">
      <div class="absolute inset-0 bg-amber-50/30"></div>
      <div class="relative z-10">
                  <BackButton @click="goBack" class="mb-4">← Retour</BackButton>

        <div class="flex flex-row gap-8 h-12">
          
          <!-- Map Selector -->
          <div v-if="availableMaps && availableMaps.length > 0" class="flex items-center gap-3">
            <select 
              :value="selectedMapId"
              @change="emit('mapChange', ($event.target as HTMLSelectElement).value)"
              class="px-3 py-2 border border-stone-300 rounded-md bg-white text-stone-900 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500"
            >
              <option v-for="mapOption in availableMaps" :key="mapOption.id" :value="mapOption.id">
                {{ mapOption.name }}
              </option>
            </select>
          </div>

          <!-- Location Filter -->
          <div v-if="availableMaps && availableMaps.length > 0" class="flex items-center gap-3">
            <div class="flex bg-stone-100 rounded-md p-1">
              <button 
                @click="emit('toggleShowAllLocations')"
                :class="showAllLocations ? 'bg-white shadow-sm' : 'hover:bg-white/50'"
                class="px-3 py-1 text-xs font-medium rounded transition-all"
              >
                Tous
              </button>
              <button 
                @click="emit('toggleShowAllLocations')"
                :class="!showAllLocations ? 'bg-white shadow-sm' : 'hover:bg-white/50'"
                class="px-3 py-1 text-xs font-medium rounded transition-all"
              >
                Cette carte
              </button>
            </div>
          </div>
        </div>
        <input v-model="searchQuery" type="text" placeholder="Rechercher..." class="w-full p-2 border rounded mb-4">
        <div class="mb-4 flex flex-wrap gap-1">
           
          <button @click="showLocations = !showLocations" class="h-8 px-3 bg-gray-400 text-white rounded hover:bg-gray-600 transition flex items-center justify-center text-sm">
            <Icon :name="showLocations ? 'heroicons:map' : 'heroicons:eye-slash'" class="w-4 h-4" />
          </button>
          <button @click="selectedType = null" :class="selectedType === null ? 'bg-amber-500 text-white' : 'bg-gray-200'" class="px-2 py-1 rounded text-xs">Tous</button>
          <button v-for="type in uniqueTypes" :key="type" @click="selectedType = type" class="px-2 py-1 rounded text-white capitalize text-xs" :style="{ backgroundColor: selectedType === type ? typeColorHex[type] : '#e5e7eb', color: selectedType === type ? 'white' : 'black' }">{{ traduireType(type) }}</button>
        </div>
        <ul v-if="showLocations" class="space-y-2">
          <li
            v-for="loc in filteredLocations"
            :key="loc.id"
            @mouseenter="hoveredLocationId = loc.id"
            @mouseleave="hoveredLocationId = null"
            @click="emit('markerClick', loc)"
            :class="{ 'bg-blue-50 shadow-sm': hoveredLocationId === loc.id }"
            class="p-3 border rounded cursor-pointer hover:bg-gray-100 transition relative"
            :style="{ borderLeft: `4px solid ${typeColorHex[loc.location_type] || '#fbbf24'}` }"
          >
            <div class="flex justify-between items-center">
              <div class="flex flex-row items-center gap-4">
                <span class="font-medium" :class="loc.location_type === 'city' ? 'font-serif' : ''">{{ loc.name }}</span>
                <span class="text-sm text-gray-600 capitalize">{{ traduireType(loc.location_type) }}</span>
                <span class="text-sm text-gray-500 capitalize">{{ traduireStatut(loc.status) }}</span>
              </div>
              <div class="flex items-center gap-2">
                <button @click.stop="handleWiki(loc)" class="text-blue-500 hover:text-blue-700" title="Voir ou créer l'article wiki">
                  <Icon name="heroicons:book-open" class="w-6 h-6" />
                </button>
                <button @click.stop="emit('deleteLocation', loc)" class="text-red-500 hover:text-red-700" title="Supprimer">
                  <Icon name="heroicons:trash" class="w-6 h-6" />
                </button>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<!-- components/map/MapCanvas.vue -->
<script setup lang="ts">
import { useRouter } from '#app'
import { computed, ref } from 'vue'
import { cellToPercent } from '~/utils/grid'
import type { MapRow, MapLocationRow } from '~/utils/types'

const props = defineProps<{
  map: MapRow
  locations: MapLocationRow[]
  availableMaps?: MapRow[]
  selectedMapId?: string
  showAllLocations?: boolean
}>()

const emit = defineEmits<{
  (e: 'cellClick', payload: { col: number; row: number }): void
  (e: 'markerClick', payload: MapLocationRow): void
  (e: 'deleteLocation', payload: MapLocationRow): void
  (e: 'mapChange', payload: string): void
  (e: 'toggleShowAllLocations'): void
  (e: 'createNewMap'): void
}>()

const hoveredLocationId = ref<string | null>(null)
const imageRef = ref<HTMLImageElement | null>(null)
const imageDimensions = ref<{ width: number; height: number } | null>(null)
const searchQuery = ref('')
const selectedType = ref<string | null>(null)
const showLocations = ref(true)

const router = useRouter()

const typeColorHex = {
  city: '#22bbe5',
  village: '#10b981',
  temple: '#8b5cf6',
  shrine: '#ec4899',
  port: '#1e40af',
  enemy_bastion: '#dc2626',
  other: '#000000'
}

// Traduction des types et statuts
const typeLabels: Record<string, string> = {
  city: 'Ville',
  village: 'Village',
  temple: 'Temple',
  shrine: 'Sanctuaire',
  port: 'Port',
  enemy_bastion: 'Bastion ennemi',
  other: 'Autre'
}
const statusLabels: Record<string, string> = {
  rumor: 'Rumeur',
  known: 'Connu',
  visited: 'Visité',
  secret: 'Secret',
  forbidden: 'Interdit'
}

const cols = computed(() => props.map.grid_cols)
const rows = computed(() => props.map.grid_rows)

const uniqueTypes = computed(() => {
  const types = new Set(props.locations.map(loc => loc.location_type))
  return Array.from(types).sort()
})

const filteredLocations = computed(() => {
  let filtered = props.locations.filter(loc => {
    const matchesType = !selectedType.value || loc.location_type === selectedType.value
    const matchesSearch = !searchQuery.value || loc.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    return matchesType && matchesSearch
  })
  return filtered.sort((a, b) => a.name.localeCompare(b.name))
})

function onImageLoad() {
  if (imageRef.value) {
    imageDimensions.value = {
      width: imageRef.value.naturalWidth,
      height: imageRef.value.naturalHeight
    }
  }
}

function goBack() {
  router.push('/')
}

function onCellClick(col: number, row: number) {
  emit('cellClick', { col, row })
}

function markerStyle(loc: MapLocationRow) {
  const { x, y } = cellToPercent(loc.grid_col, loc.grid_row, cols.value, rows.value)
  return { left: `${x}%`, top: `${y}%` }
}

function traduireType(type: string) {
  return typeLabels[type] || type
}

function traduireStatut(status: string) {
  return statusLabels[status] || status
}

async function handleWiki(loc: MapLocationRow) {
  const client = useSupabaseClient()
  const personnageActif = usePersonnageActif()
  
  if (!personnageActif.value?.id) {
    alert('Aucun personnage actif')
    return
  }
  
  // Vérifie si un article wiki existe déjà (slug = nom normalisé)
  const slug = loc.name.normalize('NFD').replace(/\p{Diacritic}/gu, '').replace(/\s+/g, '-').toLowerCase()
  
  try {
    const { data, error } = await client
      .from('wiki_items')
      .select('*')
      .eq('slug', slug)
      .eq('personnage_id', personnageActif.value.id)
      .single()
    
    if (data) {
      // Article existe, aller dessus
      router.push(`/wiki/${slug}`)
    } else {
      // Article n'existe pas, le créer
      if (confirm(`Aucun article wiki pour « ${loc.name} ». Voulez-vous le créer ?`)) {
        const { data: created, error: createError } = await client
          .from('wiki_items')
          // @ts-ignore
          .insert([{
            personnage_id: personnageActif.value.id,
            nom: loc.name,
            slug: slug,
            categorie: 'lieux',
            description: '',
            tags: []
          }])
          .select()
          .single()
        
        if (createError) {
          alert('Erreur lors de la création du wiki : ' + createError.message)
          return
        }
        
        router.push(`/wiki/${slug}`)
      }
    }
  } catch (e: any) {
    alert('Erreur lors de la vérification du wiki : ' + (e?.message || e))
  }
}

function handleJournal(loc: MapLocationRow) {
  router.push(`/journal?search=${encodeURIComponent(loc.name)}`)
}
</script>