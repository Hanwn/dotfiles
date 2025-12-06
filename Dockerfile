FROM alpine:latest

ENV DEVELOPER=hanwn

RUN set -eux; \
    ALPINE_VERSION=$(cat /etc/alpine-release | cut -d '.' -f 1,2); \
    echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v${ALPINE_VERSION}/main" > /etc/apk/repositories; \
    echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories; \
    apk update; \
    rm -rf /var/cache/apk/*


RUN set -eux ; \ 
    apk update ;\
    apk add --no-cache \
    bash curl git git-lfs openssh-client openssh-server sudo shadow tzdata\
    nodejs \
    lua5.4 \
    go delve \
    openjdk17 maven  \
    g++ gcc cmake \
    python3 uv\
    neovim ripgrep fd fzf bat delta\
    zsh starship yazi lazygit \
    stow \
    protobuf protoc \
    typst


RUN mkdir /var/run/sshd ;\
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config ;\
    # sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    # sed -i 's/#Port 22/Port 36000/' /etc/ssh/sshd_config ;\
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' ;\
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' ;\
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''


RUN set -eux; \
    mkdir -p /data/workspace && chmod 755 /data/workspace && chown root:root /data/workspace; \
    useradd -m -d /home/${DEVELOPER} -s /bin/zsh ${DEVELOPER}; \
    chown -R ${DEVELOPER}:${DEVELOPER} /data/workspace; \
    echo "${DEVELOPER}:123456" | chpasswd; \
    echo "${DEVELOPER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DEVELOPER}-nopasswd; \
    chmod 0440 /etc/sudoers.d/${DEVELOPER}-nopasswd; \
    chage -d 0 ${DEVELOPER};


RUN set -eux; \
    mkdir -p /data/startup; \
    echo '#!/bin/bash' > /data/startup/start-ssh.sh; \
    echo '/usr/sbin/sshd -D' >> /data/startup/start-ssh.sh; \
    echo 'if [ -d /data/workspace ]; then cd /data/workspace; fi' >> /etc/profile; \
    echo 'if [ -d /data/workspace ]; then cd /data/workspace; fi' >> /etc/bashrc; \
    chmod +x /data/startup/start-ssh.sh


# 指定字符集支持命令行输入中文
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \ 
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./ /home/${DEVELOPER}/dotfiles

CMD ["/data/startup/start-ssh.sh"]
