<template>
  <div v-if="!personnageActif" class="min-h-screen flex items-center justify-center bg-gradient-to-br from-amber-50 to-stone-100">
    <div class="text-center">
      <Icon name="heroicons:user-circle" class="w-16 h-16 text-stone-400 mx-auto mb-4" />
      <h2 class="text-2xl font-bold text-stone-600 mb-2">Aucun personnage sélectionné</h2>
      <p class="text-stone-500 mb-6">Veuillez sélectionner un personnage pour accéder à votre inventaire.</p>
      <NuxtLink to="/" class="px-6 py-3 bg-amber-600 hover:bg-amber-700 text-white rounded-lg font-medium transition-colors">
        Retour à l'accueil
      </NuxtLink>
    </div>
  </div>

  <div v-else class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img
        src="/background_selection.png"
        alt="Japanese room background"
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10 h-screen flex flex-col font-montserrat">
      <!-- En-tête -->
      <div class="mb-8 flex-shrink-0 w-full">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">🎒 Inventaire</h1>
          <BackButton @click="$router.push('/')" class="mb-0" blanc>← Retour</BackButton>
        </div>

      <!-- Contenu principal -->
      <div class="flex-1 overflow-y-auto">
        <div class="bg-white/90 backdrop-blur-sm rounded-xl p-6 shadow-2xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 max-w-7xl mx-auto">
          <!-- Avertissement si tables non créées -->
          <div v-if="!tablesExist" class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
            <div class="flex items-center">
              <Icon name="heroicons:exclamation-triangle" class="w-5 h-5 mr-2" />
              <strong>Attention:</strong>
            </div>
            <p class="mt-1">
              Les tables de base de données pour l'inventaire n'ont pas encore été créées.
              Veuillez exécuter le script SQL <code class="bg-red-200 px-1 rounded">database/inventory_schema.sql</code> dans votre base Supabase.
            </p>
          </div>

          <!-- Actions principales -->
          <div class="flex flex-wrap gap-4 mb-6">

          <!-- Filtrage par type avec tags -->
          <div class="flex flex-wrap gap-1 mb-4">
            <button 
              @click="selectedTypeFilter = ''" 
              :class="selectedTypeFilter === '' ? 'bg-amber-500 text-white' : 'bg-gray-200 text-gray-700'"
              class="px-3 py-1 rounded text-sm font-medium transition-colors"
            >
              Tous
            </button>
            <button 
              v-for="type in availableTypes" 
              :key="type.value"
              @click="selectedTypeFilter = type.value" 
              :class="selectedTypeFilter === type.value ? 'text-white' : 'bg-gray-200 text-gray-700'"
              class="px-3 py-1 rounded text-sm font-medium transition-colors capitalize"
              :style="{ backgroundColor: selectedTypeFilter === type.value ? type.color : undefined }"
            >
              {{ type.label }}
            </button>
          </div>
          </div>
            <div class="flex items-center gap-2">
              <button
              @click="showAddItemModal = true"
              class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-lg font-medium transition-colors flex items-center gap-2"
            >
              <Icon name="heroicons:plus" class="w-5 h-5" />
            </button>
              <input
                v-model="searchQuery"
                @input="applyFilters"
                type="text"
                placeholder="Nom, description..."
                class="w-full px-3 py-2 border border-stone-300 rounded-md bg-white text-stone-900 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500"
              />
            </div>
          <!-- Tags actifs -->
      <div v-if="activeTags.length > 0" class="mb-6">
        <div class="flex flex-wrap gap-2">
          <span class="text-sm font-medium text-stone-700">Tags actifs :</span>
          <button
            v-for="tag in activeTags"
            :key="tag.id"
            @click="removeTagFilter(tag.id)"
            class="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium"
            :style="{ backgroundColor: tag.color + '20', color: tag.color, border: `1px solid ${tag.color}` }"
          >
            {{ tag.name }}
            <Icon name="heroicons:x-mark" class="w-3 h-3" />
          </button>
          <button
            @click="clearAllTagFilters"
            class="px-2 py-1 text-xs text-stone-500 hover:text-stone-700 underline"
          >
            Effacer tout
          </button>
        </div>
      </div>

      <!-- Liste des objets -->
      <div class="bg-white rounded-lg shadow-sm border border-stone-200 overflow-hidden">
        <div
          v-for="item in filteredItems"
          :key="item.id"
          class="border-b border-stone-100 last:border-b-0"
        >
          <!-- Ligne principale -->
          <div
            @click="toggleItemExpansion(item.id)"
            class="p-4 hover:bg-stone-50 cursor-pointer transition-colors"
          >
            <div class="flex justify-between items-center">
              <div class="flex items-center gap-4 flex-1">
                <!-- Icône d'expansion -->
                <button class="flex-shrink-0">
                  <Icon
                    :name="expandedItems.has(item.id) ? 'heroicons:chevron-down' : 'heroicons:chevron-right'"
                    class="w-5 h-5 text-stone-400"
                  />
                </button>

                <!-- Nom et type -->
                <div class="flex-1">
                  <h3 class="text-lg font-semibold text-stone-800">{{ item.name }}</h3>
                  <div class="flex items-center gap-2 mt-1">
                    <span class="capitalize px-2 py-1 rounded-full text-xs font-medium"
                          :class="getTypeColorClass(item.type)">
                      {{ translateType(item.type) }}
                    </span>
                    <span class="text-sm text-stone-600">{{ item.value }} koku</span>
                    <span v-if="item.quantity > 1" class="text-sm text-stone-500">×{{ item.quantity }}</span>
                  </div>
                </div>

                <!-- Actions rapides -->
                <div class="flex items-center gap-2">
                  <button
                    @click.stop="toggleEquip(item)"
                    :class="item.is_equipped ? 'bg-green-500 hover:bg-green-600' : 'bg-stone-400 hover:bg-stone-500'"
                    class="px-3 py-1 text-white text-sm rounded transition-colors"
                    :title="item.is_equipped ? 'Déséquiper' : 'Équiper'"
                  >
                    <Icon :name="item.is_equipped ? 'heroicons:check' : 'heroicons:plus'" class="w-4 h-4" />
                  </button>
                  <button
                    @click.stop="editItem(item)"
                    class="p-2 text-stone-400 hover:text-stone-600 transition-colors rounded"
                    title="Modifier"
                  >
                    <Icon name="heroicons:pencil" class="w-4 h-4" />
                  </button>
                  <button
                    @click.stop="deleteItem(item)"
                    class="p-2 text-red-400 hover:text-red-600 transition-colors rounded"
                    title="Supprimer"
                  >
                    <Icon name="heroicons:trash" class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Panneau extensible -->
          <div
            v-if="expandedItems.has(item.id)"
            class="bg-stone-50 border-t border-stone-100 px-4 py-4"
          >
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Colonne gauche -->
              <div class="space-y-4">
                <!-- Description -->
                <div v-if="item.description">
                  <h4 class="text-sm font-semibold text-stone-700 mb-2">Description</h4>
                  <p class="text-sm text-stone-600">{{ item.description }}</p>
                </div>

                <!-- Propriétés spécifiques -->
                <div v-if="item.type === 'weapon' && item.damage" class="flex items-center gap-2">
                  <Icon name="heroicons:bolt" class="w-4 h-4 text-red-500" />
                  <span class="text-sm font-medium text-stone-700">
                    Dégâts: {{ item.damage }}
                    <span v-if="item.damage_type" class="text-stone-500">({{ translateDamageType(item.damage_type) }})</span>
                  </span>
                </div>

                <div v-if="item.type === 'armor' && item.armor_rating" class="flex items-center gap-2">
                  <Icon name="heroicons:shield-check" class="w-4 h-4 text-blue-500" />
                  <span class="text-sm font-medium text-stone-700">
                    Armure: {{ item.armor_rating }}
                  </span>
                </div>

                <!-- Poids -->
                <div v-if="item.weight > 0" class="flex items-center gap-2">
                  <Icon name="heroicons:scale" class="w-4 h-4 text-stone-500" />
                  <span class="text-sm text-stone-600">Poids: {{ item.weight }} kg</span>
                </div>
              </div>

              <!-- Colonne droite -->
              <div class="space-y-4">
                <!-- Tags -->
                <div v-if="item.tags && item.tags.length > 0">
                  <h4 class="text-sm font-semibold text-stone-700 mb-2">Tags</h4>
                  <div class="flex flex-wrap gap-1">
                    <button
                      v-for="tag in item.tags"
                      :key="tag.id"
                      @click="addTagFilter(tag)"
                      class="px-2 py-1 rounded-full text-xs font-medium transition-colors hover:opacity-80"
                      :style="{ backgroundColor: tag.color + '20', color: tag.color, border: `1px solid ${tag.color}` }"
                    >
                      {{ tag.name }}
                    </button>
                  </div>
                </div>

                <!-- État d'équipement -->
                <div class="flex items-center gap-2">
                  <Icon :name="item.is_equipped ? 'heroicons:check-circle' : 'heroicons:minus-circle'"
                        :class="item.is_equipped ? 'text-green-500' : 'text-stone-400'"
                        class="w-4 h-4" />
                  <span class="text-sm text-stone-600">
                    {{ item.is_equipped ? 'Équipé' : 'Non équipé' }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Message si aucun objet -->
      <div v-if="filteredItems.length === 0" class="text-center py-12">
        <Icon name="heroicons:backpack" class="w-16 h-16 text-stone-300 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-stone-600 mb-2">Aucun objet trouvé</h3>
        <p class="text-stone-500">
          {{ searchQuery || selectedTypeFilter || activeTags.length > 0
             ? 'Essayez de modifier vos filtres de recherche'
             : 'Commencez par ajouter votre premier objet à l\'inventaire' }}
        </p>
        </div>
      </div>
    </div>
    </div>
    </div>

    <!-- Modal d'ajout/modification d'objet -->
    <ItemModal
      v-if="showAddItemModal || editingItem"
      :item="editingItem"
      :available-tags="availableTags"
      @save="saveItem"
      @close="closeModal"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

const supabase = useSupabaseClient()
const personnageActif = usePersonnageActif()

// Types locaux
interface InventoryItem {
  id: string
  character_id: string
  name: string
  type: string
  description?: string
  value: number
  damage?: string
  damage_type?: string
  armor_rating?: number
  weight: number
  rarity: string
  is_equipped: boolean
  quantity: number
  tags?: ItemTag[]
}

interface ItemTag {
  id: string
  name: string
  color: string
  description?: string
}

// État réactif
const items = ref<InventoryItem[]>([])
const availableTags = ref<ItemTag[]>([])
const showAddItemModal = ref(false)
const editingItem = ref<InventoryItem | null>(null)
const searchQuery = ref('')
const selectedTypeFilter = ref('')
const activeTagFilters = ref<string[]>([])
const expandedItems = ref<Set<string>>(new Set())
const tablesExist = ref(true)

// Computed
const filteredItems = computed(() => {
  let filtered = items.value

  // Filtre par recherche
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(item =>
      item.name.toLowerCase().includes(query) ||
      item.description?.toLowerCase().includes(query) ||
      item.tags?.some(tag => tag.name.toLowerCase().includes(query))
    )
  }

  // Filtre par type
  if (selectedTypeFilter.value) {
    filtered = filtered.filter(item => item.type === selectedTypeFilter.value)
  }

  // Filtre par tags
  if (activeTagFilters.value.length > 0) {
    filtered = filtered.filter(item =>
      item.tags?.some(tag => activeTagFilters.value.includes(tag.id))
    )
  }

  return filtered
})

