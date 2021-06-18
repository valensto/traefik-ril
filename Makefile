include .env
export

NETWORKS="$(shell docker network ls)"
VOLUMES="$(shell docker volume ls)"
SUCCESS=[ done "\xE2\x9C\x94" ]

# default arguments
user ?= root
service ?= api

all: traefik-network sql-net
	@echo [ starting client '&' api... ]
	docker-compose up -d traefik db phpmyadmin portainer wordpress

traefik-network:
ifeq (,$(findstring traefik-public,$(NETWORKS)))
	@echo [ creating traefik network... ]
	docker network create traefik-public
	@echo $(SUCCESS)
endif

sql-net:
ifeq (,$(findstring sql-net,$(NETWORKS)))
	@echo [ creating sql network... ]
	docker network create sql-net
	@echo $(SUCCESS)
endif

down:
	@echo [ teardown all containers... ]
	docker-compose down
	@echo $(SUCCESS)

.PHONY: all
.PHONY: traefik-network
.PHONY: sql-net
.PHONY: down