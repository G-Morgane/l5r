<template>
  <PageWrapper :loading="loading" loading-message="Chargement de l'intrigue...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif || {}"
        @deselect="changeCharacter()"
        class="mb-6"
      />
    </template>

    <div v-if="intrigue">

      <!-- En-tete -->
      <div class="mb-8 w-full px-24">
        <div class="flex items-center justify-between mb-6">
          <div class="flex gap-4">
            <BackButton @click="$router.push('/intrigues')" blanc>Retour</BackButton>
            <BackButton @click="supprimerIntrigue">Supprimer</BackButton>
            <BackButton @click="ouvrirModalEdition">Modifier</BackButton>
          </div>
          <span
            class="px-4 py-2 rounded-full text-sm font-bold font-montserrat"
            :class="{
              'bg-amber-200 text-amber-900': intrigue.statut === 'en_cours',
              'bg-gray-200 text-gray-700': intrigue.statut === 'en_pause',
              'bg-green-200 text-green-900': intrigue.statut === 'resolue'
            }"
          >
            {{ getStatutLabel(intrigue.statut) }}
          </span>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 px-24">
        <!-- Description et Timeline -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Description -->
          <div class="relative border-4 border-amber-800 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
            <div class="relative z-10 p-6">
              <div class="flex items-center gap-4 mb-4">
                <img
                  :src="`/intrigues/${intrigue.image || 1}.png`"
                  :alt="intrigue.titre"
                  class="w-24 h-16 object-cover rounded-lg"
                />
                <div>
                  <h1 class="text-3xl font-bold text-stone-900 font-sakurata">{{ intrigue.titre }}</h1>
                  <p class="text-stone-600 text-sm font-montserrat">Creee le {{ formatDate(intrigue.created_at) }}</p>
                </div>
              </div>
              <div v-if="intrigue.description" class="text-stone-800 font-montserrat text-sm leading-relaxed">
                {{ intrigue.description }}
              </div>
              <p v-else class="text-stone-500 italic font-montserrat">Aucune description...</p>
            </div>
          </div>

          <!-- Timeline des evenements -->
          <div class="relative border-4 border-amber-800 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
            <div class="relative z-10 p-6">
              <div class="flex items-center justify-between mb-4">
                <h2 class="text-xl font-bold text-stone-900 font-sakurata">Chronologie</h2>
                <button
                  @click="ouvrirModalEvent()"
                  class="px-3 py-1 bg-amber-700 hover:bg-amber-600 text-white rounded-lg text-sm font-montserrat transition-colors"
                >
                  + Evenement
                </button>
              </div>

              <div v-if="events.length > 0">
                <div
                  v-for="event in eventsTries"
                  :key="event.id"
                  class="flex gap-4 group"
                >
                  <div class="flex flex-col items-center">
                    <div class="w-3 h-3 bg-amber-700 rounded-full"></div>
                    <div class="w-0.5 h-full bg-amber-700/30 flex-1"></div>
                  </div>
                  <div class="flex-1 pb-4">
                    <div class="flex items-start justify-between">
                      <div>
                        <p class="text-xs text-amber-700 font-montserrat font-bold">{{ formatDate(event.date_event) }}</p>
                        <p class="text-stone-800 font-montserrat text-sm mt-1">{{ event.description }}</p>
                      </div>
                      <div class="opacity-0 group-hover:opacity-100 transition-opacity flex gap-2">
                        <button
                          @click="ouvrirModalEvent(event)"
                          class="text-amber-700 hover:text-amber-900 text-xs"
                        >
                          Modifier
                        </button>
                        <button
                          @click="supprimerEvent(event.id)"
                          class="text-red-600 hover:text-red-800 text-xs"
                        >
                          Supprimer
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <p v-else class="text-stone-500 italic font-montserrat text-center py-4">
                Aucun evenement dans la chronologie
              </p>
            </div>
          </div>

          <!-- Pistes -->
          <div class="relative border-4 border-amber-800 bg-amber-50/30 before:absolute before:inset-0 before:border-2 before:border-amber-900 before:pointer-events-none">
            <div class="relative z-10 p-6">
              <div class="flex items-center justify-between mb-4">
                <h2 class="text-xl font-bold text-stone-900 font-sakurata">Pistes</h2>
                <button
                  @click="ouvrirModalPiste()"
                  class="px-3 py-1 bg-amber-700 hover:bg-amber-600 text-white rounded-lg text-sm font-montserrat transition-colors"
                >
                  + Piste
                </button>
              </div>

              <div v-if="pistesLiees.length > 0" class="space-y-3">
                <div
                  v-for="piste in pistesLiees"
                  :key="piste.id"
                  class="bg-white/50 rounded-lg p-4 border border-amber-900/20 group"
                >
                  <div class="flex items-start justify-between">
                    <div class="flex-1">
                      <h3 class="font-bold text-stone-900 font-montserrat">{{ piste.title }}</h3>
                      <p v-if="piste.description" class="text-stone-600 text-sm font-montserrat mt-1">{{ piste.description }}</p>
                    </div>
                    <div class="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                      <button
                        @click="ouvrirModalEditionPiste(piste)"
                        class="text-amber-700 hover:text-amber-900 text-sm"
                      >
                        Modifier
                      </button>
                      <button
                        @click="retirerLien(piste.link_id)"
                        class="text-red-600 hover:text-red-800"
                      >
                        x
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <p v-else class="text-stone-500 italic font-montserrat text-center py-4">
                Aucune piste liee
              </p>
            </div>
          </div>
        </div>

        <!-- Liens (Wiki + Journal) -->
        <div class="h-fit w-full relative overflow-hidden px-6 pt-16 pb-8" style="background-image: url('/parchemin_side.png'); background-size: 100% 100%; background-position: center; background-repeat: no-repeat;">
          <div class="relative z-10 ml-8">
            <!-- Ajouter des liens -->
            <div class="mb-6">
              <div class="relative flex gap-2 mb-3">
                <div class="relative flex-1 suggestions-container">
                  <input
                    v-model="rechercheLien"
                    type="text"
                    @input="filtrerSuggestions"
                    @focus="afficherSuggestions = true"
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat shadow-sm"
                    placeholder="Lier wiki, journal..."
                  />
                  <!-- Suggestions dropdown -->
                  <div
                    v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                    class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-xl shadow-2xl max-h-60 overflow-y-auto"
                  >
                    <button
                      v-for="(suggestion, index) in suggestionsFiltrees"
                      :key="index"
                      type="button"
                      @click="ajouterLien(suggestion)"
                      class="w-full px-4 py-2 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-2 border-b border-amber-900/10 last:border-b-0"
                    >
                      <span class="text-xs">{{ suggestion.emoji }}</span>
                      <span class="flex-1">{{ suggestion.nom }}</span>
                      <span class="text-xs text-stone-500 font-katana">{{ suggestion.typeLabel }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Liens Wiki -->
            <div v-if="wikiLies.length > 0" class="mb-4">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-2">Pages Wiki</h3>
              <div class="flex flex-wrap gap-2">
                <div
                  v-for="item in wikiLies"
                  :key="item.id"
                  class="inline-flex items-center gap-2 px-3 py-1 text-stone-800 font-montserrat text-sm font-medium transition-all group"
                  style="background-color: #EFB6A6"
                >
                  <NuxtLink :to="`/wiki/${item.slug}`" class="flex items-center gap-2 hover:underline">
                    {{ emojiParCategorie[item.categorie] || '📄' }} {{ item.nom }}
                  </NuxtLink>
                  <button
                    type="button"
                    @click="retirerLien(item.link_id)"
                    class="hover:text-red-700 transition-colors font-bold"
                  >
                    x
                  </button>
                </div>
              </div>
            </div>

            <!-- Liens Journal -->
            <div v-if="journalLies.length > 0" class="mb-4">
              <h3 class="text-sm font-bold text-stone-700 font-montserrat mb-2">Entrees de journal</h3>
              <div class="flex flex-wrap gap-2">
                <div
                  v-for="entree in journalLies"
                  :key="entree.id"
                  class="inline-flex items-center gap-2 px-3 py-1.5 bg-blue-100 text-blue-900 font-montserrat text-sm font-medium transition-all group"
                >
                  <NuxtLink :to="`/journal?entry=${entree.id}`" class="flex items-center gap-2 hover:underline">
                    {{ entree.titre }}
                  </NuxtLink>
                  <button
                    type="button"
                    @click="retirerLien(entree.link_id)"
                    class="hover:text-red-700 transition-colors font-bold"
                  >
                    x
                  </button>
                </div>
              </div>
            </div>

            <!-- Message si aucun lien -->
            <p v-if="wikiLies.length === 0 && journalLies.length === 0" class="text-stone-500 italic text-sm font-montserrat text-center py-4">
              Aucun lien pour le moment
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal edition intrigue -->
    <div v-if="afficherModalEdition" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherModalEdition = false">
      <div class="bg-amber-50 rounded-2xl max-w-2xl w-full border-4 border-amber-900/40 flex flex-col relative">
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
          <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
            <h3 class="text-2xl font-bold text-stone-900 font-manga">Modifier l'intrigue</h3>
            <button @click="afficherModalEdition = false" class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2">x</button>
          </div>
        </div>
        <div class="overflow-y-auto flex-1 p-6">
          <form @submit.prevent="sauvegarderIntrigue" class="space-y-6">
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Titre *</label>
              <input v-model="formulaireIntrigue.titre" type="text" required class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-sigokae text-lg" />
            </div>
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Description</label>
              <textarea v-model="formulaireIntrigue.description" rows="4" class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat"></textarea>
            </div>
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Statut</label>
              <select v-model="formulaireIntrigue.statut" class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat">
                <option value="en_cours">En cours</option>
                <option value="en_pause">En pause</option>
                <option value="resolue">Resolue</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Image</label>
              <div class="grid grid-cols-3 gap-4">
                <button v-for="i in 6" :key="i" type="button" @click="formulaireIntrigue.image = i" class="relative rounded-lg overflow-hidden transition-all duration-200" :class="formulaireIntrigue.image === i ? 'ring-4 ring-amber-600 scale-105' : 'opacity-70 hover:opacity-100'">
                  <img :src="`/intrigues/${i}.png`" :alt="`Image ${i}`" class="w-full h-20 object-cover" />
                </button>
              </div>
            </div>
            <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
              <button type="submit" class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 text-amber-50 font-katana">Enregistrer</button>
              <button type="button" @click="afficherModalEdition = false" class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana">Annuler</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Modal evenement -->
    <div v-if="afficherModalEvent" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherModalEvent = false">
      <div class="bg-amber-50 rounded-2xl max-w-lg w-full border-4 border-amber-900/40 flex flex-col relative">
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
            <h3 class="text-xl font-bold text-stone-900 font-manga">{{ eventEnEdition ? 'Modifier' : 'Nouvel' }} evenement</h3>
            <button @click="afficherModalEvent = false" class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2">x</button>
          </div>
        </div>
        <div class="p-6">
          <form @submit.prevent="sauvegarderEvent" class="space-y-4">
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Date</label>
              <input v-model="formulaireEvent.date_event" type="date" required class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" />
            </div>
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Description *</label>
              <textarea v-model="formulaireEvent.description" rows="3" required class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" placeholder="Que s'est-il passe ?"></textarea>
            </div>
            <div class="flex gap-4 pt-4">
              <button type="submit" class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-3 rounded-xl font-bold transition-all duration-300 text-amber-50 font-katana">Enregistrer</button>
              <button type="button" @click="afficherModalEvent = false" class="px-6 py-3 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana">Annuler</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Modal piste -->
    <div v-if="afficherModalPiste" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherModalPiste = false">
      <div class="bg-amber-50 rounded-2xl max-w-lg w-full border-4 border-amber-900/40 flex flex-col relative">
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
            <h3 class="text-xl font-bold text-stone-900 font-manga">Ajouter une piste</h3>
            <button @click="afficherModalPiste = false" class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2">x</button>
          </div>
        </div>
        <div class="p-6">
          <!-- Pistes existantes -->
          <div v-if="pistesDisponibles.length > 0" class="mb-6">
            <h4 class="text-sm font-semibold mb-3 text-stone-800 font-montserrat">Pistes existantes</h4>
            <div class="space-y-2 max-h-40 overflow-y-auto">
              <button
                v-for="piste in pistesDisponibles"
                :key="piste.id"
                type="button"
                @click="lierPiste(piste)"
                class="w-full text-left px-4 py-2 bg-white hover:bg-amber-100 rounded-lg border border-amber-900/20 transition-colors"
              >
                <span class="font-montserrat text-stone-900">{{ piste.title }}</span>
              </button>
            </div>
          </div>

          <div class="border-t border-amber-900/20 pt-6">
            <h4 class="text-sm font-semibold mb-3 text-stone-800 font-montserrat">Ou creer une nouvelle piste</h4>
            <form @submit.prevent="creerEtLierPiste" class="space-y-4">
              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Titre *</label>
                <input v-model="nouvellePiste.title" type="text" required class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" placeholder="Une nouvelle piste..." />
              </div>
              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Description</label>
                <textarea v-model="nouvellePiste.description" rows="2" class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" placeholder="Details..."></textarea>
              </div>
              <button type="submit" class="w-full bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-3 rounded-xl font-bold transition-all duration-300 text-amber-50 font-katana">Creer et lier</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal edition piste -->
    <div v-if="afficherModalEditionPiste" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherModalEditionPiste = false">
      <div class="bg-amber-50 rounded-2xl max-w-lg w-full border-4 border-amber-900/40 flex flex-col relative">
        <div class="relative overflow-hidden border-b-4 border-amber-900/20">
          <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
            <h3 class="text-xl font-bold text-stone-900 font-manga">Modifier la piste</h3>
            <button @click="afficherModalEditionPiste = false" class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2">x</button>
          </div>
        </div>
        <div class="p-6">
          <form @submit.prevent="sauvegarderPiste" class="space-y-4">
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Titre *</label>
              <input v-model="formulairePiste.title" type="text" required class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" />
            </div>
            <div>
              <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">Description</label>
              <textarea v-model="formulairePiste.description" rows="3" class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat" placeholder="Details..."></textarea>
            </div>
            <div class="flex gap-4 pt-4">
              <button type="submit" class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-3 rounded-xl font-bold transition-all duration-300 text-amber-50 font-katana">Enregistrer</button>
              <button type="button" @click="afficherModalEditionPiste = false" class="px-6 py-3 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana">Annuler</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const route = useRoute()
const router = useRouter()

const loading = ref(true)
const intrigue = ref(null)
const events = ref([])
const links = ref([])
const wikiItems = ref([])
const journalEntries = ref([])
const pistes = ref([])

const afficherModalEdition = ref(false)
const afficherModalEvent = ref(false)
const afficherModalPiste = ref(false)
const afficherModalEditionPiste = ref(false)
const afficherSuggestions = ref(false)
const rechercheLien = ref('')
const eventEnEdition = ref(null)
const pisteEnEdition = ref(null)

const formulaireIntrigue = ref({
  titre: '',
  description: '',
  statut: 'en_cours',
  image: 1
})

const formulaireEvent = ref({
  date_event: new Date().toISOString().split('T')[0],
  description: ''
})

const nouvellePiste = ref({
  title: '',
  description: ''
})

const formulairePiste = ref({
  title: '',
  description: ''
})

const emojiParCategorie = {
  'lieux': '🏯',
  'personnages': '👤',
  'clans': '⚔️',
  'autre': '📦'
}

onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await Promise.all([
        chargerIntrigue(),
        chargerWikiItems(),
        chargerJournalEntries(),
        chargerPistes()
      ])
    } finally {
      loading.value = false
    }

    document.addEventListener('click', (e) => {
      if (!e.target.closest('.suggestions-container')) {
        afficherSuggestions.value = false
      }
    })
  }
})

