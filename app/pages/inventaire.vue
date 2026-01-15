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
        <div class="relative z-10 p-6 px-24">
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
              <div class="flex flex-wrap gap-3 font-montserrat">
                <button
                  @click="selectedTypeFilter = ''"
                  :class="selectedTypeFilter === '' ? 'text-black font-montserrat scale-110' : 'text-black font-montserrat'"
                  class="px-3 py-1 text-sm font-medium transition-all font-sigokae"
                  :style="{ backgroundColor: '#fcd34d' , opacity: selectedTypeFilter === '' ? '1' : '0.6' }"
                >
                  Tous
                </button>
                <button
                  v-for="type in availableTypes"
                  :key="type.value"
                  @click="selectedTypeFilter = type.value"
                  :class="selectedTypeFilter === type.value ? 'text-black scale-110' : 'text-black'"
                  class="font-montserrat px-3 py-1 text-sm font-medium transition-all capitalize font-sigokae"
                  :style="{ backgroundColor: getTypeColor(type.value), opacity: selectedTypeFilter === type.value ? '1' : '0.6' }"
                >
                  {{ type.label }}
                </button>
              </div>

              <!-- Filtre par état d'équipement -->
              <div class="flex gap-2">
                <button
                  @click="selectedEquipFilter = ''"
                  :class="selectedEquipFilter === '' ? 'text-black scale-110' : 'text-black'"
                  class="font-montserrat px-3 py-1 text-sm font-medium transition-all font-sigokae"
                  :style="{ backgroundColor: '#6ee7b7' , opacity: selectedEquipFilter === '' ? '1' : '0.6' }"
                >
                  Tous
                </button>
                <button
                  @click="selectedEquipFilter = 'equipped'"
                  :class="selectedEquipFilter === 'equipped' ? 'text-black scale-110' : 'text-black'"
                  class="font-montserrat px-3 py-1 text-sm font-medium transition-all font-sigokae"
                  :style="{ backgroundColor: '#93c5fd', opacity: selectedEquipFilter === 'equipped' ? '1' : '0.6' }"
                >
                  Équipés
                </button>
                <button
                  @click="selectedEquipFilter = 'unequipped'"
                  :class="selectedEquipFilter === 'unequipped' ? 'text-black scale-110' : 'text-black'"
                  class="font-montserrat px-3 py-1 text-sm font-medium transition-all font-sigokae"
                  :style="{ backgroundColor: '#fca5a5', opacity: selectedEquipFilter === 'unequipped' ? '1' : '0.6' }"
                >
                  Non équipés
                </button>
              </div>
            </div>

            <!-- Filtres par tags -->
            <div v-if="filterableTags.length > 0" class="flex flex-wrap gap-3 font-montserrat">
              <span class="text-sm font-medium text-stone-700 self-center">Tags :</span>
              <button
                v-for="tag in filterableTags"
                :key="tag.id"
                @click="toggleTagFilter(tag.id)"
                :class="activeTagFilters.includes(tag.id) ? 'text-black scale-110 ring-2 ring-amber-500' : 'text-black'"
                class="px-3 py-1 text-sm font-medium transition-all font-sigokae"
                :style="{ backgroundColor: tag.color, opacity: activeTagFilters.includes(tag.id) ? '1' : '0.6' }"
              >
                {{ tag.name }}
              </button>
            </div>

            <!-- Barre de recherche et bouton ajout -->
            <div class="flex items-center gap-2">
              <div class="relative flex-1">
                <div class="relative rounded-xl overflow-hidden">
                  <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
                  <div class="absolute inset-0 bg-amber-50/30"></div>
                  <input
                    v-model="searchQuery"
                    @input="applyFilters"
                    type="text"
                    placeholder="🔍 Nom, description..."
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
              <BackButton @click="openCreateDrawer">
