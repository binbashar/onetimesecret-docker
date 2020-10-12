.PHONY: help
SHELL         := /bin/bash
MAKEFILE_PATH := ./Makefile
MAKEFILES_DIR := ./@bin/makefiles

DOCKER_TAG       := 0.0.2
DOCKER_REPO_NAME := binbash
DOCKER_IMG_NAME  := onetimesecret

help:
	@echo 'Available Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " - \033[36m%-18s\033[0m %s\n", $$1, $$2}'

#==============================================================#
# INITIALIZATION                                               #
#==============================================================#
init-makefiles: ## initialize makefiles
	rm -rf ${MAKEFILES_DIR}
	mkdir -p ${MAKEFILES_DIR}
	git clone https://github.com/binbashar/le-dev-makefiles.git ${MAKEFILES_DIR}

-include ${MAKEFILES_DIR}/docker/docker-hub-build-push.mk

up:
	docker-compose up -d

ps:
	docker-compose ps

down:
	docker-compose down

test: ## ci docker image tests
	mkdir -p ./redis
	cp ots.conf.example ots.conf
	cp redis.conf.example redis.conf
	make up && make ps && make down
	rm -rf redis ots.conf redis.conf