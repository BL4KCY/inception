FROM alpine:3.21

RUN apk update && apk add --no-cache redis bash

EXPOSE 6379

CMD [ "redis-server", "--protected-mode", "no"]
