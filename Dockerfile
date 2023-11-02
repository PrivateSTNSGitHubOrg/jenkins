ARG BOOKWORM_TAG=20231030
ARG JAVA_VERSION=21_35
FROM jenkins/jenkins

USER root

RUN jenkins-plugin-cli --plugins workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source

# RUN jenkins-plugin-cli --plugins "maven blueocean docker-workflow openjdk11 docker"
RUN jenkins-plugin-cli --plugins "blueocean docker-plugin:1.5 docker-workflow maven-plugin:3.23 kubernetes-cli:1.12.1"

RUN apt-get update
RUN apt-get install maven gettext-base -y

RUN apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/docker.gpg
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker-ce.list
RUN apt update
RUN apt install docker-ce docker-ce-cli containerd.io -y


RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


