<template>
  <div class="min-h-screen relative overflow-hidden">
    <!-- Fond image japonaise -->
    <div v-if="useRoute().fullPath.includes('profil') && !loading" class="absolute inset-0">
      <!-- Partie supérieure -->
      <div class="absolute top-0 left-0 right-0 h-full overflow-hidden" style="background-size: 100% 100%;" v-if="!customBackground">
        <img
          src="/fond_long.png"
          alt="Japanese room background top"
          class="w-full h-full object-cover object-top"
        />
      </div>
      <!-- Partie inférieure -->
      <div class="absolute bottom-0 left-0 right-0 h-1/2 overflow-hidden" v-if="!customBackground">
        <img
          src="/fond_long.png"
          alt="Japanese room background bottom"
          class="w-full h-full object-cover object-bottom scale-x-[-1]"
        />
      </div>
      <slot v-if="customBackground" name="background" />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>
    <div v-else class="absolute inset-0">
      <!-- Partie supérieure -->
      <div class="absolute top-0 left-0 right-0 h-full overflow-hidden" style="background-size: 100% 100%;" v-if="!customBackground">
        <img
          src="/fond_long.png"
          alt="Japanese room background top"
          class="w-full h-full object-cover object-top"
        />
      </div>
      <slot v-if="customBackground" name="background" />
      <div class="absolute inset-0 bg-black/10"></div>
    </div>

    <!-- Contenu principal -->
    <div class="relative z-10 container mx-auto px-4 py-4">
      <!-- Header slot (toujours visible) -->
      <div class="max-w-7xl mx-auto">
        <slot name="header" />
      </div>

      <!-- Body content -->
      <div class="max-w-7xl mx-auto" :class="bodyClass">
        <!-- Loader inline dans la zone de contenu -->
        <PageLoader v-if="loading" :message="loadingMessage" />
        <!-- Contenu réel -->
        <slot v-else />
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  loading: {
    type: Boolean,
    default: false
  },
  loadingMessage: {
    type: String,
    default: 'Chargement...'
  },
  bodyClass: {
    type: String,
    default: ''
  },
  customBackground: {
    type: Boolean,
    default: false
  }
})
</script>
