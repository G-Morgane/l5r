-- Créer la table des sorts
CREATE TABLE spells (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  cercle VARCHAR(50) NOT NULL CHECK (cercle IN ('eau', 'feu', 'terre', 'air', 'vide')),
  rang INTEGER NOT NULL CHECK (rang >= 1 AND rang <= 5),
  portee VARCHAR(255),
  zone_effet VARCHAR(255),
  duree VARCHAR(255),
  effet_augmentation TEXT,
  description TEXT,
  degats_soin VARCHAR(255),
  mot_cle TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Créer la table de relation personnage-sorts
CREATE TABLE character_spells (
  id SERIAL PRIMARY KEY,
  personnage_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  spell_id INTEGER NOT NULL REFERENCES spells(id) ON DELETE CASCADE,
  learned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(personnage_id, spell_id)
);

-- Index pour optimiser les recherches
CREATE INDEX idx_spells_cercle ON spells(cercle);
CREATE INDEX idx_spells_rang ON spells(rang);
CREATE INDEX idx_character_spells_personnage ON character_spells(personnage_id);
CREATE INDEX idx_character_spells_spell ON character_spells(spell_id);

-- Trigger pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_spells_updated_at BEFORE UPDATE ON spells
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();