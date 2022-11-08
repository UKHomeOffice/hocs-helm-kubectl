FROM alpine:3.16

RUN apk -U upgrade && apk add --no-cache ca-certificates git bash curl jq

ARG KUBECTL_VERSION="v1.20.15"
ARG KUBECTL_SHA256="239a48f1e465ecfd99dd5e3d219066ffea7bbd4cdedb98524e82ff11fd72ba12"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    sha256sum kubectl | grep ${KUBECTL_SHA256} && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

ARG HELM_VERSION="v3.10.1"
ARG HELM_SHA256="c12d2cd638f2d066fec123d0bd7f010f32c643afdf288d39a4610b1f9cb32af3"
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"

RUN set -x && \
    curl --retry 5 --retry-connrefused -LO ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

RUN helm plugin install https://github.com/databus23/helm-diff --version v3.6.0

ARG HELMFILE_VERSION="0.147.0"
ARG HELMFILE_SHA256="7d15a4441c4be8edd9dc86ade33b38bf24aa6e9e9dff3ca3c253db7787e97506"
ARG HELMFILE_LOCATION="https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}"
ARG HELMFILE_FILENAME="helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz"

RUN set -x && \
    curl --retry 5 --retry-connrefused -LO ${HELMFILE_LOCATION}/${HELMFILE_FILENAME} && \
    echo Verifying ${HELMFILE_FILENAME}... && \
    sha256sum ${HELMFILE_FILENAME} | grep -q "${HELMFILE_SHA256}" && \
    echo Extracting ${HELMFILE_FILENAME}... && \
    tar zxvf ${HELMFILE_FILENAME} && mv /helmfile /usr/local/bin/ && \
    rm ${HELMFILE_FILENAME}

RUN chmod 751 /root

CMD bash
