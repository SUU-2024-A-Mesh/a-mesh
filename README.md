# **A-mesh**
### Contents:
1. Introduction
2. Theoretical background and technology stack
3. Case study concept description
4. Solution architecture
5. Environment configuration description 
6. How to reproduce
7. Demo deployment test
8. Summary - conclusions
9. References

### 1. Introduction
Ambient Mesh is a new Istio data plane mode that’s designed for simplified operations, broader application compatibility, and reduced infrastructure cost. Ambient mesh gives users the option to forgo sidecar proxies in favor of a mesh data plane that’s integrated into their infrastructure, all while maintaining Istio’s core features of zero-trust security, telemetry, and traffic management.

The Ambient Mesh Project offers a different approach to managing microservices, standing out as better alternative to traditional service mesh architectures by significantly reducing complexity and resource overhead. Unlike service meshes that rely on sidecar proxies, Ambient Mesh simplifies application architecture, leading to enhanced performance, improved observability, and easier operational management. This streamlined method not only cuts down on CPU and memory consumption but also accelerates service-to-service communication, making it an efficient and scalable solution for modern distributed systems.

Code documentation to the project can be found [here](https://istio.io/v1.15/blog/2022/introducing-ambient-mesh/)

### 2. Theoretical background and technology stack

**Theoretical background**

In Istio's traditional model, Envoy proxies are deployed as sidecars within the pods of workloads, resulting in double-processing of traffic and increased resource consumption:
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/3352e564-9c7d-4fb9-8519-5a5b850bda5d)


Ambient Mesh deploys Waypoint proxies, which are connected through Z-tunnels for policy enforcement when necessary - traffic is routed through Z-tunnels for L4 processing, and when L7 processing is required, such as request routing, the mesh automatically creates Waypoint proxies and redirects traffic accordingly. Each Node in the mesh utilizes a single Z-tunnel process for all its Pods. Adding new Pods to mesh does not require changes in their manifests.
<!-- ![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/17a9fccc-02ed-40a0-a2f8-52dc980f04e6) -->

![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/78169141/bb2a1e1b-a30a-4931-a164-2cc2e80fa2c5)


**Technology stack**
- Amazon EKS
- Kubernetes
- Istio Ambient Mesh
- Istio Service Mesh
- GoogleCloudPlatform microservices-demo

### 3. Case study concept description

The primary goal of this project is to conduct a comprehensive analysis focusing on the resource utilization and response time metrics of an exmaple demo application. This service will be deployed both in Service Mesh and Ambient Mesh environments, allowing for a detailed comparison of their respective performance characteristics and efficiencies.

In addition to comparing resource utilization and response time metrics, we plan to measure performance, bandwidth, and startup time. These additional metrics will provide insights into the overall efficiency and scalability of the deployed environments, enabling us to make informed decisions about their suitability for different use cases and workloads.

### 4. Solution architecture

As primary goal is to analyse and compare Ambient Mesh and Service Mesh, we decided to use 3rd party test application: [GoogleCloud's Microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo) to simulate workload.

#### Architecture scheme is presented below:
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/f888a1c5-647c-4261-9ca6-7fa321ae3b9c)

Application represents online shop composed of 11 microservices comunicating using mostly grpc.

### 5. Environment configuration description

The environment consists of a set of python microservices that will generate load on the cluster, 

that will bedeployed on a aws EKS cluster with 2 worker nodes of type `t3.xlarge`, 

with istio istalled using either the default or ambient profile depending on the currently tested configuration

### 6. How to reproduce

#### Required commandline tools
| name      | version | installation instructions |
| --------- | ------- | ------------------------- |
| aws-cli   | >~ 2.15 | https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions
| terraform | >~ 1.8  | https://developer.hashicorp.com/terraform/install?product_intent=terraform
| istioctl  | >~ 1.21 | https://istio.io/latest/docs/setup/getting-started/#download

#### Reproduction steps

##### Create cluster