const chargerIntrigue = async () => {
  if (!personnageActif.value?.id) return

  const { data, error } = await client
    .from('intrigues')
    .select('*')
    .eq('id', route.params.id)
    .eq('personnage_id', personnageActif.value.id)
    .single()

  if (!error && data) {
    intrigue.value = data
    chargerEvents()
    chargerLinks()
  } else {
    navigateTo('/intrigues')
  }
}

const chargerEvents = async () => {
  const { data } = await client
    .from('intrigue_events')
    .select('*')
    .eq('intrigue_id', intrigue.value.id)
    .order('date_event', { ascending: true })

  events.value = data || []
}

const chargerLinks = async () => {
  const { data } = await client
    .from('intrigue_links')
    .select('*')
    .eq('intrigue_id', intrigue.value.id)

  links.value = data || []
}

const chargerWikiItems = async () => {
  if (!personnageActif.value?.id) return

  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  wikiItems.value = data || []
}

const chargerJournalEntries = async () => {
  if (!personnageActif.value?.id) return

  const { data } = await client
    .from('journal_entries')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('date_session', { ascending: false })

  journalEntries.value = data || []
}

const chargerPistes = async () => {
  const { data } = await client
    .from('pistes')
    .select('*')
    .order('created_at', { ascending: false })

  pistes.value = data || []
}

