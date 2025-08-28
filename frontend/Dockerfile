FROM node:lts-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --ignore-scripts

COPY . .

RUN REACT_APP_BACKEND_URL="/api" npm run build

FROM nginx:1.23.2-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --chown=nginx:nginx --from=builder /app/build /usr/share/nginx/html

RUN touch /var/run/nginx.pid \
  && chown -R nginx:nginx /var/run/nginx.pid /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
