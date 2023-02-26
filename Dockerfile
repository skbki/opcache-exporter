FROM golang:1.19-alpine AS build
RUN apk add -U --no-cache ca-certificates && update-ca-certificates
WORKDIR /app
COPY go.mod ./
COPY cmd ./
RUN go mod tidy
RUN CGO_ENABLED=0 go build -o /opcache_exporter ./cmd/exporter

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build opcache_exporter /usr/bin/opcache_exporter
EXPOSE 9101
ENTRYPOINT ["/usr/bin/opcache_exporter"]
