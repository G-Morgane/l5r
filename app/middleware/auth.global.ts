export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser()

  // Pages publiques qui ne nécessitent pas d'authentification
  const publicPages = ['/login']

  // Si l'utilisateur n'est pas connecté et essaie d'accéder à une page protégée
  if (!user.value && !publicPages.includes(to.path)) {
    return navigateTo('/login')
  }

  // Si l'utilisateur est connecté et essaie d'accéder à la page login
  if (user.value && to.path === '/login') {
    return navigateTo('/')
  }
})
