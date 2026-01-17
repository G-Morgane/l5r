<template>
  <PageWrapper :loading="loading" loading-message="Chargement du journal...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

      <div class="flex flex-col">

        <!-- Bouton créer nouvelle entrée et Barre de recherche -->
        <div class="mb-2 flex gap-4 items-center px-38">
          <div class="relative flex-1">
            <div class="relative rounded-xl overflow-hidden">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <input 
                v-model="searchQuery"
                type="text"
                placeholder="🔍 Rechercher..."
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
           <BackButton @click="startCreation">Nouveau</BackButton>
        </div>
      </div>

      <!-- Liste des entrées -->
      <div class="flex-1 overflow-y-auto px-32">
        <div v-if="entriesFiltrees.length === 0 && searchQuery" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
              <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
            </div>
          </div>
        </div>
        <div v-else-if="entries.length === 0" class="text-center py-12">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune entrée pour le moment</p>
              <p class="text-stone-600 font-montserrat">Commencez à documenter vos aventures !</p>
            </div>
          </div>
        </div>
        <div v-else class="grid grid-cols-2 gap-4 px-4 max-h-[30vh] overflow-y-auto">
          <div
            v-for="(entry, index) in entriesFiltrees"
            :key="entry.id"
            class="rounded-xl p-4 relative overflow-hidden cursor-pointer"
            @click="selectEntry(entry)"
          >
            <div class="absolute inset-0" :style="`background-image: url('${getRandomJournalImage(index)}'); background-size: 100% 100%; background-position: center;`"></div>
            <div class="relative z-10">
              <div class="flex flex-col items-center mb-3">
                <h3 class="text-lg font-bold text-black font-manga text-center">{{ entry.titre }}</h3>
                <span class="text-sm text-black font-montserrat">{{ formatDate(entry.date_session) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Modal formulaire -->
      <div v-if="afficherFormulaire" class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50" @click.self="afficherFormulaire = false">
        <div class="bg-amber-50 rounded-2xl max-w-5xl w-full border-4 border-amber-900/40 flex flex-col relative">
          <!-- En-tête avec fond -->
          <div class="relative overflow-hidden border-b-4 border-amber-900/20">
            <div class="absolute inset-0 opacity-20" style="background-image: url('/cadre.png'); background-size: cover;"></div>
            <div class="relative px-8 py-6 flex items-center justify-between bg-gradient-to-r from-amber-100 to-amber-50">
              <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                <span class="text-xl">{{ entreeEnEdition ? '✏️' : '📖' }}</span>
                {{ entreeEnEdition ? 'Modifier l\'entrée' : 'Nouvelle entrée de journal' }}
              </h3>
              <button 
                @click="afficherFormulaire = false" 
                class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 rounded-lg"
                type="button"
              >
                ×
              </button>
            </div>
          </div>

          <!-- Contenu scrollable -->
          <div class="overflow-y-auto flex-1">
            <form @submit.prevent="creerEntree" class="space-y-6">
              <div class="grid md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📜 Titre de la session *</label>
                  <input 
                    v-model="nouvelleEntree.titre" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-lg" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-3 transition-all outline-none text-stone-900 font-montserrat"
                  />
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">🏷️ Tags (Personnages, Lieux, Événements)</label>
                <div class="relative flex gap-2 mb-3">
                  <div class="relative flex-1 suggestions-container">
                    <input 
                      v-model="nouveauTag" 
                      type="text" 
                      @keyup.enter="ajouterTag"
                      @input="filtrerSuggestions"
                      @focus="afficherSuggestions = true"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-xl px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat" 
                      placeholder="Ajouter un tag (ex: Hida Takeshi, Château du Crabe...)"
                    />
                    <!-- Suggestions dropdown -->
                    <div 
                      v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                      class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-xl overflow-y-auto"
                    >
                      <button
                        v-for="(suggestion, index) in suggestionsFiltrees"
                        :key="index"
                        type="button"
                        @click="selectionnerSuggestion(suggestion)"
                        class="w-full px-4 py-2 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-2 border-b border-amber-900/10 last:border-b-0"
                      >
                        <span class="text-xs">{{ suggestion.emoji }}</span>
                        <span class="flex-1">{{ suggestion.nom }}</span>
                        <span v-if="suggestion.type === 'wiki'" class="text-xs text-stone-500 font-katana">Wiki</span>
                        <span v-else class="text-xs text-stone-500 font-katana">Tag</span>
                      </button>
                    </div>
                  </div>
                  <button 
                    type="button"
                    @click="ajouterTag"
                    class="px-4 py-2 bg-amber-700 hover:bg-amber-600 text-white rounded-xl font-semibold transition-colors font-katana"
                  >
                    + Ajouter
                  </button>
                </div>
                <div v-if="nouvelleEntree.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
                  <span 
                    v-for="(tag, index) in nouvelleEntree.tags" 
                    :key="index"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-amber-200 text-stone-800 rounded-lg font-montserrat text-sm font-medium"
                  >
                    🏷️ {{ tag }}
                    <button 
                      type="button"
                      @click="retirerTag(index)"
                      class="hover:text-red-700 transition-colors font-bold"
                    >
                      ×
                    </button>
                  </span>
                </div>
              </div>
              
              <!-- Section changements XP et autres valeurs -->
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">📊 Changements de valeurs</label>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4 p-4 bg-amber-50/50 rounded-xl border-2 border-amber-900/20">
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">XP</label>
                    <input 
                      v-model.number="nouvelleEntree.xp_change" 
                      type="number" 
                      step="1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Honneur</label>
                    <input 
                      v-model.number="nouvelleEntree.honneur_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Gloire</label>
                    <input 
                      v-model.number="nouvelleEntree.gloire_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Statut</label>
                    <input 
                      v-model.number="nouvelleEntree.statut_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Souillure</label>
                    <input 
                      v-model.number="nouvelleEntree.souillure_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                </div>
                <p class="text-xs text-stone-600 mt-2 font-montserrat">Entrez les valeurs gagnées (+) ou perdues (-) lors de cette session</p>
              </div>
              
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">✍️ Récit de la session *</label>
                <RichTextEditor 
                  v-model="nouvelleEntree.contenu" 
                  placeholder="Racontez votre aventure... Utilisez les outils pour formater votre texte, ajouter des titres, des listes, etc."
                />
              </div>

              <div class="flex gap-4 pt-6 border-t-2 border-amber-900/20">
                <button 
                  type="submit" 
                  class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4 rounded-xl font-bold text-lg transition-all duration-300 text-amber-50 flex items-center justify-center gap-2 font-katana"
                >
                  <span class="text-xl">📝</span>
                  Enregistrer l'entrée
                </button>
                <button 
                  type="button" 
                  @click="afficherFormulaire = false" 
                  class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30 rounded-xl font-semibold transition-all duration-300 text-stone-800 font-katana"
                >
                  Annuler
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Drawer détail -->
      <div v-if="entreeSelectionnee || createMode" class="fixed inset-0 z-50 flex" @click.self="closeDrawer">
        <!-- Overlay -->
        <div @click="closeDrawer" class="absolute inset-0 bg-black/30 backdrop-blur-sm"></div>

        <!-- Drawer Panel -->
        <div class="relative ml-auto w-[60vw] h-full border-l-4 border-amber-800 bg-amber-50/95 backdrop-blur-md">
          <div class="relative z-10 p-4 h-full flex flex-col pl-8">
            <!-- Header -->
            <div class="flex items-start justify-between mb-6 pb-4 border-b-2 border-amber-800/30">
              <div v-if="drawerMode === 'view'">
                <h3 class="text-2xl font-bold text-stone-900 font-manga mb-2">{{ entreeSelectionnee.titre }}</h3>
                <p class="text-sm text-stone-700 font-montserrat">📅 {{ formatDate(entreeSelectionnee.date_session) }}</p>
              </div>
              <div v-else-if="createMode || entreeEnEdition">
                <h3 class="text-2xl font-bold text-stone-900 font-manga flex items-center gap-3">
                  <span class="text-xl">{{ entreeEnEdition ? '✏️' : '📖' }}</span>
                  {{ entreeEnEdition ? 'Modifier l\'entrée' : 'Nouvelle entrée' }}
                </h3>
              </div>

              <button
                @click="closeDrawer"
                class="text-stone-600 hover:text-stone-900 font-bold text-2xl"
              >
                ×
              </button>
            </div>

          <!-- Contenu -->
          <div v-if="drawerMode === 'view'" class="overflow-y-auto flex-1 flex flex-col gap-4">
            <div v-if="entreeSelectionnee.tags && entreeSelectionnee.tags.length > 0" class="flex flex-wrap gap-2">
                  <NuxtLink
                    v-for="(tag, index) in entreeSelectionnee.tags" 
                    :key="index"
                    :to="getWikiItemByName(tag)?.slug ? `/wiki/${getWikiItemByName(tag).slug}` : `/wiki?create=${encodeURIComponent(tag)}`"
                    class="inline-flex items-center gap-1 px-3 py-1 bg-amber-300/70 hover:bg-amber-400 text-stone-800 rounded-lg font-montserrat text-sm font-medium transition-all"
                  >
                    {{ getTagEmoji(tag) }} {{ tag }}
                  </NuxtLink>
                </div>

            <!-- Section changements de valeurs -->
            <div v-if="hasStatChanges(entreeSelectionnee)">
              <div class="flex flex-row flex-wrap gap-2 text-xs font-montserrat">
                <div v-if="entreeSelectionnee.xp_change !== 0" class="bg-blue-50 px-2 py-2">
                  <span class=" text-sm">XP :</span>
                  <span :class="entreeSelectionnee.xp_change > 0 ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ entreeSelectionnee.xp_change > 0 ? ' +' : '' }}{{ entreeSelectionnee.xp_change }}
                  </span>
                </div>

                <div v-if="entreeSelectionnee.honneur_change !== 0" class="bg-yellow-50 px-2 py-2">
                  <span class=" text-sm">Honneur :</span>
                  <span :class="entreeSelectionnee.honneur_change > 0 ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ entreeSelectionnee.honneur_change > 0 ? ' +' : '' }}{{ entreeSelectionnee.honneur_change }}
                  </span>
                </div>

                <div v-if="entreeSelectionnee.gloire_change !== 0" class="bg-purple-50 px-2 py-2">
                  <span class=" text-sm">Gloire :</span>
                  <span :class="entreeSelectionnee.gloire_change > 0 ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ entreeSelectionnee.gloire_change > 0 ? '+' : '' }}{{ entreeSelectionnee.gloire_change }}
                  </span>
                </div>

                <div v-if="entreeSelectionnee.statut_change !== 0" class="bg-green-50 px-2 py-2">
                  <span class=" text-sm">Statut : </span>
                  <span :class="entreeSelectionnee.statut_change > 0 ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ entreeSelectionnee.statut_change > 0 ? '+' : '' }}{{ entreeSelectionnee.statut_change }}
                  </span>
                </div>

                <div v-if="entreeSelectionnee.souillure_change !== 0" class="bg-red-50 px-2 py-2">
                  <span class=" text-sm">Souillure : </span>
                  <span :class="entreeSelectionnee.souillure_change > 0 ? 'text-green-600' : 'text-red-600'" class="font-bold">
                    {{ entreeSelectionnee.souillure_change > 0 ? '+' : '' }}{{ entreeSelectionnee.souillure_change }}
                  </span>
                </div>
              </div>
            </div>

            <div class="prose prose-stone max-w-none text-stone-900 font-montserrat leading-relaxed journal-content text-sm">
              <MarkdownPreview :content="entreeSelectionnee.contenu" />
            </div>
          </div>

          <!-- Formulaire d'édition -->
          <div v-else class="overflow-y-auto flex-1">
            <form id="edit-form" @submit.prevent="creerEntree" class="space-y-4">
              <div class="grid md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">📜 Titre de la session *</label>
                  <input 
                    v-model="nouvelleEntree.titre" 
                    type="text" 
                    required 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-sm" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 font-montserrat text-sm"
                  />
                </div>
              </div>
              <div>
                <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">🏷️ Tags</label>
                <div class="relative suggestions-container">
                  <div class="flex gap-2">
                    <input 
                      v-model="nouveauTag" 
                      @keydown.enter.prevent="ajouterTag"
                      @input="filtrerSuggestions"
                      @focus="afficherSuggestions = true"
                      type="text" 
                      class="flex-1 bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-sm" 
                      placeholder="Ajouter un tag..."
                    />
                  </div>
                  <!-- Suggestions dropdown -->
                  <div 
                    v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                    class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30 rounded-lg overflow-y-auto"
                  >
                    <button
                      v-for="(suggestion, index) in suggestionsFiltrees"
                      :key="index"
                      type="button"
                      @click="selectionnerSuggestion(suggestion)"
                      class="w-full px-2 py-1 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-2 border-b border-amber-900/10 last:border-b-0 text-xs"
                    >
                      <span class="text-xs">{{ suggestion.emoji }}</span>
                      <span class="flex-1">{{ suggestion.nom }}</span>
                      <span v-if="suggestion.type === 'wiki'" class="text-xs text-stone-500 font-katana">Wiki</span>
                      <span v-else class="text-xs text-stone-500 font-katana">Tag</span>
                    </button>
                  </div>
                </div>
                <div v-if="nouvelleEntree.tags.length > 0" class="flex flex-wrap gap-2 mt-2">
                  <span 
                    v-for="(tag, index) in nouvelleEntree.tags" 
                    :key="index"
                    class="inline-flex items-center gap-1 px-1 py-0.5 bg-amber-300/70 text-stone-800 rounded font-montserrat text-xs font-medium"
                  >
                    {{ tag }}
                    <button @click="retirerTag(index)" class="text-stone-600 hover:text-stone-800 ml-1">×</button>
                  </span>
                </div>
              </div>
              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📖 Contenu *</label>
                <RichTextEditor v-model="nouvelleEntree.contenu" />
              </div>

              <!-- Section changements XP et autres valeurs -->
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">📊 Changements de valeurs</label>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4 p-4 bg-amber-50/50 rounded-xl border-2 border-amber-900/20">
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">XP</label>
                    <input 
                      v-model.number="nouvelleEntree.xp_change" 
                      type="number" 
                      step="1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Honneur</label>
                    <input 
                      v-model.number="nouvelleEntree.honneur_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Gloire</label>
                    <input 
                      v-model.number="nouvelleEntree.gloire_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Statut</label>
                    <input 
                      v-model.number="nouvelleEntree.statut_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Souillure</label>
                    <input 
                      v-model.number="nouvelleEntree.souillure_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700 rounded-lg px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                </div>
                <p class="text-xs text-stone-600 mt-2 font-montserrat">Entrez les valeurs gagnées (+) ou perdues (-) lors de cette session</p>
              </div>
            </form>
          </div>

          <!-- Actions -->
          <div class="mt-6 pt-4 border-t-2 border-amber-800/30 flex justify-between items-center">
            <div v-if="drawerMode === 'view'" class="flex gap-4">
              <button
                @click="modifierEntree(entreeSelectionnee)"
                class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat rounded-lg"
              >
                ✏️ Modifier
              </button>
              <button
                @click="supprimerEntree(entreeSelectionnee.id)"
                class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat rounded-lg"
              >
                🗑️ Supprimer
              </button>
            </div>

            <div v-else class="flex gap-4">
              <button
                @click="creerEntree"
                class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat rounded-lg"
              >
                💾 Sauvegarder
              </button>
              <button
                @click="closeDrawer"
                class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white font-medium transition-colors flex items-center gap-2 font-montserrat rounded-lg"
              >
                Annuler
              </button>
            </div>
          </div>
          </div>
        </div>
      </div>
  </PageWrapper>
</template>

<script setup>
const client = useSupabaseClient()
const personnageActif = usePersonnageActif()
const route = useRoute()

const loading = ref(true)
const entries = ref([])
const afficherFormulaire = ref(false)
const entreeSelectionnee = ref(null)
const drawerMode = ref('view') // 'view' or 'edit'
const createMode = ref(false)
const entreeEnEdition = ref(null)
const nouveauTag = ref('')
const searchQuery = ref('')
const afficherSuggestions = ref(false)
const wikiItems = ref([])
const tagsExistants = ref([])
const nouvelleEntree = ref({
  titre: '',
  contenu: '',
  date_session: new Date().toISOString().split('T')[0],
  tags: [],
  xp_change: 0,
  honneur_change: 0,
  gloire_change: 0,
  statut_change: 0,
  souillure_change: 0
})

// Rediriger si pas de personnage actif
onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await Promise.all([chargerEntrees(), chargerWikiItems()])
    } finally {
      loading.value = false
    }

    // Fermer les suggestions au clic en dehors
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.suggestions-container')) {
        afficherSuggestions.value = false
      }
    })
  }
})

