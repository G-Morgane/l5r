<template>
  <PageWrapper :loading="loading" loading-message="Chargement des notes...">
    <template #header>
      <PersonnageHeader
        :personnage="personnageActif"
        @deselect="changeCharacter()"
      />
    </template>

    <div v-if="personnageActif" class="px-8">
      <!-- Toolbar -->
      <div class="flex justify-between items-center mb-6">
        <BackButton @click="ajouterNote">Nouvelle note</BackButton>
      </div>

      <!-- Canvas pour les notes en positionnement libre -->
      <div
        ref="canvasRef"
        class="relative w-full bg-amber-900/5 rounded-xl border-2 border-dashed border-amber-800/30"
        style="min-height: 100vh;"
      >
        <!-- Notes en position absolue -->
        <div
          v-for="note in notes"
          :key="note.id"
          class="absolute group flex flex-col border-4 bg-amber-50/60 shadow-lg"
          :style="{
            left: note.position_x + 'px',
            top: note.position_y + 'px',
            width: note.width + 'px',
            height: note.height + 'px',
            borderColor: getBorderColor(note.color),
            zIndex: draggingNote?.id === note.id ? 100 : 1
          }"
        >
          <!-- Header de la note (drag handle) -->
          <div
            class="drag-handle flex items-center justify-between px-3 py-2 cursor-move border-b-2 border-amber-800/50 shrink-0 bg-amber-100/50"
            @mousedown="startDrag($event, note)"
          >
            <input
              v-model="note.title"
              @blur="sauvegarderNote(note)"
              @keyup.enter="($event.target as HTMLInputElement).blur()"
              class="bg-transparent font-bold text-sm flex-1 outline-none placeholder:text-stone-500 cursor-text"
              placeholder="Titre..."
              @mousedown.stop
            />
            <div class="flex items-center gap-1">
              <!-- Couleurs -->
              <div class="hidden group-hover:flex gap-1 mr-2">
                <button
                  v-for="color in colors"
                  :key="color"
                  @click="changerCouleur(note, color)"
                  class="w-4 h-4 rounded-full border border-white/50 hover:scale-110 transition-transform"
                  :class="getColorDot(color)"
                ></button>
              </div>
              <!-- Supprimer -->
              <button
                @click="supprimerNote(note.id)"
                class="opacity-0 group-hover:opacity-100 text-red-700 hover:text-red-900 transition-opacity p-1"
              >
                <Icon name="heroicons:trash" class="w-4 h-4" />
              </button>
            </div>
          </div>

          <!-- Contenu de la note -->
          <textarea
            v-model="note.content"
            @blur="sauvegarderNote(note)"
            class="w-full flex-1 p-3 bg-transparent outline-none font-montserrat text-sm resize-none"
            placeholder="Écrivez ici..."
          ></textarea>

          <!-- Handle de resize -->
          <div
            class="absolute bottom-0 right-0 w-5 h-5 cursor-se-resize flex items-center justify-center text-amber-700 z-10"
            @mousedown="startResize($event, note)"
          >
            <svg class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
              <path d="M22 22H20V20H22V22ZM22 18H20V16H22V18ZM18 22H16V20H18V22ZM22 14H20V12H22V14ZM18 18H16V16H18V18ZM14 22H12V20H14V22Z"/>
            </svg>
          </div>
        </div>

        <!-- Message si aucune note -->
        <div v-if="notes.length === 0 && !loading" class="absolute inset-0 flex items-center justify-center">
          <div class="rounded-xl p-8 border-2 border-amber-800/60 ring-4 ring-amber-900/30 relative overflow-hidden bg-white/80 max-w-md">
            <div class="absolute inset-0" style="background-image: url('/cadre.png'); background-size: 250%; background-position: center;"></div>
            <div class="absolute inset-0 bg-amber-50/30"></div>
            <div class="relative z-10">
              <p class="text-stone-800 text-lg font-semibold mb-4 font-manga">Aucune note pour le moment</p>
              <p class="text-stone-600 font-montserrat">Créez votre première note !</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </PageWrapper>
</template>

<script setup lang="ts">
interface Note {
  id: string
  personnage_id: string
  title: string
  content: string
  color: string
  width: number
  height: number
  position_x: number
  position_y: number
}

const client = useSupabaseClient()
const personnageActif = usePersonnageActif()

const loading = ref(true)
const notes = ref<Note[]>([])
const saveTimeout = ref<NodeJS.Timeout | null>(null)
const canvasRef = ref<HTMLElement | null>(null)

// Drag state
const draggingNote = ref<Note | null>(null)
const dragStartX = ref(0)
const dragStartY = ref(0)
const dragStartPosX = ref(0)
const dragStartPosY = ref(0)

// Resize state
const resizingNote = ref<Note | null>(null)
const resizeStartX = ref(0)
const resizeStartY = ref(0)
const resizeStartWidth = ref(0)
const resizeStartHeight = ref(0)

const colors = ['amber', 'rose', 'sky', 'emerald', 'violet', 'stone']

// Charger les notes
const chargerNotes = async () => {
  if (!personnageActif.value?.id) return

  const { data, error } = await client
    .from('pense_bete_notes')
    .select('*')
    .eq('personnage_id', personnageActif.value.id)

  if (error) {
    console.error('Erreur lors du chargement des notes:', error)
    return
  }

  // Assurer que position_x et position_y existent (migration)
  notes.value = (data || []).map((note, index) => ({
    ...note,
    position_x: note.position_x ?? (20 + (index % 4) * 300),
    position_y: note.position_y ?? (20 + Math.floor(index / 4) * 220)
  }))
}

