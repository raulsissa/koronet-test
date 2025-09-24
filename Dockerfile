# Multi-stage Dockerfile for Node.js web server
FROM node:20-alpine AS builder
WORKDIR /app
COPY server/package*.json ./
RUN npm install --production
COPY server/ ./

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD ["node", "index.js"]