const activeTags = computed(() => {
  return availableTags.value.filter(tag => activeTagFilters.value.includes(tag.id))
})

const availableTypes = computed(() => [
  { value: 'weapon', label: 'Armes', color: '#dc2626' },
  { value: 'armor', label: 'Armures', color: '#2563eb' },
  { value: 'shield', label: 'Boucliers', color: '#059669' },
  { value: 'item', label: 'Objets', color: '#6b7280' },
  { value: 'consumable', label: 'Consommables', color: '#7c3aed' },
  { value: 'tool', label: 'Outils', color: '#d97706' }
])

// Fonctions utilitaires
const translateType = (type: string) => {
  const translations: Record<string, string> = {
    weapon: 'Arme',
    armor: 'Armure',
    shield: 'Bouclier',
    item: 'Objet',
    consumable: 'Consommable',
    tool: 'Outil'
  }
  return translations[type] || type
}

const translateDamageType = (damageType: string) => {
  const translations: Record<string, string> = {
    slashing: 'Tranchant',
    piercing: 'Perçant',
    blunt: 'Contondant',
    fire: 'Feu',
    magic: 'Magique'
  }
  return translations[damageType] || damageType
}

const getTypeColorClass = (type: string) => {
  const colors: Record<string, string> = {
    weapon: 'bg-red-100 text-red-800',
    armor: 'bg-blue-100 text-blue-800',
    shield: 'bg-green-100 text-green-800',
    item: 'bg-stone-100 text-stone-800',
    consumable: 'bg-purple-100 text-purple-800',
    tool: 'bg-amber-100 text-amber-800'
  }
  return colors[type] || 'bg-stone-100 text-stone-800'
}

