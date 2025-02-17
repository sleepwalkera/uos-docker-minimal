# 使用 alpine 作为基础镜像
FROM alpine:latest AS builder

# 安装必要的工具：nginx 和 debootstrap
RUN apk add --no-cache \
    nginx \
    debootstrap

# 配置 nginx 代理
ARG AUTH_HEADER
RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx/http.d/ && \
    echo 'server {' > /etc/nginx/http.d/proxy.conf && \
    echo '    listen 8888;' >> /etc/nginx/http.d/proxy.conf && \
    echo '    location / {' >> /etc/nginx/http.d/proxy.conf && \
    echo '        proxy_pass https://professional-packages.chinauos.com/;' >> /etc/nginx/http.d/proxy.conf && \
    echo '        proxy_set_header Host professional-packages.chinauos.com;' >> /etc/nginx/http.d/proxy.conf && \
    echo "        proxy_set_header Authorization \"Basic $AUTH_HEADER\";" >> /etc/nginx/http.d/proxy.conf && \
    echo '    }' >> /etc/nginx/http.d/proxy.conf && \
    echo '}' >> /etc/nginx/http.d/proxy.conf

# 启动 nginx 代理，通过 debootstrap 拉取 rootfs
RUN nginx && mkdir -p /uos_root \
    && ln -s /usr/share/debootstrap/scripts/stable /usr/share/debootstrap/scripts/eagle \
    && debootstrap --include=ca-certificates --exclude=usr-is-merged --no-check-gpg eagle /uos_root/ http://localhost:8888/desktop-professional/

# 将本地的 apt 配置文件复制到镜像中
COPY ./apt /uos_root/etc/apt/

# 最终阶段：构建最终镜像
FROM scratch

# 将从 /uos_root 拉取的 rootfs 复制到最终镜像
COPY --from=builder /uos_root/ /

# 设置默认启动命令
CMD ["/bin/bash"]
