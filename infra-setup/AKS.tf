data "azurerm_kubernetes_cluster" "k8s" {
  name                = azurecaf_name.AKS.result
  resource_group_name = azurecaf_name.resource_group.result
  depends_on          = [azurerm_kubernetes_cluster.k8s]
}

resource "azurecaf_name" "AKS" {
  name          = var.base_name
  resource_type = "azurerm_kubernetes_cluster"
  suffixes      = ["prod", "north-europe"]
  clean_input   = true
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                      = azurecaf_name.AKS.result
  location                  = var.azure_location
  resource_group_name       = azurecaf_name.resource_group.result
  dns_prefix                = "${azurecaf_name.AKS.result}-dns"
  kubernetes_version        = "1.32"
  automatic_upgrade_channel = "stable"
  node_resource_group       = "${azurecaf_name.resource_group.result}-nodepool"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v6"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  depends_on = [azurerm_resource_group.webapp]
}

provider "helm" {
  kubernetes = {
    host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.0.4"
  create_namespace = true
  namespace        = "argocd"

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    }
  ]
}