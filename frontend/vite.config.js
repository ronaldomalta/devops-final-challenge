import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  // Garante caminhos absolutos para os scripts e assets na raiz ('/'),
  // evitando 404 de assets ao acessar rotas aninhadas (ex: /produtos/123)
  base: '/',
  server: {
    port: 5173,
    host: true, // Escuta em 0.0.0.0 para aceitar conexões vindas do Docker em DEV
  },
  preview: {
    port: 80,
    host: true,
  }
})