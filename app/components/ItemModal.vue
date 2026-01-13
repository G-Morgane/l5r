<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 font-montserrat" @click.self="$emit('close')">
    <div class="bg-white p-6 rounded-lg shadow-lg max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
      <h3 class="text-xl font-bold mb-6 text-stone-800">
        {{ item ? 'Modifier l\'objet' : 'Ajouter un objet' }}
      </h3>

      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Nom -->
        <div>
          <label class="block text-sm font-medium mb-2 text-stone-700">Nom *</label>
          <input
            v-model="form.name"
            type="text"
            required
            class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
            placeholder="Nom de l'objet"
          />
        </div>

        <!-- Type -->
        <div>
          <label class="block text-sm font-medium mb-2 text-stone-700">Type *</label>
          <select
            v-model="form.type"
            required
            class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
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
        <div v-if="form.type === 'weapon'" class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Dégâts</label>
            <input
              v-model="form.damage"
              type="text"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
              placeholder="ex: 3k2, 4k3+1"
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Type de dégâts</label>
            <select
              v-model="form.damage_type"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
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

        <div v-if="form.type === 'armor'">
          <label class="block text-sm font-medium mb-2 text-stone-700">Rating d'armure</label>
          <input
            v-model.number="form.armor_rating"
            type="number"
            min="0"
            class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
            placeholder="ex: 5"
          />
        </div>

        <!-- Valeur et poids -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Valeur (koku)</label>
            <input
              v-model.number="form.value"
              type="number"
              min="0"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
              placeholder="0"
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Poids (kg)</label>
            <input
              v-model.number="form.weight"
              type="number"
              min="0"
              step="0.1"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
              placeholder="0.0"
            />
          </div>
        </div>

        <!-- Quantité et rareté -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Quantité</label>
            <input
              v-model.number="form.quantity"
              type="number"
              min="1"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
              placeholder="1"
            />
          </div>
          <div>
            <label class="block text-sm font-medium mb-2 text-stone-700">Rareté</label>
            <select
              v-model="form.rarity"
              class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
            >
              <option value="common">Commun</option>
              <option value="uncommon">Peu commun</option>
              <option value="rare">Rare</option>
              <option value="legendary">Légendaire</option>
            </select>
          </div>
        </div>

        <!-- Description -->
        <div>
          <label class="block text-sm font-medium mb-2 text-stone-700">Description</label>
          <textarea
            v-model="form.description"
            rows="3"
            class="w-full px-3 py-2 border border-stone-300 rounded-md focus:outline-none focus:ring-2 focus:ring-amber-500"
            placeholder="Description de l'objet..."
          ></textarea>
        </div>

        <!-- Tags -->
        <div>
          <label class="block text-sm font-medium mb-2 text-stone-700">Tags</label>
          <div class="flex flex-wrap gap-2 mb-3">
            <button
              v-for="tag in availableTags"
              :key="tag.id"
              @click="toggleTag(tag)"
              type="button"
              class="px-3 py-1 rounded-full text-sm font-medium transition-colors"
              :class="selectedTags.includes(tag.id) ? 'ring-2 ring-offset-1' : 'hover:opacity-80'"
              :style="{
                backgroundColor: tag.color + '20',
                color: tag.color,
                border: `1px solid ${tag.color}`,
                '--tw-ring-color': tag.color
              }"
            >
              {{ tag.name }}
            </button>
          </div>
          <div v-if="selectedTags.length > 0" class="text-sm text-stone-600">
            Tags sélectionnés: {{ selectedTags.length }}
          </div>
        </div>

        <!-- Équipé -->
        <div class="flex items-center">
          <input
            v-model="form.is_equipped"
            type="checkbox"
            class="h-4 w-4 text-amber-600 focus:ring-amber-500 border-stone-300 rounded"
          />
          <label class="ml-2 text-sm text-stone-700">Équipé</label>
        </div>

        <!-- Actions -->
        <div class="flex justify-end gap-3 pt-4 border-t border-stone-200">
          <button
            type="button"
            @click="$emit('close')"
            class="px-4 py-2 text-stone-600 hover:text-stone-800 transition-colors"
          >
            Annuler
          </button>
          <button
            type="submit"
            class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-md font-medium transition-colors"
          >
            {{ item ? 'Modifier' : 'Ajouter' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

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

interface Props {
  item?: InventoryItem | null
  availableTags: ItemTag[]
}

const props = defineProps<Props>()
const emit = defineEmits<{
  save: [item: Partial<InventoryItem>]
  close: []
}>()

// État du formulaire
const form = ref({
  name: '',
  type: '',
  description: '',
  value: 0,
  damage: '',
  damage_type: '',
  armor_rating: 0,
  weight: 0,
  rarity: 'common',
  is_equipped: false,
  quantity: 1
})

const selectedTags = ref<string[]>([])

// Fonctions utilitaires
const resetForm = () => {
  form.value = {
    name: '',
    type: '',
    description: '',
    value: 0,
    damage: '',
    damage_type: '',
    armor_rating: 0,
    weight: 0,
    rarity: 'common',
    is_equipped: false,
    quantity: 1
  }
  selectedTags.value = []
}

// Réinitialiser le formulaire quand l'item change
watch(() => props.item, (newItem) => {
  if (newItem) {
    form.value = {
      name: newItem.name || '',
      type: newItem.type || '',
      description: newItem.description || '',
      value: newItem.value || 0,
      damage: newItem.damage || '',
      damage_type: newItem.damage_type || '',
      armor_rating: newItem.armor_rating || 0,
      weight: newItem.weight || 0,
      rarity: newItem.rarity || 'common',
      is_equipped: newItem.is_equipped || false,
      quantity: newItem.quantity || 1
    }
    selectedTags.value = newItem.tags?.map(tag => tag.id) || []
  } else {
    resetForm()
  }
}, { immediate: true })

const toggleTag = (tag: ItemTag) => {
  const index = selectedTags.value.indexOf(tag.id)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    selectedTags.value.push(tag.id)
  }
}

const handleSubmit = () => {
  const selectedTagObjects = props.availableTags.filter(tag =>
    selectedTags.value.includes(tag.id)
  )

  const itemData: Partial<InventoryItem> = {
    ...form.value,
    tags: selectedTagObjects
  }

  emit('save', itemData)
}
</script>