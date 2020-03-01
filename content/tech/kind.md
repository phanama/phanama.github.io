---

title: "kind"
description: >
  Playing with Kubernetes in Docker.
categories: ["kubernetes", "technology"]

---

# Playing with kind

- [Kind](https://github.com/kubernetes-sigs/kind) is an excellent tool to have Kubernetes running locally in the machine. It uses the local machine's Docker engine to create "nodes" within docker containers.
- Compared to [Minikube](https://github.com/kubernetes/minikube), Kind is much more lightweight.
- Kind supports multiple Nodes in the same local machine.
- It runs nested docker containers, so "nodes" are actual functional nodes without needing to spawn containers with the host's docker sock.

Installing kind and bringing up a cluster is easy (taken from the docs):

1. Run:
    ```shell
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.7.0/kind-$(uname)-amd64
    chmod +x ./kind
    mv ./kind /some-dir-in-your-PATH/kind
    ```

2. Create a file kind_cluster.yaml:
    ```yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
    - role: control-plane
    - role: control-plane
    - role: worker
    - role: worker
    - role: worker
    ```

3. Create the cluster:
   `kind create cluster --config kind_cluster.yaml`
4. `kubectl get nodes` outputs:
   ```shell
    NAME                  STATUS   ROLES    AGE   VERSION
    kind-control-plane    Ready    master   18s   v1.17.0
    kind-control-plane2   Ready    master   17s   v1.17.0
    kind-control-plane3   Ready    master   16s   v1.17.0
    kind-worker           Ready    <none>   16s   v1.17.0
    kind-worker2          Ready    <none>   16s   v1.17.0
    kind-worker3          Ready    <none>   16s   v1.17.0
   ```

Now I have a multi-node k8s cluster.

