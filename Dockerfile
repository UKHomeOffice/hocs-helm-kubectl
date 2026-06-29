FROM alpine:3.24

RUN apk -U upgrade && apk add --no-cache ca-certificates git bash curl jq postgresql18-client

ARG KUBECTL_VERSION="v1.36.1"
ARG KUBECTL_SHA256="629d3f410e09bf49b64ae7079f7f0bda1191efed311f7d37fdbab0ad5b0ec2b7"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    sha256sum kubectl | grep ${KUBECTL_SHA256} && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

ARG HELM_VERSION="v4.2.2"
ARG HELM_SHA256="9adafecab4d406853bba163a70e9f104f47dbbf65ce24b7653bae7e36150bcb6"
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"

RUN set -x && \
    curl --retry 5 --retry-connrefused -LO ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Verifying ${HELM_FILENAME}... && \
    sha256sum ${HELM_FILENAME} | grep -q "${HELM_SHA256}" && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

RUN helm plugin install https://github.com/databus23/helm-diff --version v3.15.10 --verify=false

ARG HELMFILE_VERSION="1.6.0"
ARG HELMFILE_SHA256="44c617bc12b5f7f1ca1da5333ccbd3865b314c132168b4ce1127f47e756008dc"
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

CMD ["bash"]
