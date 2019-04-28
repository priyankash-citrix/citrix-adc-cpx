
# **Description**

This repository contains the Citrix NetScaler Ingress Controller built around  [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/). This controller automatically configures one or more Citrix NetScaler ADC based on Ingress resource configuration .
Learn more about using Ingress on [k8s.io](https://kubernetes.io/docs/concepts/services-networking/ingress/) 

# **What is an Ingress Controller?**

An Ingress Controller is a controller that watches the Kubernetes API server for updates to the Ingress resource and reconfigures the Ingress load balancer accordingly.

The Citrix Ingress Controller can be deployed on GKE by using [helm charts](https://github.com/citrix/citrix-k8s-ingress-controller/tree/master/charts).

# **Citrix Ingress Controller Features**

Features supported by Citrix Ingress Controller can be found [here](https://github.com/citrix/citrix-k8s-ingress-controller/tree/master/deployment#citrix-ingress-controller-features)

# **Deployment Solutions**

There are two deployment solution present for Citrix Ingress Controller in Google cloud.

* Stanalone CIC for Citrix ADC VPX/MPX.
* CIC running in side-car mode with Citrix ADC CPX.

# **Code of Conduct**
This project adheres to the [Kubernetes Community Code of Conduct](https://github.com/kubernetes/community/blob/master/code-of-conduct.md). By participating in this project you agree to abide by its terms.

# **License**
[Apache License 2.0](./license/LICENSE)
