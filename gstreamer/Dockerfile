# syntax=docker/dockerfile:1.3-labs

FROM debian:bullseye

RUN apt-get update && apt-get install -y sudo tmux curl git-core subversion gnupg locales wget nano vim jq tree rsyslog ninja-build python3-pip flex bison

RUN pip3 install meson

ARG user_name
ARG git_user_name
ARG git_user_email

ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $user_name \
    && useradd --uid $USER_UID --gid $USER_GID -m $user_name

RUN echo $user_name ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$user_name \
    && chmod 0440 /etc/sudoers.d/$user_name

USER $user_name

RUN mkdir ~/src


RUN echo "set-option -g default-shell /bin/bash" >> ~/.tmux.conf

ENV TERM xterm

WORKDIR /home/$user_name/gstreamer

RUN git config --global user.email $git_user_email
RUN git config --global user.name $git_user_name

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

