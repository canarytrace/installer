FROM postman/newman:5-alpine

COPY ./elasticObjects/ /etc/postman
COPY hello.sh /opt/
RUN chmod a+x /opt/hello.sh && \
    apk --no-cache add curl

ENTRYPOINT ["/opt/hello.sh"]