Ajouter
              </BackButton>
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
            class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-black"
            :style="{ backgroundColor: tag.color, border: `1px solid ${tag.color}` }"
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
      <div class="flex flex-row flex-wrap gap-4">
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
                class="px-2 py-1 text-xs font-medium font-montserrat"
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
      <div v-if="selectedItem || isEditingMode" class="fixed inset-0 z-50 flex">
        <!-- Overlay -->
        <div @click="closeModal" class="absolute inset-0 bg-black/30 backdrop-blur-sm"></div>
        
        <!-- Drawer panel -->
        <div class="relative ml-auto w-[60vw] h-full border-l-4 border-amber-800 bg-amber-50/70" >
          <div class="relative z-10 p-4 h-full flex flex-col pl-8">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
              <h2 class="text-xl font-bold text-black font-montserrat">
                {{ isEditingMode ? (editingItem ? 'Modifier l\'objet' : 'Nouvel objet') : selectedItem?.name }}
              </h2>
              <div class="flex gap-3">
                <template v-if="isEditingMode">
                  <button
                    type="button"
                    @click="handleSave"
                    class="px-4 py-2 bg-green-500/40 hover:bg-green-500/80 text-black font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
                  >
                    <Icon name="heroicons:check" class="w-4 h-4" />
                  </button>
                  <button
                    type="button"
                    @click="closeModal"
                    class="px-4 py-2 bg-gray-500/40 hover:bg-gray-500/80 text-black font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
                  >
                    <Icon name="heroicons:x-mark" class="w-4 h-4" />
                  </button>
                </template>
                <template v-else-if="selectedItem">
                  <button
                    type="button"
                    @click="editItem(selectedItem)"
                    class="px-4 py-2 bg-amber-500/40 hover:bg-amber-500/80 text-black font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
                  >
                    <Icon name="heroicons:pencil" class="w-4 h-4" />
                  </button>
                  <button
                    type="button"
                    @click="deleteItem(selectedItem)"
                    class="px-4 py-2 bg-red-500/40 hover:bg-red-500/80 text-black font-medium transition-colors flex items-center justify-center gap-2 font-montserrat"
                  >
                    <Icon name="heroicons:trash" class="w-4 h-4" />
                  </button>
                </template>
              </div>
            </div>

            <!-- Contenu scrollable -->
            <div class="flex-1 overflow-y-auto space-y-4 max-h-[80vh]">

              <!-- MODE ÉDITION -->
              <template v-if="isEditingMode">
                <form @submit.prevent="handleSave" class="space-y-4">
                  <!-- Nom -->
                  <div class="pb-3 border-b border-red-900">
                    <label class="block text-sm font-medium mb-2 text-black font-montserrat">Nom *</label>
                    <input
                      v-model="form.name"
                      type="text"
                      required
                      class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                      placeholder="Nom de l'objet"
                    />
                  </div>

                  <!-- Type -->
                  <div class="pb-3 border-b border-red-900">
                    <label class="block text-sm font-medium mb-2 text-black font-montserrat">Type *</label>
                    <select
                      v-model="form.type"
                      required
                      class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                    >
                      <option value="">Sélectionner un type</option>
                      <option value="weapon">Arme</option>
                      <option value="armor">Armure</option>
                      <option value="shield">Bouclier</option>
                      <option value="item">Objet</option>
                      <option value="consumable">Consommable</option>
                      <option value="tool">Outil</option>
                    </select>
                  </div>

                  <!-- Champs spécifiques selon le type -->
                  <div v-if="form.type === 'weapon'" class="pb-3 border-b border-red-900">
                    <div class="grid grid-cols-1 gap-3">
                      <div>
                        <label class="block text-sm font-medium mb-2 text-black font-montserrat">Dégâts</label>
                        <input
                          v-model="form.damage"
                          type="text"
                          class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                          placeholder="ex: 3k2, 4k3+1"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium mb-2 text-black font-montserrat">Type de dégâts</label>
                        <select
                          v-model="form.damage_type"
                          class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                        >
                          <option value="">Sélectionner</option>
                          <option value="slashing">Tranchant</option>
                          <option value="piercing">Perçant</option>
                          <option value="blunt">Contondant</option>
                          <option value="fire">Feu</option>
                          <option value="magic">Magique</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <div v-if="form.type === 'armor'" class="pb-3 border-b border-red-900">
                    <div>
                      <label class="block text-sm font-medium mb-2 text-black font-montserrat">Armure (ND)</label>
                      <input
                        v-model.number="form.armor_rating"
                        type="number"
                        min="0"
                        class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                        placeholder="ex: 4"
                      />
                    </div>
                  </div>

                  <!-- Valeur, Quantité, Poids -->
                  <div class="pb-3 border-b border-red-900">
                    <div class="grid grid-cols-3 gap-3">
                      <div>
                        <label class="block text-sm font-medium mb-2 text-black font-montserrat">Valeur (koku)</label>
                        <input
                          v-model.number="form.value"
                          type="number"
                          min="0"
                          step="0.1"
                          class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                          placeholder="0"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium mb-2 text-black font-montserrat">Quantité</label>
                        <input
                          v-model.number="form.quantity"
                          type="number"
                          min="1"
                          class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                          placeholder="1"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium mb-2 text-black font-montserrat">Poids (kg)</label>
                        <input
                          v-model.number="form.weight"
                          type="number"
                          min="0"
                          step="0.1"
                          class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                          placeholder="0"
                        />
                      </div>
                    </div>
                  </div>

                  <!-- Description -->
                  <div class="pb-3 border-b border-red-900">
                    <label class="block text-sm font-medium mb-2 text-black font-montserrat">Description</label>
                    <textarea
                      v-model="form.description"
                      rows="3"
                      class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500 bg-white font-montserrat"
                      placeholder="Description de l'objet..."
                    ></textarea>
                  </div>

                  <!-- Tags -->
                  <div>
                    <label class="block text-sm font-medium mb-2 text-black font-montserrat">Tags</label>
                    <div class="flex flex-wrap gap-2 mb-2">
                      <button
                        v-for="tag in availableTags"
                        :key="tag.id"
                        type="button"
                        @click="toggleTag(tag.id)"
                        :class="selectedTags.includes(tag.id) ? 'ring-2 ring-amber-500' : ''"
                        class="px-3 py-1 text-sm font-medium font-montserrat text-black transition-all"
                        :style="{ backgroundColor: tag.color, border: `1px solid ${tag.color}` }"
                      >
                        {{ tag.name }}
                      </button>
                    </div>
                  </div>
                </form>
              </template>

              <!-- MODE VUE DÉTAILLÉE -->
              <template v-else-if="selectedItem">
                <!-- État d'équipement -->
                <div class="pb-4 border-b border-red-900">
                  <div class="flex items-center gap-3">
                    <button
                      @click="toggleEquip(selectedItem)"
                      :class="selectedItem.is_equipped ? 'bg-green-500/30 hover:bg-green-500/80' : 'bg-stone-400/50 hover:bg-stone-500/80'"
                      class="px-4 py-2 text-black text-sm transition-colors flex items-center gap-2 font-montserrat"
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
                </div>

                <!-- Informations de base -->
                <div class="pb-4 border-b border-red-900">
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
                <div v-if="selectedItem.description" class="pb-4 border-b border-red-900">
                  <h3 class="text-lg font-semibold text-black mb-2 font-montserrat">Description</h3>
                  <p class="text-black leading-relaxed font-montserrat">{{ selectedItem.description }}</p>
                </div>

                <!-- Propriétés spécifiques -->
                <div v-if="(selectedItem.type === 'weapon' && selectedItem.damage) || (selectedItem.type === 'armor' && selectedItem.armor_rating)" class="pb-4 border-b border-red-900">
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
                </div>

                <!-- Tags -->
                <div v-if="selectedItem.tags && selectedItem.tags.length > 0">
                  <h3 class="text-lg font-semibold text-black mb-3 font-montserrat">Tags</h3>
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-for="tag in selectedItem.tags"
                      :key="tag.id"
                      class="px-3 py-1 text-sm font-medium font-montserrat text-black"
                      :style="{ backgroundColor: tag.color, border: `1px solid ${tag.color}` }"
                    >
                      {{ tag.name }}
                    </span>
                  </div>
                </div>
              </template>
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
    <!-- ItemModal supprimé - maintenant intégré dans le drawer -->
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
  is_filterable?: boolean
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
const isEditingMode = ref(false)
const form = ref({
  name: '',
  type: '',
  description: '',
  value: 0,
  damage: '',
  damage_type: '',
  armor_rating: undefined as number | undefined,
  weight: 0,
  quantity: 1
})
const selectedTags = ref<string[]>([])

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

