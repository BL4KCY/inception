
PATH = srcs/docker-compose.yml

NAME = inception

start:
	docker compose -d -p $@ --file ${PATH} up --build
stop:
	docker compose -p $@ --file ${PATH} down

restart: stop start