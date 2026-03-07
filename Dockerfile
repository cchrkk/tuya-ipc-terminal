# syntax=docker/dockerfile:1

FROM golang:1.23-alpine AS builder
WORKDIR /src

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN set -eux; \
	export GOARM=""; \
	if [ "${TARGETARCH}" = "arm" ] && [ -n "${TARGETVARIANT}" ]; then export GOARM="${TARGETVARIANT#v}"; fi; \
	CGO_ENABLED=0 GOOS="${TARGETOS}" GOARCH="${TARGETARCH}" go build -trimpath -ldflags "-s -w" -o /out/tuya-ipc-terminal .

FROM alpine:3.20
RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app
COPY --from=builder /out/tuya-ipc-terminal /usr/local/bin/tuya-ipc-terminal

ENV TUYA_DATA_DIR=/data/.tuya-data
VOLUME ["/data"]
EXPOSE 8554

ENTRYPOINT ["tuya-ipc-terminal"]
CMD ["--help"]
