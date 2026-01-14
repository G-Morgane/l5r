<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img 
        src="/fond_long.png" 
        alt="Japanese room background" 
        class="w-full h-full object-contain object-top"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>
    
    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- En-tête -->
      <div v-if="!personnageActif">
        <ProfilNoCharacter />
      </div>
      <div v-else class="max-w-7xl mx-auto">
        <!-- En-tête personnage -->
        <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="() => navigateTo('/')"
        />
        <!-- Section principale : Anneaux + Stats -->
        <div class="space-y-6 mb-6">
          <!-- Ligne 1 : Tous les cercles -->
          <ProfilRings 
            :personnage-data="personnageData"
            @save="sauvegarderPersonnage"
          />

          <!-- Ligne 2 : Gloire/Honneur/Statut + Expérience/Initiative/Réputation -->
          <ProfilStats 
            :personnage-data="personnageData"
            :minimum-experience-points="minimumExperiencePoints"
            :experience-depense-auto="experienceDepenseAuto"
            :experience-restant="experienceRestant"
            :reputation-points="reputationPoints"
            :rang-reputation="rangReputation"
            @save="sauvegarderPersonnage"
            @open-xp-modal="modaleDepenseXP = true"
          />

          <!-- Ressources -->
        
        </div>

        <!-- Compétences -->
        <ProfilSkills 
          :competences="competences"
          @open-nd-modal="modaleTableND = true"
          @add-skill="ajouterCompetence"
          @save-skill="sauvegarderCompetence"
          @open-description-modal="ouvrirModaleDescription"
          @delete-skill="supprimerCompetence"
        />

        <!-- Modale Description Compétence -->
        <div v-if="modaleDescription.visible" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="fermerModaleDescription">
          <div class="bg-white rounded-xl p-6 max-w-2xl w-full mx-4 shadow-2xl border-2 border-amber-800/60">
            <div class="flex justify-between items-center mb-4">
              <h3 class="text-xl font-bold text-red-900 font-sakurata">{{ modaleDescription.competence?.nom || 'Description' }}</h3>
              <button 
                @click="fermerModaleDescription"
                class="text-red-600 hover:text-red-800 font-bold text-2xl"
              >
                ×
              </button>
            </div>
            <textarea 
              v-model="modaleDescription.description"
              class="w-full h-64 border-2 border-stone-300 rounded-lg p-4 font-montserrat text-sm"
              placeholder="Entrez la description complète de la compétence ici..."
            ></textarea>
            <div class="flex justify-end gap-2 mt-4">
              <button 
                @click="fermerModaleDescription"
                class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-bold font-katana"
              >
                Annuler
              </button>
              <button 
                @click="sauvegarderDescription"
                class="px-4 py-2 bg-green-700 hover:bg-green-800 text-white rounded-lg font-bold font-katana"
              >
                Sauvegarder
              </button>
            </div>
          </div>
        </div>

        <!-- Modale Description Avantage -->
        <div v-if="modaleDescriptionAvantage.visible" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="fermerModaleDescriptionAvantage">
          <div class="bg-white rounded-xl p-6 max-w-2xl w-full mx-4 shadow-2xl border-2 border-amber-800/60">
            <div class="flex justify-between items-center mb-4">
              <h3 class="text-xl font-bold text-red-900 font-sakurata">{{ modaleDescriptionAvantage.avantage?.nom || 'Description' }}</h3>
              <button 
                @click="fermerModaleDescriptionAvantage"
                class="text-red-600 hover:text-red-800 font-bold text-2xl"
              >
                ×
              </button>
            </div>
            <textarea 
              v-model="modaleDescriptionAvantage.description"
              class="w-full h-64 border-2 border-stone-300 rounded-lg p-4 font-montserrat text-sm"
              placeholder="Entrez la description complète de l'avantage/désavantage ici..."
            ></textarea>
            <div class="flex justify-end gap-2 mt-4">
              <button 
                @click="fermerModaleDescriptionAvantage"
                class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-bold font-katana"
              >
                Annuler
              </button>
              <button 
                @click="sauvegarderDescriptionAvantage"
                class="px-4 py-2 bg-green-700 hover:bg-green-800 text-white rounded-lg font-bold font-katana"
              >
                Sauvegarder
              </button>
            </div>
          </div>
        </div>

        <div  class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          <div class="flex flex-col gap-8">
             <ProfilResources 
            :ressources="ressources"
            @save-resources="sauvegarderRessources"
          />
           <ProfilWeapons 
            :armes="armes"
            @add-weapon="ajouterArme"
            @save-weapon="sauvegarderArme"
            @delete-weapon="supprimerArme"
          />
           <ProfilArmor 
            :armures="armures"
            @add-armor="ajouterArmure"
            @save-armor="sauvegarderArmure"
            @delete-armor="supprimerArmure"
          /> 
          <ProfilAdvantages 
            :avantages="avantages" 
            :avantages-tries="avantagesTries"
            @add-advantage="ajouterAvantage"
            @save-advantage="sauvegarderAvantage"
            @open-description-modal="ouvrirModaleDescriptionAvantage"
            @delete-advantage="supprimerAvantage"
          /></div>
          <div class="flex flex-col gap-8">
           
          <ProfilBlessures


          />
          </div>
        </div>
        
      </div>
    </div>
  </div>

  <!-- Modale Table de Référence des ND -->
  <div v-if="modaleTableND" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="modaleTableND = false">
    <div class="bg-white rounded-xl p-6 max-w-3xl w-full mx-4 shadow-2xl border-2 border-amber-800/60">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-2xl font-bold text-red-900 font-sakurata">📊 Table de Référence des ND</h3>
        <button 
          @click="modaleTableND = false"
          class="text-red-600 hover:text-red-800 font-bold text-3xl"
        >
          ×
        </button>
      </div>
      <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
        <div class="bg-green-50 border-2 border-green-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-green-700 font-montserrat">ND 5</div>
          <div class="text-sm font-semibold text-green-900 font-katana">Très Facile</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions triviales</div>
        </div>
        <div class="bg-blue-50 border-2 border-blue-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-blue-700 font-montserrat">ND 10</div>
          <div class="text-sm font-semibold text-blue-900 font-katana">Facile</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions simples</div>
        </div>
        <div class="bg-yellow-50 border-2 border-yellow-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-yellow-700 font-montserrat">ND 15</div>
          <div class="text-sm font-semibold text-yellow-900 font-katana">Moyen</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions courantes</div>
        </div>
        <div class="bg-orange-50 border-2 border-orange-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-orange-700 font-montserrat">ND 20</div>
          <div class="text-sm font-semibold text-orange-900 font-katana">Difficile</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions complexes</div>
        </div>
        <div class="bg-red-50 border-2 border-red-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-red-700 font-montserrat">ND 25</div>
          <div class="text-sm font-semibold text-red-900 font-katana">Très Difficile</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions exceptionnelles</div>
        </div>
        <div class="bg-purple-50 border-2 border-purple-600 rounded-lg p-3">
          <div class="text-2xl font-bold text-purple-700 font-montserrat">ND 30+</div>
          <div class="text-sm font-semibold text-purple-900 font-katana">Héroïque</div>
          <div class="text-xs text-stone-600 font-montserrat mt-1">Actions légendaires</div>
        </div>
      </div>
      <div class="mt-4 text-sm text-stone-600 font-montserrat italic text-center">
        💡 Les dés de 10 explosent : relancez-les et additionnez le résultat
      </div>
    </div>
  </div>

  <!-- Modale détail XP dépensé -->
  <div v-if="modaleDepenseXP" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="modaleDepenseXP = false">
    <div class="bg-white rounded-xl p-6 max-w-2xl w-full mx-4 shadow-2xl border-2 border-amber-800/60">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-bold text-red-900 font-sakurata">Détail des dépenses d'XP</h3>
        <button 
          @click="modaleDepenseXP = false"
          class="text-red-600 hover:text-red-800 font-bold text-2xl"
        >
          ×
        </button>
      </div>
      <div class="space-y-2 text-sm font-montserrat">
        <div>
          <span class="font-bold">Traits :</span>
          <ul class="list-disc ml-6">
            <li v-for="trait in xpDetails.traits" :key="trait.label">{{ trait.label }} : {{ trait.xp }} XP</li>
          </ul>
        </div>
        <div>
          <span class="font-bold">Anneau du Vide :</span>
          <span>{{ xpDetails.vide }} XP</span>
        </div>
        <div>
          <span class="font-bold">Compétences :</span>
          <ul class="list-disc ml-6">
            <li v-for="comp in xpDetails.competences" :key="comp.label">{{ comp.label }} : {{ comp.xp }} XP</li>
          </ul>
        </div>
        <div>
          <span class="font-bold">Avantages :</span>
          <ul class="list-disc ml-6">
            <li v-for="av in xpDetails.avantages" :key="av.label">{{ av.label }} : -{{ av.xp }} XP</li>
          </ul>
        </div>
        <div>
          <span class="font-bold">Désavantages :</span>
          <ul class="list-disc ml-6">
            <li v-for="des in xpDetails.desavantages" :key="des.label">{{ des.label }} : +{{ des.xp }} XP</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

