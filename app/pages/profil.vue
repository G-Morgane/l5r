<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0">
      <img 
        src="/background_selection.png" 
        alt="Japanese room background" 
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>
    
    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- En-tête -->
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">⚔️ Profil</h1>
        <NuxtLink 
          to="/"
          class="px-4 py-2 rounded-xl border-2 border-amber-800/60 ring-4 ring-amber-900/30 ring-offset-2 ring-offset-transparent shadow-2xl hover:shadow-3xl transition-all duration-300 hover:-translate-y-1 relative overflow-hidden bg-white"
        >
          <span class="text-red-800 font-bold relative z-10 font-katana">← Retour</span>
        </NuxtLink>
      </div>

      <div v-if="!personnageActif" class="text-center py-20">
        <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80 max-w-xl mx-auto">
          <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
          <div class="absolute inset-0 bg-amber-50/30"></div>
          <div class="relative z-10">
            <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucun personnage sélectionné</p>
            <NuxtLink to="/" class="inline-block px-8 py-4 bg-gradient-to-b from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-amber-50 rounded-lg font-bold text-lg transition-all duration-300 border-2 border-red-950 shadow-lg">
              Sélectionner un personnage
            </NuxtLink>
          </div>
        </div>
      </div>

      <div v-else class="max-w-7xl mx-auto">
        <!-- En-tête personnage -->
        <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="() => personnageActif = null"
        />

        <!-- Section principale : Anneaux + Stats -->
        <div class="space-y-6 mb-6">
          <!-- Ligne 1 : Tous les cercles -->
          <div class="rounded-xl px-6 pt-6 pb-3 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <div class="flex flex-wrap justify-center gap-10">
                <!-- Terre -->
                <div class="flex flex-col items-center w-36">
                  <div class="relative mb-2">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-br from-amber-100 to-green-200 flex items-center justify-center border-3 border-amber-950 shadow-xl">
                      <img src="/terre.svg" alt="Terre" class="w-12 h-12" />
                    </div>
                    <input 
                      v-model.number="personnageData.terre" 
                      type="number"
                      @blur="sauvegarderPersonnage"
                      class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-amber-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat"
                    />
                  </div>
                  <h3 class="font-bold text-amber-900 mb-1 font-katana text-base">TERRE</h3>
                  <div class="w-full space-y-0 text-xs">
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Constitution</label>
                      <input 
                        v-model.number="personnageData.constitution" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Volonté</label>
                      <input 
                        v-model.number="personnageData.volonte" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                  </div>
                </div>

                <!-- Eau -->
                <div class="flex flex-col items-center w-36">
                  <div class="relative mb-2">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-br from-blue-100 to-blue-300 flex items-center justify-center border-3 border-blue-950 shadow-xl">
                      <img src="/eau.svg" alt="Eau" class="w-12 h-12" />
                    </div>
                    <input 
                      v-model.number="personnageData.eau" 
                      type="number"
                      @blur="sauvegarderPersonnage"
                      class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-blue-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat"
                    />
                  </div>
                  <h3 class="font-bold text-blue-900 mb-1 font-katana text-base">EAU</h3>
                  <div class="w-full space-y-0 text-xs">
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Force</label>
                      <input 
                        v-model.number="personnageData.force" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Perception</label>
                      <input 
                        v-model.number="personnageData.perception" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                  </div>
                </div>

                <!-- Feu -->
                <div class="flex flex-col items-center w-36">
                  <div class="relative mb-2">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-br from-orange-100 to-orange-300 flex items-center justify-center border-3 border-red-950 shadow-xl">
                      <img src="/feu.svg" alt="Feu" class="w-12 h-12" />
                    </div>
                    <input 
                      v-model.number="personnageData.feu" 
                      type="number"
                      @blur="sauvegarderPersonnage"
                      class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-red-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat"
                    />
                  </div>
                  <h3 class="font-bold text-red-900 mb-1 font-katana text-base">FEU</h3>
                  <div class="w-full space-y-0 text-xs">
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Intelligence</label>
                      <input 
                        v-model.number="personnageData.intelligence" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Agilité</label>
                      <input 
                        v-model.number="personnageData.agilite" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                  </div>
                </div>

                <!-- Air -->
                <div class="flex flex-col items-center w-36">
                  <div class="relative mb-2">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-br from-gray-100 to-gray-300 flex items-center justify-center border-3 border-gray-700 shadow-xl">
                      <img src="/air.svg" alt="Air" class="w-12 h-12" />
                    </div>
                    <input 
                      v-model.number="personnageData.air" 
                      type="number"
                      @blur="sauvegarderPersonnage"
                      class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-gray-700 rounded-full text-center font-bold text-base shadow-lg font-montserrat"
                    />
                  </div>
                  <h3 class="font-bold text-gray-700 mb-1 font-katana text-base">AIR</h3>
                  <div class="w-full space-y-0 text-xs">
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Réflexes</label>
                      <input 
                        v-model.number="personnageData.reflexes" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex items-center justify-between px-1">
                      <label class="font-semibold font-montserrat text-[10px]">Intuition</label>
                      <input 
                        v-model.number="personnageData.intuition" 
                        type="number"
                        @blur="sauvegarderPersonnage"
                        class="w-9 border border-stone-300 rounded px-1 py-0.5 text-center font-bold bg-white font-montserrat"
                      />
                    </div>
                  </div>
                </div>

                <!-- Vide -->
                <div class="flex flex-col items-center w-36">
                  <div class="relative mb-2">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-br from-purple-100 to-purple-300 flex items-center justify-center border-3 border-purple-950 shadow-xl">
                      <img src="/vide.svg" alt="Vide" class="w-12 h-12" />
                    </div>
                    <input 
                      v-model.number="personnageData.vide" 
                      type="number"
                      @blur="sauvegarderPersonnage"
                      class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-10 h-10 bg-white border-2 border-purple-950 rounded-full text-center font-bold text-base shadow-lg font-montserrat"
                    />
                  </div>
                  <h3 class="font-bold text-purple-900 mb-1 font-katana text-base">VIDE</h3>
                  <p class="text-[10px] text-center text-stone-600 italic font-montserrat">Points de Vide</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Ligne 2 : Gloire/Honneur/Statut + Expérience/Initiative/Réputation -->
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Honneur, Gloire, Statut, Souillure -->
            <div class="rounded-xl px-6 py-2 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <div class="relative z-10">
                <div class="space-y-3">
                  <div>
                    <div class="flex items-center gap-2 mb-0.5">
                      <label class="text-xs font-bold font-montserrat">Honneur</label>
                      <input 
                        v-model.number="personnageData.honneur" 
                        type="number"
                        step="0.5"
                        min="0"
                        max="10"
                        @blur="sauvegarderPersonnage"
                        class="w-10 border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex gap-1">
                      <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 border-red-900 cursor-pointer transition-all hover:scale-110 relative overflow-hidden"
                        @click="personnageData.honneur = personnageData.honneur === i ? i - 0.5 : i; sauvegarderPersonnage()"
                      >
                        <div 
                          class="absolute inset-0 bg-red-900 transition-all"
                          :style="{ clipPath: personnageData.honneur >= i ? 'inset(0 0 0 0)' : personnageData.honneur >= i - 0.5 ? 'inset(0 50% 0 0)' : 'inset(0 100% 0 0)' }"
                        ></div>
                      </div>
                    </div>
                  </div>
                  <div>
                    <div class="flex items-center gap-2 mb-0.5">
                      <label class="text-xs font-bold font-montserrat">Gloire</label>
                      <input 
                        v-model.number="personnageData.gloire" 
                        type="number"
                        step="0.5"
                        min="0"
                        max="10"
                        @blur="sauvegarderPersonnage"
                        class="w-10 border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex gap-1">
                      <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 border-amber-600 cursor-pointer transition-all hover:scale-110"
                        :class="{ 'bg-amber-600': i <= personnageData.gloire }"
                        @click="personnageData.gloire = i; sauvegarderPersonnage()"
                      ></div>
                    </div>
                  </div>
                  <div>
                    <div class="flex items-center gap-2 mb-0.5">
                      <label class="text-xs font-bold font-montserrat">Statut</label>
                      <input 
                        v-model.number="personnageData.statut_social" 
                        type="number"
                        step="0.5"
                        min="0"
                        max="10"
                        @blur="sauvegarderPersonnage"
                        class="w-10 border border-stone-400 rounded px-1 py-0.5 text-center font-bold text-xs bg-white font-montserrat"
                      />
                    </div>
                    <div class="flex gap-1">
                      <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 border-blue-600 cursor-pointer transition-all hover:scale-110"
                        :class="{ 'bg-blue-600': i <= personnageData.statut_social }"
                        @click="personnageData.statut_social = i; sauvegarderPersonnage()"
                      ></div>
                    </div>
                  </div>
                  <div>
                    <label class="text-xs font-bold block mb-0.5 font-montserrat">Souillure</label>
                    <div class="flex gap-1">
                      <div v-for="i in 10" :key="i" class="w-6 h-6 rounded-full border-2 border-purple-900 cursor-pointer transition-all hover:scale-110"
                        :class="{ 'bg-purple-900': i <= personnageData.souillure }"
                        @click="personnageData.souillure = personnageData.souillure === i ? 0 : i; sauvegarderPersonnage()"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Initiative & XP -->
            <div class="rounded-xl p-4 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
              <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
              <div class="absolute inset-0 bg-amber-50/30"></div>
              <div class="relative z-10 space-y-3">
                <div>
                  <label class="text-sm font-bold text-center block mb-1 font-katana">INITIATIVE</label>
                  <input 
                    v-model.number="personnageData.initiative" 
                    type="number"
                    @blur="sauvegarderPersonnage"
                    class="w-full border-2 border-stone-300 rounded px-2 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                  />
                </div>
                <div>
                  <label class="text-sm font-bold text-center block mb-1 font-katana">EXPÉRIENCE</label>
                  <div class="grid grid-cols-3 gap-2">
                    <div>
                      <label class="text-xs text-center block mb-1 font-montserrat">Total</label>
                      <input 
                        v-model.number="personnageData.experience_points" 
                        type="number"
                        :min="minimumExperiencePoints"
                        @blur="if (personnageData.experience_points < minimumExperiencePoints) personnageData.experience_points = minimumExperiencePoints; sauvegarderPersonnage()"
                        class="w-full border-2 border-stone-300 rounded px-2 py-0.5 text-center font-bold text-sm bg-white font-montserrat"
                      />
                    </div>
                    <div>
                      <label class="text-xs text-center block mb-1 font-montserrat">Dépensé</label>
                      <div class="flex items-center justify-center gap-1">
                        <input 
                          :value="experienceDepenseAuto" 
                          type="number"
                          readonly
                          class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
                        />
                        <button 
                          @click="modaleDepenseXP = true"
                          class="w-5 h-5 rounded-full bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center text-xs font-bold ml-1"
                          title="Détail des dépenses d'XP"
                        >
                          ?
                        </button>
                      </div>
                    </div>
                    <div>
                      <label class="text-xs text-center block mb-1 font-montserrat">Restant</label>
                      <input 
                        :value="experienceRestant" 
                        type="number"
                        readonly
                        class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
                      />
                    </div>
                  </div>
                </div>
                <div>
                  <label class="text-sm font-bold text-center block mb-1 font-katana">RÉPUTATION</label>
                  <div class="grid grid-cols-2 gap-2">
                    <div>
                      <label class="text-xs text-center block mb-1 font-montserrat">Points</label>
                      <input 
                        :value="reputationPoints" 
                        type="number"
                        readonly
                        class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
                      />
                    </div>
                    <div>
                      <label class="text-xs text-center block mb-1 font-montserrat">Rang</label>
                      <input 
                        :value="rangReputation" 
                        type="number"
                        readonly
                        class="w-full border-2 border-stone-400 rounded px-2 py-0.5 text-center font-bold text-sm bg-stone-100 font-montserrat cursor-not-allowed"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Compétences -->
        <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90 mb-6">
          <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
          <div class="absolute inset-0 bg-amber-50/30"></div>
          <div class="relative z-10">
            <div class="flex justify-between items-center mb-4">
              <div class="flex items-center gap-2">
                <h2 class="text-2xl font-bold text-red-900 font-sakurata">Compétences</h2>
                <button 
                  @click="modaleTableND = true"
                  class="w-6 h-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center text-sm font-bold transition-all"
                  title="Voir la table de référence des ND"
                >
                  ?
                </button>
              </div>
              <div class="flex gap-2">
                <button 
                  @click="modeEditionCompetences = !modeEditionCompetences"
                  class="px-4 py-2 bg-gradient-to-b from-blue-700 to-blue-900 hover:from-blue-600 hover:to-blue-800 text-white rounded-lg font-bold transition-all border-2 border-blue-950 shadow-lg font-katana"
                >
                  {{ modeEditionCompetences ? '✓' : '✏️' }}
                </button>
                <button 
                  @click="ajouterCompetence"
                  class="px-4 py-2 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded-lg font-bold transition-all border-2 border-green-950 shadow-lg font-katana"
                >
                  +
                </button>
              </div>
            </div>
            
            <div class="overflow-x-auto bg-white/60 rounded-lg p-4">
              <table class="w-full text-sm">
                <thead>
                  <tr class="border-b-2 border-red-900">
                    <th class="text-left py-2 px-2 font-bold font-katana">Compétence</th>
                    <th class="text-center py-2 px-2 font-bold w-16 font-katana">Rang</th>
                    <th class="text-center py-2 px-2 font-bold w-24 font-katana">Trait</th>
                    <th class="text-center py-2 px-2 font-bold w-20 font-katana">Jet</th>
                    <th class="text-center py-2 px-2 font-bold w-16 font-katana">Art</th>
                    <th class="text-left py-2 px-2 font-bold font-katana">Spécialisations</th>
                    <th class="text-center py-2 px-2 font-bold w-20 font-katana">Description</th>
                    <th class="w-10"></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="comp in competences" :key="comp.id" class="border-b border-stone-300 hover:bg-amber-50/30">
                    <td class="py-2 px-2">
                      <input 
                        v-if="modeEditionCompetences"
                        v-model="comp.nom" 
                        @blur="sauvegarderCompetence(comp)"
                        class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                      />
                      <span v-else class="font-montserrat">{{ comp.nom }}</span>
                    </td>
                    <td class="py-2 px-2">
                      <input 
                        v-if="modeEditionCompetences"
                        v-model.number="comp.rang" 
                        type="number"
                        @blur="sauvegarderCompetence(comp)"
                        class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-bold font-montserrat"
                      />
                      <span v-else class="font-montserrat font-bold text-center block">{{ comp.rang }}</span>
                    </td>
                    <td class="py-2 px-2">
                      <input 
                        v-if="modeEditionCompetences"
                        v-model="comp.trait" 
                        @blur="sauvegarderCompetence(comp)"
                        class="w-full border border-stone-300 rounded px-2 py-1 text-center bg-white font-montserrat"
                      />
                      <span v-else class="font-montserrat text-center block">{{ comp.trait }}</span>
                    </td>
                    <td class="py-2 px-2 text-center">
                      <span class="font-montserrat font-bold text-green-700">{{ calculerJet(comp) }}</span>
                    </td>
                    <td class="py-2 px-2 text-center">
                      <input 
                        v-if="modeEditionCompetences"
                        v-model="comp.art" 
                        type="checkbox"
                        @change="sauvegarderCompetence(comp)"
                        class="w-5 h-5"
                      />
                      <span v-else class="font-montserrat">{{ comp.art ? '✓' : '' }}</span>
                    </td>
                    <td class="py-2 px-2">
                      <input 
                        v-if="modeEditionCompetences"
                        v-model="comp.specialisations" 
                        @blur="sauvegarderCompetence(comp)"
                        class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat text-xs"
                        placeholder="Séparées par ,"
                      />
                      <span v-else class="font-montserrat text-xs">{{ comp.specialisations }}</span>
                    </td>
                    <td class="py-2 px-2 text-center">
                      <button 
                        @click="ouvrirModaleDescription(comp)"
                        class="px-2 py-1 text-white rounded text-xs font-bold font-katana"
                        title="Voir/Modifier la description"
                      >
                        📝
                      </button>
                    </td>
                    <td class="py-2 px-2">
                      <button 
                        v-if="modeEditionCompetences"
                        @click="supprimerCompetence(comp.id)"
                        class="text-red-600 hover:text-red-800 font-bold text-lg"
                      >
                        ✕
                      </button>
                    </td>
                  </tr>
                  <tr v-if="competences.length === 0">
                    <td colspan="8" class="py-8 text-center text-stone-500 italic font-montserrat">
                      Aucune compétence pour le moment
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

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

        <!-- Armes & Armures -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          <!-- Armes -->
          <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold text-red-900 font-sakurata">⚔️ Armes</h2>
                <div class="flex gap-2">
                  <button 
                    @click="modeEditionArmes = !modeEditionArmes"
                    :class="modeEditionArmes ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'"
                    class="px-3 py-1 text-white rounded font-bold text-sm border-2 border-blue-950 font-katana transition-colors"
                  >
                    {{ modeEditionArmes ? '✓ Valider' : '✎ Éditer' }}
                  </button>
                  <button 
                    v-if="modeEditionArmes"
                    @click="ajouterArme"
                    class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-sm border-2 border-green-950 font-katana"
                  >
                    +
                  </button>
                </div>
              </div>
              <div class="space-y-3 max-h-96 overflow-y-auto pr-2">
                <!-- Mode édition -->
                <template v-if="modeEditionArmes">
                  <div v-for="arme in armes" :key="arme.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
                    <div class="flex justify-between items-start mb-2">
                      <input 
                        v-model="arme.nom" 
                        @blur="sauvegarderArme(arme)"
                        class="flex-1 font-bold border-b border-stone-400 bg-transparent font-montserrat"
                        placeholder="Nom de l'arme"
                      />
                      <button 
                        @click="supprimerArme(arme.id)"
                        class="text-red-600 hover:text-red-800 ml-2"
                      >
                        ✕
                      </button>
                    </div>
                    <div class="grid grid-cols-2 gap-2 text-sm">
                      <div>
                        <label class="text-xs text-stone-600 font-semibold font-montserrat">Type</label>
                        <input 
                          v-model="arme.type" 
                          @blur="sauvegarderArme(arme)"
                          class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                        />
                      </div>
                      <div>
                        <label class="text-xs text-stone-600 font-semibold font-montserrat">Dommages</label>
                        <input 
                          v-model="arme.dommages" 
                          @blur="sauvegarderArme(arme)"
                          class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                        />
                      </div>
                    </div>
                  </div>
                </template>
                <!-- Mode lecture -->
                <template v-else>
                  <div v-for="arme in armes" :key="arme.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
                    <div class="font-bold text-lg font-montserrat mb-1">{{ arme.nom || 'Sans nom' }}</div>
                    <div class="flex gap-4 text-sm text-stone-700 font-montserrat">
                      <div><span class="font-semibold">Type:</span> {{ arme.type || '-' }}</div>
                      <div><span class="font-semibold">Dommages:</span> {{ arme.dommages || '-' }}</div>
                    </div>
                  </div>
                </template>
                <div v-if="armes.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
                  Aucune arme
                </div>
              </div>
            </div>
          </div>

          <!-- Armures -->
          <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold text-red-900 font-sakurata">🛡️ Armures</h2>
                <div class="flex gap-2">
                  <button 
                    @click="modeEditionArmures = !modeEditionArmures"
                    :class="modeEditionArmures ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'"
                    class="px-3 py-1 text-white rounded font-bold text-sm border-2 border-blue-950 font-katana transition-colors"
                  >
                    {{ modeEditionArmures ? '✓ Valider' : '✎ Éditer' }}
                  </button>
                  <button 
                    v-if="modeEditionArmures"
                    @click="ajouterArmure"
                    class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-sm border-2 border-green-950 font-katana"
                  >
                    +
                  </button>
                </div>
              </div>
              <div class="space-y-3 max-h-96 overflow-y-auto pr-2">
                <!-- Mode édition -->
                <template v-if="modeEditionArmures">
                  <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
                    <div class="flex justify-between items-start mb-2">
                      <input 
                        v-model="armure.nom" 
                        @blur="sauvegarderArmure(armure)"
                        class="flex-1 font-bold border-b border-stone-400 bg-transparent font-montserrat"
                        placeholder="Nom de l'armure"
                      />
                      <button 
                        @click="supprimerArmure(armure.id)"
                        class="text-red-600 hover:text-red-800 ml-2"
                      >
                        ✕
                      </button>
                    </div>
                    <div class="grid grid-cols-2 gap-2 text-sm">
                      <div>
                        <label class="text-xs text-stone-600 font-semibold font-montserrat">ND Armure</label>
                        <input 
                          v-model.number="armure.nd_armure" 
                          type="number"
                          @blur="sauvegarderArmure(armure)"
                          class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                        />
                      </div>
                      <div>
                        <label class="text-xs text-stone-600 font-semibold font-montserrat">Réduction</label>
                        <input 
                          v-model.number="armure.reduction" 
                          type="number"
                          @blur="sauvegarderArmure(armure)"
                          class="w-full border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                        />
                      </div>
                    </div>
                  </div>
                </template>
                <!-- Mode lecture -->
                <template v-else>
                  <div v-for="armure in armures" :key="armure.id" class="border-2 border-amber-800/40 rounded-lg p-3 bg-white/60">
                    <div class="font-bold text-lg font-montserrat mb-1">{{ armure.nom || 'Sans nom' }}</div>
                    <div class="flex gap-4 text-sm text-stone-700">
                      <div><span class="font-semibold">ND Armure:</span> {{ armure.nd_armure || '-' }}</div>
                      <div><span class="font-semibold">Réduction:</span> {{ armure.reduction || '-' }}</div>
                    </div>
                  </div>
                </template>
                <div v-if="armures.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
                  Aucune armure
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Avantages & Ressources -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Avantages/Désavantages -->
          <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold text-red-900 font-sakurata">✨ Avantages</h2>
                <div class="flex gap-2">
                  <button 
                    @click="modeEditionAvantages = !modeEditionAvantages"
                    :class="modeEditionAvantages ? 'bg-blue-600 hover:bg-blue-700' : 'bg-green-600 hover:bg-green-700'"
                    class="px-3 py-1 text-white rounded font-bold text-sm border-2 border-blue-950 font-katana transition-colors"
                  >
                    {{ modeEditionAvantages ? '✓ Valider' : '✎ Éditer' }}
                  </button>
                  <button 
                    v-if="modeEditionAvantages"
                    @click="ajouterAvantage"
                    class="px-3 py-1 bg-gradient-to-b from-green-700 to-green-900 hover:from-green-600 hover:to-green-800 text-white rounded font-bold text-sm border-2 border-green-950 font-katana"
                  >
                    +
                  </button>
                </div>
              </div>
              <div class="space-y-2 max-h-96 overflow-y-auto pr-2">
                <!-- Mode édition -->
                <template v-if="modeEditionAvantages">
                  <div v-for="avantage in avantages" :key="avantage.id" class="border-b border-amber-800/30 pb-2 bg-white/40 px-2 py-2 rounded">
                    <div class="flex items-center gap-2">
                      <input 
                        v-model="avantage.nom" 
                        @blur="sauvegarderAvantage(avantage)"
                        class="flex-1 border border-stone-300 rounded px-2 py-1 bg-white font-montserrat"
                        placeholder="Nom"
                      />
                      <select 
                        v-model="avantage.type"
                        @change="sauvegarderAvantage(avantage)"
                        class="border border-stone-300 rounded px-2 py-1 bg-white font-bold"
                      >
                        <option value="avantage">+</option>
                        <option value="desavantage">-</option>
                      </select>
                      <input 
                        v-model.number="avantage.rang" 
                        type="number"
                        @blur="sauvegarderAvantage(avantage)"
                        class="w-16 border border-stone-300 rounded px-2 py-1 text-center bg-white font-bold font-montserrat"
                        placeholder="Rang"
                      />
                      <button 
                        @click="ouvrirModaleDescriptionAvantage(avantage)"
                        class="px-2 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded text-sm font-bold"
                        title="Éditer la description"
                      >
                        📝
                      </button>
                      <button 
                        @click="supprimerAvantage(avantage.id)"
                        class="text-red-600 hover:text-red-800"
                      >
                        ✕
                      </button>
                    </div>
                  </div>
                </template>
                <!-- Mode lecture -->
                <template v-else>
                  <div v-for="avantage in avantagesTries" :key="avantage.id" class="border-b border-amber-800/30 pb-2 bg-white/40 px-3 py-2 rounded">
                    <div class="flex items-center gap-3">
                      <div class="flex-1 font-semibold font-montserrat">{{ avantage.nom || 'Sans nom' }}</div>
                      <div class="flex items-center gap-2">
                        <div class="font-bold text-lg" :class="avantage.type === 'avantage' ? 'text-green-700' : 'text-red-700'">
                        {{ avantage.type === 'avantage' ? '+' : '-' }}{{ avantage.rang || 0 }}
                        </div>
                        <div class="text-xs font-semibold font-montserrat" :class="avantage.type === 'avantage' ? 'text-green-600' : 'text-red-600'">
                          ({{ avantage.type === 'avantage' ? '-' : '+' }}{{ avantage.rang || 0 }} XP)
                        </div>
                      </div>
                    </div>
                    <div v-if="avantage.description" class="mt-1 text-xs text-stone-600 italic font-montserrat">
                      {{ avantage.description }}
                    </div>
                  </div>
                </template>
                <div v-if="avantages.length === 0" class="text-center py-8 text-stone-500 italic font-montserrat">
                  Aucun avantage/désavantage
                </div>
              </div>
            </div>
          </div>

          <!-- Ressources -->
          <div class="rounded-xl p-6 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-2xl relative overflow-hidden bg-white/90">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <h2 class="text-xl font-bold text-red-900 mb-4 font-sakurata">💰 Ressources</h2>
              <div class="space-y-3">
                <div class="flex items-center gap-3 bg-white/40 p-3 rounded-lg">
                  <label class="font-bold w-20 font-katana">Koku</label>
                  <input 
                    v-model.number="ressources.koku" 
                    type="number"
                    @blur="sauvegarderRessources"
                    class="flex-1 border-2 border-stone-300 rounded px-3 py-2 bg-white font-bold text-lg font-montserrat"
                  />
                  <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap">= {{ ressources.koku * 50 }} bu</span>
                </div>
                <div class="flex items-center gap-3 bg-white/40 p-3 rounded-lg">
                  <label class="font-bold w-20 font-katana">Bu</label>
                  <input 
                    v-model.number="ressources.bu" 
                    type="number"
                    @blur="sauvegarderRessources"
                    class="flex-1 border-2 border-stone-300 rounded px-3 py-2 bg-white font-bold text-lg font-montserrat"
                  />
                  <span class="text-xs text-stone-600 font-montserrat whitespace-nowrap">= {{ ressources.bu * 10 }} zeni</span>
                </div>
                <div class="flex items-center gap-3 bg-white/40 p-3 rounded-lg">
                  <label class="font-bold w-20 font-katana">Zeni</label>
                  <input 
                    v-model.number="ressources.zeni" 
                    type="number"
                    @blur="sauvegarderRessources"
                    class="flex-1 border-2 border-stone-300 rounded px-3 py-2 bg-white font-bold text-lg font-montserrat"
                  />
                </div>
              </div>
            </div>
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
/* Ajout d'un style pour le cadre des sections */
.rounded-xl {
  position: relative;
  overflow: hidden;
}

.rounded-xl::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url('/cadre.png');
  background-size: 250%;
  background-position: center;
  z-index: 1;
}

.rounded-xl > * {
  position: relative;
  z-index: 2;
}
</style>