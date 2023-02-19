USER = $(shell whoami)
UID = $(shell id -u)
GID = $(shell id -g)
PWD = $(shell pwd)
NODE_PKG_MNGR = yarn
NODE = node:lts-slim
COMPOSER = composer
DC = docker compose

.PHONY: docker_build
docker_build:
	$(DC) build

.PHONY: docker_up
docker_up:
	$(DC) up --remove-orphans --force-recreate

.PHONY: init-deps
init-deps: init-back-deps  init-front-deps

.PHONY: init-back-deps
init-back-deps:
	docker run --rm -ti -v $(PWD):/app --user $(UID):$(GID) $(COMPOSER) install

.PHONY: init-front-deps
init-front-deps:
	docker run --rm -u node -w /home/node/app -v $(PWD):/home/node/app $(NODE) $(NODE_PKG_MNGR) install

.PHONY: node_watch
node_watch:
	docker run --rm --name node_symfo6-skel -u node -w /home/node/app -v $(PWD):/home/node/app $(NODE) $(NODE_PKG_MNGR) watch

.PHONY: db
db:
	$(DC) exec php-fpm composer database

.PHONY: db-dev
db-dev:
	$(DC) exec php-fpm composer database-dev
