<template>
  <div class="rich-text-editor">
    <QuillEditor
      v-model:content="content"
      :options="editorOptions"
      content-type="html"
      @update:content="handleUpdate"
      class="custom-quill"
    />
  </div>
</template>

<script setup>
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

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

const content = ref(props.modelValue)

const editorOptions = {
  theme: 'snow',
  placeholder: props.placeholder,
  modules: {
    toolbar: [
      ['bold', 'italic', 'underline'],
      [{ 'header': [2, 3, false] }],
      ['blockquote'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      ['clean']
    ]
  }
}

const handleUpdate = (newContent) => {
  emit('update:modelValue', newContent)
}

watch(() => props.modelValue, (newValue) => {
  if (newValue !== content.value) {
    content.value = newValue
  }
})
</script>

<style scoped>
.custom-quill :deep(.ql-toolbar) {
  border: 2px solid rgb(120 53 15 / 0.3);
  border-bottom: none;
  border-radius: 0.75rem 0.75rem 0 0;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}

.custom-quill :deep(.ql-container) {
  border: 2px solid rgb(120 53 15 / 0.3);
  border-top: none;
  border-radius: 0 0 0.75rem 0.75rem;
  min-height: 500px;
  font-family: 'Montserrat', sans-serif;
}

.custom-quill :deep(.ql-editor) {
  color: rgb(28 25 23);
  font-size: 16px;
  line-height: 1.625;
}

.custom-quill :deep(.ql-editor.ql-blank::before) {
  color: rgb(120 113 108 / 0.5);
  font-style: italic;
}
</style>
