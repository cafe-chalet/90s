FROM golang:1.22.5-bullseye AS builder
WORKDIR /app
RUN apt-get update -qq && \
	apt-get install --no-install-recommends -y build-essential pkg-config python-is-python3 upx

RUN apt-get install -y --no-install-recommends ca-certificates

COPY go.mod go.sum ./
RUN go version
RUN go mod tidy
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o bin/app_prod cmd/90s/90s.go

FROM scratch
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/bin .
EXPOSE 3000
CMD [ "/app/app_prod" ]
