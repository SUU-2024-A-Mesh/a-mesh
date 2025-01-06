import os
import csv
import time
import argparse
from kubernetes import client, config


def fetch_metrics():
    """Fetch node metrics using the Kubernetes API."""
    api = client.CustomObjectsApi()
    metrics = api.list_cluster_custom_object("metrics.k8s.io", "v1beta1", "nodes")
    result = []
    for node in metrics['items']:
        name = node['metadata']['name']
        cpu_usage = node['usage']['cpu']
        memory_usage = node['usage']['memory']
        result.append([name, cpu_usage, memory_usage])
    return result


def write_csv(metrics, output_file):
    """Write metrics to a CSV file."""
    with open(output_file, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["Node", "CPU Usage", "Memory Usage"])
        writer.writerows(metrics)


def main(interval, output_dir):
    config.load_incluster_config()  # Load Kubernetes cluster config
    output_file = os.path.join(output_dir, "metrics.csv")
    while True:
        try:
            metrics = fetch_metrics()
            write_csv(metrics, output_file)
            print(f"Metrics written to {output_file}")
        except Exception as e:
            print(f"Error fetching or writing metrics: {e}")
        time.sleep(interval)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dump Kubernetes node metrics to CSV.")
    parser.add_argument("--interval", type=int, default=60, help="Interval between dumps (seconds).")
    parser.add_argument("--output-dir", type=str, default="/data", help="Directory for CSV output.")
    args = parser.parse_args()
    main(args.interval, args.output_dir)
