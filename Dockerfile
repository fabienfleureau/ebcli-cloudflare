# Docker file to run AWS EB CLI tools.
FROM alpine:3.14

ENV PYTHONUNBUFFERED=1
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN apk --no-cache --update add \
        bash \
        less \
        groff \
        jq \
        git \
        curl \
        python3 \
        py-pip \
        zip

RUN pip install --ignore-installed six --upgrade pip \
        awscli \
        cloudflare \
        envsubst

RUN apk add --no-cache --virtual build-deps \
        build-base \
        gcc \
        wget \
        python3-dev \
        libffi-dev \
        openssl-dev && \
    pip install --ignore-installed six --no-cache-dir awsebcli && \
    apk del build-deps

RUN wget -q -O vault.zip https://releases.hashicorp.com/vault/1.7.2/vault_1.7.2_linux_amd64.zip && unzip vault.zip -d /usr/local/bin && chmod +x /usr/local/bin/vault

ENV PAGER="less"

# Expose credentials volume
RUN mkdir ~/.aws