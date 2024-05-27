resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "istio-system"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }
}

resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "istio-system"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }

  data = {
    "alerting_rules.yml" = "{}\n"

    alerts = "{}\n"

    allow-snippet-annotations = "false"

    "prometheus.yml" = "global:\n  evaluation_interval: 1m\n  scrape_interval: 15s\n  scrape_timeout: 10s\nrule_files:\n- /etc/config/recording_rules.yml\n- /etc/config/alerting_rules.yml\n- /etc/config/rules\n- /etc/config/alerts\nscrape_configs:\n- job_name: prometheus\n  static_configs:\n  - targets:\n    - localhost:9090\n- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n  job_name: kubernetes-apiservers\n  kubernetes_sd_configs:\n  - role: endpoints\n  relabel_configs:\n  - action: keep\n    regex: default;kubernetes;https\n    source_labels:\n    - __meta_kubernetes_namespace\n    - __meta_kubernetes_service_name\n    - __meta_kubernetes_endpoint_port_name\n  scheme: https\n  tls_config:\n    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    insecure_skip_verify: true\n- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n  job_name: kubernetes-nodes\n  kubernetes_sd_configs:\n  - role: node\n  relabel_configs:\n  - action: labelmap\n    regex: __meta_kubernetes_node_label_(.+)\n  - replacement: kubernetes.default.svc:443\n    target_label: __address__\n  - regex: (.+)\n    replacement: /api/v1/nodes/$1/proxy/metrics\n    source_labels:\n    - __meta_kubernetes_node_name\n    target_label: __metrics_path__\n  scheme: https\n  tls_config:\n    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    insecure_skip_verify: true\n- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n  job_name: kubernetes-nodes-cadvisor\n  kubernetes_sd_configs:\n  - role: node\n  relabel_configs:\n  - action: labelmap\n    regex: __meta_kubernetes_node_label_(.+)\n  - replacement: kubernetes.default.svc:443\n    target_label: __address__\n  - regex: (.+)\n    replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor\n    source_labels:\n    - __meta_kubernetes_node_name\n    target_label: __metrics_path__\n  scheme: https\n  tls_config:\n    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n    insecure_skip_verify: true\n- honor_labels: true\n  job_name: kubernetes-service-endpoints\n  kubernetes_sd_configs:\n  - role: endpoints\n  relabel_configs:\n  - action: keep\n    regex: true\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_scrape\n  - action: drop\n    regex: true\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow\n  - action: replace\n    regex: (https?)\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_scheme\n    target_label: __scheme__\n  - action: replace\n    regex: (.+)\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_path\n    target_label: __metrics_path__\n  - action: replace\n    regex: (.+?)(?::\\d+)?;(\\d+)\n    replacement: $1:$2\n    source_labels:\n    - __address__\n    - __meta_kubernetes_service_annotation_prometheus_io_port\n    target_label: __address__\n  - action: labelmap\n    regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)\n    replacement: __param_$1\n  - action: labelmap\n    regex: __meta_kubernetes_service_label_(.+)\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_namespace\n    target_label: namespace\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_service_name\n    target_label: service\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_node_name\n    target_label: node\n- honor_labels: true\n  job_name: kubernetes-service-endpoints-slow\n  kubernetes_sd_configs:\n  - role: endpoints\n  relabel_configs:\n  - action: keep\n    regex: true\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow\n  - action: replace\n    regex: (https?)\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_scheme\n    target_label: __scheme__\n  - action: replace\n    regex: (.+)\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_path\n    target_label: __metrics_path__\n  - action: replace\n    regex: (.+?)(?::\\d+)?;(\\d+)\n    replacement: $1:$2\n    source_labels:\n    - __address__\n    - __meta_kubernetes_service_annotation_prometheus_io_port\n    target_label: __address__\n  - action: labelmap\n    regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)\n    replacement: __param_$1\n  - action: labelmap\n    regex: __meta_kubernetes_service_label_(.+)\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_namespace\n    target_label: namespace\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_service_name\n    target_label: service\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_node_name\n    target_label: node\n  scrape_interval: 5m\n  scrape_timeout: 30s\n- honor_labels: true\n  job_name: prometheus-pushgateway\n  kubernetes_sd_configs:\n  - role: service\n  relabel_configs:\n  - action: keep\n    regex: pushgateway\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_probe\n- honor_labels: true\n  job_name: kubernetes-services\n  kubernetes_sd_configs:\n  - role: service\n  metrics_path: /probe\n  params:\n    module:\n    - http_2xx\n  relabel_configs:\n  - action: keep\n    regex: true\n    source_labels:\n    - __meta_kubernetes_service_annotation_prometheus_io_probe\n  - source_labels:\n    - __address__\n    target_label: __param_target\n  - replacement: blackbox\n    target_label: __address__\n  - source_labels:\n    - __param_target\n    target_label: instance\n  - action: labelmap\n    regex: __meta_kubernetes_service_label_(.+)\n  - source_labels:\n    - __meta_kubernetes_namespace\n    target_label: namespace\n  - source_labels:\n    - __meta_kubernetes_service_name\n    target_label: service\n- honor_labels: true\n  job_name: kubernetes-pods\n  kubernetes_sd_configs:\n  - role: pod\n  relabel_configs:\n  - action: keep\n    regex: true\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_scrape\n  - action: drop\n    regex: true\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow\n  - action: replace\n    regex: (https?)\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_scheme\n    target_label: __scheme__\n  - action: replace\n    regex: (.+)\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_path\n    target_label: __metrics_path__\n  - action: replace\n    regex: (\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})\n    replacement: '[$2]:$1'\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_port\n    - __meta_kubernetes_pod_ip\n    target_label: __address__\n  - action: replace\n    regex: (\\d+);((([0-9]+?)(\\.|$)){4})\n    replacement: $2:$1\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_port\n    - __meta_kubernetes_pod_ip\n    target_label: __address__\n  - action: labelmap\n    regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)\n    replacement: __param_$1\n  - action: labelmap\n    regex: __meta_kubernetes_pod_label_(.+)\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_namespace\n    target_label: namespace\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_name\n    target_label: pod\n  - action: drop\n    regex: Pending|Succeeded|Failed|Completed\n    source_labels:\n    - __meta_kubernetes_pod_phase\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_node_name\n    target_label: node\n- honor_labels: true\n  job_name: kubernetes-pods-slow\n  kubernetes_sd_configs:\n  - role: pod\n  relabel_configs:\n  - action: keep\n    regex: true\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow\n  - action: replace\n    regex: (https?)\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_scheme\n    target_label: __scheme__\n  - action: replace\n    regex: (.+)\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_path\n    target_label: __metrics_path__\n  - action: replace\n    regex: (\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})\n    replacement: '[$2]:$1'\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_port\n    - __meta_kubernetes_pod_ip\n    target_label: __address__\n  - action: replace\n    regex: (\\d+);((([0-9]+?)(\\.|$)){4})\n    replacement: $2:$1\n    source_labels:\n    - __meta_kubernetes_pod_annotation_prometheus_io_port\n    - __meta_kubernetes_pod_ip\n    target_label: __address__\n  - action: labelmap\n    regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)\n    replacement: __param_$1\n  - action: labelmap\n    regex: __meta_kubernetes_pod_label_(.+)\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_namespace\n    target_label: namespace\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_name\n    target_label: pod\n  - action: drop\n    regex: Pending|Succeeded|Failed|Completed\n    source_labels:\n    - __meta_kubernetes_pod_phase\n  - action: replace\n    source_labels:\n    - __meta_kubernetes_pod_node_name\n    target_label: node\n  scrape_interval: 5m\n  scrape_timeout: 30s\n"

    "recording_rules.yml" = "{}\n"

    rules = "{}\n"
  }
}

resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "ingresses", "configmaps"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses/status", "ingresses"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus" {
  metadata {
    name = "prometheus"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "prometheus"
    namespace = "istio-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "prometheus"
  }
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "istio-system"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 9090
      target_port = "9090"
    }

    selector = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/name" = "prometheus"
    }

    type             = "ClusterIP"
    session_affinity = "None"
  }
}

resource "kubernetes_deployment" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "istio-system"

    labels = {
      "app.kubernetes.io/component" = "server"

      "app.kubernetes.io/instance" = "prometheus"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "prometheus"

      "app.kubernetes.io/part-of" = "prometheus"

      "app.kubernetes.io/version" = "v2.51.1"

      "helm.sh/chart" = "prometheus-25.19.1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "server"

        "app.kubernetes.io/instance" = "prometheus"

        "app.kubernetes.io/name" = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "server"

          "app.kubernetes.io/instance" = "prometheus"

          "app.kubernetes.io/managed-by" = "Helm"

          "app.kubernetes.io/name" = "prometheus"

          "app.kubernetes.io/part-of" = "prometheus"

          "app.kubernetes.io/version" = "v2.51.1"

          "helm.sh/chart" = "prometheus-25.19.1"

          "sidecar.istio.io/inject" = "false"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "prometheus"
          }
        }

        volume {
          name      = "storage-volume"
          empty_dir {}
        }

        container {
          name  = "prometheus-server-configmap-reload"
          image = "ghcr.io/prometheus-operator/prometheus-config-reloader:v0.72.0"
          args  = ["--watched-dir=/etc/config", "--reload-url=http://127.0.0.1:9090/-/reload"]

          volume_mount {
            name       = "config-volume"
            read_only  = true
            mount_path = "/etc/config"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "prometheus-server"
          image = "prom/prometheus:v2.51.1"
          args  = ["--storage.tsdb.retention.time=15d", "--config.file=/etc/config/prometheus.yml", "--storage.tsdb.path=/data", "--web.console.libraries=/etc/prometheus/console_libraries", "--web.console.templates=/etc/prometheus/consoles", "--web.enable-lifecycle"]

          port {
            container_port = 9090
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "storage-volume"
            mount_path = "/data"
          }

          liveness_probe {
            http_get {
              path   = "/-/healthy"
              port   = "9090"
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 10
            period_seconds        = 15
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/-/ready"
              port   = "9090"
              scheme = "HTTP"
            }

            timeout_seconds   = 4
            period_seconds    = 5
            success_threshold = 1
            failure_threshold = 3
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 300
        dns_policy                       = "ClusterFirst"
        service_account_name             = "prometheus"
        enable_service_links             = true
      }
    }

    strategy {
      type = "Recreate"
    }

    revision_history_limit = 10
  }
}

