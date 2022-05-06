#
# Build go project
#
FROM golang:alpine3.15 as go-builder

WORKDIR /go/src/github.com/jinqin2003/mutatingwebhook

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mutatingwebhook *.go

#
# Runtime container
#
FROM alpine:latest  

RUN mkdir -p /app && \
    addgroup -S app && adduser -S app -G app && \
    chown app:app /app

WORKDIR /app

COPY --from=go-builder /go/src/github.com/jinqin2003/mutatingwebhook .

USER app

CMD ["./mutatingwebhook"]  
