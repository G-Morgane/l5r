<template>
  <div class="rounded-xl p-4 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden">
    <div class="relative z-10">
      <!-- Grand tableau unique -->
      <div class="border-2 border-amber-900 rounded-lg overflow-hidden">
        <table class="w-full border-collapse">

          <!-- 1. SECTION : INITIATIVE -->
          <thead>
            <tr class="bg-amber-900">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-base">INITIATIVE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">Rang de Réputation / Réflexes</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="initiative.reputationReflexes"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">Modificateurs</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="initiative.modificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="bg-amber-100">
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold">Initiative Actuelle</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="initiative.actuelle"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
          </tbody>

          <thead>
            <tr class="bg-amber-900">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-base border-t-4 border-white">ND D'ARMURE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">5+ (Réflexes x5)</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="armure.ndBase"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">Modificateurs</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="armure.ndModificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="bg-amber-100">
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold">ND Actuel</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="armure.actuelle"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
          </tbody>

          <!-- 3. SECTION : ARMURE -->
          <thead>
            <tr class="bg-amber-900">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-base border-t-4 border-white">ARMURE</th>
            </tr>
          </thead>
          <tbody>
            <tr class="bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat font-medium border-r border-amber-300">Bonus au ND</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="armure.bonusNd"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 font-montserrat font-medium border-r border-amber-300">Réduction</td>
               <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="armure.reduction"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat font-medium border-r border-amber-300">Qualité</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model="armure.qualite"
                  type="text"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                
              </td>
               <td class="py-2 px-2 border-r border-amber-300">
                
              </td>
            </tr>
            <tr class="bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat font-medium border-r border-amber-300">Notes</td>
              <td class="py-2 px-2 border-r border-amber-300" colspan="3">
                <input
                  v-model="armure.notes"
                  type="text"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-sm bg-white font-montserrat"
                  placeholder="Notes sur l'armure..."
                />
              </td>
            </tr>
          </tbody>

          <!-- 4. SECTION : BLESSURES -->
          <thead>
            <tr class="bg-amber-900">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-base border-t-4 border-white">BLESSURES</th>
            </tr>
          </thead>
          <tbody>
            <!-- Règles générales -->
            <tr class="bg-amber-50 border-b-2 border-amber-600">
              <td colspan="4" class="py-2 px-2">
                <div class="text-xs font-montserrat text-stone-700 space-y-0.5">
                  <div><strong>Règles générales :</strong></div>
                  <div>• Terre x2 par Rang</div>
                  <div>• Terre x5 pour Indemne</div>
                </div>
              </td>
            </tr>

            <!-- En-têtes du tableau blessures -->
            <tr class="bg-amber-100 border-b-2 border-amber-600">
              <th class="py-1 px-2 font-bold text-amber-900 font-katana text-xs border-r border-amber-400">Rang de Blessure</th>
              <th class="py-1 px-2 font-bold text-amber-900 font-katana text-xs border-r border-amber-400">Malus</th>
              <th class="py-1 px-2 font-bold text-amber-900 font-katana text-xs border-r border-amber-400">Total</th>
              <th class="py-1 px-2 font-bold text-amber-900 font-katana text-xs">Actuel</th>
            </tr>

            <!-- Lignes de blessures -->
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Indemne</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.indemne.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.indemne.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.indemne.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Égratigné</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.egratigne.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.egratigne.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.egratigne.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Légèrement Blessé</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.legerementBlesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.legerementBlesse.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.legerementBlesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Blessé</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.blesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.blesse.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.blesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Gravement Blessé</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.gravementBlesse.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.gravementBlesse.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.gravementBlesse.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">Impotent</td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.impotent.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.impotent.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.impotent.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">
                <div>Épuisé</div>
                <div class="text-xs text-stone-600 italic">Doit utiliser un Point de Vide pour agir</div>
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.epuise.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.epuise.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.epuise.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="bg-amber-50/60">
              <td class="py-2 px-2 font-montserrat border-r border-amber-300">
                <div>Hors de Combat</div>
                <div class="text-xs text-stone-600 italic">Ne peut pas agir</div>
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.horsCombat.malus"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.horsCombat.total"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
              <td class="py-2 px-2 border-r border-amber-300">
                <input
                  v-model.number="blessures.horsCombat.actuel"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
          </tbody>

          <!-- 5. SECTION : RÉCUPÉRATION DES BLESSURES -->
          <thead>
            <tr class="bg-amber-900">
              <th colspan="4" class="py-2 px-2 text-white font-bold font-katana text-center text-base border-t-4 border-white">RÉCUPÉRATION DES BLESSURES</th>
            </tr>
          </thead>
          <tbody>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">Constitution x2 + Rang de Réputation</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="recuperation.base"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="border-b border-amber-300 bg-amber-50/60">
              <td colspan="3" class="py-2 px-2 font-montserrat font-medium">Modificateurs</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="recuperation.modificateurs"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                />
              </td>
            </tr>
            <tr class="bg-amber-100">
              <td colspan="3" class="py-2 px-2 font-montserrat font-bold">Récupération Actuelle</td>
              <td class="py-2 px-2 border-l border-amber-300">
                <input
                  v-model.number="recuperation.actuelle"
                  type="number"
                  @blur="$emit('save')"
                  class="w-full border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
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
import { ref } from 'vue'

defineProps({
  personnageData: {
    type: Object,
    required: true
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

// TODO: Connecter avec les vraies données du personnage
</script>