#!/bin/sh

clear

echo
echo "Canarytrace installer"
echo "====================="
echo
echo "Documentation: https://canarytrace.atlassian.net/l/c/txdgcAjd"
echo
echo "Steps"
echo "====="
echo
echo "1). Check environment variables"
echo "2). Install index patterns to your elasticsearch cluster"
echo "3). Install visualizations to your kibana"
echo "4). Install dashboards to your kibana"
echo

if [[ -z "${ELASTIC_ENDPOINT}" ]]; then
    export ELASTIC_ENDPOINT=elasticsearch
fi
if [[ -z "${ELASTIC_PORT}" ]]; then
    export ELASTIC_PORT=9200
fi
if [[ -z "${ELASTIC_INDEX_PREFIX}" ]]; then
    export ELASTIC_INDEX_PREFIX=c.
fi
if [[ -z "${KIBANA_ENDPOINT}" ]]; then
    export KIBANA_ENDPOINT=kibana
fi
if [[ -z "${KIBANA_PORT}" ]]; then
    export KIBANA_PORT=5601
fi
echo "Parameters"
echo "=========="
echo
echo "ELASTIC_ENDPOINT     | ${ELASTIC_ENDPOINT}"
echo "ELASTIC_PORT         | ${ELASTIC_PORT}"
echo "ELASTIC_INDEX_PREFIX | ${ELASTIC_INDEX_PREFIX}"
echo "ELASTIC_USER         | ${ELASTIC_USER}"
echo "ELASTIC_PASS         | ${ELASTIC_PASS}"
echo "KIBANA_ENDPOINT      | ${KIBANA_ENDPOINT}"
echo "KIBANA_PORT          | ${KIBANA_PORT}"
echo "KIBANA_USER          | ${KIBANA_USER}"
echo "KIBANA_PASS          | ${KIBANA_PASS}"

echo
echo "Elasticsearch availability check"
echo "================================"
echo
printf "waiting "

for y in `seq 1 5`;
do
    printf "."
    IS_ELASTIC_LIVE=$(curl -u ${ELASTIC_USER}:${ELASTIC_PASS} -I -X GET ${ELASTIC_ENDPOINT}:${ELASTIC_PORT}/ 2>/dev/null | head -n 1 | cut -d$' ' -f2)
    if [ "$IS_ELASTIC_LIVE" = 200 ] ; then
        echo
        echo "Elasticsearch ${ELASTIC_ENDPOINT}:${ELASTIC_PORT} is available."
        sleep 1
        break
    fi
    sleep 1
done

if [ "$IS_ELASTIC_LIVE" != 200 ] ; then
    echo
    echo "Sorry, your Elasticsearch ${ELASTIC_ENDPOINT}:${ELASTIC_PORT} isn't available."
    exit 1
fi

newman run \
"/etc/postman/Canarytrace_elastic7.x.postman_collection.json" \
--env-var "elastic.endpoint=${ELASTIC_ENDPOINT}" \
--env-var "elastic.port=${ELASTIC_PORT}" \
--env-var "elastic.index.prefix=${ELASTIC_INDEX_PREFIX}" \
--env-var "elastic.user=${ELASTIC_USER}" \
--env-var "elastic.pass=${ELASTIC_PASS}" \
--env-var "kibana.endpoint=${KIBANA_ENDPOINT}" \
--env-var "kibana.port=${KIBANA_PORT}" \
--env-var "kibana.user=${KIBANA_USER}" \
--env-var "kibana.pass=${KIBANA_PASS}"
