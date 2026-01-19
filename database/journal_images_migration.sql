-- Migration pour ajouter les images et résumé aux entrées de journal
-- À exécuter dans Supabase SQL Editor

-- Ajouter la colonne images (tableau d'URLs)
ALTER TABLE journal_entries
ADD COLUMN IF NOT EXISTS images TEXT[] DEFAULT '{}';

-- Ajouter la colonne resume (résumé court de l'entrée)
ALTER TABLE journal_entries
ADD COLUMN IF NOT EXISTS resume TEXT;

-- Créer le bucket de stockage pour les images du journal
-- Note: Cette commande doit être exécutée via l'interface Supabase Storage ou l'API
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('journal-images', 'journal-images', true);

-- OU via l'interface Supabase:
-- 1. Aller dans Storage
-- 2. Créer un nouveau bucket nommé "journal-images"
-- 3. Cocher "Public bucket" pour permettre l'accès public aux images

-- Politique RLS pour le bucket (à créer dans l'interface Storage > Policies)
-- Politique pour permettre l'upload aux utilisateurs authentifiés:
/*
CREATE POLICY "Allow authenticated uploads"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'journal-images');

CREATE POLICY "Allow public read"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'journal-images');

CREATE POLICY "Allow authenticated delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'journal-images');
*/
