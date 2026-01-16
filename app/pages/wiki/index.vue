<template>
  <PageWrapper :loading="loading" loading-message="Chargement du wiki...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

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
  </PageWrapper>
</template>

<script setup>
const personnageActif = usePersonnageActif()
const loading = ref(false)

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
