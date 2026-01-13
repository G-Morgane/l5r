<template>
  <NuxtLink :to="link" class="group block w-24 h-24 hover:scale-110 transition-transform duration-300">
    <img :src="iconSrc" :alt="title" class="w-full h-full object-contain" />
  </NuxtLink>
</template>

<script setup>
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
</script>