// Données du personnage
const personnageData = ref({
  nom: '',
  rang: 1,
  clan: '',
  ecole: '',
  experience_points: 0,
  experience_depense: 0,
  reputation: 0,
  honneur: 5,
  gloire: 0,
  statut_social: 1,
  statut: 'vivant',
  souillure: 0,
  initiative: 0,
  terre: 2,
  eau: 2,
  feu: 2,
  air: 2,
  vide: 2,
  constitution: 2,
  volonte: 2,
  force: 2,
  perception: 3,
  intelligence: 3,
  agilite: 2,
  reflexes: 2,
  intuition: 2,
  // Valeurs de départ (après bonus famille + école)
  constitution_base: 2,
  volonte_base: 2,
  force_base: 2,
  perception_base: 3, // Shiba +1
  intelligence_base: 3, // Isawa +1
  agilite_base: 2,
  reflexes_base: 2,
  intuition_base: 2,
  vide_base: 2
})

const competences = ref([])
const avantages = ref([])
const armes = ref([])
const armures = ref([])
const ressources = ref({
  koku: 0,
  bu: 0,
  zeni: 0
})

// Tri des avantages : avantages d'abord, désavantages ensuite
const avantagesTries = computed(() => {
  return [...avantages.value].sort((a, b) => {
    if (a.type === 'avantage' && b.type === 'desavantage') return -1
    if (a.type === 'desavantage' && b.type === 'avantage') return 1
    return 0
  })
})

