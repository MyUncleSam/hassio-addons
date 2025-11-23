ARG BUILD_FROM=internxt/webdav:latest
FROM ${BUILD_FROM}

# Install jq to read Home Assistant config
RUN apk add --no-cache jq

# Copy run script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
