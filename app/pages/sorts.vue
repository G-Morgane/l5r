<template>
  <PageWrapper :loading="loading" loading-message="Chargement des sorts...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

      <div class="flex flex-col mt-12">
        <!-- Barre de navigation des cercles -->
        <div class="mb-8 flex items-center justify-between px-4">
          <div class="flex items-center gap-4">
            <div class="flex gap-4">
              <div
                v-for="cercle in ['Eau', 'Feu', 'Terre', 'Air', 'Vide', 'Universel']"
                :key="cercle"
                @click="selectionnerCercle(cercle)"
                class="cursor-pointer transition-all duration-300 rounded-lg overflow-hidden"
                :class="cercleSelectionne === cercle ? 'scale-130' : 'hover:scale-105'"
              >
                <img
                  :src="`/${cercle.toLowerCase()}.png`"
                  :alt="`Cercle ${cercle}`"
                  class="w-18 h-18 object-cover"
                />
              </div>
            </div>
          </div>

          <!-- Toggle Mes sorts / Tous les sorts -->
          <div class="flex items-center gap-3 bg-amber-50/30 px-4 py-2 border-4 border-amber-800">
            <span class="text-sm font-montserrat text-stone-700">Tous les sorts</span>
            <label class="switch flex items-center">
              <input type="checkbox" v-model="afficherMesSorts">
              <span class="slider"></span>
            </label>
            <span class="text-sm font-montserrat text-stone-700">Mes sorts</span>
          </div>
        </div>

        <!-- Liste des sorts du cercle sélectionné -->
        <div class="flex flex-col items-center">

          <!-- Liste des sorts -->
          <div v-if="sortsFiltrees.length === 0" class="text-center py-12">
            <div class=" p-8 border-4 border-amber-800 relative overflow-hidden bg-amber-50/80">
              <div class="relative z-10">
                <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">
                  {{ afficherMesSorts ? 'Aucun sort appris' : 'Aucun sort disponible' }}
                </p>
                <p class="text-stone-600 font-montserrat">
                  {{ afficherMesSorts ? 'Vous n\'avez pas encore appris de sorts de ce cercle' : 'Les sorts de ce cercle seront bientôt ajoutés' }}
                </p>
              </div>
            </div>
          </div>

          <div v-else class="max-h-[80vh] overflow-y-auto">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 w-full max-w-6xl pr-4">
            <div
              v-for="sort in sortsFiltrees"
              :key="sort.id"
              class="relative px-4 py-4 border-4 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:pointer-events-none cursor-pointer transition-all"
              :class="sortEstAppris(sort.id) ? 'border-green-800 before:border-green-900' : 'border-amber-800 before:border-amber-900'"
              @click="selectionnerSort(sort)"
            >
              <div class="relative z-10 flex flex-col h-full justify-between">
                <div class="flex items-center justify-between mb-4">
                  <h3 class="text-lg font-bold text-stone-900 font-manga">{{ sort.nom }}</h3>
                  <span class="px-3 py-1 text-xs font-medium font-montserrat text-black" :style="{ backgroundColor: '#EFB6A6', textWrap: 'nowrap' }">
                    Rang {{ sort.rang }}
                  </span>
                </div>
                                <!-- Encart Jet d'incantation -->
                <div class="mb-3 p-3 bg-purple-200/50">
                  <div class="flex justify-between items-center text-xs font-montserrat">
                    <div>
                      <span class="font-semibold text-stone-800">🎲</span>
                      <span class="text-stone-900 ml-1">{{ calculerJetIncantation(sort) }}</span>
                    </div>
                    <div>
                      <span class="font-semibold text-stone-800">🎯</span>
                      <span class="text-stone-900 ml-1">{{ calculerND(sort) }}</span>
                    </div>
                  </div>
                </div>

                <div class="space-y-3 text-xs text-stone-700 font-montserrat">
                    <div class="flex flex-row gap-12">
                  <div v-if="sort.portee" class="flex flex-col">
                    <span class="font-semibold text-stone-800">Portée:</span>
                    <span class="w-full text-stone-900 font-montserrat text-xs">{{ sort.portee }}</span>
                  </div>                  
                  <div v-if="sort.duree" class="flex  flex-col">
                    <span class="font-semibold text-stone-800">Durée:</span>
                    <span class="w-full text-stone-900 font-montserrat text-xs">{{ sort.duree }}</span>
                  </div>
                  </div>
                  <div v-if="sort.zone_effet" class="flex flex-col">
                    <span class="font-semibold text-stone-800">Zone:</span>
                    <span class="w-full text-stone-900 font-montserrat text-xs">{{ sort.zone_effet }}</span>
                  </div>

                  <div v-if="sort.degats_soin" class="flex justify-between items-center">
                    <span class="font-semibold text-stone-800">Dégâts/Soins:</span>
                    <span class="w-full text-stone-900 font-montserrat text-xs">{{ sort.degats_soin }}</span>
                  </div>
                  <div v-if="sort.effet_augmentation" class="flex flex-col">
                    <span class="font-semibold text-stone-800 flex items-center gap-2">
                      Augmentation:
                      <span v-if="personnageActif.nom === 'Shiba Shizuku' && sort.cercle.toLowerCase() === 'eau'" class="text-xs text-green-700 font-bold px-2 py-1 ">
                        +2 gratuites
                      </span>
                    </span>
                    <span class="w-full text-stone-900 font-montserrat text-xs">{{ sort.effet_augmentation }}</span>
                  </div>
                </div>

                <div v-if="sort.description" class="mt-4 text-stone-600 text-xs line-clamp-2 font-montserrat">
                  {{ sort.description }}
                </div>


                <!-- Tags -->
                <div v-if="sort.mot_cle && sort.mot_cle.length > 0" class="mt-4">
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-for="tag in sort.mot_cle.filter(tag => tag && tag.toLowerCase() !== cercleSelectionne.toLowerCase())"
                      :key="tag"
                      class="px-3 py-1 text-xs font-medium font-montserrat text-black"
                      :style="{ backgroundColor: getTagInfo(tag).color }"
                    >
                      {{ getTagInfo(tag).name }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Drawer pour les détails du sort -->
    <div v-if="sortSelectionne" class="fixed inset-0 z-50 flex">
      <!-- Overlay -->
      <div @click="sortSelectionne = null" class="absolute inset-0 bg-black/30 backdrop-blur-sm"></div>

      <!-- Drawer Panel -->
      <div class="relative ml-auto w-[70vw] h-full border-l-4 border-amber-800 bg-gradient-to-br from-amber-50/95 to-amber-100/95 backdrop-blur-md">
        <div class="relative z-10 p-4 h-full flex flex-col pl-8">
          <!-- Header avec titre et actions -->
          <div class="flex items-start justify-between mb-8 pb-4 border-b-2 border-amber-800/30">
            <div class="flex items-center gap-4">
              <div class="w-16 h-16 rounded-full bg-amber-200/50 flex items-center justify-center overflow-hidden">
                <img
                  :src="`/${sortSelectionne.cercle.toLowerCase()}.png`"
                  :alt="`Cercle ${sortSelectionne.cercle}`"
                  class="w-full h-full object-cover"
                />
              </div>
              <div>
                <h1 class="text-xl font-bold text-stone-900 font-manga">{{ sortSelectionne.nom }}</h1>
                <p class="text-stone-600 font-montserrat text-sm">{{ sortSelectionne.cercle }} • Rang {{ sortSelectionne.rang }}</p>
              </div>
            </div>

            <div class="flex items-center gap-3">
              <!-- Bouton modifier -->
              <button
                @click="modeEdition ? annulerModifications() : entrerModeEdition()"
                class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium transition-colors flex items-center justify-center gap-2 font-montserrat rounded-lg shadow-md"
                :class="modeEdition ? 'bg-amber-700' : ''"
              >
                ✏️ {{ modeEdition ? 'Annuler' : 'Modifier' }}
              </button>

              <!-- Bouton fermer -->
              <button
                @click="sortSelectionne = null"
                class="px-4 py-2 bg-gray-500/40 hover:bg-gray-500/80 text-black font-medium transition-colors flex items-center justify-center gap-2 font-montserrat text-xl rounded-lg shadow-md"
              >
                ×
              </button>
            </div>
          </div>

          <!-- Contenu principal -->
          <div class="flex-1 overflow-y-auto">
            <div class="space-y-8">
              <!-- Section Statistiques -->
              <div>
                <h3 class="text-sm font-bold text-stone-800 font-montserrat mb-4 flex items-center gap-2">
                  📊 Statistiques du sort
                  <div class="flex-1 h-px bg-amber-800/30 ml-4"></div>
                </h3>

                <div class="flex flex-row gap-8">
                  <div v-if="sortSelectionne.portee">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-1">Portée</div>
                    <div v-if="!modeEdition" class="text-stone-900 font-montserrat text-base">{{ sortSelectionne.portee }}</div>
                    <input v-else v-model="sortSelectionne.portee" class="w-full text-stone-900 font-montserrat text-xs">
                  </div>

                  <div v-if="sortSelectionne.zone_effet">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-1">Zone d'effet</div>
                    <div v-if="!modeEdition" class="text-stone-900 font-montserrat text-base">{{ sortSelectionne.zone_effet }}</div>
                    <input v-else v-model="sortSelectionne.zone_effet" class="w-full text-stone-900 font-montserrat text-xs">
                  </div>

                  <div v-if="sortSelectionne.duree">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-1">Durée</div>
                    <div v-if="!modeEdition" class="text-stone-900 font-montserrat text-base">{{ sortSelectionne.duree }}</div>
                    <input v-else v-model="sortSelectionne.duree" class="w-full text-stone-900 font-montserrat text-xs">
                  </div>

                  <div v-if="sortSelectionne.degats_soin">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-1">Dégâts/Soins</div>
                    <div v-if="!modeEdition" class="text-stone-900 font-montserrat text-base">{{ sortSelectionne.degats_soin }}</div>
                    <input v-else v-model="sortSelectionne.degats_soin" class="w-full text-stone-900 font-montserrat text-xs">
                  </div>
                </div>

                <!-- Encart Jet d'incantation -->
                <div class="mt-6 p-4 bg-amber-100/50 border border-amber-800/30 rounded-lg">
                  <div class="mb-3">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-2">🎲 Jet d'incantation</div>
                    <div v-if="sortSelectionne.cercle.toLowerCase() === 'universel'" class="space-y-1">
                      <div v-for="jet in calculerJetIncantation(sortSelectionne).split(' | ')" :key="jet" class="text-stone-900 font-montserrat text-sm">
                        {{ jet }}
                      </div>
                    </div>
                    <div v-else class="text-stone-900 font-montserrat text-lg font-bold">
                      {{ calculerJetIncantation(sortSelectionne) }}
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="text-xs font-semibold text-stone-600 font-montserrat uppercase tracking-wide mb-1">🎯 Niveau de difficulté</div>
                    <div class="text-stone-900 font-montserrat text-lg font-bold">{{ calculerND(sortSelectionne) }}</div>
                  </div>
                  <div class="text-xs text-stone-700 font-montserrat">
                    <p v-if="sortSelectionne.cercle.toLowerCase() === 'universel'">
                      <strong>Sort universel :</strong> Choisissez le cercle à utiliser pour lancer le sort
                    </p>
                    <p v-else><strong>Calcul du jet :</strong> Anneau d'élément + Rang de maîtrise effectif</p>
                    <p><strong>ND :</strong> 5 × Rang du sort</p>
                    <p v-if="personnageActif.nom === 'Shiba Shizuku' && sortSelectionne.cercle.toLowerCase() === 'eau'"><em>✨ Affinité Eau (+1 rang)</em></p>
                  </div>
                </div>
              </div>
              <div v-if="sortSelectionne.effet_augmentation">
                <h3 class="text-sm font-bold text-stone-800 font-montserrat mb-4 flex items-center gap-2">
                  ⚡ Effet d'augmentation
                  <span v-if="personnageActif.nom === 'Shiba Shizuku' && sortSelectionne.cercle.toLowerCase() === 'eau'" class="text-xs text-green-700 font-bold bg-green-100 px-2 py-1 rounded ml-2">
                    +2 gratuites
                  </span>
                  <div class="flex-1 h-px bg-amber-800/30 ml-4"></div>
                </h3>

                <div v-if="!modeEdition" class="text-stone-900 font-montserrat leading-relaxed text-justify text-sm">
                  {{ sortSelectionne.effet_augmentation }}
                </div>
                <textarea v-else v-model="sortSelectionne.effet_augmentation" rows="3" class="w-full bg-white rounded px-3 py-2 text-stone-900 font-montserrat resize-none text-sm"></textarea>
              </div>
              <!-- Section Tags -->
              <div v-if="sortSelectionne.mot_cle && sortSelectionne.mot_cle.length > 0">
                <h3 class="text-sm font-bold text-stone-800 font-montserrat mb-4 flex items-center gap-2">
                  🏷️ Catégories
                  <div class="flex-1 h-px bg-amber-800/30 ml-4"></div>
                </h3>

                <div v-if="!modeEdition" class="flex flex-wrap gap-3">
                  <span
                    v-for="tag in sortSelectionne.mot_cle"
                    :key="tag"
                    class="px-2 py-1 text-xs font-montserrat text-black"
                    :style="{ backgroundColor: getTagInfo(tag).color }"
                  >
                    {{ getTagInfo(tag).name }}
                  </span>
                </div>

                <!-- Interface d'édition des tags -->
                <div v-else class="space-y-4">
                  <!-- Tags actuels avec bouton de suppression -->
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-for="(tag, index) in sortSelectionne.mot_cle"
                      :key="tag"
                      class="inline-flex items-center gap-2 px-3 py-1 text-sm font-medium font-montserrat text-black rounded-full border-2 border-amber-800/20"
                      :style="{ backgroundColor: getTagInfo(tag).color }"
                    >
                      {{ getTagInfo(tag).name }}
                      <button
                        @click="supprimerTag(index)"
                        class="ml-1 text-red-600 hover:text-red-800 font-bold"
                        title="Supprimer ce tag"
                      >
                        ×
                      </button>
                    </span>
                  </div>

                  <!-- Ajouter un nouveau tag -->
                  <div class="flex gap-2">
                    <select
                      v-model="nouveauTag"
                      class="flex-1 bg-white rounded px-3 py-2 text-stone-900 font-montserrat text-sm border border-amber-800"
                    >
                      <option value="">Sélectionner un tag...</option>
                      <option v-for="tagKey in Object.keys(tagMapping)" :key="tagKey" :value="tagKey">
                        {{ tagMapping[tagKey].name }}
                      </option>
                    </select>
                    <button
                      @click="ajouterTag"
                      :disabled="!nouveauTag"
                      class="px-4 py-2 bg-amber-600 hover:bg-amber-700 disabled:bg-gray-400 text-white font-montserrat font-medium rounded text-sm transition-colors"
                    >
                      ➕ Ajouter
                    </button>
                  </div>
                </div>
              </div>

              <!-- Section Description -->
              <div v-if="sortSelectionne.description" >
                <h3 class="text-sm font-bold text-stone-800 font-montserrat mb-4 flex items-center gap-2">
                  📖 Description
                  <div class="flex-1 h-px bg-amber-800/30 ml-4"></div>
                </h3>

                <div v-if="!modeEdition" class="text-stone-900 font-montserrat leading-relaxed text-justify text-sm">
                  {{ sortSelectionne.description }}
                </div>
                <textarea v-else v-model="sortSelectionne.description" rows="4" class="w-full bg-white rounded px-3 py-2 text-stone-900 font-montserrat resize-none text-sm"></textarea>
              </div>

              <!-- Section Description détaillée -->
              <div>
                <h3 class="text-sm font-bold text-stone-800 font-montserrat mb-4 flex items-center gap-2">
                  📚 Description détaillée
                  <div class="flex-1 h-px bg-amber-800/30 ml-4"></div>
                </h3>

                <div v-if="!modeEdition" class="text-stone-800 font-montserrat leading-relaxed text-justify bg-white/50 rounded-lg p-4 text-sm">
                  <div v-html="sortSelectionne.detailled_description" class="preserve-whitespace"></div>
                </div>
                <div v-else class="w-full">
                  <RichTextEditor
                    v-model="sortSelectionne.detailled_description"
                    placeholder="Décrivez en détail ce sort..."
                    class="w-full"
                  />
                </div>
              </div>

              <!-- Section Effet d'augmentation -->

            </div>
          </div>

          <!-- Footer avec actions -->
          <div class="mt-8 pt-6 border-t-2 border-amber-800/30">
            <div class="flex justify-between items-center">
              <div class="flex gap-4">
                <button
                  v-if="!sortEstAppris(sortSelectionne.id) && !modeEdition"
                  @click="apprendreSort(sortSelectionne.id)"
                  class="bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-lg font-montserrat font-semibold transition-colors shadow-md flex items-center gap-2 text-sm"
                >
                  📚 Apprendre ce sort
                </button>
                <button
                  v-else-if="sortEstAppris(sortSelectionne.id) && !modeEdition"
                  @click="oublierSort(sortSelectionne.id)"
                  class="bg-red-600 hover:bg-red-700 text-white px-5 py-2 rounded-lg font-montserrat font-semibold transition-colors shadow-md flex items-center gap-2 text-sm"
                >
                  ❌ Oublier ce sort
                </button>

                <!-- Boutons de sauvegarde en mode édition -->
                <button
                  v-if="modeEdition"
                  @click="sauvegarderModifications"
                  class="bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-lg font-montserrat font-semibold transition-colors shadow-md flex items-center gap-2 text-sm"
                >
                  💾 Sauvegarder
                </button>
                <button
                  v-if="modeEdition"
                  @click="annulerModifications"
                  class="bg-gray-600 hover:bg-gray-700 text-white px-5 py-2 rounded-lg font-montserrat font-semibold transition-colors shadow-md flex items-center gap-2 text-sm"
                >
                  ↶ Annuler
                </button>
              </div>

              <div class="text-xs text-stone-600 font-montserrat">
                ID: {{ sortSelectionne.id }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </PageWrapper>
</template>

<script setup>
import RichTextEditor from '~/components/RichTextEditor.vue'

const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const loading = ref(true)
const cercleSelectionne = ref('Eau')
const sortSelectionne = ref(null)
const sorts = ref([])
const sortsAppris = ref([])
const afficherMesSorts = ref(false)
const modeEdition = ref(false)
const sauvegardeSort = ref(null)
const nouveauTag = ref('')
const avantages = ref([])

// Mapping des tags avec leurs couleurs et noms formatés
const tagMapping = {
  'art_guerre': { name: 'Art de la guerre', color: '#EEBBCD' },
  'voyage': { name: 'Voyage', color: '#ACD4CD' },
  'soin': { name: 'Soin', color: '#CBDFBB' },
  'artisanat': { name: 'Artisanat', color: '#A7D3EA' },
  'defense': { name: 'Défense', color: '#BDACCC' },
  'divination': { name: 'Diviniation', color: '#F1C5A9' },
  'tonnerre': { name: 'Tonnerre', color: '#F1E4B7' },
  'degats': { name: 'Dégâts', color: '#D9B2CD' },
  'illusion': { name: 'Illusions', color: '#EEBBCD' },
  'invocation': { name: 'Invocation', color: '#A7D3E7' },
  'glyphe' : { name: 'Glyphe', color: '#A9D3C1' },
  'peur': { name: 'Peur', color: '#D3A7A7' },
  'spirituel': { name: 'Spirituel', color: '#C1A9D3' },
  'mental': { name: 'Mental', color: '#B8A79F' },
  'social': { name: 'Social', color: '#E7A7D3' }
}

// Fonctions de calcul du jet d'incantation
const calculerJetIncantation = (sort) => {
  if (!personnageActif.value) return null

  const element = sort.cercle.toLowerCase()

  if (element === 'universel') {
    // Pour les sorts universels, calculer pour chaque élément
    const elements = ['feu', 'eau', 'terre', 'air']
    const jets = elements.map(el => {
      const anneau = personnageActif.value[el]
      let rangMaitrise = personnageActif.value.rang

      // Affinités et déficiences depuis les avantages
      const affinite = avantages.value.find(av => av.type === 'avantage' && av.nom.toLowerCase().includes('affinité') && av.nom.toLowerCase().includes(el))
      const deficience = avantages.value.find(av => av.type === 'désavantage' && av.nom.toLowerCase().includes('défici') && av.nom.toLowerCase().includes(el))

      if (affinite) {
        rangMaitrise += 1
      }
      if (deficience) {
        rangMaitrise -= 1
      }

      // Affinité spéciale pour Shizuku avec l'eau
      if (personnageActif.value.nom === 'Shiba Shizuku' && el === 'eau') {
        rangMaitrise += 1
      }

      if (rangMaitrise <= 0) return `${el.charAt(0).toUpperCase() + el.slice(1)}: Impossible`

      const jet = anneau + rangMaitrise
      return `${el.charAt(0).toUpperCase() + el.slice(1)}: ${jet}g${anneau}`
    })
    return jets.join(' | ')
  }

  const anneau = personnageActif.value[element] // terre, eau, feu, air, vide

  // Rang de maîtrise : pour l'instant, on utilise le rang du personnage
  // TODO: ajouter un champ pour rang de maîtrise par élément
  let rangMaitrise = personnageActif.value.rang

  // Affinités et déficiences depuis les avantages
  const affinite = avantages.value.find(av => av.type === 'avantage' && av.nom.toLowerCase().includes('affinité') && av.nom.toLowerCase().includes(element))
  const deficience = avantages.value.find(av => av.type === 'désavantage' && av.nom.toLowerCase().includes('défici') && av.nom.toLowerCase().includes(element))

  if (affinite) {
    rangMaitrise += 1
  }
  if (deficience) {
    rangMaitrise -= 1
  }

  // Affinité spéciale pour Shizuku avec l'eau
  if (personnageActif.value.nom === 'Shiba Shizuku' && element === 'eau') {
    rangMaitrise += 1
  }

  if (rangMaitrise <= 0) return 'Impossible'

  const jet = anneau + rangMaitrise
  return `${jet}g${anneau}`
}

const calculerND = (sort) => {
  return 5 * sort.rang
}

// Rediriger si pas de personnage actif
onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await Promise.all([
        chargerSorts(),
        chargerSortsAppris(),
        chargerAvantages()
      ])
    } finally {
      loading.value = false
    }
  }
})

