FROM node:12.14-alpine

COPY build.d /build.d

RUN	chmod +x /build.d/* && \
	run-parts --exit-on-error /build.d && \
	rm -rf /build.d
