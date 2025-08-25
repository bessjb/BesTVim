FROM ubuntu:24.04

RUN apt update && apt install -y curl git sqlite3

# set working directory
WORKDIR /app

RUN curl -L --output /app/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz
RUN tar -xzf nvim.tar.gz -C /opt

RUN curl -L --output /app/tree-sitter-x86.gz https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.8/tree-sitter-linux-x86.gz
RUN gunzip tree-sitter-x86.gz
RUN chmod +x tree-sitter-x86
RUN cp /app/tree-sitter-x86 /opt/nvim-linux-x86_64/bin/tree-sitter

RUN curl -L --output /app/fzf-0.65.1-linux_amd64.tar.gz https://github.com/junegunn/fzf/releases/download/v0.65.1/fzf-0.65.1-linux_amd64.tar.gz
RUN tar -xzf fzf-0.65.1-linux_amd64.tar.gz -C /app

ENV PATH="${PATH}:/opt/nvim-linux-x86_64/bin"

RUN git clone https://github.com/bessjb/dotfiles.git
RUN cp -r dotfiles/.config /root/