const chargerSorts = async () => {
  const { data, error } = await client
    .from('spells')
    .select('*')
    .order('rang', { ascending: true })
    .order('nom', { ascending: true })

  if (!error && data) {
    sorts.value = data
  }
}

const chargerSortsAppris = async () => {
  if (!personnageActif.value?.id) return

  const { data, error } = await client
    .from('character_spells')
    .select('spell_id')
    .eq('personnage_id', personnageActif.value.id)

  if (!error && data) {
    sortsAppris.value = data.map(item => item.spell_id)
  }
}

const chargerAvantages = async () => {
  if (!personnageActif.value?.id) return

  const { data, error } = await client
    .from('avantages')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (!error && data) {
    avantages.value = data
  }
}

const sortsFiltrees = computed(() => {
  let sortsDuCercle = sorts.value.filter(sort => sort.cercle.toLowerCase() === cercleSelectionne.value?.toLowerCase())
  
  if (afficherMesSorts.value) {
    sortsDuCercle = sortsDuCercle.filter(sort => sortEstAppris(sort.id))
  }
  
  return sortsDuCercle
})

const selectionnerCercle = (cercle) => {
  cercleSelectionne.value = cercle
  sortSelectionne.value = null // Fermer le modal de détail
}

const selectionnerSort = (sort) => {
  sortSelectionne.value = sort
}