// Ajouter une note
const ajouterNote = async () => {
  if (!personnageActif.value?.id) return

  // Trouver une position libre
  const offsetX = (notes.value.length % 4) * 300 + 20
  const offsetY = Math.floor(notes.value.length / 4) * 220 + 20

  const newNote = {
    personnage_id: personnageActif.value.id,
    title: 'Nouvelle note',
    content: '',
    color: 'amber',
    width: 280,
    height: 200,
    position_x: offsetX,
    position_y: offsetY
  }

  const { data, error } = await client
    .from('pense_bete_notes')
    .insert(newNote)
    .select()
    .single()

  if (error) {
    console.error('Erreur lors de la création:', error)
    return
  }

  notes.value.push(data)
}

// Sauvegarder une note (avec debounce)
const sauvegarderNote = async (note: Note) => {
  if (saveTimeout.value) {
    clearTimeout(saveTimeout.value)
  }

  saveTimeout.value = setTimeout(async () => {
    const { error } = await client
      .from('pense_bete_notes')
      .update({
        title: note.title,
        content: note.content,
        color: note.color,
        width: note.width,
        height: note.height,
        position_x: note.position_x,
        position_y: note.position_y
      })
      .eq('id', note.id)

    if (error) {
      console.error('Erreur lors de la sauvegarde:', error)
    }
  }, 500)
}

// Supprimer une note
const supprimerNote = async (id: string) => {
  if (!confirm('Supprimer cette note ?')) return

  const { error } = await client
    .from('pense_bete_notes')
    .delete()
    .eq('id', id)

  if (error) {
    console.error('Erreur lors de la suppression:', error)
    return
  }

  notes.value = notes.value.filter(n => n.id !== id)
}

// Changer la couleur
const changerCouleur = (note: Note, color: string) => {
  note.color = color
  sauvegarderNote(note)
}

// Couleurs de bordure
const getBorderColor = (color: string) => {
  const colors: Record<string, string> = {
    amber: '#92400e',
    rose: '#9f1239',
    sky: '#075985',
    emerald: '#065f46',
    violet: '#5b21b6',
    stone: '#292524'
  }
  return colors[color] || colors.amber
}

const getColorDot = (color: string) => {
  const classes: Record<string, string> = {
    amber: 'bg-amber-600',
    rose: 'bg-rose-600',
    sky: 'bg-sky-600',
    emerald: 'bg-emerald-600',
    violet: 'bg-violet-600',
    stone: 'bg-stone-600'
  }
  return classes[color] || classes.amber
}

// Drag functions (positionnement libre)
const startDrag = (event: MouseEvent, note: Note) => {
  event.preventDefault()

  draggingNote.value = note
  dragStartX.value = event.clientX
  dragStartY.value = event.clientY
  dragStartPosX.value = note.position_x
  dragStartPosY.value = note.position_y

  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
}

const onDrag = (event: MouseEvent) => {
  if (!draggingNote.value || !canvasRef.value) return

  const deltaX = event.clientX - dragStartX.value
  const deltaY = event.clientY - dragStartY.value

  const canvasRect = canvasRef.value.getBoundingClientRect()

  // Calculer la nouvelle position
  let newX = dragStartPosX.value + deltaX
  let newY = dragStartPosY.value + deltaY

  // Limiter aux bords du canvas
  newX = Math.max(0, Math.min(newX, canvasRect.width - draggingNote.value.width))
  newY = Math.max(0, Math.min(newY, canvasRect.height - draggingNote.value.height))

  draggingNote.value.position_x = newX
  draggingNote.value.position_y = newY
}

const stopDrag = () => {
  if (draggingNote.value) {
    sauvegarderNote(draggingNote.value)
  }
  draggingNote.value = null
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
}

// Resize functions
const startResize = (event: MouseEvent, note: Note) => {
  event.preventDefault()
  event.stopPropagation()

  resizingNote.value = note
  resizeStartX.value = event.clientX
  resizeStartY.value = event.clientY
  resizeStartWidth.value = note.width
  resizeStartHeight.value = note.height

  document.addEventListener('mousemove', onResize)
  document.addEventListener('mouseup', stopResize)
}

const onResize = (event: MouseEvent) => {
  if (!resizingNote.value) return

  const deltaX = event.clientX - resizeStartX.value
  const deltaY = event.clientY - resizeStartY.value

  resizingNote.value.width = Math.max(200, resizeStartWidth.value + deltaX)
  resizingNote.value.height = Math.max(120, resizeStartHeight.value + deltaY)
}

const stopResize = () => {
  if (resizingNote.value) {
    sauvegarderNote(resizingNote.value)
  }
  resizingNote.value = null
  document.removeEventListener('mousemove', onResize)
  document.removeEventListener('mouseup', stopResize)
}

const changeCharacter = () => {
  navigateTo('/')
}

onMounted(async () => {
  if (!personnageActif.value) {
    loading.value = false
    navigateTo('/')
  } else {
    try {
      await chargerNotes()
    } finally {
      loading.value = false
    }
  }
})

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
  document.removeEventListener('mousemove', onResize)
  document.removeEventListener('mouseup', stopResize)
})
</script>
