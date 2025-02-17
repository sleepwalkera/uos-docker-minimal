# 设置默认目标
.DEFAULT_GOAL := build

# 获取本地 auth.conf 文件路径
AUTH_CONF_FILE := apt/auth.conf.d/uos.conf

# 获取生成的 Authorization 请求头
AUTH_HEADER := $(shell cat $(AUTH_CONF_FILE) | grep professional-packages.chinauos.com | awk '{print $$4":"$$6}' | base64 -w 0)

# 设置 Docker 镜像名称
IMAGE_NAME := uos

# 定义构建目标
build:
	@echo "Generating Authorization Header..."
	@echo "Building Docker image with Authorization Header..."
	docker build --build-arg AUTH_HEADER=$(AUTH_HEADER) -t $(IMAGE_NAME) .

# 定义清理目标
clean:
	@echo "Cleaning up Docker images..."
	docker rmi $(IMAGE_NAME)