const sortEstAppris = (sortId) => {
  return sortsAppris.value.includes(sortId)
}

const apprendreSort = async (sortId) => {
  if (!personnageActif.value?.id) return

  const { error } = await client
    .from('character_spells')
    .insert({
      personnage_id: personnageActif.value.id,
      spell_id: sortId
    })

  if (!error) {
    sortsAppris.value.push(sortId)
  }
}

const oublierSort = async (sortId) => {
  if (!personnageActif.value?.id) return

  const { error } = await client
    .from('character_spells')
    .delete()
    .eq('personnage_id', personnageActif.value.id)
    .eq('spell_id', sortId)

  if (!error) {
    sortsAppris.value = sortsAppris.value.filter(id => id !== sortId)
  }
}

const getTagInfo = (tagKey) => {
  return tagMapping[tagKey] || { name: tagKey, color: '#fcd34d' }
}

const sauvegarderModifications = async () => {
  if (!sortSelectionne.value) return

  try {
    const { error } = await client
      .from('spells')
      .update({
        portee: sortSelectionne.value.portee,
        zone_effet: sortSelectionne.value.zone_effet,
        duree: sortSelectionne.value.duree,
        degats_soin: sortSelectionne.value.degats_soin,
        description: sortSelectionne.value.description,
        detailled_description: sortSelectionne.value.detailled_description,
        effet_augmentation: sortSelectionne.value.effet_augmentation,
        mot_cle: sortSelectionne.value.mot_cle
      })
      .eq('id', sortSelectionne.value.id)

    if (!error) {
      modeEdition.value = false
      sauvegardeSort.value = null
      // Recharger les sorts pour refléter les changements
      await chargerSorts()
    } else {
      console.error('Erreur lors de la sauvegarde:', error)
    }
  } catch (error) {
    console.error('Erreur lors de la sauvegarde:', error)
  }
}

