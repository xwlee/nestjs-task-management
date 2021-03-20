# Build stage
FROM node:14.9.0 AS build

USER node
WORKDIR /home/node

COPY --chown=node:node package.json yarn.lock tsconfig.json tsconfig.build.json ./
RUN yarn install --frozen-lockfile

COPY --chown=node:node src ./src
RUN yarn build

# Run stage
FROM node:14.9.0-slim

USER node
WORKDIR /home/node

COPY --chown=node:node package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production && yarn cache clean --force

COPY --chown=node:node --from=build /home/node/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]