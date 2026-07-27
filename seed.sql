CREATE DATABASE IF NOT EXISTS sdp_dashboard;
USE sdp_dashboard;

CREATE TABLE projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  color VARCHAR(7) DEFAULT '#6366f1',
  status ENUM('active','inactive','maintenance') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE metrics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  value DECIMAL(15,2) NOT NULL DEFAULT 0,
  unit VARCHAR(50) DEFAULT '',
  type ENUM('number','percentage','currency') DEFAULT 'number',
  `change` DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE charts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  type ENUM('line','bar','pie','area') DEFAULT 'line',
  chart_order INT DEFAULT 0,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE chart_data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chart_id INT NOT NULL,
  label VARCHAR(255) NOT NULL,
  value DECIMAL(15,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (chart_id) REFERENCES charts(id) ON DELETE CASCADE
);

INSERT INTO projects (name, slug, description, color, status) VALUES
  ('SDP Core', 'sdp-core', 'Plateforme principale de gestion des paiements', '#6366f1', 'active'),
  ('Marketplace', 'marketplace', 'Place de marché B2B', '#f59e0b', 'active'),
  ('Ninno', 'mobile-app', 'Application mobile clients', '#10b981', 'active'),
  ('Analytics', 'analytics', 'Moteur de reporting et analytics', '#ef4444', 'active'),
  ('Admin Portal', 'admin-portal', 'Portail d''administration interne', '#8b5cf6', 'maintenance');

INSERT INTO metrics (project_id, name, value, unit, type, `change`) VALUES
  (1, 'Utilisateurs actifs', 12543, '', 'number', 12.5),
  (1, 'Transactions/jour', 8432, '', 'number', -3.2),
  (1, 'Taux de succès', 98.7, '%', 'percentage', 0.5),
  (1, 'Revenu mensuel', 284500, '€', 'currency', 8.1),
  (2, 'Vendeurs actifs', 3421, '', 'number', 15.3),
  (2, 'Produits listés', 28743, '', 'number', 22.7),
  (2, 'Panier moyen', 89.50, '€', 'currency', 5.2),
  (2, 'Commandes/jour', 1567, '', 'number', 11.8),
  (3, 'Downloads', 45231, '', 'number', 34.2),
  (3, 'DAU', 12340, '', 'number', 18.6),
  (3, 'Crash rate', 0.3, '%', 'percentage', -0.1),
  (3, 'Rating moyen', 4.7, '/5', 'number', 0.2),
  (4, 'Rapports générés', 892, '', 'number', 45.0),
  (4, 'Datasets', 156, '', 'number', 12.0),
  (4, 'Temps de requête', 1.2, 's', 'number', -23.5),
  (4, 'Stockage utilisé', 2.4, 'TB', 'number', 8.3),
  (5, 'Utilisateurs internes', 456, '', 'number', 5.0),
  (5, 'Requêtes API', 12890, '/jour', 'number', -2.1),
  (5, 'Uptime', 99.9, '%', 'percentage', 0.0),
  (5, 'Tickets ouverts', 23, '', 'number', -15.0);

INSERT INTO charts (project_id, title, type, chart_order) VALUES
  (1, 'Transactions (30j)', 'line', 1),
  (1, 'Répartition des revenus', 'pie', 2),
  (1, 'Utilisateurs par jour', 'area', 3),
  (2, 'Ventes par catégorie', 'bar', 1),
  (2, 'Évolution du CA', 'line', 2),
  (3, 'Sessions par OS', 'pie', 1),
  (3, 'Rétention utilisateurs', 'area', 2),
  (4, 'Requêtes par jour', 'line', 1),
  (4, 'Temps de réponse', 'bar', 2),
  (5, 'Utilisation API', 'line', 1),
  (5, 'Tickets par catégorie', 'bar', 2);

INSERT INTO chart_data (chart_id, label, value) VALUES
  (1, '01/07', 8200), (1, '05/07', 8400), (1, '10/07', 7900), (1, '15/07', 8600), (1, '20/07', 9100), (1, '25/07', 8432),
  (2, 'Abonnements', 45), (2, 'Transactions', 30), (2, 'Publicité', 15), (2, 'Autres', 10),
  (3, 'Lun', 11200), (3, 'Mar', 11800), (3, 'Mer', 12500), (3, 'Jeu', 12100), (3, 'Ven', 13500), (3, 'Sam', 9800), (3, 'Dim', 8700),
  (4, 'Électronique', 35), (4, 'Mode', 25), (4, 'Maison', 20), (4, 'Sport', 12), (4, 'Autre', 8),
  (5, 'Sem 1', 45000), (5, 'Sem 2', 52000), (5, 'Sem 3', 48500), (5, 'Sem 4', 56000),
  (6, 'iOS', 48), (6, 'Android', 42), (6, 'Web', 10),
  (7, 'J1', 100), (7, 'J7', 65), (7, 'J14', 48), (7, 'J30', 34), (7, 'J60', 22), (7, 'J90', 15),
  (8, 'Lun', 890), (8, 'Mar', 920), (8, 'Mer', 880), (8, 'Jeu', 950), (8, 'Ven', 1020), (8, 'Sam', 780), (8, 'Dim', 720),
  (9, 'API Rest', 0.8), (9, 'GraphQL', 1.2), (9, 'WebSocket', 0.5), (9, 'gRPC', 2.1),
  (10, 'Lun', 12500), (10, 'Mar', 13100), (10, 'Mer', 12800), (10, 'Jeu', 13400), (10, 'Ven', 14200), (10, 'Sam', 11500), (10, 'Dim', 10900),
  (11, 'Bug', 40), (11, 'Feature', 25), (11, 'Support', 20), (11, 'Autre', 15);
