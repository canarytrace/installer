resource "digitalocean_kubernetes_cluster" "canarytrace" {

  name     = "canarytrace-k8s"
  region   = "fra1"
  version = "1.18.8-do.1"
  node_pool {
    name       = "canarypool"
    size       = "s-4vcpu-8gb"
    node_count = 1
  }
  tags    = ["canarytrace"]

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save canarytrace-k8s"
  }
}
