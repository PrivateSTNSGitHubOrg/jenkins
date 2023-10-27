from jenkins/jenkins

USER root

# Update system and install Maven.
RUN apt-get update && apt-get install -y lsb-release maven

# Download Docker-application and install.
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update, download and install Docker-terminal and gettext-base(is used in Jenkins-file for creating new unique branch.
RUN apt-get update && apt-get install -y docker-ce-cli gettext-base

# Install plugins for the Jenkins-machine.
RUN jenkins-plugin-cli --plugins workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source

# RUN jenkins-plugin-cli --plugins "maven blueocean docker-workflow openjdk11 docker"
RUN jenkins-plugin-cli --plugins "blueocean docker-plugin:1.5 docker-workflow adoptopenjdk:1.5 maven-plugin:3.23"

# Download and install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN chmod +x kubectl
RUN mkdir -p ~/.local/bin
RUN mv ./kubectl ~/.local/bin/kubectl


# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
