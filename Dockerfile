FROM alpine:3.20.2 AS builder

RUN apk add --no-cache debootstrap wget

ARG AUTH_LOGIN
ARG AUTH_PASSWORD
RUN LOGIN=$(printf '%s' "$AUTH_LOGIN" | base64 -d) && \
    PASSWORD=$(printf '%s' "$AUTH_PASSWORD" | base64 -d) && \
    printf 'machine professional-packages.chinauos.com login %s password %s\n' \
        "$LOGIN" "$PASSWORD" > /root/.netrc && \
    chmod 600 /root/.netrc && \
    printf 'auth_no_challenge = on\niri = off\n' > /root/.wgetrc && \
    ln -s /usr/share/debootstrap/scripts/stable /usr/share/debootstrap/scripts/eagle && \
    debootstrap --include=ca-certificates --exclude=usr-is-merged --no-check-gpg \
        eagle /uos_root/ https://professional-packages.chinauos.com/desktop-professional/

COPY ./apt /uos_root/etc/apt/

FROM scratch

COPY --from=builder /uos_root/ /

CMD ["/bin/bash"]
