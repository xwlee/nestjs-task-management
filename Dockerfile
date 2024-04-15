# Build stage
FROM node:21.7.3-alpine AS build

USER node
WORKDIR /home/node

COPY --chown=node:node ./ ./
RUN yarn install --frozen-lockfile
RUN yarn build

# Run stage
FROM node:21.7.3-alpine

USER node
WORKDIR /home/node

COPY --chown=node:node package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production && yarn cache clean --force

COPY --chown=node:node --from=build /home/node/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]