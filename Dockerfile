FROM golang:1.23-alpine AS builder

RUN apk add --no-cache git ca-certificates

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o headscale ./cmd/headscale

FROM gcr.io/distroless/base-debian12

COPY --from=builder /build/headscale /usr/local/bin/headscale

EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/headscale"]