const eventsTries = computed(() => {
  return [...events.value].sort((a, b) => new Date(a.date_event) - new Date(b.date_event))
})

const wikiLies = computed(() => {
  const wikiLinks = links.value.filter(l => l.type === 'wiki')
  return wikiLinks.map(link => {
    const item = wikiItems.value.find(w => w.id === link.linked_id)
    return item ? { ...item, link_id: link.id } : null
  }).filter(Boolean)
})

const journalLies = computed(() => {
  const journalLinks = links.value.filter(l => l.type === 'journal')
  return journalLinks.map(link => {
    const entree = journalEntries.value.find(j => j.id === link.linked_id)
    return entree ? { ...entree, link_id: link.id } : null
  }).filter(Boolean)
})

const pistesLiees = computed(() => {
  const pisteLinks = links.value.filter(l => l.type === 'piste')
  return pisteLinks.map(link => {
    const piste = pistes.value.find(p => String(p.id) === String(link.linked_id))
    return piste ? { ...piste, link_id: link.id } : null
  }).filter(Boolean)
})

const pistesDisponibles = computed(() => {
  const liees = pistesLiees.value.map(p => p.id)
  return pistes.value.filter(p => !liees.includes(p.id))
})

const suggestionsFiltrees = computed(() => {
  const query = rechercheLien.value.toLowerCase().trim()
  const suggestions = []

  // Wiki items
  wikiItems.value.forEach(item => {
    const dejaLie = links.value.some(l => l.type === 'wiki' && l.linked_id === item.id)
    if (!dejaLie && (!query || item.nom.toLowerCase().includes(query))) {
      suggestions.push({
        id: item.id,
        nom: item.nom,
        type: 'wiki',
        typeLabel: 'Wiki',
        emoji: emojiParCategorie[item.categorie] || '📄'
      })
    }
  })

  // Journal entries
  journalEntries.value.forEach(entree => {
    const dejaLie = links.value.some(l => l.type === 'journal' && l.linked_id === entree.id)
    if (!dejaLie && (!query || entree.titre.toLowerCase().includes(query))) {
      suggestions.push({
        id: entree.id,
        nom: entree.titre,
        type: 'journal',
        typeLabel: 'Journal',
        emoji: '📖'
      })
    }
  })

  return suggestions.slice(0, 10)
})

