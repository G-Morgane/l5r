<template>
  <MapCanvas
    v-if="map"
    :map="map"
    :locations="locations"
    :available-maps="availableMaps"
    :selected-map-id="selectedMapId"
    :show-all-locations="showAllLocations"
    @cellClick="handleCellClick"
    @markerClick="handleMarkerClick"
    @deleteLocation="handleDeleteLocation"
    @mapChange="handleMapChange"
    @toggleShowAllLocations="toggleShowAllLocations"
    @createNewMap="createNewMap"
  />

    <!-- Modal for location -->
    <div v-if="modalOpen" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 font-montserrat" @click.self="modalOpen = false">
      <div class="bg-white p-6 rounded-lg shadow-lg max-w-md w-full mx-4">
        <h3 class="text-xl font-bold mb-4">{{ editing ? 'Modifier le point d\'intérêt' : 'Ajouter un point d\'intérêt' }}</h3>
        <form @submit.prevent="handleSave">
          <div class="mb-4">
            <label class="block text-sm font-medium mb-1">Nom</label>
            <input v-model="form.name" type="text" class="w-full border rounded px-3 py-2" required />
          </div>
          <div class="mb-4">
            <label class="block text-sm font-medium mb-1">Type</label>
            <select v-model="form.location_type" class="w-full border rounded px-3 py-2">
              <option value="city">Ville</option>
              <option value="village">Village</option>
              <option value="temple">Temple</option>
              <option value="shrine">Sanctuaire</option>
              <option value="port">Port</option>
              <option value="enemy_bastion">Bastion ennemis</option>
              <option value="other">Autre</option>
            </select>
          </div>
          <div class="mb-4">
            <label class="block text-sm font-medium mb-1">Statut</label>
            <select v-model="form.status" class="w-full border rounded px-3 py-2">
              <option value="rumor">Rumeur</option>
              <option value="known">Connu</option>
              <option value="visited">Visité</option>
              <option value="secret">Secret</option>
              <option value="forbidden">Interdit</option>
            </select>
          </div>
          <div class="mb-4">
            <label class="block text-sm font-medium mb-1">Notes</label>
            <textarea v-model="form.notes" class="w-full border rounded px-3 py-2" rows="3"></textarea>
          </div>
          <div class="flex justify-end space-x-2">
            <button type="button" @click="modalOpen = false" class="px-4 py-2 bg-gray-300 rounded">Annuler</button>
            <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded">Sauvegarder</button>
          </div>
        </form>
      </div>
    </div>

</template>
<script setup lang="ts">
import type { MapRow, MapLocationRow } from '~/utils/types'
const supabase = useSupabaseClient()

const map = ref<MapRow | null>(null)
const availableMaps = ref<MapRow[]>([])
const selectedMapId = ref<string>('')
const allLocations = ref<MapLocationRow[]>([])

// Filtrage des points d'intérêt
const showAllLocations = ref(true)
const locations = computed(() => {
  if (showAllLocations.value) {
    return allLocations.value
  } else {
    return allLocations.value.filter(loc => loc.map_id === selectedMapId.value)
  }
})

// modal state
const modalOpen = ref(false)
const editing = ref<MapLocationRow | null>(null)
const pendingCell = ref<{ col: number; row: number } | null>(null)
const form = ref({
  name: '',
  location_type: 'other' as MapLocationRow['location_type'],
  status: 'rumor' as MapLocationRow['status'],
  notes: '' as string | null,
  grid_col: 0,
  grid_row: 0,
  map_id: '',
  color: null as string | null,
  icon: null as string | null
})

async function loadAvailableMaps() {
  const { data, error } = await supabase
    .from('maps')
    .select('*')
    .order('name')
  
  if (error) {
    console.error('Erreur lors du chargement des cartes:', error)
    return
  }
  
  availableMaps.value = data as MapRow[]
  
  // Si aucune carte n'existe, en créer une par défaut
  if (availableMaps.value.length === 0) {
    await createDefaultMap()
  } else if (!map.value) {
    // Sélectionner la première carte par défaut
    selectedMapId.value = availableMaps.value[0].id
    map.value = availableMaps.value[0]
  }
}

