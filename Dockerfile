FROM golang:alpine as builder

# Install dependencies and build the binaries.
RUN apk add --no-cache \
    git \
    make \
&&  git clone https://github.com/guggero/docker-wallet-control /go/src/github.com/guggero/docker-wallet-control \
&&  cd /go/src/github.com/guggero/docker-wallet-control \
&&  make \
&&  make install

# Start a new, final image.
FROM alpine as final

# Add bash and ca-certs, for quality of life and SSL-related reasons.
RUN apk --no-cache add \
    bash \
    ca-certificates

# Copy the binaries from the builder image.
COPY --from=builder /go/bin/docker-wallet-control /bin/

EXPOSE 80 443

# Specify the start command and entrypoint.
ENTRYPOINT ["docker-wallet-control"]
CMD ["docker-wallet-control"]
