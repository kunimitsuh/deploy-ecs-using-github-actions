##
## Development
##
FROM golang:1.22-bookworm as dev
WORKDIR /app
COPY . .
RUN go mod download


##
## Builder
##
FROM golang:1.22-bookworm as builder

WORKDIR /app

COPY . .

RUN go mod download

RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

##
## Production Deploy
##
FROM alpine as prod

WORKDIR /app

COPY --from=builder /app/main ./

ENV GIN_MODE release

ENTRYPOINT ["./main"]