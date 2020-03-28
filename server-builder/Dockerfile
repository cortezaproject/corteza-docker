FROM golang:1.12-alpine

ENV CGO_ENABLED=0

COPY build.d /build.d

RUN	chmod +x /build.d/* && \
	run-parts --exit-on-error /build.d && \
	rm -rf /build.d