// Mode édition pour les compétences
const modeEditionCompetences = ref(false)

// Mode édition pour les armes, armures et avantages
const modeEditionArmes = ref(false)
const modeEditionArmures = ref(false)
const modeEditionAvantages = ref(false)

// Modale table de référence des ND
const modaleTableND = ref(false)

// Modale de description de compétence
const modaleDescription = ref({
  visible: false,
  competence: null,
  description: ''
})

const ouvrirModaleDescription = (comp) => {
  modaleDescription.value = {
    visible: true,
    competence: comp,
    description: comp.description || ''
  }
}

const fermerModaleDescription = () => {
  modaleDescription.value = {
    visible: false,
    competence: null,
    description: ''
  }
}

const sauvegarderDescription = async () => {
  if (modaleDescription.value.competence) {
    modaleDescription.value.competence.description = modaleDescription.value.description
    await sauvegarderCompetence(modaleDescription.value.competence)
    fermerModaleDescription()
  }
}

// Modale de description d'avantage
const modaleDescriptionAvantage = ref({
  visible: false,
  avantage: null,
  description: ''
})

const ouvrirModaleDescriptionAvantage = (avantage) => {
  modaleDescriptionAvantage.value = {
    visible: true,
    avantage: avantage,
    description: avantage.description || ''
  }
}

const fermerModaleDescriptionAvantage = () => {
  modaleDescriptionAvantage.value = {
    visible: false,
    avantage: null,
    description: ''
  }
}

const sauvegarderDescriptionAvantage = async () => {
  if (modaleDescriptionAvantage.value.avantage) {
    modaleDescriptionAvantage.value.avantage.description = modaleDescriptionAvantage.value.description
    await sauvegarderAvantage(modaleDescriptionAvantage.value.avantage)
    fermerModaleDescriptionAvantage()
  }
}

// Calculer le jet de dés pour une compétence (règles L5R: Trait+Compétence dés, garder Trait)
const calculerJet = (comp) => {
  if (!comp.trait || !comp.rang) return '-'
  
  // Mapper le nom du trait en minuscules vers la valeur du personnage
  const traitNom = comp.trait.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '')
  const mappingTraits = {
    'constitution': personnageData.value.constitution,
    'volonte': personnageData.value.volonte,
    'force': personnageData.value.force,
    'perception': personnageData.value.perception,
    'intelligence': personnageData.value.intelligence,
    'agilite': personnageData.value.agilite,
    'reflexes': personnageData.value.reflexes,
    'intuition': personnageData.value.intuition,
    'vide': personnageData.value.vide
  }
  
  const valeurTrait = mappingTraits[traitNom] || 0
  const lancer = valeurTrait + (comp.rang || 0)
  const garder = valeurTrait
  
  return `${lancer}g${garder}`
}

