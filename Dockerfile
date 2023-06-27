FROM alpine:3

ARG KUBECTL_VERSION="STABLE"
ARG KUBECTL_ARCH="amd64"

## install some useful tools to have around in a kubectl container
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    jq \
    python3 \
    aws-cli

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$( [ "$KUBECTL_VERSION" == "STABLE" ] && curl -L -s "https://dl.k8s.io/release/stable.txt" || echo "$KUBECTL_VERSION" )/bin/linux/$KUBECTL_ARCH/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# step down from root
RUN adduser -D user
USER user
WORKDIR /home/user
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/user/.local/bin

# TODO: do we want a different command or entrypoint?
CMD [ "/bin/bash" ]
