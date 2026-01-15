-- Exemples de sorts à insérer pour tester la page
-- Cercle de l'Eau - Rang 1
INSERT INTO spells (nom, cercle, rang, portee, zone_effet, duree, effet_augmentation, description, degats_soin, mot_cle) VALUES
('Tempête de Sable', 'eau', 1, '30 mètres', 'Cône de 10 mètres', 'Instantané', 'La zone d''effet passe à 15 mètres', 'Crée une tempête de sable qui aveugle et étourdit les ennemis.', 'Aveuglement 1 round', ARRAY['aveuglement', 'zone', 'tempête']),
('Mur d''Eau', 'eau', 1, 'Personnelle', 'Mur de 5m x 2m x 2m', 'Concentration', 'Le mur gagne +2 en armure', 'Crée un mur d''eau solide qui bloque les projectiles et absorbe les dégâts.', 'Armure +4 contre projectiles', ARRAY['défense', 'mur', 'protection']),
('Respiration Aquatique', 'eau', 1, 'Toucher', '1 créature', '10 minutes', 'Durée x2', 'Permet à une créature de respirer sous l''eau.', 'Respiration aquatique', ARRAY['buff', 'respiration', 'utilitaire']),

-- Cercle de l'Eau - Rang 2
('Vague Écrasante', 'eau', 2, '30 mètres', 'Ligne de 15 mètres', 'Instantané', 'Dégâts +1k1', 'Crée une vague d''eau qui écrase les ennemis.', '3k3 dégâts contondants', ARRAY['dégâts', 'zone', 'écrasement']),
('Contrôle des Courants', 'eau', 2, '60 mètres', 'Zone de 10m x 10m', 'Concentration', 'Vitesse x2', 'Contrôle les courants d''eau dans une zone.', 'Contrôle total des courants', ARRAY['contrôle', 'eau', 'mobilité']),
('Gel Instantané', 'eau', 2, '30 mètres', '1 créature ou objet', 'Permanente', 'Zone +3 mètres', 'Gèle instantanément une cible.', 'Gel permanent', ARRAY['contrôle', 'gel', 'immobilisation']),

-- Cercle du Feu - Rang 1
('Boule de Feu', 'feu', 1, '30 mètres', 'Sphère de 3 mètres', 'Instantané', 'Dégâts +1k1', 'Lance une boule de feu explosive.', '4k3 dégâts de feu', ARRAY['dégâts', 'feu', 'explosion']),
('Mur de Flammes', 'feu', 1, 'Personnelle', 'Mur de 5m x 2m x 2m', 'Concentration', 'Dégâts +1k1', 'Crée un mur de flammes infranchissable.', '3k2 dégâts de feu au contact', ARRAY['défense', 'mur', 'feu']),
('Lumière', 'feu', 1, 'Toucher', 'Objet ou zone de 3m', '1 heure', 'Portée x2', 'Illumine une zone comme une torche.', 'Éclaire comme une torche', ARRAY['utilitaire', 'lumière', 'vision']),

-- Cercle du Feu - Rang 2
('Tempête de Feu', 'feu', 2, '30 mètres', 'Cercle de 10 mètres', 'Concentration', 'Dégâts +1k1', 'Crée une tempête de feu tourbillonnante.', '2k2 dégâts de feu par round', ARRAY['dégâts', 'zone', 'tempête']),
('Volonté de Feu', 'feu', 2, 'Personnelle', 'Le lanceur', '1 heure', 'Effet x2', 'Le lanceur devient insensible au feu.', 'Immunité au feu', ARRAY['buff', 'résistance', 'feu']),
('Explosion', 'feu', 2, '30 mètres', 'Sphère de 5 mètres', 'Instantané', 'Rayon +3 mètres', 'Crée une explosion de feu destructrice.', '5k4 dégâts de feu', ARRAY['dégâts', 'explosion', 'zone']),

-- Cercle de la Terre - Rang 1
('Armure de Pierre', 'terre', 1, 'Toucher', '1 créature', '10 minutes', 'Armure +2', 'Durcit la peau comme de la pierre.', 'Armure +4', ARRAY['buff', 'armure', 'défense']),
('Tremblement de Terre', 'terre', 1, '60 mètres', 'Cercle de 10 mètres', 'Instantané', 'Zone +5 mètres', 'Fait trembler le sol et déséquilibre les ennemis.', 'Test de Force difficulté 4', ARRAY['zone', 'contrôle', 'déséquilibre']),
('Mur de Pierre', 'terre', 1, 'Personnelle', 'Mur de 5m x 2m x 2m', 'Permanente', 'Épaisseur x2', 'Crée un mur de pierre solide.', 'Armure 8, Réduction 10', ARRAY['défense', 'mur', 'permanent']),