const chargerEntrees = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('journal_entries')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
    .order('created_at', { ascending: false })
  
  entries.value = data || []
  
  // Extraire tous les tags uniques des entrées
  const allTags = new Set()
  entries.value.forEach(entry => {
    if (entry.tags) {
      entry.tags.forEach(tag => allTags.add(tag))
    }
  })
  tagsExistants.value = Array.from(allTags)
  
  // Si on a un paramètre entry dans l'URL, ouvrir cette entrée
  const entryId = route.query.entry
  if (entryId) {
    const entry = entries.value.find(e => e.id === entryId)
    if (entry) {
      entreeSelectionnee.value = entry
    }
  }
}

const chargerWikiItems = async () => {
  if (!personnageActif.value?.id) return
  
  const { data } = await client
    .from('wiki_items')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)
  
  wikiItems.value = data || []
}

const entriesFiltrees = computed(() => {
  if (!searchQuery.value.trim()) return entries.value
  
  const query = searchQuery.value.toLowerCase()
  return entries.value.filter(entry => {
    const titreMatch = entry.titre?.toLowerCase().includes(query)
    const contenuMatch = entry.contenu?.toLowerCase().includes(query)
    const tagsMatch = entry.tags?.some(tag => tag.toLowerCase().includes(query))
    const dateMatch = formatDate(entry.date_session)?.toLowerCase().includes(query)
    return titreMatch || contenuMatch || tagsMatch || dateMatch
  })
})

