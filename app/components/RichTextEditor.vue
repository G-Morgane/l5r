<template>
  <div class="rich-text-editor">
    <!-- Barre d'outils -->
    <div v-if="editor" class="toolbar bg-amber-100/80 border-2 border-amber-900/30 rounded-t-xl p-3 flex flex-wrap gap-2 shadow-sm">
      <button
        @click="editor.chain().focus().toggleBold().run()"
        :class="editor.isActive('bold') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Gras"
      >
        <span class="font-bold">B</span>
      </button>
      <button
        @click="editor.chain().focus().toggleItalic().run()"
        :class="editor.isActive('italic') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Italique"
      >
        <span class="italic">I</span>
      </button>
      <button
        @click="editor.chain().focus().toggleUnderline().run()"
        :class="editor.isActive('underline') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Souligné"
      >
        <span class="underline">U</span>
      </button>
      <div class="w-px h-8 bg-amber-900/30"></div>
      <button
        @click="editor.chain().focus().toggleHeading({ level: 2 }).run()"
        :class="editor.isActive('heading', { level: 2 }) ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Titre"
      >
        H2
      </button>
      <button
        @click="editor.chain().focus().toggleHeading({ level: 3 }).run()"
        :class="editor.isActive('heading', { level: 3 }) ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Sous-titre"
      >
        H3
      </button>
      <div class="w-px h-8 bg-amber-900/30"></div>
      <button
        @click="editor.chain().focus().toggleBulletList().run()"
        :class="editor.isActive('bulletList') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Liste à puces"
      >
        • List
      </button>
      <button
        @click="editor.chain().focus().toggleOrderedList().run()"
        :class="editor.isActive('orderedList') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Liste numérotée"
      >
        1. List
      </button>
      <div class="w-px h-8 bg-amber-900/30"></div>
      <button
        @click="editor.chain().focus().toggleBlockquote().run()"
        :class="editor.isActive('blockquote') ? 'bg-amber-700 text-white' : 'bg-white text-stone-800'"
        class="px-3 py-1.5 rounded-lg hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Citation"
      >
        "
      </button>
      <button
        @click="editor.chain().focus().setHorizontalRule().run()"
        class="px-3 py-1.5 rounded-lg bg-white text-stone-800 hover:bg-amber-600 hover:text-white transition-colors font-semibold text-sm border border-amber-900/20"
        type="button"
        title="Ligne horizontale"
      >
        —
      </button>
    </div>

    <!-- Zone d'édition -->
    <editor-content :editor="editor" class="editor-content" />
  </div>
</template>

<script setup>
import { useEditor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Placeholder from '@tiptap/extension-placeholder'
import Underline from '@tiptap/extension-underline'
import TextAlign from '@tiptap/extension-text-align'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: 'Commencez à écrire...'
  }
})

const emit = defineEmits(['update:modelValue'])

const editor = useEditor({
  content: props.modelValue,
  extensions: [
    StarterKit,
    Underline,
    TextAlign.configure({
      types: ['heading', 'paragraph'],
    }),
    Placeholder.configure({
      placeholder: props.placeholder
    })
  ],
  editorProps: {
    attributes: {
      class: 'prose max-w-none focus:outline-none min-h-[500px] p-4 bg-white border-2 border-t-0 border-amber-900/30 rounded-b-xl text-stone-900 font-montserrat'
    }
  },
  onUpdate: ({ editor }) => {
    emit('update:modelValue', editor.getHTML())
  }
})

watch(() => props.modelValue, (value) => {
  const isSame = editor.value.getHTML() === value
  if (isSame) return
  editor.value.commands.setContent(value, false)
})

onBeforeUnmount(() => {
  editor.value?.destroy()
})
</script>

<style scoped>
:deep(.ProseMirror) {
  min-height: 500px;
  outline: none;
}

:deep(.ProseMirror p.is-editor-empty:first-child::before) {
  content: attr(data-placeholder);
  float: left;
  color: rgb(120 113 108 / 0.5);
  pointer-events: none;
  height: 0;
  font-style: italic;
}

:deep(.ProseMirror h2) {
  font-size: 1.5rem;
  font-weight: bold;
  color: rgb(28 25 23);
  margin-top: 1.5rem;
  margin-bottom: 0.75rem;
  font-family: 'Sakurata', cursive;
}

:deep(.ProseMirror h3) {
  font-size: 1.25rem;
  font-weight: bold;
  color: rgb(41 37 36);
  margin-top: 1rem;
  margin-bottom: 0.5rem;
  font-family: 'Katana', sans-serif;
}

:deep(.ProseMirror ul),
:deep(.ProseMirror ol) {
  padding-left: 1.5rem;
  margin-top: 1rem;
  margin-bottom: 1rem;
}

:deep(.ProseMirror ul li) {
  list-style-type: disc;
}

:deep(.ProseMirror ol li) {
  list-style-type: decimal;
}

:deep(.ProseMirror blockquote) {
  border-left: 4px solid rgb(180 83 9);
  padding-left: 1rem;
  font-style: italic;
  color: rgb(87 83 78);
  margin-top: 1rem;
  margin-bottom: 1rem;
}

:deep(.ProseMirror hr) {
  border-color: rgb(120 53 15 / 0.5);
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
}

:deep(.ProseMirror p) {
  margin-bottom: 0.75rem;
  line-height: 1.625;
  font-family: 'Montserrat', sans-serif;
}

:deep(.ProseMirror strong) {
  font-weight: bold;
  color: rgb(28 25 23);
}

:deep(.ProseMirror em) {
  font-style: italic;
}

:deep(.ProseMirror u) {
  text-decoration: underline;
}
</style>
