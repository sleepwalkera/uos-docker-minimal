.DEFAULT_GOAL := build

AUTH_CONF_FILE := apt/auth.conf.d/uos.conf

AUTH_LOGIN   := $(shell grep -m1 '^machine packages\.chinauos\.com ' $(AUTH_CONF_FILE) | awk '{print $$4}' | base64 -w 0)
AUTH_PASSWORD := $(shell grep -m1 '^machine packages\.chinauos\.com ' $(AUTH_CONF_FILE) | awk '{print $$6}' | base64 -w 0)

IMAGE_NAME := uos

build:
	@echo "Building Docker image..."
	docker build \
		--build-arg AUTH_LOGIN=$(AUTH_LOGIN) \
		--build-arg AUTH_PASSWORD=$(AUTH_PASSWORD) \
		-t $(IMAGE_NAME) .

clean:
	@echo "Cleaning up Docker images..."
	docker rmi $(IMAGE_NAME)
