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
            <div class="relative  overflow-hidden">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <input 
                v-model="searchQuery"
                type="text"
                placeholder="🔍 Rechercher..."
                class="relative z-10 w-full bg-transparent border-2 border-amber-800/60 focus:border-amber-700  px-4 py-2 pr-10 transition-all outline-none text-stone-900 placeholder:text-stone-500 font-montserrat text-sm"
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
          <div class=" p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">🔍 Aucun résultat trouvé</p>
              <p class="text-stone-600 font-montserrat">Essayez avec d'autres mots-clés</p>
            </div>
          </div>
        </div>
        <div v-else-if="entries.length === 0" class="text-center py-12">
          <div class=" p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80">
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
            class=" p-4 relative overflow-hidden cursor-pointer"
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
        <div class="bg-amber-50  max-w-5xl w-full border-4 border-amber-900/40 flex flex-col relative">
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
                class="text-stone-700 hover:text-stone-900 transition-colors text-4xl leading-none p-2 hover:bg-amber-200/50 "
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
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-4 py-3 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-lg" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-4 py-3 transition-all outline-none text-stone-900 font-montserrat"
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
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-4 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat" 
                      placeholder="Ajouter un tag (ex: Hida Takeshi, Château du Crabe...)"
                    />
                    <!-- Suggestions dropdown -->
                    <div 
                      v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                      class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30  overflow-y-auto"
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
                    class="px-4 py-2 bg-amber-700 hover:bg-amber-600 text-white  font-semibold transition-colors font-katana"
                  >
                    + Ajouter
                  </button>
                </div>
                <div v-if="nouvelleEntree.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
                  <span 
                    v-for="(tag, index) in nouvelleEntree.tags" 
                    :key="index"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-amber-200 text-stone-800 font-montserrat text-sm font-medium"
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
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4 p-4 bg-amber-50/50  border-2 border-amber-900/20">
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">XP</label>
                    <input 
                      v-model.number="nouvelleEntree.xp_change" 
                      type="number" 
                      step="1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Honneur</label>
                    <input 
                      v-model.number="nouvelleEntree.honneur_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Gloire</label>
                    <input 
                      v-model.number="nouvelleEntree.gloire_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Statut</label>
                    <input 
                      v-model.number="nouvelleEntree.statut_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Souillure</label>
                    <input 
                      v-model.number="nouvelleEntree.souillure_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
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
                  class="flex-1 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 px-6 py-4  font-bold text-lg transition-all duration-300 text-amber-50 flex items-center justify-center gap-2 font-katana"
                >
                  <span class="text-xl">📝</span>
                  Enregistrer l'entrée
                </button>
                <button 
                  type="button" 
                  @click="afficherFormulaire = false" 
                  class="px-8 py-4 bg-stone-200 hover:bg-stone-300 border-2 border-amber-900/30  font-semibold transition-all duration-300 text-stone-800 font-katana"
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
                  <span v-if="isSaving" class="text-xs text-amber-600 font-montserrat font-normal flex items-center gap-1">
                    <svg class="animate-spin h-3 w-3" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Sauvegarde...
                  </span>
                  <span v-else-if="lastSavedData" class="text-xs text-green-600 font-montserrat font-normal">✓ Sauvegardé</span>
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
                  <button
                    v-for="(tag, index) in entreeSelectionnee.tags"
                    :key="index"
                    @click="ouvrirWikiDrawer(tag)"
                    class="inline-flex items-center gap-1 px-3 py-1 text-stone-800  font-montserrat text-sm font-medium transition-all cursor-pointer hover:opacity-80"
                    :style="{ backgroundColor: getTagColor(tag) }"
                  >
                    {{ getTagEmoji(tag) }} {{ tag }}
                  </button>
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

            <!-- Images -->
            <div v-if="entreeSelectionnee.images && entreeSelectionnee.images.length > 0" class="mt-4 pt-4 border-t border-amber-800/20">
              <h4 class="text-xs font-semibold text-stone-700 font-montserrat mb-2">🖼️ Images</h4>
              <div class="grid grid-cols-3 gap-2">
                <div
                  v-for="(img, index) in entreeSelectionnee.images"
                  :key="index"
                  class="aspect-square  overflow-hidden border border-amber-900/20 cursor-pointer hover:opacity-80 transition-opacity"
                  @click="ouvrirImageModal(img, entreeSelectionnee)"
                >
                  <img :src="img" class="w-full h-full object-cover" />
                </div>
              </div>
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
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-sigokae text-sm" 
                    placeholder="La bataille du clan du Crabe"
                  />
                </div>
                <div>
                  <label class="block text-xs font-semibold mb-1 text-stone-800 font-montserrat">📅 Date de session</label>
                  <input 
                    v-model="nouvelleEntree.date_session" 
                    type="date" 
                    class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-1 transition-all outline-none text-stone-900 font-montserrat text-sm"
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
                      class="flex-1 bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-1 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-sm" 
                      placeholder="Ajouter un tag..."
                    />
                  </div>
                  <!-- Suggestions dropdown -->
                  <div 
                    v-if="afficherSuggestions && suggestionsFiltrees.length > 0"
                    class="absolute z-50 w-full mt-1 bg-white border-2 border-amber-900/30  overflow-y-auto"
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
                    class="inline-flex items-center gap-1 px-1 py-0.5 bg-amber-300/70 text-stone-800font-montserrat text-xs font-medium"
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

              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">📝 Résumé (pour la galerie)</label>
                <textarea
                  v-model="nouvelleEntree.resume"
                  rows="2"
                  class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 placeholder:text-stone-400 font-montserrat text-sm resize-none"
                  placeholder="Un court résumé de cette session..."
                ></textarea>
              </div>

              <!-- Section images -->
              <div>
                <label class="block text-sm font-semibold mb-2 text-stone-800 font-montserrat">🖼️ Images</label>
                <div class="space-y-3">
                  <!-- Upload button -->
                  <div class="flex gap-2">
                    <label class="flex-1 cursor-pointer">
                      <div class="flex items-center justify-center gap-2 px-4 py-3 bg-white border-2 border-dashed border-amber-900/30 hover:border-amber-700  transition-colors">
                        <span v-if="!uploadingImage">📷 Ajouter une image</span>
                        <span v-else class="flex items-center gap-2">
                          <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                          </svg>
                          Upload en cours...
                        </span>
                      </div>
                      <input
                        type="file"
                        accept="image/*"
                        class="hidden"
                        @change="uploadImage"
                        :disabled="uploadingImage"
                      />
                    </label>
                  </div>

                  <!-- Preview des images -->
                  <div v-if="nouvelleEntree.images && nouvelleEntree.images.length > 0" class="grid grid-cols-4 gap-2">
                    <div
                      v-for="(img, index) in nouvelleEntree.images"
                      :key="index"
                      class="relative group aspect-square  overflow-hidden border border-amber-900/20"
                    >
                      <img :src="img" class="w-full h-full object-cover" />
                      <button
                        type="button"
                        @click="retirerImage(index)"
                        class="absolute top-1 right-1 w-5 h-5 bg-red-600 hover:bg-red-700 text-white  flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        ×
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Section changements XP et autres valeurs -->
              <div>
                <label class="block text-sm font-semibold mb-3 text-stone-800 font-montserrat">📊 Changements de valeurs</label>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4 p-4 bg-amber-50/50  border-2 border-amber-900/20">
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">XP</label>
                    <input 
                      v-model.number="nouvelleEntree.xp_change" 
                      type="number" 
                      step="1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Honneur</label>
                    <input 
                      v-model.number="nouvelleEntree.honneur_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Gloire</label>
                    <input 
                      v-model.number="nouvelleEntree.gloire_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Statut</label>
                    <input 
                      v-model.number="nouvelleEntree.statut_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
                      placeholder="0"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Souillure</label>
                    <input 
                      v-model.number="nouvelleEntree.souillure_change" 
                      type="number" 
                      step="0.1"
                      class="w-full bg-white border-2 border-amber-900/30 focus:border-amber-700  px-3 py-2 transition-all outline-none text-stone-900 font-montserrat text-sm" 
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
                class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat "
              >
                ✏️ Modifier
              </button>
              <button
                @click="supprimerEntree(entreeSelectionnee.id)"
                class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat "
              >
                🗑️ Supprimer
              </button>
            </div>

            <div v-else class="flex gap-4">
              <button
                @click="closeDrawer"
                class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium transition-colors flex items-center gap-2 font-montserrat "
              >
                ✓ Fermer
              </button>
              <span class="text-xs text-stone-500 font-montserrat self-center italic">
                Les modifications sont sauvegardées automatiquement
              </span>
            </div>
          </div>
          </div>
        </div>
      </div>

      <!-- Wiki Drawer (gauche) -->
      <div v-if="wikiDrawerOpen" class="fixed inset-0 z-50 flex" @click.self="fermerWikiDrawer">
        <!-- Overlay -->
        <div @click="fermerWikiDrawer" class="absolute inset-0 bg-black/30 backdrop-blur-sm"></div>

        <!-- Drawer Panel (gauche) -->
        <div class="relative mr-auto w-[40vw] h-full border-r-4 border-amber-800 bg-amber-50/95 backdrop-blur-md">
          <div class="relative z-10 p-4 h-full flex flex-col pr-8">
            <!-- Header -->
            <div class="flex items-start justify-between mb-4 pb-4 border-b-2 border-amber-800/30">
              <div>
                <h3 class="text-xl font-bold text-stone-900 font-manga mb-1">
                  {{ wikiTagSelectionne }}
                </h3>
                <span v-if="wikiItemSelectionne" class="text-xs text-stone-600 font-montserrat">
                  {{ emojiParCategorie[wikiItemSelectionne.categorie] }} {{ getCategoryName(wikiItemSelectionne.categorie) }}
                </span>
                <span v-else class="text-xs text-amber-700 font-montserrat italic">
                  Page non créée
                </span>
              </div>
              <button
                @click="fermerWikiDrawer"
                class="text-stone-600 hover:text-stone-900 font-bold text-2xl"
              >
                ×
              </button>
            </div>

            <!-- Contenu si la page existe -->
            <div v-if="wikiItemSelectionne" class="overflow-y-auto flex-1 flex flex-col gap-4">
              <!-- Mode vue -->
              <template v-if="!wikiEditMode">
                <!-- Description -->
                <div v-if="wikiItemSelectionne.description" class="text-stone-800 font-montserrat text-sm">
                  <MarkdownPreview :content="wikiItemSelectionne.description" />
                </div>
                <p v-else class="text-stone-500 italic font-montserrat text-sm">Aucune description...</p>
              </template>

              <!-- Mode édition -->
              <template v-else>
                <RichTextEditor v-model="wikiEditDescription" />
              </template>

              <!-- Métadonnées -->
              <div class="border-t border-amber-800/30 pt-3 space-y-1 text-xs">
                <div>
                  <span class="font-semibold text-stone-700 font-montserrat">Créé le:</span>
                  <span class="ml-2 text-stone-800 font-montserrat">{{ formatDate(wikiItemSelectionne.created_at) }}</span>
                </div>
              </div>

              <!-- Gestion des liens wiki -->
              <div class="border-t border-amber-800/30 pt-3">
                <h4 class="text-xs font-bold text-stone-700 font-montserrat mb-2">Pages Wiki liées</h4>

                <!-- Input pour ajouter un lien -->
                <div class="relative mb-2 wiki-tag-suggestions">
                  <div class="flex gap-1">
                    <input
                      v-model="nouveauWikiTag"
                      type="text"
                      @keydown.enter.prevent="ajouterWikiTag"
                      @input="filtrerWikiSuggestions"
                      @focus="afficherWikiSuggestions = true"
                      class="flex-1 bg-white border border-amber-900/30 focus:border-amber-700px-2 py-1 text-xs outline-none text-stone-900 placeholder:text-stone-400 font-montserrat"
                      placeholder="Ajouter un lien..."
                    />
                  </div>
                  <!-- Suggestions dropdown -->
                  <div
                    v-if="afficherWikiSuggestions && wikiSuggestionsFiltrees.length > 0"
                    class="absolute z-50 w-full mt-1 bg-white border border-amber-900/30shadow-lg max-h-32 overflow-y-auto"
                  >
                    <button
                      v-for="(suggestion, index) in wikiSuggestionsFiltrees"
                      :key="index"
                      type="button"
                      @click="selectionnerWikiSuggestion(suggestion)"
                      class="w-full px-2 py-1 text-left hover:bg-amber-100 transition-colors font-montserrat text-stone-900 flex items-center gap-1 border-b border-amber-900/10 last:border-b-0 text-xs"
                    >
                      <span>{{ emojiParCategorie[suggestion.categorie] }}</span>
                      <span class="flex-1">{{ suggestion.nom }}</span>
                    </button>
                  </div>
                </div>

                <!-- Tags actuels -->
                <div v-if="wikiItemSelectionne.tags && wikiItemSelectionne.tags.length > 0" class="flex flex-wrap gap-1">
                  <button
                    v-for="(tag, index) in wikiItemSelectionne.tags"
                    :key="index"
                    class="inline-flex items-center gap-1 px-2 py-0.5 text-stone-800font-montserrat text-xs transition-all group"
                    :style="{ backgroundColor: getTagColor(tag) }"
                  >
                    <span @click="ouvrirWikiDrawer(tag)" class="cursor-pointer hover:underline">
                      {{ getTagEmoji(tag) }} {{ tag }}
                    </span>
                    <button
                      type="button"
                      @click="retirerWikiTag(index)"
                      class="hover:text-red-700 transition-colors font-bold ml-1"
                    >
                      ×
                    </button>
                  </button>
                </div>
                <p v-else class="text-stone-500 italic text-xs">Aucun lien</p>
              </div>

              <!-- Liens Wiki entrants -->
              <div v-if="wikiItemsLies.length > 0" class="border-t border-amber-800/30 pt-3">
                <h4 class="text-xs font-bold text-stone-700 font-montserrat mb-2">Mentionné dans</h4>
                <div class="flex flex-wrap gap-1">
                  <button
                    v-for="itemLie in wikiItemsLies"
                    :key="itemLie.id"
                    @click="ouvrirWikiDrawer(itemLie.nom)"
                    class="inline-flex items-center gap-1 px-2 py-0.5 text-stone-800font-montserrat text-xs transition-all cursor-pointer hover:opacity-80"
                    :style="{ backgroundColor: categoryConfig[itemLie.categorie]?.color || '#CDAFCE' }"
                  >
                    {{ emojiParCategorie[itemLie.categorie] }} {{ itemLie.nom }}
                  </button>
                </div>
              </div>

              <!-- Entrées de journal liées -->
              <div v-if="wikiEntreesLiees.length > 0" class="border-t border-amber-800/30 pt-3">
                <h4 class="text-xs font-bold text-stone-700 font-montserrat mb-2">Entrées de journal</h4>
                <div class="flex flex-wrap gap-1">
                  <button
                    v-for="entree in wikiEntreesLiees"
                    :key="entree.id"
                    @click="selectEntryFromWiki(entree)"
                    class="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-100 hover:bg-blue-200 text-blue-900font-montserrat text-xs transition-all cursor-pointer"
                  >
                    📖 {{ entree.titre }}
                  </button>
                </div>
              </div>
            </div>

            <!-- Contenu si la page n'existe pas -->
            <div v-else class="overflow-y-auto flex-1 flex flex-col gap-4">
              <div class="bg-amber-100/50  p-4 border border-amber-800/20">
                <p class="text-stone-700 font-montserrat text-sm mb-4">
                  Cette page wiki n'existe pas encore. Voulez-vous la créer ?
                </p>

                <div class="space-y-3">
                  <div>
                    <label class="block text-xs font-semibold mb-1 text-stone-700 font-montserrat">Catégorie</label>
                    <div class="grid grid-cols-2 gap-2">
                      <button
                        v-for="(config, key) in categoryConfig"
                        :key="key"
                        type="button"
                        @click="nouvelleCategorieWiki = key"
                        class="px-2 py-1.5  border-2 transition-all font-montserrat text-xs flex items-center gap-1 justify-center"
                        :class="nouvelleCategorieWiki === key
                          ? 'border-stone-800 ring-2 ring-stone-400'
                          : 'border-transparent hover:border-stone-300'"
                        :style="{ backgroundColor: config.color }"
                      >
                        <span>{{ config.emoji }}</span>
                        <span class="text-stone-800">{{ config.name }}</span>
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Entrées de journal qui mentionnent ce tag -->
              <div v-if="wikiEntreesLiees.length > 0" class="border-t border-amber-800/30 pt-3">
                <h4 class="text-xs font-bold text-stone-700 font-montserrat mb-2">Mentionné dans le journal</h4>
                <div class="flex flex-wrap gap-1">
                  <button
                    v-for="entree in wikiEntreesLiees"
                    :key="entree.id"
                    @click="selectEntryFromWiki(entree)"
                    class="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-100 hover:bg-blue-200 text-blue-900font-montserrat text-xs transition-all cursor-pointer"
                  >
                    📖 {{ entree.titre }}
                  </button>
                </div>
              </div>
            </div>

            <!-- Actions -->
            <div class="mt-4 pt-4 border-t-2 border-amber-800/30 flex gap-2">
              <template v-if="wikiItemSelectionne">
                <button
                  v-if="!wikiEditMode"
                  @click="activerWikiEditMode"
                  class="px-3 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium transition-colors flex items-center justify-center gap-1 font-montserrat  text-sm"
                >
                  ✏️ Modifier
                </button>
                <button
                  v-if="wikiEditMode"
                  @click="sauvegarderWiki"
                  class="px-3 py-2 bg-green-600 hover:bg-green-700 text-white font-medium transition-colors flex items-center justify-center gap-1 font-montserrat  text-sm"
                >
                  💾 Sauvegarder
                </button>
                <button
                  v-if="wikiEditMode"
                  @click="annulerWikiEdit"
                  class="px-3 py-2 bg-stone-400 hover:bg-stone-500 text-white font-medium transition-colors font-montserrat  text-sm"
                >
                  Annuler
                </button>
                <button
                  v-if="!wikiEditMode"
                  @click="navigateTo(`/wiki/${wikiItemSelectionne.slug}`)"
                  class="px-3 py-2 bg-stone-600 hover:bg-stone-700 text-white font-medium transition-colors flex items-center justify-center gap-1 font-montserrat  text-sm"
                >
                  📖 Page complète
                </button>
              </template>
              <button
                v-else
                @click="creerPageWiki"
                :disabled="!nouvelleCategorieWiki"
                class="flex-1 px-3 py-2 bg-green-600 hover:bg-green-700 text-white font-medium transition-colors flex items-center justify-center gap-2 font-montserrat  text-sm disabled:opacity-50 disabled:cursor-not-allowed"
              >
                ✨ Créer la page
              </button>
              <button
                @click="fermerWikiDrawer"
                class="px-3 py-2 bg-stone-200 hover:bg-stone-300 text-stone-800 font-medium transition-colors font-montserrat  text-sm"
              >
                ×
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Image Modal -->
      <div v-if="imageModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center" @click.self="fermerImageModal">
        <div @click="fermerImageModal" class="absolute inset-0 bg-black/80"></div>
        <div class="relative max-w-4xl max-h-[90vh] flex flex-col bg-amber-50  overflow-hidden border-4 border-amber-800">
          <!-- Image -->
          <div class="flex-1 overflow-hidden flex items-center justify-center p-4">
            <img :src="imageModalUrl" class="max-w-full max-h-[60vh] object-contain " />
          </div>

          <!-- Info entrée -->
          <div v-if="imageModalEntree" class="p-4 border-t-2 border-amber-800/30 bg-amber-50/80">
            <h3 class="font-bold text-lg text-stone-900 font-manga mb-1">{{ imageModalEntree.titre }}</h3>
            <p class="text-xs text-stone-600 font-montserrat mb-2">{{ formatDate(imageModalEntree.date_session) }}</p>
            <p v-if="imageModalEntree.resume" class="text-sm text-stone-700 font-montserrat">{{ imageModalEntree.resume }}</p>
            <p v-else class="text-sm text-stone-500 font-montserrat italic">Pas de résumé</p>
            <button
              @click="fermerImageModal(); selectEntry(imageModalEntree)"
              class="mt-3 px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-medium  font-montserrat text-sm"
            >
              Voir l'entrée complète
            </button>
          </div>

          <!-- Bouton fermer -->
          <button
            @click="fermerImageModal"
            class="absolute top-2 right-2 w-8 h-8 bg-stone-800 hover:bg-stone-700 text-white  flex items-center justify-center text-xl"
          >
            ×
          </button>
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

