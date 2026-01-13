// composables/useMapLocations.ts
import type { MapLocationRow } from '~/utils/types'

export function useMapLocations() {
  const supabase = useSupabaseClient()
  const locations = ref<MapLocationRow[]>([])
  const loading = ref(false)

  async function fetchByMapId(mapId: string) {
    loading.value = true
    const { data, error } = await supabase
      .from('map_locations')
      .select('*')
      .eq('map_id', mapId)
      .order('created_at', { ascending: true })
    loading.value = false
    if (error) throw error
    locations.value = (data ?? []) as MapLocationRow[]
  }

  async function createLocation(payload: Omit<MapLocationRow, 'id'>) {
    const { data, error } = await supabase
      .from('map_locations')
      .insert(payload)
      .select('*')
      .single()
    if (error) throw error
    locations.value.push(data as MapLocationRow)
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
    locations.value = locations.value.map(l => (l.id === id ? (data as MapLocationRow) : l))
    return data as MapLocationRow
  }

  async function deleteLocation(id: string) {
    const { error } = await supabase.from('map_locations').delete().eq('id', id)
    if (error) throw error
    locations.value = locations.value.filter(l => l.id !== id)
  }

  return { locations, loading, fetchByMapId, createLocation, updateLocation, deleteLocation }
}
