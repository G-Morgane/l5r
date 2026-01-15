-- Migration pour ajouter les colonnes L5R à la table personnages
-- Exécuter ce script pour mettre à jour la base de données existante

-- Ajouter les colonnes de statistiques L5R
ALTER TABLE personnages 
ADD COLUMN IF NOT EXISTS experience_points INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS reputation INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS honneur INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS gloire INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS souillure INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS initiative INTEGER DEFAULT 0;

-- Ajouter les colonnes des anneaux (1-10)
ALTER TABLE personnages 
ADD COLUMN IF NOT EXISTS terre INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS eau INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS feu INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS air INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS vide INTEGER DEFAULT 2;

-- Ajouter les colonnes des traits dérivés
ALTER TABLE personnages 
ADD COLUMN IF NOT EXISTS constitution INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS volonte INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS force INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS perception INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS intelligence INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS agilite INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS reflexes INTEGER DEFAULT 2,
ADD COLUMN IF NOT EXISTS intuition INTEGER DEFAULT 2;

-- Créer la table des compétences si elle n'existe pas
CREATE TABLE IF NOT EXISTS competences (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  rang INTEGER DEFAULT 0,
  trait VARCHAR(50), -- Force, Agilité, etc.
  art BOOLEAN DEFAULT false,
  specialisations TEXT[],
  capacite_maitrise TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des avantages et désavantages si elle n'existe pas
CREATE TABLE IF NOT EXISTS avantages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  type VARCHAR(50), -- avantage, désavantage
  rang INTEGER DEFAULT 1,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des armes si elle n'existe pas
CREATE TABLE IF NOT EXISTS armes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  prix VARCHAR(50),
  domaines TEXT, -- Kenjutsu, Kyujutsu, etc.
  dommages VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des armures si elle n'existe pas
CREATE TABLE IF NOT EXISTS armures (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  prix VARCHAR(50),
  nd_armure INTEGER DEFAULT 0,
  reduction INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des blessures si elle n'existe pas
CREATE TABLE IF NOT EXISTS blessures (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  niveau VARCHAR(50), -- Sain, Égratignure, Légère, Blessé, Gravement, Estropié, Mourant
  penalite INTEGER DEFAULT 0,
  nbre_blessures INTEGER DEFAULT 0,
  limite INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des ressources si elle n'existe pas
CREATE TABLE IF NOT EXISTS ressources (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  type VARCHAR(50), -- koku, bu, zeni
  montant INTEGER DEFAULT 0,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer les index si ils n'existent pas
CREATE INDEX IF NOT EXISTS idx_competences_personnage ON competences(personnage_id);
CREATE INDEX IF NOT EXISTS idx_avantages_personnage ON avantages(personnage_id);
CREATE INDEX IF NOT EXISTS idx_armes_personnage ON armes(personnage_id);
CREATE INDEX IF NOT EXISTS idx_armures_personnage ON armures(personnage_id);
CREATE INDEX IF NOT EXISTS idx_blessures_personnage ON blessures(personnage_id);
CREATE INDEX IF NOT EXISTS idx_ressources_personnage ON ressources(personnage_id);

-- Activer Row Level Security pour les nouvelles tables
ALTER TABLE competences ENABLE ROW LEVEL SECURITY;
ALTER TABLE avantages ENABLE ROW LEVEL SECURITY;
ALTER TABLE armes ENABLE ROW LEVEL SECURITY;
ALTER TABLE armures ENABLE ROW LEVEL SECURITY;
ALTER TABLE blessures ENABLE ROW LEVEL SECURITY;
ALTER TABLE ressources ENABLE ROW LEVEL SECURITY;

-- Créer les politiques RLS pour les nouvelles tables
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'competences' AND policyname = 'Permettre lecture publique competences') THEN
    CREATE POLICY "Permettre lecture publique competences" ON competences FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'competences' AND policyname = 'Permettre écriture publique competences') THEN
    CREATE POLICY "Permettre écriture publique competences" ON competences FOR ALL USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'avantages' AND policyname = 'Permettre lecture publique avantages') THEN
    CREATE POLICY "Permettre lecture publique avantages" ON avantages FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'avantages' AND policyname = 'Permettre écriture publique avantages') THEN
    CREATE POLICY "Permettre écriture publique avantages" ON avantages FOR ALL USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'armes' AND policyname = 'Permettre lecture publique armes') THEN
    CREATE POLICY "Permettre lecture publique armes" ON armes FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'armes' AND policyname = 'Permettre écriture publique armes') THEN
    CREATE POLICY "Permettre écriture publique armes" ON armes FOR ALL USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'armures' AND policyname = 'Permettre lecture publique armures') THEN
    CREATE POLICY "Permettre lecture publique armures" ON armures FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'armures' AND policyname = 'Permettre écriture publique armures') THEN
    CREATE POLICY "Permettre écriture publique armures" ON armures FOR ALL USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'blessures' AND policyname = 'Permettre lecture publique blessures') THEN
    CREATE POLICY "Permettre lecture publique blessures" ON blessures FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'blessures' AND policyname = 'Permettre écriture publique blessures') THEN
    CREATE POLICY "Permettre écriture publique blessures" ON blessures FOR ALL USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'ressources' AND policyname = 'Permettre lecture publique ressources') THEN
    CREATE POLICY "Permettre lecture publique ressources" ON ressources FOR SELECT USING (true);
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'ressources' AND policyname = 'Permettre écriture publique ressources') THEN
    CREATE POLICY "Permettre écriture publique ressources" ON ressources FOR ALL USING (true);
  END IF;
END $$;

-- Créer la table des cartes
CREATE TABLE IF NOT EXISTS maps (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url TEXT,
  grid_cols INTEGER NOT NULL,
  grid_rows INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Créer la table des emplacements sur la carte
CREATE TABLE IF NOT EXISTS map_locations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  map_id UUID REFERENCES maps(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  location_type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  grid_col INTEGER NOT NULL,
  grid_row INTEGER NOT NULL,
  notes TEXT,
  color VARCHAR(7),
  icon VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index
CREATE INDEX IF NOT EXISTS idx_map_locations_map_id ON map_locations(map_id);

-- RLS
ALTER TABLE maps ENABLE ROW LEVEL SECURITY;
ALTER TABLE map_locations ENABLE ROW LEVEL SECURITY;

-- Politiques
CREATE POLICY "Permettre lecture publique maps" ON maps FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique maps" ON maps FOR ALL USING (true);
CREATE POLICY "Permettre lecture publique map_locations" ON map_locations FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique map_locations" ON map_locations FOR ALL USING (true);

-- Migration pour ajouter les colonnes de changement de stats dans journal_entries
ALTER TABLE journal_entries
ADD COLUMN IF NOT EXISTS xp_change DECIMAL(5,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS honneur_change DECIMAL(5,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS gloire_change DECIMAL(5,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS statut_change DECIMAL(5,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS souillure_change DECIMAL(5,2) DEFAULT 0;

-- Ajouter la colonne statut_social à la table personnages si elle n'existe pas
ALTER TABLE personnages
ADD COLUMN IF NOT EXISTS statut_social INTEGER DEFAULT 1;
