ARG BUILD_FROM=internxt/webdav:latest
FROM ${BUILD_FROM}

# Install jq, nginx, and apache2-utils for htpasswd
RUN apk add --no-cache jq nginx apache2-utils

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT []
CMD [ "/run.sh" ]
