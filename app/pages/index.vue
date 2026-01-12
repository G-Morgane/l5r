<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img 
        src="/background_selection.png" 
        alt="Japanese room background" 
        class="w-full h-full object-cover"
      />
      <!-- Overlay léger pour assurer la lisibilité -->
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 md:py-12 relative z-10">
      <!-- Sélection de personnage -->
      <div v-if="!personnageActif" class="max-w-7xl mx-auto">
        <!-- En-tête avec Torii et mon -->
        <div class="text-center mb-8 relative">
          
          <h1 class="text-5xl md:text-3xl mt-36 font-bold text-stone-900 mb-2 font-sakurata maxW500">
            Choisissez Votre Personnage
          </h1>
        </div>

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
        <div v-else>
          <div class="flex flex-wrap justify-center gap-6 mb-10 max-w-7xl mx-auto">
            <PersonnageCard
              v-for="perso in personnages"
              :key="perso.id"
              :personnage="perso"
              @select="selectionnerPersonnage"
            />
          </div>

          <!-- Bouton créer nouveau personnage style parchemin -->
          <div class="flex justify-center">
            <button
              @click="afficherFormulaire = true"
              class="inline-block px-6 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden"
            >
              <div class="absolute inset-0 rotate-180" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <span class="text-lg text-red-800 font-bold relative z-10 drop-shadow-sm">✚ Creer un Nouveau Personnage</span>
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
      <div v-else class="max-w-6xl mx-auto">
        <!-- En-tête personnage style parchemin -->
        <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="() => personnageActif = null"
        />

        <!-- Cartes de navigation style parchemin -->
        <div class="grid md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6">
          <NavigationCard
            link="/journal"
            emoji="📖"
            title="Journal de bord"
            description="Aventures et sessions"
          />

          <NavigationCard
            link="/wiki"
            emoji="📚"
            title="Wiki"
            description="Lieux, PNJ, événements"
          />

          <NavigationCard
            link="/profil"
            emoji="⚔️"
            title="Profil"
            description="Fiche de personnage"
          />

          <NavigationCard
            link="/inventaire"
            emoji="🎒"
            title="Inventaire"
            description="Équipement et trésor"
          />

          <NavigationCard
            link="/sorts"
            emoji="✨"
            title="Sorts"
            description="Magie et rituels"
          />
            <NavigationCard
            link="/histoire"
            emoji="📜"
            title="Histoire"
            description="Chronologie et récits"
          />
          
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const personnages = ref([])
const afficherFormulaire = ref(false)
const nouveauPerso = ref({
  nom: '',
  clan: '',
  famille: '',
  ecole: '',
  description: ''
})

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

const famillesDisponibles = computed(() => {
  const clanSelectionne = clans.find(c => c.nom === nouveauPerso.value.clan)
  return clanSelectionne ? clanSelectionne.familles : []
})

// Réinitialiser la famille quand on change de clan
watch(() => nouveauPerso.value.clan, () => {
  nouveauPerso.value.famille = ''
})

// Charger les personnages
const chargerPersonnages = async () => {
  const { data } = await client
    .from('personnages')
    .select('*')
    .order('created_at', { ascending: false })
  
  personnages.value = data || []
}

const selectionnerPersonnage = (perso) => {
  personnageActif.value = perso
}

const creerPersonnage = async () => {
  const { data, error } = await client
    .from('personnages')
    .insert([nouveauPerso.value])
    .select()
    .single()

  if (!error && data) {
    personnages.value.unshift(data)
    nouveauPerso.value = { nom: '', clan: '', famille: '', ecole: '', description: '' }
    afficherFormulaire.value = false
  }
}

onMounted(() => {
  chargerPersonnages()
})
</script>

<style scoped>
.maxW500 {
  max-width: 500px;
  margin-left: auto;
  margin-right: auto;
}
</style>
