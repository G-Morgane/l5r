<template>
  <div class="text-center py-20">
    <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 shadow-xl relative overflow-hidden bg-white/80 max-w-xl mx-auto">
      <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
      <div class="absolute inset-0 bg-amber-50/30"></div>
      <div class="relative z-10">
        <p class="text-stone-800 text-xs font-semibold mb-4 font-manga">Aucun personnage sélectionné</p>
        <NuxtLink to="/" class="inline-block px-8 py-4 bg-gradient-to-b from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 text-amber-50 rounded-lg font-bold text-xs transition-all duration-300 border-2 border-red-950 shadow-lg">
          Sélectionner un personnage
        </NuxtLink>
      </div>
    </div>
  </div>
</template>