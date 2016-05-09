FROM alpine:3.3

MAINTAINER ContainerShip Developers <developers@containership.io>

RUN apk update
RUN apk add drill

ADD . /app
WORKDIR /app
CMD ./run.sh
