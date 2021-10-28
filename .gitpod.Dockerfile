FROM gitpod/workspace-base

USER root

# Needed for the experimental network mode (to support Tailscale)
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN . /etc/os-release \
    && echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add - \
    && sudo apt-get install --reinstall ca-certificates \
    && sudo mkdir /usr/local/share/ca-certificates/cacert.org \
    && sudo wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && sudo update-ca-certificates \
    && sudo apt-get update \
    && sudo apt-get -y upgrade \
    && sudo apt-get -y install podman

# Install user environment
CMD /bin/bash -l
USER gitpod
ENV USER gitpod
WORKDIR /home/gitpod

