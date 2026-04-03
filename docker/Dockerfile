FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY main.go ./

RUN mkdir -p /out \
    && CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/shadow-api .

FROM scratch

COPY --from=builder /out/shadow-api /shadow-api

EXPOSE 8080

ENTRYPOINT ["/shadow-api"]
