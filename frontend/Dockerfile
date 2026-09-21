# 1. Certifique-se de incluir "AS build" na primeira linha
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ARG VITE_API_URL=http://localhost:3001
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# 2. Estágio final do Nginx
FROM nginx:alpine

# O "--from=build" deve ser idêntico ao alias definido no primeiro "FROM"
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]