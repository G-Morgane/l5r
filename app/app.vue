<template>
  <NuxtPage />
</template>

<script setup>
// Configuration des transitions de page
const pageTransition = {
  name: 'page',
  mode: 'out-in'
}
</script>

<style>
@import "tailwindcss";
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap');

/* Polices personnalisées */
@font-face {
  font-family: 'Katana';
  src: url('/fonts/KATANA.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Sakurata';
  src: url('/fonts/SAKURATA.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Sigokae';
  src: url('/fonts/Sigokae Demo.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Manga';
  src: url('/fonts/Manga.otf') format('opentype');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Manga';
  src: url('/fonts/Manga Bold.otf') format('opentype');
  font-weight: bold;
  font-style: normal;
}

@font-face {
  font-family: 'Japanatsuki';
  src: url('/fonts/Japanatsuki.ttf') format('opentype');
  font-weight: bold;
  font-style: normal;
}

@layer base {
  body {
    font-family: 'Sigokae', 'Georgia', serif;
  }
}

@layer utilities {
  .text-shadow-lg {
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
  }
  
  .font-katana {
    font-family: 'Katana', sans-serif;
  }
  
  .font-sakurata {
    font-family: 'Sakurata', cursive;
  }
  
  .font-sigokae {
    font-family: 'Sigokae', serif;
  }
  
  .font-montserrat {
    font-family: 'Montserrat', sans-serif;
  }
  
  .font-manga {
    font-family: 'Katana', sans-serif;
  }
  
  .paper-texture {
    background-image: 
      repeating-linear-gradient(0deg, rgba(0,0,0,.03) 0px, transparent 1px, transparent 2px, rgba(0,0,0,.03) 3px),
      repeating-linear-gradient(90deg, rgba(0,0,0,.03) 0px, transparent 1px, transparent 2px, rgba(0,0,0,.03) 3px);
  }
}

.maxW500 {
  max-width: 500px;
  margin-left: auto;
  margin-right: auto;
}

/* Page Transitions - Fade */
.page-enter-active,
.page-leave-active {
  transition: opacity 0.3s ease;
}

.page-enter-from,
.page-leave-to {
  opacity: 0;
}
</style>