<template>
  <ClientOnly>
    <div class="markdown-preview-wrapper">
      <MdPreview
        :modelValue="content"
        language="fr"
        class="md-preview-custom"
        :noIconfont="true"
      />
    </div>
  </ClientOnly>
</template>

<script setup>
import { MdPreview } from 'md-editor-v3'
import 'md-editor-v3/lib/preview.css'

defineProps({
  content: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
/* Force transparent background on all md-editor elements */
.markdown-preview-wrapper {
  background: transparent !important;
}

.markdown-preview-wrapper :deep(*) {
  background: transparent !important;
  background-color: transparent !important;
}

.markdown-preview-wrapper :deep(.md-editor) {
  background: transparent !important;
  background-color: transparent !important;
  --md-bk-color: transparent !important;
}

.markdown-preview-wrapper :deep(.md-editor-preview-wrapper) {
  padding: 0 !important;
  background: transparent !important;
}

.markdown-preview-wrapper :deep(.md-editor-preview) {
  background: transparent !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(h1) {
  font-size: 0.9rem !important;
  font-weight: bold !important;
  color: rgb(120 53 15) !important;
  margin: 0.4rem 0 0.2rem !important;
  border-bottom: 1px solid rgb(120 53 15 / 0.3) !important;
  padding-bottom: 0.1rem !important;
}

.markdown-preview-wrapper :deep(h2) {
  font-size: 0.85rem !important;
  font-weight: bold !important;
  color: rgb(146 64 14) !important;
  margin: 0.3rem 0 0.15rem !important;
}

.markdown-preview-wrapper :deep(h3) {
  font-size: 0.8rem !important;
  font-weight: 600 !important;
  color: rgb(180 83 9) !important;
  margin: 0.25rem 0 0.1rem !important;
}

.markdown-preview-wrapper :deep(h4),
.markdown-preview-wrapper :deep(h5),
.markdown-preview-wrapper :deep(h6) {
  font-size: 0.75rem !important;
  font-weight: 600 !important;
  color: rgb(180 83 9) !important;
  margin: 0.15rem 0 !important;
}

.markdown-preview-wrapper :deep(p) {
  margin-bottom: 0.2rem !important;
  line-height: 1.3 !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(ul) {
  margin: 0.2rem 0 !important;
  padding-left: 0.4rem !important;
  list-style: none !important;
}

.markdown-preview-wrapper :deep(ul li) {
  margin: 0.1rem 0 !important;
  padding-left: 1rem !important;
  position: relative !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(ul li)::before {
  content: '➤' !important;
  position: absolute !important;
  left: 0 !important;
  color: rgb(180 83 9) !important;
  font-size: 0.6rem !important;
}

.markdown-preview-wrapper :deep(ol) {
  margin: 0.2rem 0 !important;
  padding-left: 1.2rem !important;
  list-style: decimal !important;
}

.markdown-preview-wrapper :deep(ol li) {
  margin: 0.1rem 0 !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(blockquote) {
  border-left: 2px solid rgb(180 83 9) !important;
  padding: 0.2rem 0.4rem !important;
  margin: 0.2rem 0 !important;
  font-style: italic !important;
  color: rgb(68 64 60) !important;
  background: rgb(254 243 199 / 0.3) !important;
  border-radius: 0 0.25rem 0.25rem 0 !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(code) {
  background: rgb(231 229 228) !important;
  padding: 0.1rem 0.2rem !important;
  border-radius: 0.2rem !important;
  font-family: monospace !important;
  font-size: 0.65rem !important;
}

.markdown-preview-wrapper :deep(pre) {
  background: rgb(231 229 228) !important;
  padding: 0.3rem !important;
  border-radius: 0.2rem !important;
  overflow-x: auto !important;
  margin: 0.2rem 0 !important;
  border-left: 2px solid rgb(180 83 9) !important;
}

.markdown-preview-wrapper :deep(pre code) {
  background: none !important;
  padding: 0 !important;
}

.markdown-preview-wrapper :deep(table) {
  width: 100% !important;
  border-collapse: collapse !important;
  margin: 0.3rem 0 !important;
  font-size: 0.7rem !important;
}

.markdown-preview-wrapper :deep(th) {
  border: 1px solid rgb(120 53 15 / 0.3) !important;
  background: rgb(254 243 199 / 0.5) !important;
  padding: 0.15rem 0.3rem !important;
  text-align: left !important;
  font-weight: 600 !important;
}

.markdown-preview-wrapper :deep(td) {
  border: 1px solid rgb(120 53 15 / 0.3) !important;
  padding: 0.15rem 0.3rem !important;
}

.markdown-preview-wrapper :deep(a) {
  color: rgb(180 83 9) !important;
  text-decoration: underline !important;
}

.markdown-preview-wrapper :deep(a:hover) {
  color: rgb(120 53 15) !important;
}

.markdown-preview-wrapper :deep(hr) {
  border: none !important;
  border-top: 1px solid rgb(120 53 15 / 0.3) !important;
  margin: 0.5rem 0 !important;
}
</style>

<style>
/* Global overrides for md-editor background - not scoped */
.markdown-preview-wrapper .md-editor,
.markdown-preview-wrapper .md-editor-preview-wrapper,
.markdown-preview-wrapper .md-editor-preview,
.markdown-preview-wrapper .md-editor-content {
  background: transparent !important;
  background-color: transparent !important;
}
</style>
