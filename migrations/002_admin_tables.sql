ALTER TABLE projects ADD COLUMN IF NOT EXISTS notes TEXT AFTER color;

CREATE TABLE IF NOT EXISTS project_notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  content TEXT NOT NULL,
  type ENUM('info', 'warning', 'update', 'maintenance') DEFAULT 'info',
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS role_project_permissions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  project_id INT NOT NULL,
  permission ENUM('none', 'view', 'edit', 'admin') DEFAULT 'none',
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  UNIQUE KEY uq_role_project (role_id, project_id)
);

CREATE TABLE IF NOT EXISTS user_projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  project_id INT NOT NULL,
  permission ENUM('none', 'view', 'edit', 'admin') DEFAULT 'view',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_project (user_id, project_id)
);

INSERT IGNORE INTO role_project_permissions (role_id, project_id, permission)
SELECT r.id, p.id, 'admin'
FROM (SELECT id FROM roles WHERE name = 'admin') r
CROSS JOIN projects p;

INSERT IGNORE INTO role_project_permissions (role_id, project_id, permission)
SELECT r.id, p.id, 'edit'
FROM (SELECT id FROM roles WHERE name = 'manager') r
CROSS JOIN projects p;

INSERT IGNORE INTO role_project_permissions (role_id, project_id, permission)
SELECT r.id, p.id, 'view'
FROM (SELECT id FROM roles WHERE name = 'viewer') r
CROSS JOIN projects p;
