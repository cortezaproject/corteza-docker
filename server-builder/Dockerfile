FROM golang:1.15-alpine

ENV GOFLAGS="-mod=vendor"
ENV CGO_ENABLED=1

COPY build.d /build.d

RUN	chmod +x /build.d/* && \
	run-parts --exit-on-error /build.d && \
	rm -rf /build.d