// Calculer l'XP dépensé automatiquement
const experienceDepenseAuto = computed(() => {
  let total = 0
  
  // Coût des Traits (coût = 4 × nouveau rang pour chaque rang au-dessus de la base)
  const traitsData = [
    { valeur: personnageData.value.constitution, base: personnageData.value.constitution_base || 2 },
    { valeur: personnageData.value.volonte, base: personnageData.value.volonte_base || 2 },
    { valeur: personnageData.value.force, base: personnageData.value.force_base || 2 },
    { valeur: personnageData.value.perception, base: personnageData.value.perception_base || 2 },
    { valeur: personnageData.value.intelligence, base: personnageData.value.intelligence_base || 2 },
    { valeur: personnageData.value.agilite, base: personnageData.value.agilite_base || 2 },
    { valeur: personnageData.value.reflexes, base: personnageData.value.reflexes_base || 2 },
    { valeur: personnageData.value.intuition, base: personnageData.value.intuition_base || 2 }
  ]
  
  traitsData.forEach(trait => {
    const valeur = trait.valeur || trait.base
    if (valeur > trait.base) {
      for (let i = trait.base + 1; i <= valeur; i++) {
        total += i * 4
      }
    }
  })
  
  // Coût de l'Anneau du Vide (base = 2, coût = 6 × nouveau rang)
  const vide = personnageData.value.vide || 2
  const videBase = personnageData.value.vide_base || 2
  if (vide > videBase) {
    for (let i = videBase + 1; i <= vide; i++) {
      total += i * 6
    }
  }
  
  // Coût des Compétences (coût = nouveau rang)
  competences.value.forEach(comp => {
    const rang = comp.rang || 0
    if (rang > 0) {
      for (let i = 1; i <= rang; i++) {
        total += i
      }
    }
  })
  
  // Coût des Avantages (+ leur valeur) et Désavantages (- leur valeur car ils donnent des points)
  avantages.value.forEach(avantage => {
    const rang = avantage.rang || 0
    if (avantage.type === 'avantage') {
      total += rang  // Les avantages coûtent des points
    } else if (avantage.type === 'desavantage') {
      total -= rang  // Les désavantages donnent des points
    }
  })
  
  return total
})

// Calculer l'expérience restante
const experienceRestant = computed(() => {
  return (personnageData.value.experience_points || 0) - experienceDepenseAuto.value
})

// Calculer les points de Réputation : (Somme des Anneaux × 10) + Somme des Rangs de Compétence
const reputationPoints = computed(() => {
  const sommeAnneaux = (personnageData.value.terre || 0) + 
                        (personnageData.value.eau || 0) + 
                        (personnageData.value.feu || 0) + 
                        (personnageData.value.air || 0) + 
                        (personnageData.value.vide || 0)
  
  const sommeCompetences = competences.value.reduce((sum, comp) => sum + (comp.rang || 0), 0)
  
  return (sommeAnneaux * 10) + sommeCompetences
})

// Calculer le Rang de Réputation basé sur les tranches de 25 points
const rangReputation = computed(() => {
  const points = reputationPoints.value
  if (points < 150) return 1
  if (points < 175) return 2
  if (points < 200) return 3
  if (points < 225) return 4
  if (points < 250) return 5
  if (points < 275) return 6
  if (points < 300) return 7
  if (points < 325) return 8
  return Math.floor((points - 300) / 25) + 8
})

// Calcul du minimum XP total requis
const minimumExperiencePoints = computed(() => {
  const desavantages = avantages.value.filter(a => a.type === 'desavantage')
  const totalDesavantages = desavantages.reduce((sum, a) => sum + (a.rang || 0), 0)
  return 40 + totalDesavantages
})

