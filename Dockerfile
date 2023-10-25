FROM ubuntu:20.04 as base

RUN apt update
RUN apt install -y git wget zip unzip build-essential kpartx qemu binfmt-support qemu-user-static e2fsprogs dosfstools

FROM base as packer

ARG PACKER_RELEASE="1.7.6"

WORKDIR /tmp

RUN wget https://releases.hashicorp.com/packer/${PACKER_RELEASE}/packer_${PACKER_RELEASE}_linux_amd64.zip \
    && unzip packer_${PACKER_RELEASE}_linux_amd64.zip \
    && mv packer /usr/local/bin

FROM packer as packer_arm

ARG PACKER_ARM_BUILDER_VERSION="0.2.7"

WORKDIR /tmp/

RUN wget https://github.com/solo-io/packer-builder-arm-image/releases/download/v${PACKER_ARM_BUILDER_VERSION}/packer-plugin-arm-image_v${PACKER_ARM_BUILDER_VERSION}_x5.0_linux_amd64.zip \
    && unzip packer-plugin-arm-image_v${PACKER_ARM_BUILDER_VERSION}_x5.0_linux_amd64.zip \
    && mv packer-plugin-arm-image_v${PACKER_ARM_BUILDER_VERSION}_x5.0_linux_amd64 /usr/local/bin/packer-builder-arm-image \
    && chmod +x /usr/local/bin/packer-builder-arm-image

FROM packer_arm as prep

WORKDIR /usr/src/workspace

COPY . .

FROM prep as builder

WORKDIR /usr/src/workspace

RUN packer build image.json