// Emojis par catégorie
const emojiParCategorie = {
  'lieux': '🏯',
  'personnages': '👤',
  'clans': '⚔️',
  'autre': '📦'
}

// Suggestions combinées du wiki et des tags existants
const suggestionsFiltrees = computed(() => {
  const query = nouveauTag.value.toLowerCase().trim()
  
  if (!query) {
    // Si pas de recherche, afficher toutes les suggestions
    const suggestions = []
    
    // Ajouter les items du wiki
    wikiItems.value.forEach(item => {
      if (!nouvelleEntree.value.tags.includes(item.nom)) {
        suggestions.push({
          nom: item.nom,
          type: 'wiki',
          emoji: emojiParCategorie[item.categorie] || '🏷️'
        })
      }
    })
    
    // Ajouter les tags existants
    tagsExistants.value.forEach(tag => {
      if (!nouvelleEntree.value.tags.includes(tag) && !suggestions.find(s => s.nom === tag)) {
        suggestions.push({
          nom: tag,
          type: 'tag',
          emoji: '🏷️'
        })
      }
    })
    
    return suggestions.slice(0, 10)
  }
  
  const suggestions = []
  
  // Filtrer les items du wiki
  wikiItems.value.forEach(item => {
    if (item.nom.toLowerCase().includes(query) && !nouvelleEntree.value.tags.includes(item.nom)) {
      suggestions.push({
        nom: item.nom,
        type: 'wiki',
        emoji: emojiParCategorie[item.categorie] || '🏷️'
      })
    }
  })
  
  // Filtrer les tags existants
  tagsExistants.value.forEach(tag => {
    if (tag.toLowerCase().includes(query) && !nouvelleEntree.value.tags.includes(tag) && !suggestions.find(s => s.nom === tag)) {
      suggestions.push({
        nom: tag,
        type: 'tag',
        emoji: '🏷️'
      })
    }
  })
  
  return suggestions.slice(0, 10)
})