// Charger les données
onMounted(async () => {
  if (!personnageActif.value) return

  // Charger le personnage
  const { data: perso } = await client
    .from('personnages')
    .select('*')
    .eq('id', personnageActif.value.id)
    .single()

  if (perso) {
    personnageData.value = {
      ...perso,
      // S'assurer que les valeurs de base existent (pour les anciens personnages)
      constitution_base: perso.constitution_base ?? 2,
      volonte_base: perso.volonte_base ?? 2,
      force_base: perso.force_base ?? 2,
      perception_base: perso.perception_base ?? 3, // Shiba +1
      intelligence_base: perso.intelligence_base ?? 3, // Isawa +1
      agilite_base: perso.agilite_base ?? 2,
      reflexes_base: perso.reflexes_base ?? 2,
      intuition_base: perso.intuition_base ?? 2,
      vide_base: perso.vide_base ?? 2
    }
  }

  // Charger les compétences
  const { data: comps } = await client
    .from('competences')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (comps) {
    // Convertir les arrays de spécialisations en strings pour l'affichage
    competences.value = comps.map(comp => ({
      ...comp,
      specialisations: Array.isArray(comp.specialisations) 
        ? comp.specialisations.join(', ') 
        : comp.specialisations || ''
    }))
  }

  // Charger les avantages
  const { data: avts } = await client
    .from('avantages')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (avts) {
    avantages.value = avts
  }

  // Charger les armes
  const { data: arms } = await client
    .from('armes')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (arms) {
    armes.value = arms
  }

  // Charger les armures
  const { data: armrs } = await client
    .from('armures')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (armrs) {
    armures.value = armrs
  }

  // Charger les ressources
  const { data: ress } = await client
    .from('ressources')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (ress && ress.length > 0) {
    ress.forEach(r => {
      if (r.type === 'koku') ressources.value.koku = r.montant
      if (r.type === 'bu') ressources.value.bu = r.montant
      if (r.type === 'zeni') ressources.value.zeni = r.montant
    })
  }
})

// Calculer automatiquement les anneaux en fonction des traits
watch([
  () => personnageData.value.constitution,
  () => personnageData.value.volonte
], () => {
  personnageData.value.terre = Math.min(personnageData.value.constitution, personnageData.value.volonte)
})

watch([
  () => personnageData.value.force,
  () => personnageData.value.perception
], () => {
  personnageData.value.eau = Math.min(personnageData.value.force, personnageData.value.perception)
})

watch([
  () => personnageData.value.intelligence,
  () => personnageData.value.agilite
], () => {
  personnageData.value.feu = Math.min(personnageData.value.intelligence, personnageData.value.agilite)
})

watch([
  () => personnageData.value.reflexes,
  () => personnageData.value.intuition
], () => {
  personnageData.value.air = Math.min(personnageData.value.reflexes, personnageData.value.intuition)
})

// Sauvegarder le personnage
const sauvegarderPersonnage = async () => {
  if (!personnageActif.value) return
  
  await client
    .from('personnages')
    .update(personnageData.value)
    .eq('id', personnageActif.value.id)
}

// Compétences
const ajouterCompetence = async () => {
  const { data } = await client
    .from('competences')
    .insert({
      personnage_id: personnageActif.value.id,
      nom: '',
      rang: 0,
      trait: '',
      art: false
    })
    .select()
    .single()

  if (data) {
    competences.value.push(data)
  }
}

const sauvegarderCompetence = async (comp) => {
  // Convertir les spécialisations en array si c'est une string
  let competenceData = { ...comp }
  if (comp.specialisations && typeof comp.specialisations === 'string') {
    competenceData.specialisations = comp.specialisations.split(',').map(s => s.trim()).filter(s => s)
  }
  
  await client
    .from('competences')
    .update(competenceData)
    .eq('id', comp.id)
}

const supprimerCompetence = async (id) => {
  await client
    .from('competences')
    .delete()
    .eq('id', id)

  competences.value = competences.value.filter(c => c.id !== id)
}

// Avantages
const ajouterAvantage = async () => {
  const { data } = await client
    .from('avantages')
    .insert({
      personnage_id: personnageActif.value.id,
      nom: '',
      type: 'avantage',
      rang: 1
    })
    .select()
    .single()

  if (data) {
    avantages.value.push(data)
  }
}

const sauvegarderAvantage = async (avantage) => {
  await client
    .from('avantages')
    .update(avantage)
    .eq('id', avantage.id)
}

const supprimerAvantage = async (id) => {
  await client
    .from('avantages')
    .delete()
    .eq('id', id)

  avantages.value = avantages.value.filter(a => a.id !== id)
}

// Armes
const ajouterArme = async () => {
  const { data } = await client
    .from('armes')
    .insert({
      personnage_id: personnageActif.value.id,
      nom: '',
      type: '',
      prix: ''
    })
    .select()
    .single()

  if (data) {
    armes.value.push(data)
  }
}

