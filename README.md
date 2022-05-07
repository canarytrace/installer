# Canarytrace installer
> Installer prepares Elasticsearch and Kibana for interpretation data from Canarytrace.
> Contains `mappings` for Elasticsearch indices and `index-patterns`, `visualizations`, `dashboards` and `searches` for Kibana.

- Compatible with Elasticsearch and Kibana 7.x and 8.x
- You can use this installer or import objects manually.
- Supported versions https://github.com/canarytrace/installer/tree/master/elasticObjects
- Ready for Canarytrace Pro, Canarytrace for DevOps and Listener
- Ready for local use
- Ready for use on elastic.co
- Installer automatically detect version of your Elasticsearch start the installation.

## Example with Elasticsearch and Kibana on localhost

1). Create a user-defined bridges canarytrace
```
docker network create canary
```

2). Run dockerized Elasticsearch
```
docker run --name elasticsearch --net canary --rm -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_SETTING_XPACK_SECURITY_ENABLED=false -e ES_SETTING_ACTION_DESTRUCTIVE__REQUIRES__NAME=false docker.elastic.co/elasticsearch/elasticsearch:8.2.0 bin/elasticsearch -Enetwork.host=0.0.0.0

```

3). Run dockerized Kibana 
```
docker run --name kibana --net canary --rm -d -p 5601:5601 docker.elastic.co/kibana/kibana:8.2.0
```
and wait until the Kibana is started http://localhost:5601

4). Run Canarytrace installer
```
docker run --name installer --net canary --rm quay.io/canarytrace/installer:1.0
```

**Always use the latest docker images**
> Quay.io repository https://quay.io/repository/canarytrace/installer?tab=tags

## Configuration
> Change Elasticsearch endpoint

```
docker run --name installer --net canary --rm -e ELASTIC_ENDPOINT=http://localhost quay.io/canarytrace/installer:7.3
```

**Available configuration / Environment variables**

- `-e ELASTIC_ENDPOINT=http://localhost` for local installation of Elasticsearch or `elasticsearch` if you use `--net canary` bridge or `https://1234.eu-central-1.aws.cloud.es.io` if you use elastic.co
- `-e ELASTIC_PORTT=9200` this is a default REST-API port of Elasticsearch
- `-e ELASTIC_INDEX_PREFIX=c` default is `c`, e.g. index `c.report-*`
- `-e ELASTIC_USER=elastic`
- `-e ELASTIC_PASS=12345`
- `-e KIBANA_ENDPOINT=http://localhost` for local installation of Elasticsearch or `kibana` if you use `--net canary` bridge or `https://1234.eu-central-1.aws.
- `-e KIBANA_PORT=5601`
- `-e KIBANA_USER=elastic`
- `-e KIBANA_PASS=@josePh8`

## Example with Docker Compose

1). Open `docker-compose.yml` and set correct credentials and endpoints your Elasticsearch deployment

2). Run `docker-compose up`

## Successfully output

```bash
# docker run --name installer --net canary --rm quay.io/canarytrace/installer:1.0

Canarytrace installer
=====================

Documentation: https://canarytrace.com/docs/
Discussions: https://github.com/canarytrace/documentation/discussions

Steps
=====

1). Check environment variables
2). Check version of Elasticsearch
3). Install index patterns to your elasticsearch cluster
4). Install visualizations to your kibana
5). Install dashboards to your kibana

Available Elasticsearch objects
===============================
7.17.3
8.2.0

Parameters
==========

ELASTIC_ENDPOINT     | elasticsearch
ELASTIC_PORT         | 9200
ELASTIC_INDEX_PREFIX | c.
ELASTIC_USER         | 
ELASTIC_PASS         | 
KIBANA_ENDPOINT      | kibana
KIBANA_PORT          | 5601
KIBANA_USER          | 
KIBANA_PASS          | 

Elasticsearch availability check
================================

waiting .
Elasticsearch elasticsearch:9200 is available.

Check Elasticsearch version
===========================
8.2.0
We will install settings for version  8.2.0


newman

Canarytrace_elastic8.2.0

→ report
  PUT elasticsearch:9200/_template/c.report [200 OK, 325B, 564ms]
  ✓  Verify response body | acknowledged
  ✓  Verify response code | 200

→ request-log
  PUT elasticsearch:9200/_template/c.request-log [200 OK, 325B, 45ms]
  ✓  Verify response body | acknowledged
  ✓  Verify response code | 200

→ performance-entries
  PUT elasticsearch:9200/_template/c.performance-entries [200 OK, 325B, 34ms]
  ✓  Verify response body | acknowledged
  ✓  Verify response code | 200

→ coverage-audit
  PUT elasticsearch:9200/_template/c.coverage-audit [200 OK, 325B, 41ms]
  ✓  Verify response body | acknowledged
  ✓  Verify response code | 200

→ Kibana upload index patterns
  POST kibana:5601/api/saved_objects/_import?overwrite=true [200 OK, 2.14kB, 546ms]
  ✓  Verify response body | success
  ✓  Verify response code | 200

→ Kibana upload visualizations
  POST kibana:5601/api/saved_objects/_import?overwrite=true [200 OK, 8.61kB, 777ms]
  ✓  Verify response body | success
  ✓  Verify response code | 200

→ Kibana upload dashboards
  POST kibana:5601/api/saved_objects/_import?overwrite=true [200 OK, 1.23kB, 763ms]
  ✓  Verify response body | success
  ✓  Verify response code | 200

→ Kibana upload search
  POST kibana:5601/api/saved_objects/_import?overwrite=true [200 OK, 636B, 799ms]
  ✓  Verify response body | success
  ✓  Verify response code | 200

┌─────────────────────────┬────────────────────┬────────────────────┐
│                         │           executed │             failed │
├─────────────────────────┼────────────────────┼────────────────────┤
│              iterations │                  1 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│                requests │                  8 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│            test-scripts │                 16 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│      prerequest-scripts │                  8 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│              assertions │                 16 │                  0 │
├─────────────────────────┴────────────────────┴────────────────────┤
│ total run duration: 6.1s                                          │
├───────────────────────────────────────────────────────────────────┤
│ total data received: 11.02kB (approx)                             │
├───────────────────────────────────────────────────────────────────┤
│ average response time: 446ms [min: 34ms, max: 799ms, s.d.: 326ms] │
└───────────────────────────────────────────────────────────────────┘
```