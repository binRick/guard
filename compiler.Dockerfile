FROM fedora:latest as compiler

RUN dnf -y update && dnf -y install musl-gcc zsh fish golang-bin

COPY ./ /guard
#RUN go build -v -o /guard-musl
RUN env CGO_ENABLED=1 CC=musl-gcc go build -o /guard-musl
RUN stat /guard-musl
RUN file /guard-musl
RUN ldd /guard-musl
RUN /guard-musl --help

from compiler as C1
RUN touch /1
