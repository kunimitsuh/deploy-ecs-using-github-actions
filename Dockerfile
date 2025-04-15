##
## Development
##
FROM golang:1.24-bookworm AS dev
WORKDIR /app
COPY . .
RUN go mod download


##
## Builder
##
FROM golang:1.24-bookworm AS builder

WORKDIR /app

COPY . .

RUN go mod download

RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

##
## Production Deploy
##
FROM alpine AS prod

WORKDIR /app

COPY --from=builder /app/main ./

ENV GIN_MODE=release

ENTRYPOINT ["./main"]