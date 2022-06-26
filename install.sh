#!/bin/sh

clear

echo
echo "Canarytrace installer"
echo "====================="
echo
echo "Documentation: https://canarytrace.com/docs/"
echo "Discussions: https://github.com/canarytrace/documentation/discussions"
echo
echo "Steps"
echo "====="
echo
echo "1). Check environment variables"
echo "2). Check version of Elasticsearch"
echo "3). Install index patterns to your elasticsearch cluster"
echo "4). Install visualizations to your kibana"
echo "5). Install dashboards to your kibana"
echo
echo "Available Elasticsearch objects"
echo "==============================="
ls /etc/postman
echo

if [[ -z "${ELASTIC_ENDPOINT}" ]]; then
    export ELASTIC_ENDPOINT=elasticsearch
fi
if [[ -z "${ELASTIC_PORT}" ]]; then
    export ELASTIC_PORT=
fi
if [[ -z "${ELASTIC_INDEX_PREFIX}" ]]; then
    export ELASTIC_INDEX_PREFIX=c.
fi
if [[ -z "${KIBANA_ENDPOINT}" ]]; then
    export KIBANA_ENDPOINT=kibana
fi
if [[ -z "${KIBANA_PORT}" ]]; then
    export KIBANA_PORT=
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

for y in `seq 1 15`;
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

echo
echo "Check Elasticsearch version"
echo "==========================="
ELASTIC_VERSION=$(curl -s -u ${ELASTIC_USER}:${ELASTIC_PASS} -X GET ${ELASTIC_ENDPOINT}:${ELASTIC_PORT} | jq -r ".version.number")
echo $ELASTIC_VERSION


run_installation () {
    newman run \
    "/etc/postman/${ELASTIC_VERSION}/Canarytrace_elastic${ELASTIC_VERSION}.postman_collection.json" \
    --env-var "elastic.endpoint=${ELASTIC_ENDPOINT}" \
    --env-var "elastic.port=${ELASTIC_PORT}" \
    --env-var "elastic.index.prefix=${ELASTIC_INDEX_PREFIX}" \
    --env-var "elastic.user=${ELASTIC_USER}" \
    --env-var "elastic.pass=${ELASTIC_PASS}" \
    --env-var "kibana.endpoint=${KIBANA_ENDPOINT}" \
    --env-var "kibana.port=${KIBANA_PORT}" \
    --env-var "kibana.user=${KIBANA_USER}" \
    --env-var "kibana.pass=${KIBANA_PASS}"
}


if [ "${ELASTIC_VERSION:0:1}" -eq 7 ] ; 
then
    VERSION="7.17.3"
    echo "We will install settings for version " $VERSION
    echo
    echo
    run_installation
elif [ "${ELASTIC_VERSION:0:1}" -eq 8 ] ;
then
    VERSION="8.2.0"
    echo "We will install settings for version " $VERSION
    echo
    echo
    run_installation
else
  echo "⭕ Sorry, but we don't currently support your version" $ELASTIC_VERSION
  echo "You can download Elasticsearch objects and import them manually via Postman."
  echo "Documentation https://canarytrace.com/docs/features/installer"
  echo
  echo
  exit 1
fi