## Installing Helm with RBAC enabled AKS

Helm is the package manager for Kubernetes, it helps the deployment of complex infrastructure in a consistent and easy way.

The packages on Helm are called "Charts" and we can build our own Chart to deploy our application in a CI/CD.

# Create a Service account for Tiller

Tiller is the server side for Helm, this yaml creates the tiller service account, also available in the directory.

``` yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

``` bash
kubectl apply -f 1-ServiceAccount.yaml
```

## Installing Helm client in your machine

We are going to use the 2.11.0 release that is complatible with Kubernetes 1.11, download the binary that suits your environment [Helm releases](https://github.com/helm/helm/releases/tag/v2.11.0).

The install is a single executable file (this release came with tiller too), put the content in any particular folder and ad it's path to your System Path variable.

## Initiate Helm Tiller using the service account

With helm available do the *Helm init*

```bash
helm init --service-account tiller
```