const getStatutLabel = (statut) => {
  const labels = {
    'en_cours': 'En cours',
    'en_pause': 'En pause',
    'resolue': 'Resolue'
  }
  return labels[statut] || statut
}

const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const ouvrirModalEdition = () => {
  formulaireIntrigue.value = {
    titre: intrigue.value.titre,
    description: intrigue.value.description || '',
    statut: intrigue.value.statut || 'en_cours',
    image: intrigue.value.image || 1
  }
  afficherModalEdition.value = true
}

const sauvegarderIntrigue = async () => {
  const { error } = await client
    .from('intrigues')
    .update({
      titre: formulaireIntrigue.value.titre,
      description: formulaireIntrigue.value.description,
      statut: formulaireIntrigue.value.statut,
      image: formulaireIntrigue.value.image,
      updated_at: new Date().toISOString()
    })
    .eq('id', intrigue.value.id)

  if (!error) {
    await chargerIntrigue()
    afficherModalEdition.value = false
  }
}

const supprimerIntrigue = async () => {
  if (!confirm(`Supprimer "${intrigue.value.titre}" ?`)) return

  // Supprimer les liens et events
  await client.from('intrigue_links').delete().eq('intrigue_id', intrigue.value.id)
  await client.from('intrigue_events').delete().eq('intrigue_id', intrigue.value.id)

  const { error } = await client
    .from('intrigues')
    .delete()
    .eq('id', intrigue.value.id)

  if (!error) {
    router.push('/intrigues')
  }
}

