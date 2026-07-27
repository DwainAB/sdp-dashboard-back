import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import dashboardRoutes from './routes/dashboards'
import authRoutes from './routes/auth'

const app = express()
const PORT = Number(process.env.PORT) || 3001

app.use(cors({ origin: '*' }))
app.use(express.json())

app.use('/api', dashboardRoutes)
app.use('/api', authRoutes)

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' })
})

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`)
})