async function loadAllLocations() {
  // Charger tous les points d'intérêt de toutes les cartes
  const { data, error } = await supabase
    .from('map_locations')
    .select('*')
    .order('name')
  
  if (error) {
    console.error('Erreur lors du chargement des points d\'intérêt:', error)
    return
  }
  
  allLocations.value = data as MapLocationRow[]
}

async function createLocation(payload: Omit<MapLocationRow, 'id'>) {
  const { data, error } = await supabase
    .from('map_locations')
    .insert(payload)
    .select('*')
    .single()
  
  if (error) throw error
  
  allLocations.value.push(data as MapLocationRow)
  return data as MapLocationRow
}

async function updateLocation(id: string, patch: Partial<MapLocationRow>) {
  const { data, error } = await supabase
    .from('map_locations')
    .update(patch)
    .eq('id', id)
    .select('*')
    .single()
  
  if (error) throw error
  
  allLocations.value = allLocations.value.map(l => (l.id === id ? (data as MapLocationRow) : l))
  return data as MapLocationRow
}

async function deleteLocation(id: string) {
  const { error } = await supabase
    .from('map_locations')
    .delete()
    .eq('id', id)
  
  if (error) throw error
  
  allLocations.value = allLocations.value.filter(l => l.id !== id)
}

async function createDefaultMap() {
  const { data: created, error } = await supabase
    .from('maps')
    .insert({
      name: 'Rokugan',
      image_url: null,
      grid_cols: 80,
      grid_rows: 45,
    })
    .select('*')
    .single()
  
  if (error) throw error
  
  const newMap = created as MapRow
  availableMaps.value = [newMap]
  selectedMapId.value = newMap.id
  map.value = newMap
}

async function createNewMap() {
  const mapName = prompt('Nom de la nouvelle carte:')
  if (!mapName?.trim()) return
  
  const { data: created, error } = await supabase
    .from('maps')
    .insert({
      name: mapName.trim(),
      image_url: null,
      grid_cols: 80,
      grid_rows: 45,
    })
    .select('*')
    .single()
  
  if (error) {
    alert('Erreur lors de la création de la carte: ' + error.message)
    return
  }
  
  const newMap = created as MapRow
  availableMaps.value.push(newMap)
  selectedMapId.value = newMap.id
  map.value = newMap
  // Recharger tous les points d'intérêt au cas où
  await loadAllLocations()
}

onMounted(async () => {
  await loadAvailableMaps()
  await loadAllLocations()
})

function handleCellClick({ col, row }: { col: number; row: number }) {
  pendingCell.value = { col, row }
  editing.value = null
  form.value = {
    name: '',
    location_type: 'other',
    status: 'rumor',
    notes: '',
    grid_col: col,
    grid_row: row,
    map_id: map.value!.id,
    color: null,
    icon: null
  }
  modalOpen.value = true
}

function handleMarkerClick(loc: MapLocationRow) {
  editing.value = loc
  pendingCell.value = null
  form.value = { ...loc }
  modalOpen.value = true
}

async function handleSave() {
  if (editing.value) {
    await updateLocation(editing.value.id, form.value)
  } else {
    await createLocation(form.value)
  }
  modalOpen.value = false
  editing.value = null
  pendingCell.value = null
}

async function handleDeleteLocation(loc: MapLocationRow) {
  if (confirm(`Supprimer ${loc.name} ?`)) {
    await deleteLocation(loc.id)
  }
}

function handleMapChange(mapId: string) {
  selectedMapId.value = mapId
  const selectedMap = availableMaps.value.find(m => m.id === mapId)
  if (selectedMap) {
    map.value = selectedMap
  }
}

function toggleShowAllLocations() {
  showAllLocations.value = !showAllLocations.value
}
</script>


