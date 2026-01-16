-- Script SQL pour créer les tables des intrigues et journal
-- À exécuter dans Supabase SQL Editor

-- Table des intrigues
CREATE TABLE IF NOT EXISTS intrigues (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  titre VARCHAR(255) NOT NULL,
  description TEXT,
  statut VARCHAR(50) DEFAULT 'en_cours' CHECK (statut IN ('en_cours', 'en_pause', 'resolue')),
  image INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des événements d'intrigue
CREATE TABLE IF NOT EXISTS intrigue_events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  intrigue_id UUID NOT NULL REFERENCES intrigues(id) ON DELETE CASCADE,
  date_event DATE NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des liens d'intrigue (pour lier wiki, journal, pistes)
CREATE TABLE IF NOT EXISTS intrigue_links (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  intrigue_id UUID NOT NULL REFERENCES intrigues(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL CHECK (type IN ('wiki', 'journal', 'piste')),
  linked_id UUID NOT NULL, -- ID de l'élément lié (wiki_item, journal_entry, ou piste)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des entrées de journal
CREATE TABLE IF NOT EXISTS journal_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  titre VARCHAR(255) NOT NULL,
  contenu TEXT,
  date_session DATE NOT NULL,
  type_session VARCHAR(50) DEFAULT 'normale' CHECK (type_session IN ('normale', 'combat', 'social', 'exploration')),
  xp_gagne INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des éléments wiki
CREATE TABLE IF NOT EXISTS wiki_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  categorie VARCHAR(100) NOT NULL CHECK (categorie IN ('lieux', 'personnages', 'clans', 'autre')),
  nom VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  contenu TEXT,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des pistes
CREATE TABLE IF NOT EXISTS pistes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_intrigues_personnage ON intrigues(personnage_id);
CREATE INDEX IF NOT EXISTS idx_intrigues_statut ON intrigues(statut);
CREATE INDEX IF NOT EXISTS idx_intrigue_events_intrigue ON intrigue_events(intrigue_id);
CREATE INDEX IF NOT EXISTS idx_intrigue_events_date ON intrigue_events(date_event);
CREATE INDEX IF NOT EXISTS idx_intrigue_links_intrigue ON intrigue_links(intrigue_id);
CREATE INDEX IF NOT EXISTS idx_intrigue_links_type ON intrigue_links(type);
CREATE INDEX IF NOT EXISTS idx_journal_entries_personnage ON journal_entries(personnage_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_date ON journal_entries(date_session);
CREATE INDEX IF NOT EXISTS idx_wiki_items_personnage ON wiki_items(personnage_id);
CREATE INDEX IF NOT EXISTS idx_wiki_items_categorie ON wiki_items(categorie);
CREATE INDEX IF NOT EXISTS idx_wiki_items_slug ON wiki_items(slug);

-- Trigger pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Appliquer le trigger aux tables qui ont updated_at
CREATE TRIGGER update_intrigues_updated_at BEFORE UPDATE ON intrigues
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_intrigue_events_updated_at BEFORE UPDATE ON intrigue_events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_journal_entries_updated_at BEFORE UPDATE ON journal_entries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wiki_items_updated_at BEFORE UPDATE ON wiki_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();