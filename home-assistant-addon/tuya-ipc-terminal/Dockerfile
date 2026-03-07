ARG BUILD_FROM
FROM golang:1.23-alpine AS builder

WORKDIR /src
RUN apk add --no-cache git
RUN git clone --depth=1 https://github.com/cchrkk/tuya-ipc-terminal.git .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags "-s -w" -o /out/tuya-ipc-terminal .

FROM ${BUILD_FROM}
RUN apk add --no-cache ca-certificates jq

COPY --from=builder /out/tuya-ipc-terminal /usr/local/bin/tuya-ipc-terminal
COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