// Fonctions de données
const loadItems = async () => {
  if (!personnageActif.value) return

  try {
    const { data, error } = await supabase
      .from('inventory_items')
      .select(`
        *,
        item_tag_relations(
          item_tags(*)
        )
      `)
      .eq('character_id', personnageActif.value.id)
      .order('name')

    if (error) {
      console.warn('Erreur lors du chargement des objets (tables peut-être non créées):', error)
      tablesExist.value = false
      return
    }

    // Transformer les données pour inclure les tags
    items.value = data.map(item => ({
      ...item,
      tags: item.item_tag_relations?.map((rel: any) => rel.item_tags) || []
    }))
  } catch (error) {
    console.warn('Erreur lors du chargement des objets:', error)
    tablesExist.value = false
  }
}

const loadTags = async () => {
  try {
    const { data, error } = await supabase
      .from('item_tags')
      .select('*')
      .order('name')

    if (error) {
      console.warn('Erreur lors du chargement des tags (tables peut-être non créées):', error)
      tablesExist.value = false
      return
    }

    availableTags.value = data as ItemTag[]
  } catch (error) {
    console.warn('Erreur lors du chargement des tags:', error)
    tablesExist.value = false
  }
}

// Fonctions d'interaction
const applyFilters = () => {
  // Les computed se mettent à jour automatiquement
}

