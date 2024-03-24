FROM debian:bullseye-slim

LABEL repo_url = https://github.com/MayamaTakeshi/mydockerfiles

SHELL ["/bin/bash", "--login", "-c"]

ARG user_name

RUN apt update 

# utilities
RUN apt install -y sudo tmux curl git-core gnupg locales wget nano vim jq tree rsyslog racket net-tools tcpdump ngrep sngrep iproute2 libpcap-dev

# build packages
RUN apt install -y build-essential cmake automake autoconf libtool libtool-bin pkg-config

# general
RUN apt install -y libssl-dev zlib1g-dev libdb-dev unixodbc-dev libncurses5-dev libexpat1-dev libgdbm-dev bison erlang-dev libtpl-dev libtiff5-dev uuid-dev

# core
RUN apt install -y libpcre3-dev libedit-dev libsqlite3-dev libcurl4-openssl-dev nasm

# core codecs
RUN apt install -y libogg-dev libspeex-dev libspeexdsp-dev

# for mod_enum
RUN apt install -y libldns-dev

# for mod_python3
RUN apt install -y python3-dev

# for mod_av
RUN apt install -y libavformat-dev libswscale-dev libavresample-dev

# for mod_opus
RUN apt install -y libopus-dev

# for mod_sndfile
RUN apt install -y libsndfile1-dev libflac-dev libogg-dev libvorbis-dev

# for mod_shout
RUN apt install -y libshout3-dev libmpg123-dev libmp3lame-dev

# for mod_mariadb
RUN apt install -y libmariadb-dev

# for mod_flite
RUN apt install -y flite1-dev

# for mod_pocketsphinx
RUN apt install -y libpocketsphinx-dev

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
 
RUN . ~/.nvm/nvm.sh && nvm install v21.7.0

RUN . ~/.nvm/nvm.sh && npm install -g yarn

RUN apt install -y ruby
RUN gem install tmuxinator -v 1.1.5

# sip-lab dependencies
RUN apt install -y git build-essential automake autoconf libtool libspeex-dev libopus-dev libsdl2-dev libavdevice-dev libswscale-dev libv4l-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libvo-amrwbenc-dev libboost-dev libtiff-dev libpcap-dev libssl-dev uuid-dev flite-dev cmake

# Adding vim .editorconfig
RUN <<EOF
mkdir -p ~/.vim/pack/local/start
cd ~/.vim/pack/local/start
git clone https://github.com/editorconfig/editorconfig-vim.git
EOF