-- Cercle de la Terre - Rang 2
('Éboulement', 'terre', 2, '60 mètres', 'Zone de 15m x 15m', 'Instantané', 'Zone +5 mètres', 'Fait s''effondrer le sol sous les ennemis.', '4k3 dégâts contondants', ARRAY['dégâts', 'zone', 'effondrement']),
('Force de la Terre', 'terre', 2, 'Toucher', '1 créature', '1 heure', 'Effet x2', 'Augmente considérablement la force.', '+2k2 sur tests de Force', ARRAY['buff', 'force', 'physique']),
('Prison de Pierre', 'terre', 2, '30 mètres', '1 créature', 'Concentration', 'Armure +4', 'Enferme une créature dans la pierre.', 'Immobilisation complète', ARRAY['contrôle', 'immobilisation', 'prison']),

-- Cercle de l'Air - Rang 1
('Souffle de Vent', 'air', 1, 'Personnelle', 'Cône de 10 mètres', 'Instantané', 'Portée +10 mètres', 'Crée une bourrasque qui repousse les ennemis.', 'Repousse de 5 mètres', ARRAY['contrôle', 'repousse', 'vent']),
('Lévitation', 'air', 1, 'Toucher', '1 créature', 'Concentration', 'Vitesse x2', 'Permet de léviter et voler lentement.', 'Vitesse de vol 10m par round', ARRAY['buff', 'mobilité', 'vol']),
('Invisibilité', 'air', 1, 'Personnelle', 'Le lanceur', 'Concentration', 'Peut bouger normalement', 'Rend le lanceur invisible.', 'Invisibilité parfaite', ARRAY['buff', 'furtivité', 'illusion']),

-- Cercle de l'Air - Rang 2
('Tornade', 'air', 2, '60 mètres', 'Cylindre de 5m x 10m', 'Concentration', 'Dégâts +1k1', 'Crée une tornade destructrice.', '3k3 dégâts contondants', ARRAY['dégâts', 'zone', 'tornade']),
('Vitesse du Vent', 'air', 2, 'Toucher', '1 créature', '10 minutes', 'Vitesse x2', 'Augmente considérablement la vitesse.', 'Vitesse x3', ARRAY['buff', 'vitesse', 'mobilité']),
('Illusion Majeure', 'air', 2, '30 mètres', 'Zone de 10m x 10m', 'Concentration', 'Illusions multiples', 'Crée des illusions réalistes.', 'Illusions convaincantes', ARRAY['illusion', 'tromperie', 'contrôle']),

-- Cercle du Vide - Rang 1
('Communion', 'vide', 1, 'Personnelle', 'Esprit', 'Concentration', 'Peut poser des questions supplémentaires', 'Permet de communiquer avec les esprits.', 'Communication spirituelle', ARRAY['spirituel', 'communication', 'divination']),
('Bénédiction', 'vide', 1, 'Toucher', '1 créature', '1 heure', 'Effet x2', 'Accorde une bénédiction spirituelle.', '+1k1 sur tous les tests', ARRAY['buff', 'spirituel', 'bénédiction']),
('Malédiction', 'vide', 1, '30 mètres', '1 créature', '1 heure', 'Effet x2', 'Lance une malédiction spirituelle.', '-1k1 sur tous les tests', ARRAY['malédiction', 'spirituel', 'débilitant']),

-- Cercle du Vide - Rang 2
('Vision', 'vide', 2, 'Personnelle', 'Esprit', 'Concentration', 'Peut voir dans le passé', 'Permet de voir des événements passés.', 'Vision rétrospective', ARRAY['divination', 'vision', 'passé']),
('Protection', 'vide', 2, 'Toucher', '1 créature', '1 heure', 'Effet x2', 'Protège contre les influences spirituelles.', 'Immunité aux malédictions', ARRAY['protection', 'spirituel', 'défense']),
('Invocation', 'vide', 2, '30 mètres', '1 esprit', '1 heure', 'Peut invoquer plusieurs esprits', 'Invoque un esprit pour servir.', 'Esprit invoqué', ARRAY['invocation', 'spirituel', 'contrôle']);