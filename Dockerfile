ARG IMAGE=alpine

FROM alpine AS qemu
ARG QEMU=x86_64
ARG QEMU_VERSION=v2.11.0
ADD https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VERSION}/qemu-${QEMU}-static /qemu-${QEMU}-static
RUN chmod +x /qemu-${QEMU}-static

FROM ${IMAGE}
ARG QEMU=x86_64
COPY --from=qemu /qemu-${QEMU}-static /usr/bin/qemu-${QEMU}-static

ARG ARCH=amd64
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION

ADD . /usr/src/app
WORKDIR /usr/src/app
RUN apk add --update --no-cache tini python py-pip && \
    pip install --no-cache-dir -r requirements.txt && \
    python setup.py install

ENTRYPOINT ["tini", "--", "fdu"]
CMD ["--help"]

LABEL de.whatever4711.freenom.version=$VERSION \
      de.whatever4711.freenom.name="Freenom" \
      de.whatever4711.freenom.docker.cmd="docker run --name=freenom whatever4711/freenom" \
      de.whatever4711.freenom.vendor="Marcel Grossmann" \
      de.whatever4711.freenom.architecture=$ARCH \
      de.whatever4711.freenom.vcs-ref=$VCS_REF \
      de.whatever4711.freenom.vcs-url=$VCS_URL \
      de.whatever4711.freenom.build-date=$BUILD_DATE