const addTagFilter = (tag: ItemTag) => {
  if (!activeTagFilters.value.includes(tag.id)) {
    activeTagFilters.value.push(tag.id)
  }
}

const removeTagFilter = (tagId: string) => {
  activeTagFilters.value = activeTagFilters.value.filter(id => id !== tagId)
}

const clearAllTagFilters = () => {
  activeTagFilters.value = []
}

const toggleItemExpansion = (itemId: string) => {
  if (expandedItems.value.has(itemId)) {
    expandedItems.value.delete(itemId)
  } else {
    expandedItems.value.add(itemId)
  }
}

const toggleEquip = async (item: InventoryItem) => {
  const { error } = await supabase
    .from('inventory_items')
    .update({ is_equipped: !item.is_equipped })
    .eq('id', item.id)

  if (error) {
    console.error('Erreur lors de la mise à jour:', error)
    return
  }

  item.is_equipped = !item.is_equipped
}

const editItem = (item: InventoryItem) => {
  editingItem.value = { ...item }
}

const deleteItem = async (item: InventoryItem) => {
  if (!confirm(`Êtes-vous sûr de vouloir supprimer "${item.name}" ?`)) return

  const { error } = await supabase
    .from('inventory_items')
    .delete()
    .eq('id', item.id)

  if (error) {
    console.error('Erreur lors de la suppression:', error)
    return
  }

  await loadItems()
}

const saveItem = async (itemData: Partial<InventoryItem>) => {
  try {
    if (!personnageActif.value) {
      alert('Erreur: Aucun personnage sélectionné')
      return
    }

    const isEditing = !!editingItem.value
    const itemId = editingItem.value?.id

    // Préparer les données
    const itemPayload = {
      ...itemData,
      character_id: personnageActif.value.id,
      updated_at: new Date().toISOString()
    }

    if (!isEditing) {
      itemPayload.created_at = new Date().toISOString()
    }

    // Sauvegarder l'item
    const { data: savedItem, error: itemError } = await supabase
      .from('inventory_items')
      .upsert(itemPayload)
      .select()
      .single()

    if (itemError) {
      console.error('Erreur lors de la sauvegarde:', itemError)
      alert(`Erreur lors de la sauvegarde: ${itemError.message}`)
      return
    }

    // Gérer les tags si fournis
    if (itemData.tags) {
      // Supprimer les anciennes relations
      await supabase
        .from('item_tag_relations')
        .delete()
        .eq('item_id', savedItem.id)

      // Ajouter les nouvelles relations
      if (itemData.tags.length > 0) {
        const tagRelations = itemData.tags.map((tag: ItemTag) => ({
          item_id: savedItem.id,
          tag_id: tag.id
        }))

        const { error: tagError } = await supabase
          .from('item_tag_relations')
          .insert(tagRelations)

        if (tagError) {
          console.error('Erreur lors de la sauvegarde des tags:', tagError)
          alert(`Erreur lors de la sauvegarde des tags: ${tagError.message}`)
        }
      }
    }

    await loadItems()
    closeModal()
  } catch (error) {
    console.error('Erreur inattendue:', error)
    alert('Une erreur inattendue s\'est produite')
  }
}

const closeModal = () => {
  showAddItemModal.value = false
  editingItem.value = null
}

// Lifecycle
onMounted(async () => {
  await loadTags()
  await loadItems()
})
</script>