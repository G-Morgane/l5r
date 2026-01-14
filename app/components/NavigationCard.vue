<template>
  <NuxtLink :to="link" class="group block transition-transform duration-300 flex flex-col items-center justify-center" >
    <div class="relative">
      <img :src="iconSrc" :alt="title" class="w-24 h-12 object-contain mb-2" />
    </div>
    <span class=" text-center font-bold text-stone-900 font-katana">{{ title }}</span>
  </NuxtLink>
</template>

<script setup>
const route = useRoute()

const props = defineProps({
  link: {
    type: String,
    required: true
  },
  emoji: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  }
})

const isActive = computed(() => route.path === props.link)

const iconSrc = computed(() => {
  const iconMap = {
    '/journal': '/journal_icon.png',
    '/wiki': '/wiki_icone.png',
    '/profil': '/profile_icone.png',
    '/inventaire': '/inventaire_icone.png',
    '/sorts': '/sorts_icone.png',
    '/carte': '/carte_icone.png',
    '/intrigues': '/intrigue_icone.png',
    '/histoire': '/journal_icon.png' // Utilise journal_icon.png pour histoire en attendant
  }
  return iconMap[props.link] || '/journal_icon.png'
})

const srcEncore = '/cercle_encre.png'
</script>
