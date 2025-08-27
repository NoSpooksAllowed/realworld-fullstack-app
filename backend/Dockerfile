FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --omit=dev \
  && chown node:node .

COPY --chown=node:node --from=builder /app/node_modules ./node_modules
COPY --chown=node:node --from=builder /app/dist ./dist
COPY --chown=node:node --from=builder /app/package*.json ./

USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]