const ouvrirModalEvent = (event = null) => {
  if (event) {
    eventEnEdition.value = event
    formulaireEvent.value = {
      date_event: event.date_event,
      description: event.description
    }
  } else {
    eventEnEdition.value = null
    formulaireEvent.value = {
      date_event: new Date().toISOString().split('T')[0],
      description: ''
    }
  }
  afficherModalEvent.value = true
}

const sauvegarderEvent = async () => {
  if (eventEnEdition.value) {
    const { error } = await client
      .from('intrigue_events')
      .update({
        date_event: formulaireEvent.value.date_event,
        description: formulaireEvent.value.description
      })
      .eq('id', eventEnEdition.value.id)

    if (!error) {
      await chargerEvents()
      afficherModalEvent.value = false
    }
  } else {
    const { error } = await client
      .from('intrigue_events')
      .insert([{
        intrigue_id: intrigue.value.id,
        date_event: formulaireEvent.value.date_event,
        description: formulaireEvent.value.description,
        ordre: events.value.length
      }])

    if (!error) {
      await chargerEvents()
      afficherModalEvent.value = false
    }
  }
}

const supprimerEvent = async (eventId) => {
  if (!confirm('Supprimer cet evenement ?')) return

  const { error } = await client
    .from('intrigue_events')
    .delete()
    .eq('id', eventId)

  if (!error) {
    await chargerEvents()
  }
}

