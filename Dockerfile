#FROM node:lts
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:0-14 as clonestage

# Import ARGs
ARG GIT_REPO_URL

# Create app directory
WORKDIR /usr/src/app

# Clone git repository
RUN git clone ${GIT_REPO_URL} .

# next multistage
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:0-14

# Create app directory
WORKDIR /usr/src/app

# copy cloned repo
COPY --from=clonestage /usr/src/app/package.json /usr/src/app
COPY --from=clonestage /usr/src/app/yarn.lock /usr/src/app

# install packages
RUN yarn install

# copy cloned repo
COPY --from=clonestage /usr/src/app /usr/src/app

# Keep container alive
CMD exec /bin/bash -c "echo Container started ; trap \"exit 0\" 15; while sleep 1 & wait $!; do :; done"
 
