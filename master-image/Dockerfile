FROM jenkins/jenkins

ARG DOCKER_GPG=https://download.docker.com/linux/debian/gpg
ARG DOCKER_DEBIAN=https://download.docker.com/linux/debian

User root
# copy jenkins plugins file with all required plugins
COPY plugins/plugins.txt /usr/share/jenkins/plugins.txt

# install plugins, docker and remove unecessary files
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    && curl -fsSL $DOCKER_GPG | apt-key add - \
    && add-apt-repository \
       "deb [arch=amd64] $DOCKER_DEBIAN \
       $(lsb_release -cs) \
       stable" \
    && apt-get update \
    && apt-get -y install docker-ce docker-ce-cli containerd.io \
    && /usr/local/bin/install-plugins.sh < usr/share/jenkins/plugins.txt \
    && apt-get clean

# to run container without docker compose or volume mapping
# uncomment following statements to copy required config files to container
# copy configurations for sfdx org authentication
# COPY configs/ /etc/configs/auth

# switch to jenkins user
USER jenkins

# set jenkins environment variables for jenkins
# do not run awt
ENV JAVA_OPTS="-Djava.awt.headless=true"
# do not run intial setup wizard
# WARNING: when below option enabled then setup users using config files
#ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
