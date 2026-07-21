##
## Development
##
FROM golang:1.26-trixie AS dev
WORKDIR /app
COPY . .
RUN go mod download


##
## Builder
##
FROM golang:1.26-trixie AS builder

WORKDIR /app

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

##
## Production Deploy
##
FROM alpine:3.24 AS prod

WORKDIR /app

COPY --from=builder /app/main ./

RUN addgroup -S app && adduser -S app -G app && chown -R app:app /app
USER app

EXPOSE 1323

ENTRYPOINT ["./main"]
