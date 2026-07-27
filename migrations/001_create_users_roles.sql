CREATE TABLE IF NOT EXISTS roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_permissions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  resource VARCHAR(100) NOT NULL,
  action VARCHAR(100) NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  UNIQUE KEY uq_role_permission (role_id, resource, action)
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255),
  role_id INT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  last_login TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

INSERT INTO roles (name, description) VALUES
  ('admin', 'Accès complet à toutes les pages et actions'),
  ('manager', 'Accès en lecture + édition sur la plupart des pages'),
  ('viewer', 'Accès en lecture seule sur les pages autorisées')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO role_permissions (role_id, resource, action)
SELECT r.id, p.resource, p.action
FROM (SELECT id FROM roles WHERE name = 'admin') r
CROSS JOIN (
  SELECT 'dashboard' as resource, 'view' as action
  UNION SELECT 'dashboard', 'edit'
  UNION SELECT 'lylo', 'view'
  UNION SELECT 'lylo', 'edit'
  UNION SELECT 'aglae', 'view'
  UNION SELECT 'aglae', 'edit'
  UNION SELECT 'ninno', 'view'
  UNION SELECT 'ninno', 'edit'
  UNION SELECT 'users', 'view'
  UNION SELECT 'users', 'edit'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.resource = p.resource AND rp.action = p.action
);

INSERT INTO role_permissions (role_id, resource, action)
SELECT r.id, p.resource, p.action
FROM (SELECT id FROM roles WHERE name = 'manager') r
CROSS JOIN (
  SELECT 'dashboard' as resource, 'view' as action
  UNION SELECT 'dashboard', 'edit'
  UNION SELECT 'lylo', 'view'
  UNION SELECT 'lylo', 'edit'
  UNION SELECT 'aglae', 'view'
  UNION SELECT 'aglae', 'edit'
  UNION SELECT 'ninno', 'view'
  UNION SELECT 'users', 'view'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.resource = p.resource AND rp.action = p.action
);

INSERT INTO role_permissions (role_id, resource, action)
SELECT r.id, p.resource, p.action
FROM (SELECT id FROM roles WHERE name = 'viewer') r
CROSS JOIN (
  SELECT 'dashboard' as resource, 'view' as action
  UNION SELECT 'lylo', 'view'
  UNION SELECT 'aglae', 'view'
  UNION SELECT 'ninno', 'view'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.resource = p.resource AND rp.action = p.action
);
