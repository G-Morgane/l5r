// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  modules: ['@nuxtjs/supabase', '@nuxt/icon'],
  supabase: {
    redirect: false
  },
  postcss: {
    plugins: {
      '@tailwindcss/postcss': {},
    },
  },
  css: ['@/assets/css/global.css'],
  head: {
    link: [
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap' }
    ]
  },
  tailwindcss: {
    config: {
      theme: {
        fontFamily: {
          sans: ['Montserrat', 'ui-sans-serif', 'system-ui'],
        }
      }
    }
  }
})