const annulerModifications = () => {
  if (sauvegardeSort.value) {
    // Restaurer les valeurs originales
    Object.assign(sortSelectionne.value, sauvegardeSort.value)
  }
  modeEdition.value = false
  sauvegardeSort.value = null
}

// Fonction appelée quand on entre en mode édition
const entrerModeEdition = () => {
  if (!modeEdition.value) {
    // Sauvegarder l'état actuel
    sauvegardeSort.value = { ...sortSelectionne.value }
    modeEdition.value = true
  }
}

const ajouterTag = () => {
  if (nouveauTag.value && sortSelectionne.value) {
    // Vérifier si le tag n'existe pas déjà
    if (!sortSelectionne.value.mot_cle.includes(nouveauTag.value)) {
      sortSelectionne.value.mot_cle.push(nouveauTag.value)
    }
    nouveauTag.value = ''
  }
}

const supprimerTag = (index) => {
  if (sortSelectionne.value && sortSelectionne.value.mot_cle) {
    sortSelectionne.value.mot_cle.splice(index, 1)
  }
}

const changeCharacter = () => {
  navigateTo('/')
}
</script>

<style scoped>
/* Switch personnalisé inspiré de Uiverse.io */
.switch {
  --button-width: 3.5em;
  --button-height: 1.5em;
  --toggle-diameter: 1em;
  --button-toggle-offset: calc((var(--button-height) - var(--toggle-diameter)) / 2);
  --toggle-shadow-offset: 10px;
  --toggle-wider: 3em;
  --color-amber: #CDAFCE;
  --color-green: #A4C7E7; /* green-500 */
}