const filtrerSuggestions = () => {
  afficherSuggestions.value = true
}

const ajouterLien = async (suggestion) => {
  const { error } = await client
    .from('intrigue_links')
    .insert([{
      intrigue_id: intrigue.value.id,
      type: suggestion.type,
      linked_id: suggestion.id
    }])

  if (!error) {
    await chargerLinks()
    rechercheLien.value = ''
    afficherSuggestions.value = false
  }
}

const retirerLien = async (linkId) => {
  const { error } = await client
    .from('intrigue_links')
    .delete()
    .eq('id', linkId)

  if (!error) {
    await chargerLinks()
  }
}

const ouvrirModalPiste = () => {
  nouvellePiste.value = { title: '', description: '' }
  afficherModalPiste.value = true
}

const lierPiste = async (piste) => {
  const { error } = await client
    .from('intrigue_links')
    .insert([{
      intrigue_id: intrigue.value.id,
      type: 'piste',
      linked_id: piste.id
    }])

  if (!error) {
    await chargerLinks()
    afficherModalPiste.value = false
  }
}

const creerEtLierPiste = async () => {
  // Creer la piste
  const { data: newPiste, error: pisteError } = await client
    .from('pistes')
    .insert([{
      title: nouvellePiste.value.title,
      description: nouvellePiste.value.description
    }])
    .select()
    .single()

  if (pisteError || !newPiste) return

  // Lier a l'intrigue
  await client
    .from('intrigue_links')
    .insert([{
      intrigue_id: intrigue.value.id,
      type: 'piste',
      linked_id: newPiste.id
    }])

  await chargerPistes()
  await chargerLinks()
  afficherModalPiste.value = false
}

const changeCharacter = () => {
  navigateTo('/')
}

const ouvrirModalEditionPiste = (piste) => {
  pisteEnEdition.value = piste
  formulairePiste.value = {
    title: piste.title,
    description: piste.description || ''
  }
  afficherModalEditionPiste.value = true
}

const sauvegarderPiste = async () => {
  if (!pisteEnEdition.value?.id) return

  const { error } = await client
    .from('pistes')
    .update({
      title: formulairePiste.value.title,
      description: formulairePiste.value.description
    })
    .eq('id', pisteEnEdition.value.id)

  if (!error) {
    await chargerPistes()
    afficherModalEditionPiste.value = false
    pisteEnEdition.value = null
  }
}
</script>
