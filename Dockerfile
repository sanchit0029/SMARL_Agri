# ==========================================
# Multi-stage Dockerfile for AgriPrice AI
# ==========================================

# Stage 1: Build the React + Vite Frontend
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# Stage 2: Production Server (Node.js + Express + SQLite)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5000

# Install production dependencies for backend
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install --omit=dev

# Copy backend source code & data
COPY backend/ ./

# Copy compiled frontend assets from Stage 1 into frontend/dist
COPY --from=frontend-builder /app/frontend/dist /app/frontend/dist

# Expose server port
EXPOSE 5000

# Start Express server (serves APIs and static frontend)
CMD ["node", "server.js"]
