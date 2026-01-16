-- Schema pour la fonctionnalité Pense-bête
-- Exécuter ce script dans Supabase SQL Editor

-- Table des notes/mémos
CREATE TABLE IF NOT EXISTS pense_bete_notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  title VARCHAR(255) DEFAULT 'Note',
  content TEXT DEFAULT '',
  color VARCHAR(20) DEFAULT 'amber',
  width INTEGER DEFAULT 300,
  height INTEGER DEFAULT 200,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour les requêtes par personnage
CREATE INDEX IF NOT EXISTS idx_pense_bete_personnage ON pense_bete_notes(personnage_id);

-- Index pour l'ordre
CREATE INDEX IF NOT EXISTS idx_pense_bete_order ON pense_bete_notes(personnage_id, order_index);

-- Trigger pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_pense_bete_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_pense_bete_updated_at ON pense_bete_notes;
CREATE TRIGGER trigger_pense_bete_updated_at
  BEFORE UPDATE ON pense_bete_notes
  FOR EACH ROW
  EXECUTE FUNCTION update_pense_bete_updated_at();

-- Activer RLS (Row Level Security)
ALTER TABLE pense_bete_notes ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre toutes les opérations (ajuster selon vos besoins de sécurité)
CREATE POLICY "Allow all operations on pense_bete_notes" ON pense_bete_notes
  FOR ALL
  USING (true)
  WITH CHECK (true);