const creerEntree = async () => {
  if (!personnageActif.value?.id) return

  console.log('coucou')
  
  // Fermer les suggestions
  afficherSuggestions.value = false
  
  // Si on est en mode édition
  if (entreeEnEdition.value) {
    const { data, error } = await client
      .from('journal_entries')
      .update(nouvelleEntree.value)
      .eq('id', entreeEnEdition.value.id)
      .select()
      .single()

    if (!error && data) {
      // Appliquer les changements aux valeurs du personnage
      await appliquerChangementsPersonnage(nouvelleEntree.value)
      
      const index = entries.value.findIndex(e => e.id === data.id)
      if (index !== -1) entries.value[index] = data
      nouvelleEntree.value = {
        titre: '',
        contenu: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: [],
        xp_change: 0,
        honneur_change: 0,
        gloire_change: 0,
        statut_change: 0,
        souillure_change: 0
      }
      afficherFormulaire.value = false
      entreeEnEdition.value = null
      drawerMode.value = 'view'
      entreeSelectionnee.value = data
      // Recharger pour mettre à jour les tags existants
      await chargerEntrees()
    }
  } else {
    // Mode création
    const { data, error } = await client
      .from('journal_entries')
      .insert([{
        personnage_id: personnageActif.value.id,
        ...nouvelleEntree.value
      }])
      .select()
      .single()

    if (!error && data) {
      // Appliquer les changements aux valeurs du personnage
      await appliquerChangementsPersonnage(nouvelleEntree.value)
      
      entries.value.unshift(data)
      nouvelleEntree.value = {
        titre: '',
        contenu: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: [],
        xp_change: 0,
        honneur_change: 0,
        gloire_change: 0,
        statut_change: 0,
        souillure_change: 0
      }
      afficherFormulaire.value = false
      closeDrawer()
      // Recharger pour mettre à jour les tags existants
      await chargerEntrees()
    }
  }
}

