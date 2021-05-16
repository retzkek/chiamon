FROM golang:alpine AS builder

WORKDIR /build
RUN apk add --update --no-cache --virtual build-dependencies git make \
    && git clone https://github.com/google/mtail \
    && cd mtail \
    && make install

FROM alpine
COPY --from=builder /build/mtail/usr/local/bin/mtail /usr/bin/mtail
COPY *.mtail /etc/mtail/

ENTRYPOINT ["/usr/bin/mtail"]
