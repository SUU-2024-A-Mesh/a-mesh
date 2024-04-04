# **A-mesh**
### Contents:
1. Introduction
2. Theoretical background and technology stack
3. Case study concept description
4. Solution architecture
5. Environment configuration description 
6. Installation method
7. How to reproduce
8. Demo deployment test
9. Summary - conclusions
10. References

### 1. Introduction
Ambient Mesh is a new Istio data plane mode that’s designed for simplified operations, broader application compatibility, and reduced infrastructure cost. Ambient mesh gives users the option to forgo sidecar proxies in favor of a mesh data plane that’s integrated into their infrastructure, all while maintaining Istio’s core features of zero-trust security, telemetry, and traffic management.

The Ambient Mesh Project offers a different approach to managing microservices, standing out as better alternative to traditional service mesh architectures by significantly reducing complexity and resource overhead. Unlike service meshes that rely on sidecar proxies, Ambient Mesh simplifies application architecture, leading to enhanced performance, improved observability, and easier operational management. This streamlined method not only cuts down on CPU and memory consumption but also accelerates service-to-service communication, making it an efficient and scalable solution for modern distributed systems.

Code documentation to the project can be found [here](https://istio.io/v1.15/blog/2022/introducing-ambient-mesh/)

### 2. Theoretical background and technology stack

**Theoretical background**

In Istio's traditional model, Envoy proxies are deployed as sidecars within the pods of workloads, resulting in double-processing of traffic and increased resource consumption:
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/3352e564-9c7d-4fb9-8519-5a5b850bda5d)


Ambient Mesh deploys Waypoint proxies, which are connected through Z-tunnels for policy enforcement when necessary - traffic is routed through Z-tunnels for L4 processing, and when L7 processing is required, such as request routing, the mesh automatically creates Waypoint proxies and redirects traffic accordingly. Each Node in the mesh utilizes a single Z-tunnel process for all its Pods. Adding new Pods to mesh does not require changes in their manifests.
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/17a9fccc-02ed-40a0-a2f8-52dc980f04e6)


**Technology stack**
- Amazon EKS
- Kubernetes
- Istio Ambient Mesh
- Istio Service Mesh
- Python REST API
- Knative (?)

### 3. Case study concept description

The primary goal of this project is to conduct a comprehensive analysis focusing on the resource utilization and response time metrics of a REST API implemented using the Python. This API will be deployed both in Service Mesh and Ambient Mesh environments, allowing for a detailed comparison of their respective performance characteristics and efficiencies.

### 4. Solution architecture
### 5. Environment configuration description 
### 6. Installation method
### 7. How to reproduce
### 8. Demo deployment test
### 9. Summary - conclusions
### 10. References