Enter terraform directory, initialize terraform (valid aws cli credentials required).
```bash
cd terraform
terraform init
```

Deploy the cluster with service mesh use either mode=ambient or mode=regular depending on the type of the mesh you wish to deploy
```bash
# example for mode=ambient
terraform apply -var mode=ambient
```


##### Fetch cluster credentials
Update .kube/config using aws EKS credentials, use --name=ambient-mesh or --name=regular-mesh depending on the mode selected earlier

```bash
# example for --name=ambient-mesh
aws eks update-kubeconfig --name=ambient-mesh
```


##### Deploy test services
```bash
change aws credentials (output: json)
```


```bash
aws eks describe-cluster --region us-east-1 --name <your cluster> --query cluster.status
aws eks --region us-east-1 update-kubeconfig --name <your cluster>
```


```bash
kubectl apply -f templates/release/kubernetes/manifests.yaml
```



### 7. Demo deployment test

+ #### Ambient Mesh
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/8a958d34-9447-4707-a8ae-c9b5afa88e29)
```bash
$ kubectl get nodes
NAME                            STATUS   ROLES    AGE   VERSION
ip-172-31-29-221.ec2.internal   Ready    <none>   55m   v1.29.3-eks-ae9a62a
ip-172-31-82-151.ec2.internal   Ready    <none>   55m   v1.29.3-eks-ae9a62a
ip-172-31-84-144.ec2.internal   Ready    <none>   55m   v1.29.3-eks-ae9a62a

kubectl top nodes
NAME                            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
ip-172-31-29-221.ec2.internal   976m         24%    1709Mi          11%       
ip-172-31-82-151.ec2.internal   698m         17%    2032Mi          13%       
ip-172-31-84-144.ec2.internal   667m         17%    1715Mi          11% 
```

