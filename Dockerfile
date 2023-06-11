# Stage 1 - Build
FROM node:18.16 as build

WORKDIR /usr/app

RUN apt-get update -y && \ 
  npm install --location=global npm@latest

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY . .

# Stage 2 - Production
FROM node:18.16-alpine as production

WORKDIR /usr/app

RUN apk update && \ 
  npm install --location=global npm@latest

ENV NODE_ENV=production

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY --from=build /usr/app ./app

RUN chown -R node:node .

USER node

EXPOSE 3000

CMD ["node", "./app/app.js"]