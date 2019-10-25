FROM openfalcon/makegcc-golang:1.10-alpine as builder
LABEL maintainer laiwei.ustc@gmail.com
USER root

ENV FALCON_DIR=/open-falcon PROJ_PATH=${GOPATH}/src/github.com/lxlee1102/anteye

RUN mkdir -p $FALCON_DIR && \
    mkdir -p $FALCON_DIR/anteye/config && \
    mkdir -p $FALCON_DIR/anteye/bin && \
    mkdir -p $FALCON_DIR/anteye/var && \
    mkdir -p $PROJ_PATH && \
    apk add --no-cache ca-certificates bash git

COPY . ${PROJ_PATH}
WORKDIR ${PROJ_PATH}
RUN go get ./... && \
    ./control build  && \
    go build ./vendor/github.com/lxlee1102/cfgmaker && \
    cp -f falcon-anteye $FALCON_DIR/anteye/bin/falcon-anteye && \
    cp -f cfgmaker $FALCON_DIR/anteye/cfgmaker && \
    cp -f cmdocker/anteye.tpl $FALCON_DIR/anteye/ && \
    cp -f cmdocker/falcon-entry.sh $FALCON_DIR/ && \
    cp -f cmdocker/localtime.shanghai $FALCON_DIR/ && \
    rm -rf ${PROJ_PATH}


WORKDIR $FALCON_DIR
RUN tar -czf falcon-anteye.tar.gz ./


FROM alpine:3.7 as prog
USER root

ENV FALCON_DIR=/open-falcon FALCON_MODULE=anteye

RUN mkdir -p $FALCON_DIR && \
    apk add --no-cache ca-certificates bash util-linux

WORKDIR $FALCON_DIR

COPY --from=0  $FALCON_DIR/falcon-anteye.tar.gz  $FALCON_DIR/
COPY --from=0  $FALCON_DIR/localtime.shanghai  $FALCON_DIR/
RUN tar -zxf falcon-anteye.tar.gz && \
    rm -rf falcon-anteye.tar.gz && \
    mv localtime.shanghai /etc/localtime

EXPOSE 8001

# create config-files by ENV
CMD ["./falcon-entry.sh"]
