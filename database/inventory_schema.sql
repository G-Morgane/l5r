-- Création des tables pour le système d'inventaire L5R

-- Table des objets d'inventaire
CREATE TABLE inventory_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  character_id UUID NOT NULL REFERENCES personnages(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL, -- 'weapon', 'armor', 'item', 'consumable', etc.
  description TEXT,
  value INTEGER DEFAULT 0, -- valeur en koku
  damage VARCHAR(50), -- seulement pour les armes, ex: "3k2", "4k3+2", etc.
  damage_type VARCHAR(50), -- 'slashing', 'piercing', 'blunt', 'fire', etc.
  armor_rating INTEGER, -- seulement pour les armures
  weight DECIMAL(5,2) DEFAULT 0, -- poids en kg
  rarity VARCHAR(20) DEFAULT 'common', -- 'common', 'uncommon', 'rare', 'legendary'
  is_equipped BOOLEAN DEFAULT false,
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des tags pour les objets
CREATE TABLE item_tags (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  color VARCHAR(7) DEFAULT '#6b7280', -- couleur hex pour l'affichage
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table de relation many-to-many entre items et tags
CREATE TABLE item_tag_relations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  item_id UUID NOT NULL REFERENCES inventory_items(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES item_tags(id) ON DELETE CASCADE,
  UNIQUE(item_id, tag_id)
);

-- Insertion de tags par défaut
INSERT INTO item_tags (name, color, description) VALUES
  ('Arme', '#dc2626', 'Objets pouvant servir d''arme'),
  ('Armure', '#2563eb', 'Protection corporelle'),
  ('Bouclier', '#059669', 'Protection défensive'),
  ('Outil', '#d97706', 'Outils et ustensiles'),
  ('Consommable', '#7c3aed', 'Objets à usage unique'),
  ('Magique', '#c2410c', 'Objets dotés de propriétés magiques'),
  ('Rare', '#b91c1c', 'Objets de grande valeur'),
  ('Commun', '#6b7280', 'Objets ordinaires'),
  ('Lourd', '#374151', 'Objets encombrants'),
  ('Léger', '#9ca3af', 'Objets faciles à transporter');

-- Index pour améliorer les performances
CREATE INDEX idx_inventory_items_character_id ON inventory_items(character_id);
CREATE INDEX idx_inventory_items_type ON inventory_items(type);
CREATE INDEX idx_inventory_items_is_equipped ON inventory_items(is_equipped);
CREATE INDEX idx_item_tag_relations_item_id ON item_tag_relations(item_id);
CREATE INDEX idx_item_tag_relations_tag_id ON item_tag_relations(tag_id);

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour inventory_items
CREATE TRIGGER update_inventory_items_updated_at
    BEFORE UPDATE ON inventory_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Politiques RLS (Row Level Security)
ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_tag_relations ENABLE ROW LEVEL SECURITY;

-- Politique pour inventory_items : seuls les propriétaires peuvent voir/modifier leurs objets
CREATE POLICY "Users can view their own inventory items" ON inventory_items
    FOR SELECT USING (auth.uid() = character_id);

CREATE POLICY "Users can insert their own inventory items" ON inventory_items
    FOR INSERT WITH CHECK (auth.uid() = character_id);

CREATE POLICY "Users can update their own inventory items" ON inventory_items
    FOR UPDATE USING (auth.uid() = character_id);

CREATE POLICY "Users can delete their own inventory items" ON inventory_items
    FOR DELETE USING (auth.uid() = character_id);

-- Politiques pour les tags (accessibles à tous)
CREATE POLICY "Tags are viewable by everyone" ON item_tags
    FOR SELECT USING (true);

-- Politiques pour les relations (liées aux items)
CREATE POLICY "Users can view tag relations for their items" ON item_tag_relations
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM inventory_items
            WHERE inventory_items.id = item_tag_relations.item_id
            AND inventory_items.character_id = auth.uid()
        )
    );

CREATE POLICY "Users can manage tag relations for their items" ON item_tag_relations
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM inventory_items
            WHERE inventory_items.id = item_tag_relations.item_id
            AND inventory_items.character_id = auth.uid()
        )
    );