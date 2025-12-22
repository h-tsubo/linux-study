FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    sudo \
    man \
    less \
    vim \
    curl \
    git \
    iputils-ping \
    net-tools \
    build-essential \
    locales \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /workspace
