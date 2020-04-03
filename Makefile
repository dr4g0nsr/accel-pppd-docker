# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# grep the version from the mix file
VERSION=$(shell ./version.sh)

DOCKER_COMMAND="docker-compose -f docker-compose.yml"

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS

clean: stop ## Clean all volumes mounted locally to NFS (warning, you WILL lost all data!)
	rm -rf /data/*

# Build the container
build: ## Build the container
	docker build . -t accel-pppd:latest -t dr4g0nsr/accel-pppd:latest

build-nc: ## Build the container without caching
	docker build . -t accel-pppd:latest --nocache

start: ## Start docker containers using docker-compose
	docker-compose up -d

stop: ## Stop and remove a running container
	"${DOCKER_COMMAND}" stop

remove-dangling: ## Remove all dangling images
	#@docker rmi \$(docker images -q -f dangling=true)
	@docker image prune

kill-containers: stop remove-dangling ## Remove all containers, preserve local data
	@docker system prune -a
	@docker network prune

addcommit: ## Add changes to git
	git add *

commit: ## Commit changes to git
	git commit -m changes && git push

connect: ## Connect to docker container
	@docker exec -it accel-pppd /bin/bash

push: ## Push image
	@docker push dr4g0nsr/accel-pppd:latest


