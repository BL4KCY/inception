SHELL := /bin/sh
COMPOSE_FILE = srcs/docker-compose.yml

up:
	@mkdir  ${HOME}/data/wordpressVOL ${HOME}/data/mariadbVOL -p
	@docker compose -f  ${COMPOSE_FILE} up --build -d
down:
	@docker compose -f ${COMPOSE_FILE} down
stop:
	@docker compose -f ${COMPOSE_FILE} stop
start:
	@docker compose -f ${COMPOSE_FILE} start
restart:
	@docker compose -f ${COMPOSE_FILE} restart

clean:
	@docker volume rm `docker volume ls -qf dangling=true`
	@sudo rm -rf ${HOME}/data/wordpressVOL ${HOME}/data/mariadbVOL