```bash
$ kubectl logs loadgenerator-5d554bc6c7-ns2kp
...
Name                                                          # reqs      # fails     Avg     Min     Max  |  Median   req/s failures/s
--------------------------------------------------------------------------------------------------------------------------------------------
 GET /                                                           6190 1025(16.56%)    2822       2   18708  |    1100    2.00    2.00
 GET /cart                                                      15797 11009(69.69%)    4601       2   24780  |    3000    9.40    9.40
 POST /cart                                                     15655 10901(69.63%)    5131       2  117376  |    3000    8.50    8.50
 POST /cart/checkout                                             5242 1114(21.25%)    4973      17   26874  |    3300    4.10    4.10
 GET /product/0PUK6V6EV0                                         7702 5472(71.05%)    4742       2   20997  |    3100    3.40    3.40
 GET /product/1YMWWN1N4O                                         7593 5278(69.51%)    4608       2   21885  |    2900    2.90    2.90
 GET /product/2ZYFJ3GM2N                                         7698 5400(70.15%)    4657       3   21575  |    3000    4.20    4.20
 GET /product/66VCHSJNUP                                         7608 5305(69.73%)    4703       2   21389  |    3100    3.00    3.00
 GET /product/6E92ZMYYFZ                                         7651 5287(69.10%)    4683       2   21619  |    3000    2.90    2.90
 GET /product/9SIQT8TOJO                                         7639 5387(70.52%)    4666       2   21478  |    3000    2.50    2.50
 GET /product/L9ECAV7KIM                                         7770 5413(69.67%)    4630       2   21575  |    3000    4.10    4.10
 GET /product/LS4PSXUNUM                                         7551 5318(70.43%)    4722       2   22771  |    3000    3.40    3.40
 GET /product/OLJCESPC7Z                                         7643 5336(69.82%)    4761       2   25824  |    3100    3.70    3.70
 POST /setCurrency                                              10804 2485(23.00%)    3990       2   23527  |    1700    5.30    5.30
--------------------------------------------------------------------------------------------------------------------------------------------
 Aggregated                                                    122543 74730(60.98%)                                      59.40   59.40
...
```
+ #### Service Mesh
![image](https://github.com/SUU-2024-A-Mesh/a-mesh/assets/92889577/3ed386f5-4de9-4586-bb5b-a64df7b5489f)
```bash
PS C:\Users\sIGORs\Desktop\suu> kubectl top nodes
NAME                            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
ip-172-31-0-104.ec2.internal    1381m        35%    1905Mi          12%
ip-172-31-10-90.ec2.internal    1733m        44%    1479Mi          9%
ip-172-31-2-129.ec2.internal    1412m        36%    1372Mi          9%
ip-172-31-32-41.ec2.internal    2037m        51%    1623Mi          10%
ip-172-31-35-113.ec2.internal   2206m        56%    1833Mi          12%
PS C:\Users\sIGORs\Desktop\suu> kubectl get  nodes
NAME                            STATUS   ROLES    AGE   VERSION
ip-172-31-0-104.ec2.internal    Ready    <none>   30m   v1.29.3-eks-ae9a62a
ip-172-31-10-90.ec2.internal    Ready    <none>   30m   v1.29.3-eks-ae9a62a
ip-172-31-2-129.ec2.internal    Ready    <none>   30m   v1.29.3-eks-ae9a62a
ip-172-31-32-41.ec2.internal    Ready    <none>   30m   v1.29.3-eks-ae9a62a
ip-172-31-35-113.ec2.internal   Ready    <none>   30m   v1.29.3-eks-ae9a62a
```
```bash
--------------------------------------------------------------------------------------------------------------------------------------------
 GET /                                                           1221     0(0.00%)     366      37    2347  |     270    5.30    0.00
 GET /cart                                                       2445     0(0.00%)     385      34    2323  |     280   11.60    0.00
 POST /cart                                                      2500     0(0.00%)     521      46    2981  |     410    9.40    0.00
 POST /cart/checkout                                              829     0(0.00%)     417      77    2468  |     330    3.00    0.00
 GET /product/0PUK6V6EV0                                         1166     0(0.00%)     347      35    3653  |     260    4.50    0.00
 GET /product/1YMWWN1N4O                                         1144     0(0.00%)     361      36    3733  |     280    4.30    0.00
 GET /product/2ZYFJ3GM2N                                         1173     0(0.00%)     362      36    2411  |     280    4.50    0.00
 GET /product/66VCHSJNUP                                         1196     0(0.00%)     355      33    2322  |     270    5.30    0.00
 GET /product/6E92ZMYYFZ                                         1235     0(0.00%)     340      37    2145  |     270    5.10    0.00
 GET /product/9SIQT8TOJO                                         1231     0(0.00%)     357      37    2869  |     260    5.40    0.00
 GET /product/L9ECAV7KIM                                         1221     0(0.00%)     361      34    2515  |     300    4.80    0.00
 GET /product/LS4PSXUNUM                                         1255     0(0.00%)     351      31    2766  |     270    5.30    0.00
 GET /product/OLJCESPC7Z                                         1182     0(0.00%)     350      32    2229  |     260    5.00    0.00
 POST /setCurrency                                               1668     0(0.00%)     436      39    3798  |     330    7.10    0.00
--------------------------------------------------------------------------------------------------------------------------------------------
 Aggregated                                                     19466     0(0.00%)                                      80.60    0.00
```

### 8. Summary - conclusions
+ Ambient Mesh is more capable of storing more nodes - we were able to fit 5, when on Service Mesh only 3.
+ We have observed more failed requests on Ambient Mesh in comparison to Service Mesh
+ Memory usage is about 1.7 times higher on Service Mesh
+ CPU usage is about 2 times higher on Service Mesh

Conclusion:
Ambient Mesh is more economical solution than Service Mesh.

### 9. References
+ [GoogleCloud's Microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo)
+ [Ambient Mesh documentation](https://istio.io/v1.15/blog/2022/introducing-ambient-mesh/)
+ [Istio Service Mesh](https://istio.io/latest/about/service-mesh/)
