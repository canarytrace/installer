#!/bin/bash

docker run -v $(pwd)/elasticObjects/:/etc/postman \
--net canary --rm postman/newman:5-alpine run \
"/etc/postman/Canarytrace_elastic7.x.postman_collection.json" \
--env-var "elastic.endpoint=XXX" \
--env-var "elastic.port=9243" \
--env-var "elastic.index.prefix=c" \
--env-var "elastic.user=elastic" \
--env-var "elastic.pass=XXX" \
--env-var "kibana.protocol=https" \
--env-var "kibana.endpoint=XXX" \
--env-var "kibana.port=9243" \
--env-var "kibana.user=elastic" \
--env-var "kibana.pass=XXX"