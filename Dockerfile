FROM python:3.6-slim

ARG build_date=unspecified

# workspace location
ARG WORKSPACE
ENV WORKSPACE ${WORKSPACE:-/ansible}

LABEL org.opencontainers.image.title="mdd-container" \
      org.opencontainers.image.description="Model-Driven-DevOps" \
      org.opencontainers.image.vendor="Cisco Systems" \
      org.opencontainers.image.created="${build_date}" \
      org.opencontainers.image.url="https://github.com/model-driven-devops" \
      org.opencontainers.image.source="https://github.com/model-driven-devops/mdd-container" \
      org.opencontainers.image.created="${build_date}"

COPY requirements.txt /tmp/requirements.txt
COPY requirements.yml /tmp/requirements.yml
RUN apt-get update && \
    apt-get install -y --no-install-recommends iputils-ping telnet openssh-client curl build-essential sshpass && \
    pip3 install --upgrade --no-cache-dir setuptools pip && \
    echo "===> Installing PIP Requirements <==="  && \
    pip3 install --no-cache -r /tmp/requirements.txt && \
    echo "===> Installing Ansible Collections <===" && \
    ansible-galaxy collection install -r /tmp/requirements.yml && \
    apt-get remove -y curl build-essential && \
    apt-get autoremove -y && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

WORKDIR ${WORKSPACE}