// Wiki drawer state
const wikiDrawerOpen = ref(false)
const wikiTagSelectionne = ref('')
const wikiItemSelectionne = ref(null)
const wikiItemsLies = ref([])
const wikiEntreesLiees = ref([])
const nouvelleCategorieWiki = ref('')

const categoryConfig = {
  clans: { name: 'Clans', emoji: '⚔️', color: '#AAABCF' },
  lieux: { name: 'Lieux', emoji: '🏯', color: '#ACD4CD' },
  personnages: { name: 'Personnages', emoji: '👤', color: '#F1C5A9' },
  autre: { name: 'Autre', emoji: '📦', color: '#CDAFCE' }
}

// Wiki drawer edit state
const wikiEditMode = ref(false)
const wikiEditDescription = ref('')

// Wiki tag management
const nouveauWikiTag = ref('')
const afficherWikiSuggestions = ref(false)
const nouvelleEntree = ref({
  titre: '',
  contenu: '',
  date_session: new Date().toISOString().split('T')[0],
  tags: [],
  images: [],
  xp_change: 0,
  honneur_change: 0,
  gloire_change: 0,
  statut_change: 0,
  souillure_change: 0
})

// Image upload state
const uploadingImage = ref(false)

// Image modal state
const imageModalOpen = ref(false)
const imageModalUrl = ref('')
const imageModalEntree = ref(null)

