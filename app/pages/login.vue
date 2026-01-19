<template>
  <div class="min-h-screen relative overflow-hidden flex items-center justify-center">
    <!-- Fond -->
    <div class="absolute inset-0">
      <img
        src="/background.png"
        alt="Background"
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/40"></div>
    </div>

    <!-- Formulaire de connexion -->
    <div class="relative z-10 w-full max-w-md mx-4">
      <div class="bg-white rounded-xl p-8 shadow-2xl border-2 border-amber-800/60">
        <!-- Header -->
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold text-red-900 font-sakurata mb-2">Bienvenue</h1>
          <p class="text-stone-600 font-montserrat">Connectez-vous pour accéder à vos personnages</p>
        </div>

        <!-- Message d'erreur -->
        <div v-if="error" class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm">
          {{ error }}
        </div>

        <!-- Formulaire -->
        <form @submit.prevent="handleLogin" class="space-y-5">
          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Email</label>
            <input
              v-model="email"
              type="email"
              required
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="votre@email.com"
            />
          </div>

          <div>
            <label class="block text-sm font-semibold mb-2 text-stone-700">Mot de passe</label>
            <input
              v-model="password"
              type="password"
              required
              class="w-full px-4 py-3 border-2 border-stone-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition-colors"
              placeholder="Votre mot de passe"
            />
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full py-3 bg-gradient-to-r from-red-700 to-red-900 hover:from-red-600 hover:to-red-800 disabled:from-gray-400 disabled:to-gray-500 text-white rounded-lg font-bold font-katana transition-all duration-300 shadow-lg"
          >
            <span v-if="loading">Connexion en cours...</span>
            <span v-else>Se connecter</span>
          </button>
        </form>

      </div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  layout: false
})

const client = useSupabaseClient()
const user = useSupabaseUser()

// Rediriger si déjà connecté
watch(user, (newUser) => {
  if (newUser) {
    navigateTo('/')
  }
}, { immediate: true })

// Login
const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

const handleLogin = async () => {
  error.value = ''
  loading.value = true

  try {
    const { error: authError } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value
    })

    if (authError) {
      if (authError.message.includes('Invalid login credentials')) {
        error.value = 'Email ou mot de passe incorrect'
      } else {
        error.value = authError.message
      }
    } else {
      navigateTo('/')
    }
  } catch (e) {
    error.value = 'Une erreur est survenue'
  } finally {
    loading.value = false
  }
}

</script>
