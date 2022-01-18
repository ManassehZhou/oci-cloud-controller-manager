# Powered by MZ, inspired by oci-cloud-controller-manager

FROM golang:alpine

# prepare dependencies
RUN apk add make gcc git

# Copy source code to docker
WORKDIR /app
ADD . /app

ARG COMPONENT

RUN COMPONENT=${COMPONENT} make clean build

FROM alpine

# prepare dependencies
RUN apk add util-linux e2fsprogs python2

# Copy from built results
COPY --from=0 /app/dist/* /usr/local/bin/
COPY --from=0 /app/image/* /usr/local/bin/
