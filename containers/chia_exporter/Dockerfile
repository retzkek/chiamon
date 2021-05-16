FROM golang:alpine AS builder

WORKDIR /build
RUN apk add --update --no-cache --virtual build-dependencies git make \
    && git clone https://github.com/tcinbis/chia_exporter \
    && cd chia_exporter \
    && go build -tags netgo

FROM alpine
COPY --from=builder /build/chia_exporter/chia_exporter /usr/bin/chia_exporter

ENTRYPOINT ["/usr/bin/chia_exporter"]
