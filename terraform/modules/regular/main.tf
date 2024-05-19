resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "base"
  namespace = "istio-system"

  wait = true

  set {
    name = "defaultRevision"
    value = "default"
  }

  depends_on = [ kubernetes_namespace_v1.istio_system ]
}

resource "helm_release" "istio_cni" {
  name = "istio-cni"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "cni"
  namespace = "kube-system"

  wait = true
  
  depends_on = [ helm_release.istio_base ]
}

resource "helm_release" "istiod" {
  name = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"
  namespace = "istio-system"

  wait = true

  set {
    name = "istio_cni.enabled"
    value = "true"
  }

  depends_on = [ helm_release.istio_cni ]
}

resource "kubernetes_labels" "namespace_default_labels" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    "istio-injection" = "enabled"
  }

  depends_on = [ helm_release.istiod ]
}