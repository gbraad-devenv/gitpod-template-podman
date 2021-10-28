FROM gitpod/workspace-base

USER root

# Needed for the experimental network mode (to support Tailscale)
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN apt-get install -y podman

# Install user environment
CMD /bin/bash -l
USER gitpod
ENV USER gitpod
WORKDIR /home/gitpod
