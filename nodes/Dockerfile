FROM adoptopenjdk/openjdk11:alpine

ARG VERSION=4.3
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG SFDX_URL=https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
ARG SFDX_INSTALLER=sfdx-linux-amd64.tar.xz

RUN addgroup -g ${gid} ${group}
RUN adduser -h /home/${user} -u ${uid} -G ${group} -D ${user}



ARG AGENT_WORKDIR=/home/${user}/agent

RUN apk add --update --no-cache curl bash git git-lfs openssh-client openssl procps \
  && curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar \
  && mkdir sfdx \
  && wget $SFDX_URL \
  && tar xJf $SFDX_INSTALLER -C sfdx --strip-components 1 \
  && ./sfdx/install \
  && rm -r sfdx \
  && apk del curl

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}