const sauvegarderArme = async (arme) => {
  await client
    .from('armes')
    .update(arme)
    .eq('id', arme.id)
}

const supprimerArme = async (id) => {
  await client
    .from('armes')
    .delete()
    .eq('id', id)

  armes.value = armes.value.filter(a => a.id !== id)
}

// Armures
const ajouterArmure = async () => {
  const { data } = await client
    .from('armures')
    .insert({
      personnage_id: personnageActif.value.id,
      nom: '',
      type: '',
      prix: ''
    })
    .select()
    .single()

  if (data) {
    armures.value.push(data)
  }
}

const sauvegarderArmure = async (armure) => {
  await client
    .from('armures')
    .update(armure)
    .eq('id', armure.id)
}

const supprimerArmure = async (id) => {
  await client
    .from('armures')
    .delete()
    .eq('id', id)

  armures.value = armures.value.filter(a => a.id !== id)
}

// Ressources
const sauvegarderRessources = async () => {
  if (!personnageActif.value) return
  
  // Supprimer les anciennes ressources
  await client
    .from('ressources')
    .delete()
    .eq('personnage_id', personnageActif.value.id)

  // Insérer les nouvelles ressources
  const ressourcesData = []
  if (ressources.value.koku > 0) {
    ressourcesData.push({ personnage_id: personnageActif.value.id, type: 'koku', montant: ressources.value.koku })
  }
  if (ressources.value.bu > 0) {
    ressourcesData.push({ personnage_id: personnageActif.value.id, type: 'bu', montant: ressources.value.bu })
  }
  if (ressources.value.zeni > 0) {
    ressourcesData.push({ personnage_id: personnageActif.value.id, type: 'zeni', montant: ressources.value.zeni })
  }
  
  if (ressourcesData.length > 0) {
    await client
      .from('ressources')
      .insert(ressourcesData)
  }
}

// Modale détail XP dépensé
const modaleDepenseXP = ref(false)

const xpDetails = computed(() => {
  // Traits
  const traitsData = [
    { label: 'Constitution', valeur: personnageData.value.constitution, base: personnageData.value.constitution_base || 2 },
    { label: 'Volonté', valeur: personnageData.value.volonte, base: personnageData.value.volonte_base || 2 },
    { label: 'Force', valeur: personnageData.value.force, base: personnageData.value.force_base || 2 },
    { label: 'Perception', valeur: personnageData.value.perception, base: personnageData.value.perception_base || 2 },
    { label: 'Intelligence', valeur: personnageData.value.intelligence, base: personnageData.value.intelligence_base || 2 },
    { label: 'Agilité', valeur: personnageData.value.agilite, base: personnageData.value.agilite_base || 2 },
    { label: 'Réflexes', valeur: personnageData.value.reflexes, base: personnageData.value.reflexes_base || 2 },
    { label: 'Intuition', valeur: personnageData.value.intuition, base: personnageData.value.intuition_base || 2 }
  ]
  const traits = []
  traitsData.forEach(trait => {
    let xp = 0
    if (trait.valeur > trait.base) {
      for (let i = trait.base + 1; i <= trait.valeur; i++) {
        xp += i * 4
      }
    }
    if (xp > 0) traits.push({ label: trait.label, xp })
  })
  // Vide
  let videXP = 0
  const vide = personnageData.value.vide || 2
  const videBase = personnageData.value.vide_base || 2
  if (vide > videBase) {
    for (let i = videBase + 1; i <= vide; i++) {
      videXP += i * 6
    }
  }
  // Compétences
  const competencesList = []
  competences.value.forEach(comp => {
    const rang = comp.rang || 0
    let xp = 0
    if (rang > 0) {
      for (let i = 1; i <= rang; i++) {
        xp += i
      }
    }
    if (xp > 0) competencesList.push({ label: comp.nom || 'Compétence', xp })
  })
  // Avantages
  const avantagesList = avantages.value.filter(a => a.type === 'avantage' && a.rang > 0).map(a => ({ label: a.nom || 'Avantage', xp: a.rang }))
  // Désavantages
  const desavantagesList = avantages.value.filter(a => a.type === 'desavantage' && a.rang > 0).map(a => ({ label: a.nom || 'Désavantage', xp: a.rang }))
  return {
    traits,
    vide: videXP,
    competences: competencesList,
    avantages: avantagesList,
    desavantages: desavantagesList
  }
})
</script>

<style scoped>
</style>