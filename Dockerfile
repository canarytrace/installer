FROM postman/newman:5-alpine

COPY ./elasticObjects/ /etc/postman
COPY install.sh /opt/
RUN chmod a+x /opt/install.sh && \
    apk --no-cache add curl jq

ENTRYPOINT ["/opt/install.sh"]