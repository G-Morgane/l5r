<template>
  <div class="relative overflow-hidden h-screen">
    <!-- Fond image japonaise -->
    <div class="absolute inset-0" style="background-image: url('/fond_long.png'); background-position: top, bottom; background-repeat: no-repeat; background-size: 100% auto, 100% auto;">
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10">
      <!-- En-tête personnage -->
      <PersonnageHeader 
          :personnage="personnageActif"
          @deselect="changeCharacter()"
        />

      <div class="flex flex-col mt-12">

        <!-- Catégories principales -->
        <div class="flex flex-wrap justify-between px-18">
          <NuxtLink
            to="/wiki/category-clans"
            class="rounded-xl overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
          >
            <img 
              src="/wiki/clans.png" 
              alt="Clans" 
              class="w-66 h-42 object-cover"
            />
          </NuxtLink>
          
          <NuxtLink
            to="/wiki/category-lieux"
            class="rounded-xl overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
          >
            <img 
              src="/wiki/lieux.png" 
              alt="Lieux" 
              class="w-66 h-42 object-cover"
            />
          </NuxtLink>
          
          <NuxtLink
            to="/wiki/category-personnages"
            class="rounded-xl overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
          >
            <img 
              src="/wiki/personnages.png" 
              alt="Personnages" 
              class="w-66 h-42 object-cover"
            />
          </NuxtLink>
          
          <NuxtLink
            to="/wiki/category-autre"
            class="rounded-xl overflow-hidden cursor-pointer transition-all duration-300 hover:scale-105"
          >
            <img 
              src="/wiki/autre.png" 
              alt="Autre" 
              class="w-66 h-42 object-cover"
            />
          </NuxtLink>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
const personnageActif = usePersonnageActif()

// Rediriger si pas de personnage actif
onMounted(() => {
  if (!personnageActif.value) {
    navigateTo('/')
  }
})

const changeCharacter = () => {
  navigateTo('/')
}
</script>
