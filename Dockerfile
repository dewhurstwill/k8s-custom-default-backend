FROM node:16 as build

RUN npm i -g webpack webpack-cli webpack-dev-server

USER node
WORKDIR /home/node/app

# Copy react template to container
COPY --chown=node content/template ./

RUN yarn install

# Set REDIRECT_URL for build
ARG REDIRECT_URL
ENV REACT_APP_REDIRECT=$REDIRECT_URL

# Run react build
RUN yarn build

FROM nginx:alpine as deploy

# Remove default NGINX Config
RUN rm /etc/nginx/conf.d/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# NGINX Config
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Resources
COPY --from=build /home/node/app/build/ /var/www/html/

CMD ["nginx", "-g", "daemon off;"]