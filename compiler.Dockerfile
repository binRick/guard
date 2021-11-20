FROM fedora:latest as base

RUN dnf -y update && dnf -y install musl-gcc zsh fish golang-bin
RUN dnf -y install coreutils psmisc

<<<<<<< HEAD
COPY ./ /guard
WORKDIR /guard
#RUN go build -v -o /guard-musl
=======
WORKDIR /guard
COPY go.mod go.sum \
      main.go proto.go server.go \
                                  /guard/
RUN find /guard
>>>>>>> ef5fc8aca357c2877d17394ffeedaea9c0aa31e1
RUN env CGO_ENABLED=1 CC=musl-gcc go build -o /guard-musl
RUN stat /guard-musl
RUN file /guard-musl
RUN ldd /guard-musl
RUN /guard-musl --help

FROM base as guardclient
FROM base as guardserver
FROM base as compiler

