FROM alpine:3.21

COPY ./conf /etc/my.cnf.d

WORKDIR /setupDB

RUN apk update && apk add mariadb mariadb-client &&\
	mkdir -p /var/run/mysqld/ &&\
	mkdir -p /var/log/mysql &&\
	chown -R mysql:mysql /var/log/mysql &&\
	chown -R mysql:mysql /var/run/mysqld

RUN	mariadb-install-db --user=mysql

COPY ./tools /setupDB/

CMD [ "sh", "setup-mariadb.sh"]

EXPOSE 3306