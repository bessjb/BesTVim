FROM ubuntu:24.04

# Install Git
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Git clone repo
RUN git clone git@github.com:bessjb/BesTVim.git
