FROM gitpod/workspace-base

USER root

# Needed for the experimental network mode (to support Tailscale)
RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.12/slirp4netns-$(uname -m) \
    && chmod +x /usr/bin/slirp4netns

RUN . /etc/os-release \
    && echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | apt-key add - \
    && apt-get install --reinstall ca-certificates \
    && mkdir /usr/local/share/ca-certificates/cacert.org \
    && wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt \
    && update-ca-certificates \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install podman

RUN cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
    && sed -i '/^# cgroup_manager = "systemd"/ a cgroup_manager = "cgroupfs"' /etc/containers/containers.conf \
    # && sed -i '/^# events_logger = "journald"/ a events_logger = "file"' /etc/containers/containers.conf \
    && sed -i '/^driver = "overlay"/ c\driver = "vfs"' /etc/containers/storage.conf \
    && echo podman:10000:5000 > /etc/subuid \
    && echo podman:10000:5000 > /etc/subgid

# Install user environment
CMD /bin/bash -l
USER gitpod
ENV USER gitpod
WORKDIR /home/gitpod

