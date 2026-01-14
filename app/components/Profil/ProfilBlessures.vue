<template>
  <div class="rounded-xl p-2 relative overflow-hidden text-xs" style="background-image: url('/parchemin_side.png'); background-size: 100% 100%;">
    <div class="relative z-10 px-12 py-24 pl-24">
      <!-- Grand tableau unique -->
      <div class=" overflow-hidden">
        <table class="w-full border-collapse px-24">

          <!-- 1. SECTION : INITIATIVE -->
          <thead>
            <tr class="bg-red-900/50">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text// Synchroniser la valeur calculée avec armure.actuelle
watch(ndArmureActuelCalculee, (newValue) => {
  armure.value.actuelle = newValue
}, { immediate: true })

// Synchroniser les totaux de blessures calculés
watch(indemneTotalCalculee, (newValue) => {
  blessures.value.indemne.total = newValue
}, { immediate: true })

watch(autresBlessuresTotalCalculee, (newValue) => {
  blessures.value.egratigne.total = newValue
  blessures.value.legerementBlesse.total = newValue
  blessures.value.blesse.total = newValue
  blessures.value.gravementBlesse.total = newValue
  blessures.value.impotent.total = newValue
  blessures.value.epuise.total = newValue
  blessures.value.horsCombat.total = newValue
}, { immediate: true })

// Synchroniser la récupération calculée
watch(recuperationBaseCalculee, (newValue) => {
  recuperation.value.base = newValue
}, { immediate: true })

watch(recuperationActuelleCalculee, (newValue) => {
  recuperation.value.actuelle = newValue
}, { immediate: true })

// Calcul automatique de l'initiative actuelle : base + modificateursr text-xs">INITIATIVE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">Rang de Réputation + Réflexes</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="initiativeBaseCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">Modificateurs</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="initiative.modificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr>
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold border border-red-900">Initiative Actuelle</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="initiativeActuelleCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
          </tbody>

          <thead>
            <tr class="bg-red-900/50">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-xs">ND D'ARMURE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">5+ (Réflexes x5)</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="ndArmureBaseCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900 ">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">Modificateurs</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="armure.ndModificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold border border-red-900">ND Actuel</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="ndArmureActuelCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
          </tbody>

          <!-- 3. SECTION : ARMURE -->
          <thead>
            <tr class="bg-red-900/50">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-xs">ARMURE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat font-medium border border-red-900">Bonus au ND</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="armure.bonusNd"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 font-montserrat font-medium border border-red-900">Réduction</td>
               <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="armure.reduction"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat font-medium border border-red-900">Qualité</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model="armure.qualite"
                  type="text"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                
              </td>
               <td class="py-2 px-2 border border-red-900">
                
              </td>
            </tr>
            <tr>
              <td class="py-2 px-2 font-montserrat font-medium border border-red-900">Notes</td>
              <td class="py-2 px-2 border border-red-900" colspan="3">
                <input
                  v-model="armure.notes"
                  type="text"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-xs bg-transparent font-montserrat"
                  placeholder="Notes sur l'armure..."
                />
              </td>
            </tr>
          </tbody>

          <!-- 4. SECTION : BLESSURES -->
          <thead>
            <tr class="bg-red-900/50">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-xs">BLESSURES</th>
            </tr>
          </thead>
          <tbody>
            <!-- Règles générales -->
            <tr class="bg-amber-50 border-b-2 border-red-900">
              <td colspan="4" class="py-2 px-2">
                <div class="text-xs font-montserrat text-stone-700 space-y-0.5">
                  <div><strong>Règles générales :</strong></div>
                  <div>• Terre x2 par Rang</div>
                  <div>• Terre x5 pour Indemne</div>
                </div>
              </td>
            </tr>

            <!-- En-têtes du tableau blessures -->
            <tr class="bg-amber-100 border-b-2 border-red-900">
              <th class="py-1 px-2 font-bold text-red-900 font-katana text-xs border border-red-900">Rang de Blessure</th>
              <th class="py-1 px-2 font-bold text-red-900 font-katana text-xs border border-red-900">Malus</th>
              <th class="py-1 px-2 font-bold text-red-900 font-katana text-xs border border-red-900">Total</th>
              <th class="py-1 px-2 font-bold text-red-900 font-katana text-xs border border-red-900">Actuel</th>
            </tr>

            <!-- Lignes de blessures -->
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Indemne</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.indemne.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="indemneTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.indemne.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Égratigné</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.egratigne.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.egratigne.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Légèrement Blessé</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.legerementBlesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.legerementBlesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Blessé</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.blesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.blesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Gravement Blessé</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.gravementBlesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.gravementBlesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">Impotent</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.impotent.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.impotent.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">
                <div>Épuisé</div>
                <div class="text-xs text-stone-600 italic">Doit utiliser un Pts de Vide pour agir</div>
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.epuise.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.epuise.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td class="py-2 px-2 font-montserrat border border-red-900">
                <div>Hors de Combat</div>
                <div class="text-xs text-stone-600 italic">Ne peut pas agir</div>
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.horsCombat.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="autresBlessuresTotalCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="blessures.horsCombat.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
          </tbody>

          <!-- 5. SECTION : RÉCUPÉRATION DES BLESSURES -->
          <thead>
            <tr class="bg-red-900/50">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-xs">RÉCUPÉRATION DES BLESSURES</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">Constitution x2 + Rang de Réputation</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="recuperationBaseCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
            <tr class="border-b border-red-900">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium border border-red-900">Modificateurs</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  v-model.number="recuperation.modificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-transparent font-montserrat"
                />
              </td>
            </tr>
            <tr>
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold border border-red-900">Récupération Actuelle</td>
              <td class="py-2 px-2 border border-red-900">
                <input
                  :value="recuperationActuelleCalculee"
                  type="number"
                  readonly
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-stone-100 font-montserrat cursor-not-allowed"
                />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  personnageData: {
    type: Object,
    required: true,
    default: () => ({})
  }
})