const changeCharacter = () => {
  personnageActif.value = null
  navigateTo('/')
}

const startCreation = () => {
  createMode.value = true
  drawerMode.value = 'edit'
  entreeSelectionnee.value = null
  nouvelleEntree.value = {
    titre: '',
    contenu: '',
    date_session: new Date().toISOString().split('T')[0],
    tags: [],
    xp_change: 0,
    honneur_change: 0,
    gloire_change: 0,
    statut_change: 0,
    souillure_change: 0
  }
  afficherSuggestions.value = false
  nouveauTag.value = ''
}

const selectEntry = (entry) => {
  entreeSelectionnee.value = entry
  drawerMode.value = 'view'
  createMode.value = false
}

const closeDrawer = () => {
  entreeSelectionnee.value = null
  createMode.value = false
  drawerMode.value = 'view'
}

const modifierEntree = (entry) => {
  entreeEnEdition.value = entry
  nouvelleEntree.value = {
    titre: entry.titre,
    contenu: entry.contenu,
    date_session: entry.date_session,
    tags: entry.tags || [],
    xp_change: entry.xp_change || 0,
    honneur_change: entry.honneur_change || 0,
    gloire_change: entry.gloire_change || 0,
    statut_change: entry.statut_change || 0,
    souillure_change: entry.souillure_change || 0
  }
  drawerMode.value = 'edit'
  afficherSuggestions.value = false
}

