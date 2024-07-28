.PHONY: build start stop list init deploy status remove scale logs usage

COMPOSE_FILE=docker-compose.yml
STACK_NAME=meilisearch_stack

build:
	docker-compose -f $(COMPOSE_FILE) build

start:
	docker swarm init
	docker stack deploy -c $(COMPOSE_FILE) $(STACK_NAME)

stop:
	docker stack rm $(STACK_NAME)
	docker swarm leave --force

list:
	docker stack services $(STACK_NAME)

init:
	docker swarm init

deploy:
	docker stack deploy -c $(COMPOSE_FILE) $(STACK_NAME)

status:
	docker stack services $(STACK_NAME)

remove:
	docker stack rm $(STACK_NAME)
	docker swarm leave --force

scale:
	# Replace the service name with the actual name from 'docker stack services' make scale REPLICAS=5
	docker service scale $(STACK_NAME)_meilisearch=$(REPLICAS)

logs:
	# Replace the service name with the actual name from 'docker stack services'
	docker service logs -f $(STACK_NAME)_meilisearch

usage:
	# Show resource usage of each Meilisearch instance
	docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" `docker ps --filter label=com.docker.swarm.service.name=$(STACK_NAME)_meilisearch -q`
# Example usage: make scale REPLICAS=5
