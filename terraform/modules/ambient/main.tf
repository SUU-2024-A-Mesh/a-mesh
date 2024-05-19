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

  set {
    name = "profile"
    value = "ambient"
  }
  
  depends_on = [ helm_release.istio_base ]
}

resource "helm_release" "istiod" {
  name = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"
  namespace = "istio-system"

  wait = true

  set {
    name = "profile"
    value = "ambient"
  }

  depends_on = [ helm_release.istio_cni ]
}

resource "helm_release" "ztunnel" {
  name = "ztunnel"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "ztunnel"
  namespace = "istio-system"

  wait = true

  depends_on = [ helm_release.istiod ]
}

resource "kubernetes_labels" "namespace_default_labels" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  
  labels = {
    "istio.io/dataplane-mode" = "ambient"
  }
  
  depends_on = [ helm_release.ztunnel ]
}