const ajouterTag = () => {
  if (nouveauTag.value.trim() && !nouvelleEntree.value.tags.includes(nouveauTag.value.trim())) {
    nouvelleEntree.value.tags.push(nouveauTag.value.trim())
    nouveauTag.value = ''
    afficherSuggestions.value = false
  }
}

const selectionnerSuggestion = (suggestion) => {
  if (!nouvelleEntree.value.tags.includes(suggestion.nom)) {
    nouvelleEntree.value.tags.push(suggestion.nom)
    nouveauTag.value = ''
    afficherSuggestions.value = false
  }
}

const filtrerSuggestions = () => {
  afficherSuggestions.value = true
}

const retirerTag = (index) => {
  nouvelleEntree.value.tags.splice(index, 1)
}

const supprimerEntree = async (id) => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette entrée ?')) return
  
  const { error } = await client
    .from('journal_entries')
    .delete()
    .eq('id', id)

  if (!error) {
    entries.value = entries.value.filter(e => e.id !== id)
    entreeSelectionnee.value = null
    
    // Recalculer les stats du personnage après suppression
    await recalculerStatsPersonnage()
  }
}

const appliquerChangementsPersonnage = async (changements) => {
  if (!personnageActif.value?.id) return

  // Récupérer les données actuelles du personnage
  const { data: perso } = await client
    .from('personnages')
    .select('*')
    .eq('id', personnageActif.value.id)
    .single()

  if (!perso) return

  // Calculer les nouvelles valeurs
  const nouvellesValeurs = {
    experience_points: (perso.experience_points || 0) + (changements.xp_change || 0),
    honneur: Math.max(0, Math.min(10, (perso.honneur || 5) + (changements.honneur_change || 0))),
    gloire: Math.max(0, Math.min(10, (perso.gloire || 0) + (changements.gloire_change || 0))),
    statut_social: Math.max(0, Math.min(10, (perso.statut_social || 1) + (changements.statut_change || 0))),
    souillure: Math.max(0, Math.min(10, (perso.souillure || 0) + (changements.souillure_change || 0)))
  }

  // Mettre à jour le personnage
  await client
    .from('personnages')
    .update(nouvellesValeurs)
    .eq('id', personnageActif.value.id)
}