const filterableTags = computed(() => {
  return availableTags.value.filter(tag => tag.is_filterable)
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

    let tags = data as ItemTag[]

    // Ajouter les tags par défaut s'ils n'existent pas
    const defaultTags = [
      { name: 'NÉCESSAIRE DE VOYAGE', color: '#8b5cf6', is_filterable: true },
      { name: 'Petit', color: '#6b7280', is_filterable: false },
      { name: 'Moyen', color: '#6b7280', is_filterable: false },
      { name: 'Grand', color: '#6b7280', is_filterable: false }
    ]

    for (const defaultTag of defaultTags) {
      const existingTag = tags.find(tag => tag.name === defaultTag.name)
      if (!existingTag) {
        // Insérer le tag par défaut dans la base de données
        const { data: newTag, error: insertError } = await supabase
          .from('item_tags')
          .insert({
            name: defaultTag.name,
            color: defaultTag.color,
            description: defaultTag.is_filterable ? 'Tag filtrable' : 'Tag descriptif'
          })
          .select()
          .single()

        if (!insertError && newTag) {
          tags.push({ ...newTag, is_filterable: defaultTag.is_filterable })
        }
      } else {
        // Mettre à jour la propriété is_filterable
        existingTag.is_filterable = defaultTag.is_filterable
      }
    }

    // Trier les tags selon l'ordre spécifié
    const tagOrder = ['Commun', 'Rare', 'Petit', 'Moyen', 'Grand', 'Magique', 'Consommable', 'Outil', 'Nécessaire de voyage']
    tags.sort((a, b) => {
      const indexA = tagOrder.indexOf(a.name)
      const indexB = tagOrder.indexOf(b.name)
      
      // Si les deux tags sont dans la liste d'ordre, trier selon l'ordre
      if (indexA !== -1 && indexB !== -1) {
        return indexA - indexB
      }
      
      // Si seulement un est dans la liste, le mettre en premier
      if (indexA !== -1) return -1
      if (indexB !== -1) return 1
      
      // Sinon, trier alphabétiquement
      return a.name.localeCompare(b.name)
    })

    availableTags.value = tags
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

const toggleTagFilter = (tagId: string) => {
  if (activeTagFilters.value.includes(tagId)) {
    removeTagFilter(tagId)
  } else {
    const tag = availableTags.value.find(t => t.id === tagId)
    if (tag) {
      addTagFilter(tag)
    }
  }
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

const openCreateDrawer = () => {
  editingItem.value = null
  selectedItem.value = null
  isEditingMode.value = true
  // Initialiser le formulaire pour création
  form.value = {
    name: '',
    type: '',
    description: '',
    value: 0,
    damage: '',
    damage_type: '',
    armor_rating: undefined,
    weight: 0,
    quantity: 1
  }
  selectedTags.value = []
}

const editItem = (item: InventoryItem) => {
  editingItem.value = { ...item }
  selectedItem.value = item
  isEditingMode.value = true
  // Initialiser le formulaire avec les données de l'item
  form.value = {
    name: item.name,
    type: item.type,
    description: item.description || '',
    value: item.value,
    damage: item.damage || '',
    damage_type: item.damage_type || '',
    armor_rating: item.armor_rating || undefined,
    weight: item.weight,
    quantity: item.quantity
  }
  selectedTags.value = item.tags?.map(tag => tag.id) || []
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
    // Ne pas fermer le drawer, juste repasser en mode non-édition
    isEditingMode.value = false
    editingItem.value = null
    // Recharger l'item sélectionné pour afficher les changements
    if (selectedItem.value && selectedItem.value.id === savedItem.id) {
      selectedItem.value = savedItem
      // Recharger les tags de l'item
      const updatedItem = await loadItems()
      const foundItem = items.value.find(item => item.id === savedItem.id)
      if (foundItem) {
        selectedItem.value = foundItem
      }
    }
  } catch (error) {
    console.error('Erreur inattendue:', error)
    alert('Une erreur inattendue s\'est produite')
  }
}

const toggleTag = (tagId: string) => {
  const index = selectedTags.value.indexOf(tagId)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    selectedTags.value.push(tagId)
  }
}

const handleSave = async () => {
  const itemData = {
    ...form.value,
    tags: availableTags.value.filter(tag => selectedTags.value.includes(tag.id))
  }
  await saveItem(itemData)
}

const closeModal = () => {
  showAddItemModal.value = false
  editingItem.value = null
  isEditingMode.value = false
  selectedItem.value = null
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