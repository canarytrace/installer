# Canarytrace installator

### DigitalOcean

### Elasticsearch & Kibana

1). Change part of local URI in exportet postman collection on `/etc/postman`

2). Run `./install.sh`

### Kubernetes via Terraform
> /digitalocean/k8s.tf

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