// Auto-save state
const autoSaveTimeout = ref(null)
const isSaving = ref(false)
const lastSavedData = ref(null)

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
      if (!e.target.closest('.wiki-tag-suggestions')) {
        afficherWikiSuggestions.value = false
      }
    })
  }
})

// Auto-save watcher
watch(
  nouvelleEntree,
  () => {
    // Ne déclenche l'auto-save que si on est en mode édition dans le drawer
    if (drawerMode.value === 'edit' && (createMode.value || entreeEnEdition.value)) {
      triggerAutoSave()
    }
  },
  { deep: true }
)

// Sauvegarder avant de quitter la page
onBeforeUnmount(() => {
  if (autoSaveTimeout.value) {
    clearTimeout(autoSaveTimeout.value)
  }
  // Sauvegarde synchrone finale si nécessaire
  if (drawerMode.value === 'edit' && (createMode.value || entreeEnEdition.value)) {
    autoSave()
  }
})

const triggerAutoSave = () => {
  if (autoSaveTimeout.value) {
    clearTimeout(autoSaveTimeout.value)
  }
  autoSaveTimeout.value = setTimeout(() => {
    autoSave()
  }, 1000) // Sauvegarde après 1 seconde d'inactivité
}

const autoSave = async () => {
  if (isSaving.value || !personnageActif.value?.id) return

  // Vérifier si les données ont changé
  const currentData = JSON.stringify(nouvelleEntree.value)
  if (currentData === lastSavedData.value) return

  isSaving.value = true

  try {
    if (entreeEnEdition.value) {
      // Mode édition - mise à jour de l'entrée existante
      const anciennesValeurs = {
        xp_change: entreeEnEdition.value.xp_change || 0,
        honneur_change: entreeEnEdition.value.honneur_change || 0,
        gloire_change: entreeEnEdition.value.gloire_change || 0,
        statut_change: entreeEnEdition.value.statut_change || 0,
        souillure_change: entreeEnEdition.value.souillure_change || 0
      }

      const nouvellesValeurs = {
        xp_change: nouvelleEntree.value.xp_change || 0,
        honneur_change: nouvelleEntree.value.honneur_change || 0,
        gloire_change: nouvelleEntree.value.gloire_change || 0,
        statut_change: nouvelleEntree.value.statut_change || 0,
        souillure_change: nouvelleEntree.value.souillure_change || 0
      }

      const differenceChangements = {
        xp_change: nouvellesValeurs.xp_change - anciennesValeurs.xp_change,
        honneur_change: nouvellesValeurs.honneur_change - anciennesValeurs.honneur_change,
        gloire_change: nouvellesValeurs.gloire_change - anciennesValeurs.gloire_change,
        statut_change: nouvellesValeurs.statut_change - anciennesValeurs.statut_change,
        souillure_change: nouvellesValeurs.souillure_change - anciennesValeurs.souillure_change
      }

      const { data, error } = await client
        .from('journal_entries')
        .update(nouvelleEntree.value)
        .eq('id', entreeEnEdition.value.id)
        .select()
        .single()

      if (!error && data) {
        // Appliquer la différence des changements au personnage
        const hasChanges = differenceChangements.xp_change !== 0 ||
                           differenceChangements.honneur_change !== 0 ||
                           differenceChangements.gloire_change !== 0 ||
                           differenceChangements.statut_change !== 0 ||
                           differenceChangements.souillure_change !== 0

        if (hasChanges) {
          await appliquerChangementsPersonnage(differenceChangements)
        }

        // Mettre à jour l'entrée en édition avec les nouvelles valeurs de référence
        entreeEnEdition.value = { ...data }

        // Mettre à jour dans la liste
        const index = entries.value.findIndex(e => e.id === data.id)
        if (index !== -1) entries.value[index] = data

        lastSavedData.value = currentData
      }
    } else if (createMode.value && nouvelleEntree.value.titre) {
      // Mode création - créer une nouvelle entrée
      const { data, error } = await client
        .from('journal_entries')
        .insert([{
          personnage_id: personnageActif.value.id,
          ...nouvelleEntree.value
        }])
        .select()
        .single()

      if (!error && data) {
        // Appliquer les changements au personnage
        await appliquerChangementsPersonnage(nouvelleEntree.value)

        // Ajouter à la liste
        entries.value.unshift(data)

        // Passer en mode édition pour les prochaines sauvegardes
        createMode.value = false
        entreeEnEdition.value = { ...data }

        lastSavedData.value = currentData
      }
    }
  } finally {
    isSaving.value = false
  }
}

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
    // Calculer la différence entre les anciennes et nouvelles valeurs
    const anciennesValeurs = {
      xp_change: entreeEnEdition.value.xp_change || 0,
      honneur_change: entreeEnEdition.value.honneur_change || 0,
      gloire_change: entreeEnEdition.value.gloire_change || 0,
      statut_change: entreeEnEdition.value.statut_change || 0,
      souillure_change: entreeEnEdition.value.souillure_change || 0
    }

    const nouvellesValeurs = {
      xp_change: nouvelleEntree.value.xp_change || 0,
      honneur_change: nouvelleEntree.value.honneur_change || 0,
      gloire_change: nouvelleEntree.value.gloire_change || 0,
      statut_change: nouvelleEntree.value.statut_change || 0,
      souillure_change: nouvelleEntree.value.souillure_change || 0
    }

    // La différence à appliquer
    const differenceChangements = {
      xp_change: nouvellesValeurs.xp_change - anciennesValeurs.xp_change,
      honneur_change: nouvellesValeurs.honneur_change - anciennesValeurs.honneur_change,
      gloire_change: nouvellesValeurs.gloire_change - anciennesValeurs.gloire_change,
      statut_change: nouvellesValeurs.statut_change - anciennesValeurs.statut_change,
      souillure_change: nouvellesValeurs.souillure_change - anciennesValeurs.souillure_change
    }

    const { data, error } = await client
      .from('journal_entries')
      .update(nouvelleEntree.value)
      .eq('id', entreeEnEdition.value.id)
      .select()
      .single()

    if (!error && data) {
      // Appliquer seulement la différence des changements au personnage
      const hasChanges = differenceChangements.xp_change !== 0 ||
                         differenceChangements.honneur_change !== 0 ||
                         differenceChangements.gloire_change !== 0 ||
                         differenceChangements.statut_change !== 0 ||
                         differenceChangements.souillure_change !== 0

      if (hasChanges) {
        await appliquerChangementsPersonnage(differenceChangements)
      }

      const index = entries.value.findIndex(e => e.id === data.id)
      if (index !== -1) entries.value[index] = data
      nouvelleEntree.value = {
        titre: '',
        contenu: '',
        resume: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: [],
        images: [],
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
        resume: '',
        date_session: new Date().toISOString().split('T')[0],
        tags: [],
        images: [],
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

const closeDrawer = async () => {
  // Sauvegarder avant de fermer si en mode édition
  if (drawerMode.value === 'edit' && (createMode.value || entreeEnEdition.value)) {
    if (autoSaveTimeout.value) {
      clearTimeout(autoSaveTimeout.value)
    }
    await autoSave()
  }

  entreeSelectionnee.value = null
  createMode.value = false
  drawerMode.value = 'view'
  entreeEnEdition.value = null
  lastSavedData.value = null
  nouvelleEntree.value = {
    titre: '',
    contenu: '',
    resume: '',
    date_session: new Date().toISOString().split('T')[0],
    tags: [],
    images: [],
    xp_change: 0,
    honneur_change: 0,
    gloire_change: 0,
    statut_change: 0,
    souillure_change: 0
  }
}

const modifierEntree = (entry) => {
  entreeEnEdition.value = { ...entry }
  nouvelleEntree.value = {
    titre: entry.titre,
    contenu: entry.contenu,
    resume: entry.resume || '',
    date_session: entry.date_session,
    tags: entry.tags || [],
    images: entry.images || [],
    xp_change: entry.xp_change || 0,
    honneur_change: entry.honneur_change || 0,
    gloire_change: entry.gloire_change || 0,
    statut_change: entry.statut_change || 0,
    souillure_change: entry.souillure_change || 0
  }
  // Initialiser lastSavedData pour éviter une sauvegarde immédiate
  lastSavedData.value = JSON.stringify(nouvelleEntree.value)
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

// Image upload methods
const uploadImage = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  uploadingImage.value = true

  try {
    // Générer un nom de fichier unique
    const fileExt = file.name.split('.').pop()
    const fileName = `${personnageActif.value.id}/${Date.now()}.${fileExt}`

    // Upload vers Supabase Storage
    const { data, error } = await client.storage
      .from('journal-images')
      .upload(fileName, file)

    if (error) {
      console.error('Erreur upload:', error)
      alert('Erreur lors de l\'upload de l\'image')
      return
    }

    // Obtenir l'URL publique
    const { data: urlData } = client.storage
      .from('journal-images')
      .getPublicUrl(fileName)

    // Ajouter l'URL à la liste des images
    if (!nouvelleEntree.value.images) {
      nouvelleEntree.value.images = []
    }
    nouvelleEntree.value.images.push(urlData.publicUrl)
  } catch (err) {
    console.error('Erreur:', err)
    alert('Erreur lors de l\'upload')
  } finally {
    uploadingImage.value = false
    // Reset l'input file
    event.target.value = ''
  }
}

const retirerImage = (index) => {
  nouvelleEntree.value.images.splice(index, 1)
}

// Image modal methods
const ouvrirImageModal = (url, entree) => {
  imageModalUrl.value = url
  imageModalEntree.value = entree
  imageModalOpen.value = true
}

const fermerImageModal = () => {
  imageModalOpen.value = false
  imageModalUrl.value = ''
  imageModalEntree.value = null
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

// Wiki drawer methods
const ouvrirWikiDrawer = async (tagName) => {
  wikiTagSelectionne.value = tagName
  wikiDrawerOpen.value = true
  nouvelleCategorieWiki.value = ''

  // Chercher si l'item wiki existe
  const item = getWikiItemByName(tagName)
  wikiItemSelectionne.value = item || null

  // Charger les items liés (qui mentionnent cet item)
  if (item) {
    wikiItemsLies.value = wikiItems.value.filter(i =>
      i.id !== item.id && i.tags?.includes(item.nom)
    )
  } else {
    wikiItemsLies.value = []
  }

  // Charger les entrées de journal qui mentionnent ce tag
  wikiEntreesLiees.value = entries.value.filter(e =>
    e.tags?.includes(tagName)
  )
}

const fermerWikiDrawer = () => {
  wikiDrawerOpen.value = false
  wikiTagSelectionne.value = ''
  wikiItemSelectionne.value = null
  wikiItemsLies.value = []
  wikiEntreesLiees.value = []
  nouvelleCategorieWiki.value = ''
  wikiEditMode.value = false
  wikiEditDescription.value = ''
}

const creerPageWiki = async () => {
  if (!personnageActif.value?.id || !nouvelleCategorieWiki.value || !wikiTagSelectionne.value) return

  // Créer le slug à partir du nom
  const slug = wikiTagSelectionne.value
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')

  const { data, error } = await client
    .from('wiki_items')
    .insert([{
      personnage_id: personnageActif.value.id,
      nom: wikiTagSelectionne.value,
      categorie: nouvelleCategorieWiki.value,
      slug,
      description: '',
      tags: []
    }])
    .select()
    .single()

  if (!error && data) {
    // Ajouter à la liste des items
    wikiItems.value.push(data)
    // Mettre à jour le drawer avec le nouvel item
    wikiItemSelectionne.value = data
    nouvelleCategorieWiki.value = ''
  }
}

const selectEntryFromWiki = (entry) => {
  fermerWikiDrawer()
  selectEntry(entry)
}

const getCategoryName = (categoryId) => {
  return categoryConfig[categoryId]?.name || 'Autre'
}

const getTagColor = (tagName) => {
  const wikiItem = getWikiItemByName(tagName)
  if (wikiItem) {
    return categoryConfig[wikiItem.categorie]?.color || '#CDAFCE'
  }
  return '#CDAFCE' // Couleur par défaut (Autre)
}

const activerWikiEditMode = () => {
  wikiEditMode.value = true
  wikiEditDescription.value = wikiItemSelectionne.value?.description || ''
}

const annulerWikiEdit = () => {
  wikiEditMode.value = false
  wikiEditDescription.value = ''
}

const sauvegarderWiki = async () => {
  if (!wikiItemSelectionne.value?.id) return

  const { error } = await client
    .from('wiki_items')
    .update({ description: wikiEditDescription.value })
    .eq('id', wikiItemSelectionne.value.id)

  if (!error) {
    wikiItemSelectionne.value.description = wikiEditDescription.value
    // Mettre à jour aussi dans la liste locale
    const index = wikiItems.value.findIndex(i => i.id === wikiItemSelectionne.value.id)
    if (index !== -1) {
      wikiItems.value[index].description = wikiEditDescription.value
    }
    wikiEditMode.value = false
  }
}

// Wiki tag suggestions
const wikiSuggestionsFiltrees = computed(() => {
  const query = nouveauWikiTag.value.toLowerCase().trim()
  const tagsActuels = wikiItemSelectionne.value?.tags || []

  // Filtrer les items qui ne sont pas déjà dans les tags et qui ne sont pas l'item actuel
  const itemsDisponibles = wikiItems.value.filter(i =>
    i.id !== wikiItemSelectionne.value?.id &&
    !tagsActuels.includes(i.nom)
  )

  if (!query) {
    return itemsDisponibles.slice(0, 8)
  }

  return itemsDisponibles
    .filter(i => i.nom.toLowerCase().includes(query))
    .slice(0, 8)
})

const filtrerWikiSuggestions = () => {
  afficherWikiSuggestions.value = true
}

const ajouterWikiTag = async () => {
  if (!nouveauWikiTag.value.trim() || !wikiItemSelectionne.value?.id) return

  const tags = wikiItemSelectionne.value.tags || []
  if (!tags.includes(nouveauWikiTag.value.trim())) {
    const nouveauxTags = [...tags, nouveauWikiTag.value.trim()]

    const { error } = await client
      .from('wiki_items')
      .update({ tags: nouveauxTags })
      .eq('id', wikiItemSelectionne.value.id)

    if (!error) {
      wikiItemSelectionne.value.tags = nouveauxTags
      // Mettre à jour dans la liste locale
      const index = wikiItems.value.findIndex(i => i.id === wikiItemSelectionne.value.id)
      if (index !== -1) {
        wikiItems.value[index].tags = nouveauxTags
      }
      nouveauWikiTag.value = ''
      afficherWikiSuggestions.value = false
    }
  }
}

const selectionnerWikiSuggestion = async (suggestion) => {
  const tags = wikiItemSelectionne.value?.tags || []
  if (!tags.includes(suggestion.nom)) {
    const nouveauxTags = [...tags, suggestion.nom]

    const { error } = await client
      .from('wiki_items')
      .update({ tags: nouveauxTags })
      .eq('id', wikiItemSelectionne.value.id)

    if (!error) {
      wikiItemSelectionne.value.tags = nouveauxTags
      // Mettre à jour dans la liste locale
      const index = wikiItems.value.findIndex(i => i.id === wikiItemSelectionne.value.id)
      if (index !== -1) {
        wikiItems.value[index].tags = nouveauxTags
      }
      nouveauWikiTag.value = ''
      afficherWikiSuggestions.value = false
    }
  }
}

const retirerWikiTag = async (index) => {
  if (!wikiItemSelectionne.value?.id) return

  const nouveauxTags = [...(wikiItemSelectionne.value.tags || [])]
  nouveauxTags.splice(index, 1)

  const { error } = await client
    .from('wiki_items')
    .update({ tags: nouveauxTags })
    .eq('id', wikiItemSelectionne.value.id)

  if (!error) {
    wikiItemSelectionne.value.tags = nouveauxTags
    // Mettre à jour dans la liste locale
    const idx = wikiItems.value.findIndex(i => i.id === wikiItemSelectionne.value.id)
    if (idx !== -1) {
      wikiItems.value[idx].tags = nouveauxTags
    }
  }
}

</script>

