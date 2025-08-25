FROM ubuntu:24.04

ENV BASE_DIR="app"

RUN apt update && apt install -y curl git make clang unzip npm cmake

RUN apt install -y nodejs sqlite3 

# set working directory
WORKDIR /$BASE_DIR

RUN curl -L --output /$BASE_DIR/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz
RUN tar -xzf nvim.tar.gz -C /opt
RUN mv /opt/nvim-linux-x86_64 /opt/nvim

RUN curl -L --output /$BASE_DIR/tree-sitter-x86.gz https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.8/tree-sitter-linux-x86.gz
RUN gunzip tree-sitter-x86.gz
RUN chmod +x tree-sitter-x86
RUN mv /$BASE_DIR/tree-sitter-x86 /opt/nvim/bin/tree-sitter

WORKDIR /$BASE_DIR

RUN curl -L --output /$BASE_DIR/fzf-0.65.1-linux_amd64.tar.gz https://github.com/junegunn/fzf/releases/download/v0.65.1/fzf-0.65.1-linux_amd64.tar.gz
RUN tar -xzf /$BASE_DIR/fzf-0.65.1-linux_amd64.tar.gz -C /$BASE_DIR
RUN mv /$BASE_DIR/fzf /opt/nvim/bin

RUN curl -L --output /$BASE_DIR/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
RUN tar -xzf /$BASE_DIR/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz 
RUN mv /$BASE_DIR/ripgrep-14.1.1-x86_64-unknown-linux-musl/rg /opt/nvim/bin/rg

RUN apt download liblua5.1-0-dev
RUN apt download lua5.1

RUN dpkg-deb -x liblua5.1-0-dev_5.1.5-9build2_amd64.deb ./liblua5.1
RUN dpkg-deb -x lua5.1_5.1.5-9build2_amd64.deb lua5.1

RUN cp -rn liblua5.1/usr/* /opt/nvim/
RUN cp -rn lua5.1/usr/* /opt/nvim/

ENV PATH="$PATH:/opt/nvim/bin"
ENV LD_LIBRARY_PATH="/opt/nvim/lib"
RUN mkdir /opt/nvim/log

RUN curl -L --output /$BASE_DIR/luarocks-3.12.2.tar.gz  https://luarocks.org/releases/luarocks-3.12.2.tar.gz
RUN tar zxpf luarocks-3.12.2.tar.gz
WORKDIR /$BASE_DIR/luarocks-3.12.2
RUN ./configure && make && make install
RUN luarocks install luaunit

RUN mkdir -p /opt/miniconda3
RUN curl -L --output /opt/miniconda3/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
RUN bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3

RUN /opt/miniconda3/bin/conda init
RUN /opt/miniconda3/bin/python -m pip install pynvim jupyter-client cairosvg pnglatex plotly kaleido pyperclip nbformat pillow ipykernel
RUN /opt/miniconda3/bin/python -m ipykernel install --name nvim

RUN /opt/miniconda3/bin/python - <<'EOF'
from jupyter_client import KernelManager
km = KernelManager(kernel_name="nvim")
km.start_kernel()
km.shutdown_kernel(now=True)
EOF

# RUN git clone https://github.com/bessjb/dotfiles.git
# COPY config /root/.config

WORKDIR /root

