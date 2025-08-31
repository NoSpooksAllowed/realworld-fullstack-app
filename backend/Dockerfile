FROM node:lts-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN apt-get update -y && apt-get install -y openssl \
  && npx prisma generate \
  && npm run build

FROM node:lts-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --omit=dev \
  && chown node:node .

COPY --chown=node:node --from=builder /app/node_modules ./node_modules
COPY --chown=node:node --from=builder /app/dist ./dist
COPY --chown=node:node --from=builder /app/package*.json ./
COPY --chown=node:node --from=builder /app/prisma ./prisma

RUN apt-get update -y && apt-get install -y openssl

USER node

EXPOSE 3000

CMD ["node", "dist/server.js"]
