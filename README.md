# Canarytrace installer
> This installer prepare Elasticsearch and Kibana for Canarytrace use

- For Elasticsearch and Kibana 7.x
- Dockerized - the docker image tag corresponds to the version of the Elasticsearch for which it is intended 
- Install index patterns
- Install visualizations
- Install dashboards
- Ready for Canarytrace edition smoke, developer and professional
- Ready for local use
- Ready for use on elastic.co

## Example with Elasticsearch and Kibana on localhost

1). Create a user-defined bridges canarytrace
```
docker network create canary
```

2). Run dockerized Elasticsearch
```
docker run --name elasticsearch --net canary --rm -d -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.8.1 bin/elasticsearch -Enetwork.host=0.0.0.0
```

3). Run dockerized Kibana 
```
docker run --name kibana --net canary --rm -d -p 5601:5601 docker.elastic.co/kibana/kibana:7.8.1
```

4). Run Canarytrace installer
```
docker run --name installer --net canary --rm quay.io/canarytrace/installer:7.0
```

**Always use the latest docker images**
> Quay.io repository https://quay.io/repository/canarytrace/installer?tab=tags

## Configuration
> Change Elasticsearch endpoint

```
docker run --name installer --net canary --rm -e ELASTIC_ENDPOINT=http://localhost quay.io/canarytrace/installer:7.0
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

## Example with docker-compose and elastic.co
> docker-compose contains configuration for prepare Elasticsearch and Kibana on elastic.

1). Open `docker-compose.yml` and set correct credentials and endpoints your Elasticsearch deployment on [elastic.co](elastic.co)

2). Run `docker-compose up`


## Build custom docker image

### Prepare

1). Change part of local URI in exportet postman collection on `/etc/postman`

2). Build image `docker build -t canarytrace/installer:7.1 .`

## Build k8s on DigitalOcean via Terraform
> edit this file `/digitalocean/k8s.tf`

1). rename name of `name`

2). `terraform init`

3). `terraform apply`

# Troubleshooting

## Problem with create k8s cluster on DigitalOcean 

**Problem with authorization / 401 Unable to authenticate you**
- set correct DO token `export DIGITALOCEAN_TOKEN=token`

- DO authorization `doctl auth init -t token`

**422 validation error: invalid version slug**
- run `doctl kubernetes options versions` and verify `version` label in `/digitalocean/k8s.tf` 