.slider {
  display: inline-block;
  width: var(--button-width);
  height: var(--button-height);
  background-color: var(--color-amber);
  border-radius: calc(var(--button-height) / 2);
  position: relative;
  transition: 0.3s all ease-in-out;
  cursor: pointer;
}

.slider::after {
  content: "";
  display: inline-block;
  width: var(--toggle-diameter);
  height: var(--toggle-diameter);
  background-color: #fff;
  border-radius: calc(var(--toggle-diameter) / 2);
  position: absolute;
  top: var(--button-toggle-offset);
  transform: translateX(var(--button-toggle-offset));
  box-shadow: var(--toggle-shadow-offset) 0 calc(var(--toggle-shadow-offset) * 4) rgba(0, 0, 0, 0.1);
  transition: 0.3s all ease-in-out;
}

.switch input[type="checkbox"]:checked + .slider {
  background-color: var(--color-green);
}

.switch input[type="checkbox"]:checked + .slider::after {
  transform: translateX(calc(var(--button-width) - var(--toggle-diameter) - var(--button-toggle-offset)));
  box-shadow: calc(var(--toggle-shadow-offset) * -1) 0 calc(var(--toggle-shadow-offset) * 4) rgba(0, 0, 0, 0.1);
}

.switch input[type="checkbox"] {
  display: none;
}

.switch input[type="checkbox"]:active + .slider::after {
  width: var(--toggle-wider);
}

.switch input[type="checkbox"]:checked:active + .slider::after {
  transform: translateX(calc(var(--button-width) - var(--toggle-wider) - var(--button-toggle-offset)));
}

.scale-140 {
  transform: scale(1.2);
}

.preserve-whitespace {
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>