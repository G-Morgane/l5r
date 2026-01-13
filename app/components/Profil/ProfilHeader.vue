<template>
  <div class="flex items-center justify-between mb-6">
    <h1 class="text-5xl font-bold text-white font-sakurata drop-shadow-lg">⚔️ Profil</h1>
  <BackButton @click="goBack" class="mb-4" blanc>← Retour</BackButton>
  </div>
</template>

<script setup>  
  const goBack = () => {
    window.history.length > 1 ? window.history.back() : window.location.href = '/';
  };
</script>