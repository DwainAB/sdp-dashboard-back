import { Router, Request, Response } from 'express'
import pool from '../db'

const router = Router()

router.get('/users/me', async (req: Request, res: Response) => {
  const email = req.headers['x-user-email'] as string
  if (!email) {
    res.status(401).json({ error: 'Email requis' })
    return
  }
  const [rows] = await pool.query<any[]>(
    `SELECT u.id, u.email, u.first_name, u.last_name, u.is_active, u.last_login,
            r.id as role_id, r.name as role_name, r.description as role_description
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE u.email = ? AND u.is_active = TRUE`,
    [email]
  )
  const user = rows[0]
  if (!user) {
    res.status(404).json({ error: 'Utilisateur non trouvé' })
    return
  }
  const [permissions] = await pool.query<any[]>(
    `SELECT resource, action FROM role_permissions WHERE role_id = ?`,
    [user.role_id]
  )
  res.json({ ...user, permissions })
})

router.post('/auth/login', async (req: Request, res: Response) => {
  const { email, first_name, last_name } = req.body
  if (!email) {
    res.status(400).json({ error: 'Email requis' })
    return
  }
  const [rows] = await pool.query<any[]>(
    `SELECT u.id, u.email, u.first_name, u.last_name, u.is_active,
            r.id as role_id, r.name as role_name, r.description as role_description
     FROM users u
     JOIN roles r ON r.id = u.role_id
     WHERE u.email = ?`,
    [email]
  )
  let user = rows[0]
  if (!user) {
    res.status(403).json({ error: 'Accès refusé. Votre email n\'est pas autorisé.' })
    return
  }
  if (!user.is_active) {
    res.status(403).json({ error: 'Compte désactivé. Contactez un administrateur.' })
    return
  }
  await pool.query('UPDATE users SET last_login = NOW() WHERE id = ?', [user.id])
  if (first_name || last_name) {
    await pool.query(
      `UPDATE users SET first_name = COALESCE(NULLIF(?, ''), first_name), last_name = COALESCE(NULLIF(?, ''), last_name) WHERE id = ?`,
      [first_name || null, last_name || null, user.id]
    )
  }
  const [permissions] = await pool.query<any[]>(
    `SELECT resource, action FROM role_permissions WHERE role_id = ?`,
    [user.role_id]
  )
  user = { ...user, permissions }
  res.json(user)
})

export default router
