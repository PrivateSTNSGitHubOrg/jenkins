from jenkins/jenkins:lts-jdk11

USER root

# Update, download and install Docker-terminal and gettext-base(is used in Jenkins-file for creating new unique branch.
# RUN apt-get update && apt-get install -y docker-ce-cli gettext-base

# Install plugins for the Jenkins-machine.
RUN jenkins-plugin-cli --plugins workflow-aggregator github ws-cleanup greenballs simple-theme-plugin kubernetes docker-workflow kubernetes-cli github-branch-source

# RUN jenkins-plugin-cli --plugins "maven blueocean docker-workflow openjdk11 docker"
RUN jenkins-plugin-cli --plugins "blueocean docker-plugin:1.5 docker-workflow maven-plugin:3.23 kubernetes-cli:1.12.1"

RUN apt-get update && apt-get install -y gettext-base

# RUN -DJava.net.ssl.trustStore=$JAVA_HOME/jre/lib/security/cacerts
# RUN -DJava.net.ssl.trustStorePassword=[PASSWORD]

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
