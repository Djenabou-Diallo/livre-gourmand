-- ============================================================
-- RESET COMPLET DE LA BASE DE DONNEES
-- ============================================================

USE monlivres;

-- Désactiver les clés étrangères pour pouvoir tout supprimer
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS commentaires;
DROP TABLE IF EXISTS avis;
DROP TABLE IF EXISTS liste_items;
DROP TABLE IF EXISTS listes_cadeaux;
DROP TABLE IF EXISTS commande_items;
DROP TABLE IF EXISTS commandes;
DROP TABLE IF EXISTS panier_items;
DROP TABLE IF EXISTS panier;
DROP TABLE IF EXISTS ouvrages;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Réactiver les clés étrangères
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- CREATION DES TABLES
-- ============================================================

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100),
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('client','editeur','gestionnaire','administrateur') NOT NULL DEFAULT 'client',
  actif BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) UNIQUE NOT NULL,
  description TEXT
) ENGINE=InnoDB;

CREATE TABLE ouvrages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre VARCHAR(255) NOT NULL,
  auteur VARCHAR(255) NOT NULL,
  isbn VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  prix DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  image VARCHAR(255),
  categorie_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE panier (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  actif BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE panier_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  panier_id INT NOT NULL,
  ouvrage_id INT NOT NULL,
  quantite INT NOT NULL,
  prix_unitaire DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (panier_id) REFERENCES panier(id) ON DELETE CASCADE,
  FOREIGN KEY (ouvrage_id) REFERENCES ouvrages(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE commandes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  statut ENUM('en_cours','payee','annulee','expediee') NOT NULL DEFAULT 'en_cours',
  adresse_livraison TEXT,
  mode_livraison VARCHAR(100),
  mode_paiement VARCHAR(100),
  payment_provider_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE commande_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  commande_id INT NOT NULL,
  ouvrage_id INT NOT NULL,
  quantite INT NOT NULL,
  prix_unitaire DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE,
  FOREIGN KEY (ouvrage_id) REFERENCES ouvrages(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE listes_cadeaux (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  proprietaire_id INT NOT NULL,
  code_partage VARCHAR(255) UNIQUE NOT NULL,
  date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (proprietaire_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE liste_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  liste_id INT NOT NULL,
  ouvrage_id INT NOT NULL,
  quantite_souhaitee INT NOT NULL,
  FOREIGN KEY (liste_id) REFERENCES listes_cadeaux(id) ON DELETE CASCADE,
  FOREIGN KEY (ouvrage_id) REFERENCES ouvrages(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE avis (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  ouvrage_id INT NOT NULL,
  note INT NOT NULL,
  commentaire TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_avis (client_id, ouvrage_id),
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (ouvrage_id) REFERENCES ouvrages(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE commentaires (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  ouvrage_id INT NOT NULL,
  contenu TEXT NOT NULL,
  valide BOOLEAN NOT NULL DEFAULT false,
  date_soumission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_validation TIMESTAMP NULL,
  valide_par INT NULL,
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (ouvrage_id) REFERENCES ouvrages(id) ON DELETE CASCADE,
  FOREIGN KEY (valide_par) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  commande_id INT NOT NULL,
  provider VARCHAR(100),
  provider_payment_id VARCHAR(255),
  statut VARCHAR(100),
  amount DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (commande_id) REFERENCES commandes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- DONNEES DE TEST
-- ============================================================

-- Utilisateurs
INSERT INTO users (nom, email, password_hash, role) VALUES
('Admin',        'admin@recettes.com',   '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'administrateur'),
('Julie Martin',  'julie@example.com',   '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'client'),
('Chef Antoine',  'antoine@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'editeur'),
('Marie Dupont',  'marie@example.com',   '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'client');

-- Categories
INSERT INTO categories (nom, description) VALUES
('Soupes & Entrees',  'Veloutés, soupes et entrées chaudes ou froides'),
('Plats principaux',  'Viandes, poissons et pâtes pour les repas du soir'),
('Salades & Leger',   'Salades fraîches et repas légers'),
('Desserts',          'Gâteaux, tartes et douceurs sucrées'),
('Boissons',          'Smoothies, chocolats chauds et boissons maison');

-- Ouvrages
INSERT INTO ouvrages (titre, auteur, isbn, description, prix, stock, image, categorie_id) VALUES
('Veloute de Courge', 'Chef Marie Laurent', '978-2-01-000001-1',
'Une recette onctueuse et reconfortante. Courge butternut, creme fraiche et epices douces.',
18.99, 25, 'veloute_de_courge.jpg',
(SELECT id FROM categories WHERE nom = 'Soupes & Entrees')),

('Bruschettas Tomate Basilic', 'Chef Paolo Rossi', '978-2-01-000002-2',
'L''entree italienne par excellence. Tomates fraiches, basilic et pain grille croustillant.',
14.99, 30, 'Bruschettas_tomate_basilic.jpg',
(SELECT id FROM categories WHERE nom = 'Soupes & Entrees')),

('Soupe a l''Oignon Gratinee', 'Chef Jean Dupont', '978-2-01-000003-3',
'La vraie soupe a l''oignon facon bistrot parisien, gratinee au fromage comte.',
16.99, 20, 'Soupe_a_l_oignon_gratinee.jpg',
(SELECT id FROM categories WHERE nom = 'Soupes & Entrees')),

('Lasagne Maison', 'Chef Sofia Bianchi', '978-2-01-000004-4',
'Lasagnes faites maison avec une bolognaise mijotee 3 heures et une bechamel cremeuse.',
22.99, 18, 'Lasagne_Maison.jpg',
(SELECT id FROM categories WHERE nom = 'Plats principaux')),

('Poulet Roti aux Herbes', 'Chef Thomas Martin', '978-2-01-000005-5',
'Poulet fermier roti lentement avec thym, romarin et ail confit.',
19.99, 22, 'poulet_Roti_aux_Herbes.jpg',
(SELECT id FROM categories WHERE nom = 'Plats principaux')),

('Saumon Grille au Citron', 'Chef Anne Moreau', '978-2-01-000006-6',
'Filets de saumon grilles avec une marinade citronnee et herbes fraiches.',
24.99, 15, 'Saumon_Grille_au_citron.jpg',
(SELECT id FROM categories WHERE nom = 'Plats principaux')),

('Salade Cesar', 'Chef Robert King', '978-2-01-000007-7',
'Romaine croquante, croutons maison, parmesan et sauce Cesar cremeuse.',
13.99, 35, 'Salade_Cesar.jpg',
(SELECT id FROM categories WHERE nom = 'Salades & Leger')),

('Fondant au Chocolat', 'Chef Claire Petit', '978-2-01-000008-8',
'Coeur coulant au chocolat noir 70%, servi tiede avec glace vanille.',
17.99, 28, 'Fondant_au_chocolat.jpg',
(SELECT id FROM categories WHERE nom = 'Desserts')),

('Tarte aux Fraises Maison', 'Chef Isabelle Blanc', '978-2-01-000009-9',
'Tarte sablee avec creme patissiere a la vanille et fraises fraiches de saison.',
15.99, 20, 'Tarte_aux_Fraises_Maison.jpg',
(SELECT id FROM categories WHERE nom = 'Desserts')),

('Tiramisu Classique', 'Chef Marco Ferrari', '978-2-01-000010-0',
'L''authentique tiramisu italien : mascarpone, savoiardi imbibes d''espresso et cacao amer.',
16.99, 24, 'tiramisu_classique.jpg',
(SELECT id FROM categories WHERE nom = 'Desserts')),

('Chocolat Chaud Maison', 'Chef Emma Rousseau', '978-2-01-000011-1',
'Chocolat chaud onctueux facon salon de the, avec guimauves et cacao de qualite.',
11.99, 40, 'Chocolat_Chaud_maison.jpg',
(SELECT id FROM categories WHERE nom = 'Boissons')),

('Smoothie Fraise Banane', 'Chef Lea Fontaine', '978-2-01-000012-2',
'Smoothie frais et vitamine aux fraises, banane et lait vegetal.',
12.99, 45, 'Smoothie_fraise_banane.jpg',
(SELECT id FROM categories WHERE nom = 'Boissons'));

SELECT CONCAT(COUNT(*), ' ouvrages inseres') AS resultat FROM ouvrages;
