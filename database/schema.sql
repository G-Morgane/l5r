-- Table des personnages
CREATE TABLE personnages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  clan VARCHAR(100),
  famille VARCHAR(100),
  ecole VARCHAR(100),
  rang INTEGER DEFAULT 1,
  statut VARCHAR(50) DEFAULT 'vivant', -- vivant, mort, retraité
  avatar_url TEXT,
  description TEXT,
  -- Statistiques L5R
  experience_points INTEGER DEFAULT 0,
  reputation INTEGER DEFAULT 0,
  honneur INTEGER DEFAULT 0,
  gloire INTEGER DEFAULT 0,
  souillure INTEGER DEFAULT 0,
  initiative INTEGER DEFAULT 0,
  -- Anneaux (1-10)
  terre INTEGER DEFAULT 2,
  eau INTEGER DEFAULT 2,
  feu INTEGER DEFAULT 2,
  air INTEGER DEFAULT 2,
  vide INTEGER DEFAULT 2,
  -- Traits dérivés
  constitution INTEGER DEFAULT 2,
  volonte INTEGER DEFAULT 2,
  force INTEGER DEFAULT 2,
  perception INTEGER DEFAULT 2,
  intelligence INTEGER DEFAULT 2,
  agilite INTEGER DEFAULT 2,
  intuition INTEGER DEFAULT 2,
  reflexes INTEGER DEFAULT 2,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des compétences
CREATE TABLE competences (
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

-- Table des avantages et désavantages
CREATE TABLE avantages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  type VARCHAR(50), -- avantage, désavantage
  rang INTEGER DEFAULT 1,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des armes
CREATE TABLE armes (
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

-- Table des armures
CREATE TABLE armures (
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

-- Table des blessures
CREATE TABLE blessures (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  niveau VARCHAR(50), -- Sain, Égratignure, Légère, Blessé, Gravement, Estropié, Mourant
  penalite INTEGER DEFAULT 0,
  nbre_blessures INTEGER DEFAULT 0,
  limite INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des ressources
CREATE TABLE ressources (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  type VARCHAR(50), -- koku, bu, zeni
  montant INTEGER DEFAULT 0,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des entrées de wiki
CREATE TABLE wiki_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE SET NULL,
  titre VARCHAR(255) NOT NULL,
  contenu TEXT NOT NULL,
  categorie VARCHAR(100), -- lieu, PNJ, événement, règle, etc.
  tags TEXT[], -- tags supplémentaires
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Table des items wiki (lieux, personnages, clans)
CREATE TABLE wiki_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  categorie VARCHAR(50) NOT NULL, -- lieux, personnages, clans
  description TEXT,
  tags TEXT[], -- tags pour lier avec d'autres pages wiki
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(personnage_id, slug)
);

-- Table du journal de bord
CREATE TABLE journal_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  personnage_id UUID REFERENCES personnages(id) ON DELETE CASCADE,
  titre VARCHAR(255) NOT NULL,
  contenu TEXT NOT NULL,
  date_session DATE NOT NULL,
  session_numero INTEGER,
  lieu VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index pour améliorer les performances
CREATE INDEX idx_wiki_personnage ON wiki_entries(personnage_id);
CREATE INDEX idx_wiki_categorie ON wiki_entries(categorie);
CREATE INDEX idx_wiki_items_personnage ON wiki_items(personnage_id);
CREATE INDEX idx_wiki_items_categorie ON wiki_items(categorie);
CREATE INDEX idx_wiki_items_slug ON wiki_items(slug);
CREATE INDEX idx_journal_personnage ON journal_entries(personnage_id);
CREATE INDEX idx_journal_session ON journal_entries(date_session);
CREATE INDEX idx_competences_personnage ON competences(personnage_id);
CREATE INDEX idx_avantages_personnage ON avantages(personnage_id);
CREATE INDEX idx_armes_personnage ON armes(personnage_id);
CREATE INDEX idx_armures_personnage ON armures(personnage_id);
CREATE INDEX idx_blessures_personnage ON blessures(personnage_id);
CREATE INDEX idx_ressources_personnage ON ressources(personnage_id);

-- Activer Row Level Security (RLS)
ALTER TABLE personnages ENABLE ROW LEVEL SECURITY;
ALTER TABLE wiki_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE wiki_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE competences ENABLE ROW LEVEL SECURITY;
ALTER TABLE avantages ENABLE ROW LEVEL SECURITY;
ALTER TABLE armes ENABLE ROW LEVEL SECURITY;
ALTER TABLE armures ENABLE ROW LEVEL SECURITY;
ALTER TABLE blessures ENABLE ROW LEVEL SECURITY;
ALTER TABLE ressources ENABLE ROW LEVEL SECURITY;

-- Politiques RLS pour permettre la lecture publique (à ajuster selon vos besoins)
CREATE POLICY "Permettre lecture publique personnages" ON personnages FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique personnages" ON personnages FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique wiki" ON wiki_entries FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique wiki" ON wiki_entries FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique wiki_items" ON wiki_items FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique wiki_items" ON wiki_items FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique journal" ON journal_entries FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique journal" ON journal_entries FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique competences" ON competences FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique competences" ON competences FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique avantages" ON avantages FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique avantages" ON avantages FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique armes" ON armes FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique armes" ON armes FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique armures" ON armures FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique armures" ON armures FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique blessures" ON blessures FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique blessures" ON blessures FOR ALL USING (true);

CREATE POLICY "Permettre lecture publique ressources" ON ressources FOR SELECT USING (true);
CREATE POLICY "Permettre écriture publique ressources" ON ressources FOR ALL USING (true);
