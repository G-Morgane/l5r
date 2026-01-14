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
        src="/fond_long.png"
        alt="Japanese room background"
        class="w-full h-auto"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- PersonnageHeader -->
      <PersonnageHeader
        :personnage="personnageActif || {}"
        @deselect="changeCharacter()"
        class="mb-6"
      />

      <!-- Contenu principal -->
      <div class="max-h-[80vh] relative overflow-y-auto">
        <div class="relative z-10 p-6">
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
          <div class="flex flex-col gap-3 mb-4">

            <!-- Filtres - Types à gauche, Équipement à droite -->
            <div class="flex justify-between items-center font-montserrat">
              <!-- Filtrage par type avec tags -->
              <div class="flex flex-wrap gap-1 font-montserrat">
                <button
                  @click="selectedTypeFilter = ''"
                  :class="selectedTypeFilter === '' ? 'text-black font-montserrat' : 'bg-gray-200 text-gray-700 font-montserrat'"
                  class="px-3 py-1 rounded text-sm font-medium transition-colors font-sigokae"
                  :style="{ backgroundColor: selectedTypeFilter === '' ? '#fcd34d' : undefined }"
                >
                  Tous
                </button>
                <button
                  v-for="type in availableTypes"
                  :key="type.value"
                  @click="selectedTypeFilter = type.value"
                  :class="selectedTypeFilter === type.value ? 'text-black' : 'bg-gray-200 text-gray-700'"
                  class="font-montserrat px-3 py-1 rounded text-sm font-medium transition-colors capitalize font-sigokae"
                  :style="{ backgroundColor: selectedTypeFilter === type.value ? getTypeColor(type.value) : undefined }"
                >
                  {{ type.label }}
                </button>
              </div>

              <!-- Filtre par état d'équipement -->
              <div class="flex gap-2">
                <button
                  @click="selectedEquipFilter = ''"
                  :class="selectedEquipFilter === '' ? 'text-black' : 'bg-gray-200 text-gray-700'"
                  class="font-montserrat px-3 py-1 rounded text-sm font-medium transition-colors font-sigokae"
                  :style="{ backgroundColor: selectedEquipFilter === '' ? '#6ee7b7' : undefined }"
                >
                  Tous
                </button>
                <button
                  @click="selectedEquipFilter = 'equipped'"
                  :class="selectedEquipFilter === 'equipped' ? 'text-black' : 'bg-gray-200 text-gray-700'"
                  class="font-montserrat px-3 py-1 rounded text-sm font-medium transition-colors font-sigokae"
                  :style="{ backgroundColor: selectedEquipFilter === 'equipped' ? '#93c5fd' : undefined }"
                >
                  Équipés
                </button>
                <button
                  @click="selectedEquipFilter = 'unequipped'"
                  :class="selectedEquipFilter === 'unequipped' ? 'text-black' : 'bg-gray-200 text-gray-700'"
                  class="font-montserrat px-3 py-1 rounded text-sm font-medium transition-colors font-sigokae"
                  :style="{ backgroundColor: selectedEquipFilter === 'unequipped' ? '#fca5a5' : undefined }"
                >
                  Non équipés
                </button>
              </div>
            </div>

            <!-- Barre de recherche et bouton ajout -->
            <div class="flex items-center gap-2">
              <button
                @click="showAddItemModal = true"
                class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-lg font-medium transition-colors flex items-center gap-2 font-sigokae"
              >
                <Icon name="heroicons:plus" class="w-5 h-5" />
                Ajouter
              </button>
              <input
                v-model="searchQuery"
                @input="applyFilters"
                type="text"
                placeholder="Nom, description..."
                class="flex-1 px-3 py-2 border border-stone-300 rounded-md bg-white text-stone-900 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 font-sigokae"
              />
            </div>
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
      <div class="grid grid-cols-4">
        <div
          v-for="item in filteredItems"
          :key="item.id"
          class="rounded-lg overflow-hidden"
          style="width: 170px; height: 170px; background-image: url('/square.png'); background-size: cover; background-position: center; background-repeat: no-repeat;"
        >
          <!-- Ligne principale -->
          <div
            @click="openItemDrawer(item)"
            class="p-4 cursor-pointer transition-all hover:scale-105 flex flex-col items-center justify-center h-full"
          >
            <div class="flex items-center gap-2 mb-2">
              <h3 class="text-lg font-semibold text-black font-montserrat">{{ item.name }}</h3>
              <Icon :name="item.is_equipped ? 'heroicons:check-circle' : 'heroicons:minus-circle'"
                    :class="item.is_equipped ? 'text-green-600' : 'text-gray-600'"
                    class="w-5 h-5" />
            </div>
            <div class="flex items-center gap-2 mb-2">
              <span
                class="px-2 py-1 rounded-full text-xs font-medium font-montserrat"
                :style="{ backgroundColor: getTypeColor(item.type), color: '#374151' }"
              >
                {{ translateType(item.type) }}
              </span>
               <div v-if="item.type === 'weapon' && item.damage" class="text-center">
              <span class="text-sm font-semibold text-red-600 font-montserrat">{{ item.damage }}</span>
              <span v-if="item.damage_type" class="text-xs text-red-500 font-montserrat ml-1">({{ translateDamageType(item.damage_type) }})</span>
            </div>
            </div>
                          <span class="text-sm text-black font-montserrat">{{ item.value }} koku</span>

           
          </div>

        </div>
      </div>

      <!-- Drawer pour les détails d'objet -->
      <div v-if="selectedItem" class="fixed inset-0 z-50 flex">
        <!-- Overlay -->
        <div @click="closeItemDrawer" class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>
        
        <!-- Drawer panel -->
        <div class="relative ml-auto w-full max-w-md h-full" style="background-image: url('/drawer.png'); background-size: 100% 100%; background-position: center; background-repeat: no-repeat;">
          <div class="relative z-10 p-6 h-full flex flex-col mt-24 pl-12">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
              <h2 class="text-xl font-bold text-black font-montserrat">{{ selectedItem.name }}</h2>
              <button @click="closeItemDrawer" class="p-2 text-black hover:text-gray-700 transition-colors">
                <Icon name="heroicons:x-mark" class="w-6 h-6" />
              </button>
            </div>

            <!-- Contenu scrollable -->
            <div class="flex-1 overflow-y-auto space-y-6 max-h-[62vh] ">
              <!-- État d'équipement -->
              <div class="flex items-center gap-3">
                <button
                  @click="toggleEquip(selectedItem)"
                  :class="selectedItem.is_equipped ? 'bg-green-500 hover:bg-green-600' : 'bg-stone-400 hover:bg-stone-500'"
                  class="px-4 py-2 text-black text-sm rounded-lg transition-colors flex items-center gap-2 font-montserrat"
                >
                  <Icon :name="selectedItem.is_equipped ? 'heroicons:check' : 'heroicons:plus'" class="w-4 h-4" />
                  {{ selectedItem.is_equipped ? 'Déséquiper' : 'Équiper' }}
                </button>
                <div class="flex items-center gap-2">
                  <Icon :name="selectedItem.is_equipped ? 'heroicons:check-circle' : 'heroicons:minus-circle'"
                        :class="selectedItem.is_equipped ? 'text-green-600' : 'text-gray-600'"
                        class="w-5 h-5" />
                  <span class="text-sm text-black font-montserrat">
                    {{ selectedItem.is_equipped ? 'Équipé' : 'Non équipé' }}
                  </span>
                </div>
              </div>

              <!-- Informations de base -->
              <div class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <span class="text-sm font-semibold text-black font-montserrat">Type</span>
                    <p class="text-black capitalize font-montserrat">{{ translateType(selectedItem.type) }}</p>
                  </div>
                  <div>
                    <span class="text-sm font-semibold text-black font-montserrat">Valeur</span>
                    <p class="text-black font-montserrat">{{ selectedItem.value }} koku</p>
                  </div>
                  <div v-if="selectedItem.quantity > 1">
                    <span class="text-sm font-semibold text-black font-montserrat">Quantité</span>
                    <p class="text-black font-montserrat">{{ selectedItem.quantity }}</p>
                  </div>
                  <div v-if="selectedItem.weight > 0">
                    <span class="text-sm font-semibold text-black font-montserrat">Poids</span>
                    <p class="text-black font-montserrat">{{ selectedItem.weight }} kg</p>
                  </div>
                </div>
              </div>

              <!-- Description -->
              <div v-if="selectedItem.description">
                <h3 class="text-lg font-semibold text-black mb-2 font-montserrat">Description</h3>
                <p class="text-black leading-relaxed font-montserrat">{{ selectedItem.description }}</p>
              </div>

              <!-- Propriétés spécifiques -->
              <div class="space-y-3">
                <div v-if="selectedItem.type === 'weapon' && selectedItem.damage" class="flex items-center gap-3">
                  <Icon name="heroicons:bolt" class="w-5 h-5 text-red-600" />
                  <div>
                    <span class="text-sm font-semibold text-black font-montserrat">Dégâts</span>
                    <p class="text-black font-montserrat">{{ selectedItem.damage }}
                      <span v-if="selectedItem.damage_type" class="text-black font-montserrat">({{ translateDamageType(selectedItem.damage_type) }})</span>
                    </p>
                  </div>
                </div>

                <div v-if="selectedItem.type === 'armor' && selectedItem.armor_rating" class="flex items-center gap-3">
                  <Icon name="heroicons:shield-check" class="w-5 h-5 text-blue-600" />
                  <div>
                    <span class="text-sm font-semibold text-black font-montserrat">Armure</span>
                    <p class="text-black font-montserrat">{{ selectedItem.armor_rating }}</p>
                  </div>
                </div>
              </div>

              <!-- Tags -->
              <div v-if="selectedItem.tags && selectedItem.tags.length > 0">
                <h3 class="text-lg font-semibold text-black mb-3 font-montserrat">Tags</h3>
                <div class="flex flex-wrap gap-2">
                  <span
                    v-for="tag in selectedItem.tags"
                    :key="tag.id"
                    class="px-3 py-1 rounded-full text-sm font-medium font-montserrat"
                    :style="{ backgroundColor: tag.color + '40', color: 'black', border: `1px solid ${tag.color}` }"
                  >
                    {{ tag.name }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Actions du bas -->
            <div class="mt-6 pl-36 flex gap-3">
              <button
                @click="editItem(selectedItem)"
                class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-black rounded-lg font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
              >
                <Icon name="heroicons:pencil" class="w-4 h-4" />
                            </button>
              <button
                @click="deleteItem(selectedItem)"
                class="px-4 py-2 bg-red-600 hover:bg-red-700 text-black rounded-lg font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
              >
                <Icon name="heroicons:trash" class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Message si aucun objet -->
      <div v-if="filteredItems.length === 0" class="text-center py-12">
        <Icon name="heroicons:backpack" class="w-16 h-16 text-stone-200 mx-auto mb-4" />
        <h3 class="text-lg font-medium text-stone-200 mb-2">Aucun objet trouvé</h3>
        <p class="text-stone-300">
          {{ searchQuery || selectedTypeFilter || activeTags.length > 0
             ? 'Essayez de modifier vos filtres de recherche'
             : 'Commencez par ajouter votre premier objet à l\'inventaire' }}
        </p>
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
const selectedEquipFilter = ref('')
const activeTagFilters = ref<string[]>([])
const expandedItems = ref<Set<string>>(new Set())
const tablesExist = ref(true)
const selectedItem = ref<InventoryItem | null>(null)

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

  // Filtre par état d'équipement
  if (selectedEquipFilter.value) {
    if (selectedEquipFilter.value === 'equipped') {
      filtered = filtered.filter(item => item.is_equipped)
    } else if (selectedEquipFilter.value === 'unequipped') {
      filtered = filtered.filter(item => !item.is_equipped)
    }
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

const getTypeColor = (type: string) => {
  const colors: Record<string, string> = {
    weapon: '#fca5a5',      // red-300 - rouge pastel
    armor: '#93c5fd',       // blue-300 - bleu pastel
    shield: '#6ee7b7',      // emerald-300 - vert pastel
    item: '#d1d5db',        // gray-300 - gris pastel
    consumable: '#c4b5fd',  // violet-300 - violet pastel
    tool: '#fcd34d'         // amber-300 - jaune pastel
  }
  return colors[type] || '#d1d5db'
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

const openItemDrawer = (item: InventoryItem) => {
  selectedItem.value = item
}

const closeItemDrawer = () => {
  selectedItem.value = null
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
  
  // Mettre à jour l'item sélectionné si c'est le même
  if (selectedItem.value && selectedItem.value.id === item.id) {
    selectedItem.value.is_equipped = item.is_equipped
  }
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
  
  // Fermer le drawer si c'était l'item supprimé
  if (selectedItem.value && selectedItem.value.id === item.id) {
    closeItemDrawer()
  }
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

    if (isEditing && itemId) {
      itemPayload.id = itemId
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
    
    // Fermer le drawer si c'était l'item modifié
    if (selectedItem.value && selectedItem.value.id === savedItem.id) {
      closeItemDrawer()
    }
  } catch (error) {
    console.error('Erreur inattendue:', error)
    alert('Une erreur inattendue s\'est produite')
  }
}

const closeModal = () => {
  showAddItemModal.value = false
  editingItem.value = null
}

const changeCharacter = () => {
  personnageActif.value = null
  navigateTo('/')
}

// Lifecycle
onMounted(async () => {
  await loadTags()
  await loadItems()
})
</script>