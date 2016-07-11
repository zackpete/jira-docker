FROM frolvlad/alpine-oraclejdk8

ENV RUN_USER daemon
ENV RUN_GROUP daemon

ENV JIRA_VERSION             7.1.9
ENV JIRA_HOME                /var/atlassian/application-data/jira
ENV JIRA_INSTALL_DIR         /opt/atlassian/jira
ENV JIRA_URL                 https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz

RUN apk add --update bash curl tar \
    && mkdir -p ${JIRA_INSTALL_DIR} \
    && curl -L ${JIRA_URL} | tar -xz --strip=1 -C "$JIRA_INSTALL_DIR" \
    && mkdir -p "${JIRA_INSTALL_DIR}/conf/Catalina" \
    && chmod -R 700 "${JIRA_INSTALL_DIR}/conf/Catalina" \
    && chmod -R 700 "${JIRA_INSTALL_DIR}/logs" \
    && chmod -R 700 "${JIRA_INSTALL_DIR}/temp" \
    && chmod -R 700 "${JIRA_INSTALL_DIR}/work" \
    && chown -R ${RUN_USER}:${RUN_GROUP} "${JIRA_INSTALL_DIR}/" \
    && apk del curl tar \
    && rm -fr /var/cache/apk/*

USER ${RUN_USER}:${RUN_GROUP}
CMD "${JIRA_INSTALL_DIR}/bin/start-jira.sh" -fg
