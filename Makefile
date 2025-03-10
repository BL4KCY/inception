PATH = srcs/docker-compose.yml

up:
	$(shell mkdir  ${HOME}/data/wordpressVOL ${HOME}/data/mariadbVOL -p)
	$(shell docker-compose -f  ${PATH} up -d --build)
down:
	$(shell docker-compose -f ${PATH} down)
stop:
	$(shell docker-compose -f ${PATH} stop)
start:
	$(shell docker-compose -f ${PATH} start)
restart:
	$(shell docker-compose -f ${PATH} restart)

clean:
	$(shell docker volume rm `docker volume ls -qf dangling=true`)
	$(shell sudo rm -rf ${HOME}/data/wordpressVOL ${HOME}/data/mariadbVOL)