const recalculerStatsPersonnage = async () => {
  if (!personnageActif.value?.id) return

  // Récupérer toutes les entrées de journal du personnage
  const { data: entries } = await client
    .from('journal_entries')
    .select('xp_change, honneur_change, gloire_change, statut_change, souillure_change')
    .eq('personnage_id', personnageActif.value.id)

  if (!entries) return

  // Calculer la somme de tous les changements
  const totalChangements = entries.reduce((acc, entry) => ({
    xp_change: acc.xp_change + (entry.xp_change || 0),
    honneur_change: acc.honneur_change + (entry.honneur_change || 0),
    gloire_change: acc.gloire_change + (entry.gloire_change || 0),
    statut_change: acc.statut_change + (entry.statut_change || 0),
    souillure_change: acc.souillure_change + (entry.souillure_change || 0)
  }), {
    xp_change: 0,
    honneur_change: 0,
    gloire_change: 0,
    statut_change: 0,
    souillure_change: 0
  })

  // Valeurs de base par défaut
  const valeursBase = {
    experience_points: 0,
    honneur: 5,
    gloire: 0,
    statut_social: 1,
    souillure: 0
  }

  // Calculer les nouvelles valeurs basées sur les valeurs de base + somme des changements
  const nouvellesValeurs = {
    experience_points: valeursBase.experience_points + totalChangements.xp_change,
    honneur: Math.max(0, Math.min(10, valeursBase.honneur + totalChangements.honneur_change)),
    gloire: Math.max(0, Math.min(10, valeursBase.gloire + totalChangements.gloire_change)),
    statut_social: Math.max(0, Math.min(10, valeursBase.statut_social + totalChangements.statut_change)),
    souillure: Math.max(0, Math.min(10, valeursBase.souillure + totalChangements.souillure_change))
  }

  // Mettre à jour le personnage
  await client
    .from('personnages')
    .update(nouvellesValeurs)
    .eq('id', personnageActif.value.id)
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

const getWikiItemByName = (name) => {
  return wikiItems.value.find(item => item.nom.toLowerCase() === name.toLowerCase())
}

const getTagEmoji = (tagName) => {
  const wikiItem = getWikiItemByName(tagName)
  if (wikiItem) {
    return emojiParCategorie[wikiItem.categorie] || '🏷️'
  }
  return '🏷️'
}

const getRandomJournalImage = (index) => {
  const images = ['/journal/arbre.png', '/journal/batiment.png', '/journal/drapeau.png', '/journal/oni.png']
  return images[index % images.length]
}

const hasStatChanges = (entry) => {
  return (entry.xp_change && entry.xp_change !== 0) ||
         (entry.honneur_change && entry.honneur_change !== 0) ||
         (entry.gloire_change && entry.gloire_change !== 0) ||
         (entry.statut_change && entry.statut_change !== 0) ||
         (entry.souillure_change && entry.souillure_change !== 0)
}
</script>

