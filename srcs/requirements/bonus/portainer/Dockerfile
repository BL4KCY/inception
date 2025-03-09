FROM alpine:3.21

RUN apk update && apk add --no-cache wget bash

RUN wget https://github.com/portainer/portainer/releases/download/2.27.1/portainer-2.27.1-linux-amd64.tar.gz\
	--output-document portainer.gz && tar vxf portainer.gz

WORKDIR /portainer

EXPOSE 9000 9443

CMD [ "./portainer" ]