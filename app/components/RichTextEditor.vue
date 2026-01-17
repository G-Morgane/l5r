<template>
  <ClientOnly>
    <div class="markdown-editor">
      <MdEditor
        v-model="content"
        language="fr"
        theme="light"
        :preview="false"
        :toolbars="toolbars"
        :footers="[]"
        @onChange="handleChange"
        class="editor"
      />
    </div>
  </ClientOnly>
</template>

<script setup>
import { MdEditor } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue'])

const content = ref(props.modelValue)

const toolbars = [
  'bold',
  'italic',
  'strikeThrough',
  '-',
  'title',
  'quote',
  '-',
  'unorderedList',
  'orderedList',
  '-',
  'table',
  'link',
  '-',
  'revoke',
  'next'
]

const handleChange = (value) => {
  emit('update:modelValue', value)
}

watch(() => props.modelValue, (newValue) => {
  if (newValue !== content.value) {
    content.value = newValue
  }
})
</script>

<style scoped>
.markdown-editor {
  border-radius: 0.75rem;
  overflow: hidden;
}

.editor {
  --md-bk-color: #fffbf5;
  --md-border-color: rgb(120 53 15 / 0.3);
  min-height: 400px;
}

:deep(.md-editor) {
  border: 2px solid rgb(120 53 15 / 0.3) !important;
  border-radius: 0.75rem;
}

:deep(.md-editor-toolbar) {
  background: rgba(255, 255, 255, 0.95) !important;
  border-bottom: 2px solid rgb(120 53 15 / 0.3) !important;
}

:deep(.md-editor-input-wrapper) {
  background: #fffbf5 !important;
}

:deep(.md-editor-input-wrapper textarea) {
  font-family: 'Montserrat', monospace !important;
  font-size: 14px !important;
}
</style>
