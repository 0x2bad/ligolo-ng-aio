FROM node:20-alpine AS webui-builder
ARG WEBUI_REF=master
WORKDIR /web
RUN apk add --no-cache git
RUN git clone --depth=1 --branch "${WEBUI_REF}" https://github.com/nicocha30/ligolo-ng-web.git .
RUN npm ci && npm run build  # outputs /web/dist

FROM alpine:3.20
WORKDIR /opt/ligolo-ng

RUN apk add --no-cache nginx tini ca-certificates iproute2 iptables curl gettext && update-ca-certificates

RUN set -e; \
    REPO="nicocha30/ligolo-ng"; TAG="${LIGOLO_VERSION:-latest}"; \
    [ "$TAG" = latest ] && TAG="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest" | sed -E 's#.*/tag/##')"; \
    ASSET="ligolo-ng_proxy_${TAG#?}_linux_amd64.tar.gz"; \
    curl -fsSL --retry 3 "https://github.com/$REPO/releases/download/$TAG/$ASSET" \
    | tar -xz -C /opt/ligolo-ng proxy; \
    rm -f $ASSET

COPY --from=webui-builder /web/dist /usr/share/nginx/html

COPY --chmod=0644 ./ligolo-ng.yaml.tpl /opt/ligolo-ng/ligolo-ng.yaml
COPY --chmod=0644 ./nginx.conf /etc/nginx/nginx.conf
COPY --chmod=0755 ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENV LIGOLO_ARGS=""

EXPOSE 8000 11601

ENTRYPOINT ["/sbin/tini","--","/usr/local/bin/entrypoint.sh"]