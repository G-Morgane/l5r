<template>
  <PageWrapper :loading="loading" loading-message="Chargement des personnages..." :custom-background="true">
    <template #background>
      <img
        src="/background.png"
        alt="Japanese room background"
        class="w-full h-full object-cover"
      />
    </template>

    <!-- Sélection de personnage -->
    <div v-if="!personnageActif">
        <!-- Aucun personnage -->
        <div v-if="personnages.length === 0" class="text-center max-w-xl mx-auto">
          <div class="rounded-lg p-12 shadow-2xl relative" style="background-image: url('/cadre.png'); background-size: cover; background-position: center;">
            <div class="absolute inset-0 bg-amber-50/40 rounded-lg"></div>
            <div class="relative z-10">
              <div class="absolute -top-3 -left-3 w-6 h-6 bg-amber-900 rotate-45"></div>
              <div class="absolute -top-3 -right-3 w-6 h-6 bg-amber-900 rotate-45"></div>
              <div class="absolute -bottom-3 -left-3 w-6 h-6 bg-amber-900 rotate-45"></div>
              <div class="absolute -bottom-3 -right-3 w-6 h-6 bg-amber-900 rotate-45"></div>
              
              <div class="text-8xl mb-6">⚔️</div>
              <p class="text-stone-900 text-lg mb-8 font-bold drop-shadow-sm">Aucun personnage pour le moment</p>
              <button
                @click="afficherFormulaire = true"
                class="bg-gradient-to-b from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-amber-50 px-10 py-4 rounded-lg font-bold text-lg transition-all duration-300 shadow-lg border-2 border-red-950"
              >
                ⚔ Créer votre premier personnage
              </button>
            </div>
          </div>
        </div>

        <!-- Liste des personnages style parchemins -->
        <div v-else style="margin-top: 15vh">
          <div
            class="flex flex-wrap justify-center gap-6 w-full rounded-xl shadow-xl relative"
            style="background-image: url('/parchemin_header.png'); background-size: 100% 100%; background-position: center; background-repeat: no-repeat; height: 70vh;"
          >
            <div class="w-full flex flex-row flex-wrap justify-center items-center gap-10 h-full" style="position:relative; top:-50px;">
              <PersonnageCard
                v-for="perso in personnages"
                :key="perso.id"
                :personnage="perso"
                @select="selectionnerPersonnage"
              />
            </div>
          </div>

          <!-- Bouton créer nouveau personnage style parchemin -->
          <div class="flex justify-center">
            <button
              @click="afficherFormulaire = true"
              class="inline-block px-6 py-2 relative overflow-hidden"
            >
              <div class="absolute inset-0 rotate-180" style="background-image: url('/fond_bouton.png'); background-size: 100% 100%; background-repeat: no-repeat;"></div>
              <span class="text-lg text-red-800 font-bold relative z-10 drop-shadow-sm font-katana">✚ Créer un Nouveau Personnage</span>
            </button>
          </div>
        </div>

        <!-- Formulaire de création -->
        <PersonnageForm
          v-if="afficherFormulaire"
          :clans="clans"
          @submit="creerPersonnage"
          @close="afficherFormulaire = false"
        />
      </div>

    <!-- Menu principal avec personnage actif -->
    <div v-else style="margin-top: 30vh;">
      <!-- En-tête personnage style parchemin -->
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="deselectionnerPersonnage"
        @edit="ouvrirEdition"
      />

      <!-- Formulaire d'édition du personnage actif -->
      <PersonnageForm
        v-if="afficherFormulaireEdition"
        :clans="clans"
        :personnage="personnageActif"
        @submit="modifierPersonnage"
        @close="afficherFormulaireEdition = false"
      />
    </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const personnages = ref([])
const afficherFormulaire = ref(false)
const afficherFormulaireEdition = ref(false)
const loading = ref(true)

// Clans et familles de L5R
const clans = [
  { nom: 'Crabe', familles: ['Hida', 'Hiruma', 'Kaiu', 'Kuni', 'Yasuki'] },
  { nom: 'Grue', familles: ['Asahina', 'Daidoji', 'Doji', 'Kakita'] },
  { nom: 'Dragon', familles: ['Agasha', 'Kitsuki', 'Mirumoto', 'Togashi'] },
  { nom: 'Lion', familles: ['Akodo', 'Ikoma', 'Kitsu', 'Matsu'] },
  { nom: 'Phénix', familles: ['Asako', 'Isawa', 'Shiba'] },
  { nom: 'Scorpion', familles: ['Bayushi', 'Shosuro', 'Soshi', 'Yogo'] },
  { nom: 'Licorne', familles: ['Ide', 'Iuchi', 'Moto', 'Shinjo', 'Utaku'] },
  { nom: 'Mante', familles: ['Yoritomo', 'Moshi', 'Tsuruchi'] },
  { nom: 'Impérial', familles: ['Miya', 'Otomo', 'Seppun'] }
]

// Charger les personnages
const chargerPersonnages = async () => {
  loading.value = true
  try {
    const { data } = await client
      .from('personnages')
      .select('*')
      .order('created_at', { ascending: false })

    personnages.value = data || []
  } finally {
    loading.value = false
  }
}

const selectionnerPersonnage = (perso) => {
  personnageActif.value = perso
}

const deselectionnerPersonnage = () => {
  personnageActif.value = null
  navigateTo('/')
}

const creerPersonnage = async (formData) => {
  const { data, error } = await client
    .from('personnages')
    .insert([formData])
    .select()
    .single()

  if (!error && data) {
    personnages.value.unshift(data)
    afficherFormulaire.value = false
  }
}

const ouvrirEdition = () => {
  afficherFormulaireEdition.value = true
}

const modifierPersonnage = async (formData) => {
  if (!personnageActif.value) return

  const { data, error } = await client
    .from('personnages')
    .update(formData)
    .eq('id', personnageActif.value.id)
    .select()
    .single()

  if (!error && data) {
    // Mettre à jour le personnage actif
    personnageActif.value = data
    // Mettre à jour dans la liste des personnages
    const index = personnages.value.findIndex(p => p.id === data.id)
    if (index !== -1) {
      personnages.value[index] = data
    }
    afficherFormulaireEdition.value = false
  }
}

onMounted(() => {
  chargerPersonnages()
})
</script>