defineEmits(['save'])

const initiative = ref({
  reputationReflexes: 0,
  modificateurs: 0,
  actuelle: 0
})

const armure = ref({
  ndBase: 0,
  ndModificateurs: 0,
  bonusNd: 0,
  qualite: '',
  reduction: 0,
  notes: '',
  actuelle: 0
})

const blessures = ref({
  indemne: { malus: 0, total: 10, actuel: 0 },
  egratigne: { malus: 3, total: 4, actuel: 0 },
  legerementBlesse: { malus: 5, total: 4, actuel: 0 },
  blesse: { malus: 10, total: 4, actuel: 0 },
  gravementBlesse: { malus: 15, total: 4, actuel: 0 },
  impotent: { malus: 20, total: 4, actuel: 0 },
  epuise: { malus: 40, total: 4, actuel: 0 },
  horsCombat: { malus: 0, total: 4, actuel: 0 }
})

const recuperation = ref({
  base: 0,
  modificateurs: 0,
  actuelle: 0
})

// Calcul automatique du ND d'armure de base : 5 + (Réflexes x5)
const ndArmureBaseCalculee = computed(() => {
  if (!props.personnageData) return 0
  
  const reflexes = props.personnageData.reflexes || 2
  return 5 + (reflexes * 5)
})

// Calcul automatique de l'initiative de base : Rang de Réputation + Réflexes
const initiativeBaseCalculee = computed(() => {
  if (!props.personnageData) return 0
  
  const reputation = props.personnageData.rangReputation || 1
  const reflexes = props.personnageData.reflexes || 2
  return reputation + reflexes
})

// Calcul automatique du ND d'armure actuel : base + modificateurs
const ndArmureActuelCalculee = computed(() => {
  return armure.value.ndBase + (armure.value.ndModificateurs || 0)
})

// Calcul automatique de l'initiative actuelle : base + modificateurs
const initiativeActuelleCalculee = computed(() => {
  return initiative.value.reputationReflexes + (initiative.value.modificateurs || 0)
})

// Calcul automatique des totaux de blessures
const terreCalculee = computed(() => props.personnageData?.terre || 2)

const indemneTotalCalculee = computed(() => terreCalculee.value * 5)
const autresBlessuresTotalCalculee = computed(() => terreCalculee.value * 2)

// Calcul automatique de la récupération de base : Constitution x2 + Rang de Réputation
const recuperationBaseCalculee = computed(() => {
  if (!props.personnageData) return 0
  
  const constitution = props.personnageData.constitution || 2
  const reputation = props.personnageData.rangReputation || 1
  return (constitution * 2) + reputation
})

// Calcul automatique de la récupération actuelle : base + modificateurs
const recuperationActuelleCalculee = computed(() => {
  return recuperation.value.base + (recuperation.value.modificateurs || 0)
})

// La valeur de recuperation.base sera automatiquement synchronisée via le computed
// puisqu'elle est utilisée dans recuperationActuelleCalculee

// Synchroniser la valeur calculée avec initiative.reputationReflexes
watch(initiativeBaseCalculee, (newValue) => {
  initiative.value.reputationReflexes = newValue
}, { immediate: true })

// Synchroniser la valeur calculée avec initiative.actuelle
watch(initiativeActuelleCalculee, (newValue) => {
  initiative.value.actuelle = newValue
}, { immediate: true })

// Synchroniser la valeur calculée avec armure.ndBase
watch(ndArmureBaseCalculee, (newValue) => {
  armure.value.ndBase = newValue
}, { immediate: true })

// Synchroniser la valeur calculée avec armure.actuelle
watch(ndArmureActuelCalculee, (newValue) => {
  armure.value.actuelle = newValue
}, { immediate: true })

// Synchroniser les totaux de blessures calculés
watch(indemneTotalCalculee, (newValue) => {
  blessures.value.indemne.total = newValue
}, { immediate: true })

watch(autresBlessuresTotalCalculee, (newValue) => {
  blessures.value.egratigne.total = newValue
  blessures.value.legerementBlesse.total = newValue
  blessures.value.blesse.total = newValue
  blessures.value.gravementBlesse.total = newValue
  blessures.value.impotent.total = newValue
  blessures.value.epuise.total = newValue
  blessures.value.horsCombat.total = newValue
}, { immediate: true })

// Synchroniser la récupération calculée
watch(recuperationBaseCalculee, (newValue) => {
  recuperation.value.base = newValue
}, { immediate: true })

watch(recuperationActuelleCalculee, (newValue) => {
  recuperation.value.actuelle = newValue
}, { immediate: true })

// TODO: Connecter avec les vraies données du personnage
</script>