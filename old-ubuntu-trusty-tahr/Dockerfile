# syntax=docker/dockerfile:1.3-labs

FROM ubuntu:trusty

RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y sudo tmux curl git-core subversion gnupg locales wget nano vim jq tree rsyslog realpath python-dev python-mysqldb net-tools tcpdump ngrep swig build-essential cmake libapr1-dev libaprutil1-dev libsofia-sip-ua-dev


SHELL ["/bin/bash", "--login", "-c"]

RUN echo "set-option -g default-shell /bin/bash" >> ~/.tmux.conf

ENV TERM xterm

RUN <<EOF cat > ~/.vimrc 
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
EOF

CMD ["bash"]

