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
    NAME                  STATUS   ROLES    AGE     VERSION
    kind-control-plane    Ready    master   3m6s    v1.17.0
    kind-control-plane2   Ready    master   2m34s   v1.17.0
    kind-control-plane3   Ready    master   96s     v1.17.0
    kind-worker2          Ready    <none>   70s     v1.17.0
    kind-worker           Ready    <none>   70s     v1.17.0
    kind-worker3          Ready    <none>   68s     v1.17.0
   ```

Now I have a multi-node k8s cluster.


## Tuning the CNI

Kind ships with a default CNI plugin `kindnetd`. We can [disable the default CNI plugin](https://kind.sigs.k8s.io/docs/user/configuration/#disable-default-cni) to install other plugins. Here, we'll disable `kindnetd` and install Calico CNI.

1. Add this to the configuration:
   ```yaml
    #kind.yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    networking:
    # the default CNI will not be installed
        disableDefaultCNI: true
    ...
   ```
2. Create the cluster. `kind create cluster --config kind.yaml`
3. See that there's no `kindnetd` pods running. Coredns is pending because we don't have k8s networking setup yet.
   ```shell
    $ kubectl get pods -n kube-system

    NAME                                          READY   STATUS    RESTARTS   AGE
    coredns-6955765f44-gmwb5                      0/1     Pending   0          6m2s
    coredns-6955765f44-sbcwb                      0/1     Pending   0          6m2s
    etcd-kind-control-plane                       1/1     Running   0          6m14s
    etcd-kind-control-plane2                      1/1     Running   0          5m37s
    etcd-kind-control-plane3                      1/1     Running   0          4m42s
    kube-apiserver-kind-control-plane             1/1     Running   0          6m14s
    kube-apiserver-kind-control-plane2            1/1     Running   0          4m36s
    kube-apiserver-kind-control-plane3            1/1     Running   1          3m24s
    kube-controller-manager-kind-control-plane    1/1     Running   1          6m14s
    kube-controller-manager-kind-control-plane2   1/1     Running   0          4m16s
    kube-controller-manager-kind-control-plane3   1/1     Running   0          3m40s
    kube-proxy-cczv4                              1/1     Running   0          4m22s
    kube-proxy-dnlz8                              1/1     Running   0          4m22s
    kube-proxy-h4tgr                              1/1     Running   0          4m22s
    kube-proxy-m7rdc                              1/1     Running   0          6m2s
    kube-proxy-mxzw8                              1/1     Running   0          5m42s
    kube-proxy-tx8n2                              1/1     Running   0          4m42s
    kube-scheduler-kind-control-plane             1/1     Running   1          6m14s
    kube-scheduler-kind-control-plane2            1/1     Running   0          4m14s
    kube-scheduler-kind-control-plane3            1/1     Running   0          3m44s
   ```
4. We'll install calico:
   ```shell
    $ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
    
    #wait for several minutes, or watch the pods in kube-system

    $ kubectl get pods -n kube-system
    NAME                                          READY   STATUS    RESTARTS   AGE
    calico-kube-controllers-75f6c789b6-pb2pd      1/1     Running   0          9m13s
    calico-node-5cxmq                             1/1     Running   0          9m13s
    calico-node-ct2fg                             1/1     Running   0          9m13s
    calico-node-hcj6j                             1/1     Running   0          9m13s
    calico-node-ldnxj                             1/1     Running   0          9m13s
    calico-node-rbpg9                             1/1     Running   0          9m13s
    calico-node-rxpzw                             1/1     Running   0          9m13s
    coredns-6955765f44-gmwb5                      1/1     Running   0          17m
    coredns-6955765f44-sbcwb                      1/1     Running   0          17m
    etcd-kind-control-plane                       1/1     Running   0          17m
    etcd-kind-control-plane2                      1/1     Running   0          16m
    etcd-kind-control-plane3                      1/1     Running   0          16m
    kube-apiserver-kind-control-plane             1/1     Running   0          17m
    kube-apiserver-kind-control-plane2            1/1     Running   0          15m
    kube-apiserver-kind-control-plane3            1/1     Running   1          14m
    kube-controller-manager-kind-control-plane    1/1     Running   1          17m
    kube-controller-manager-kind-control-plane2   1/1     Running   0          15m
    kube-controller-manager-kind-control-plane3   1/1     Running   0          15m
    kube-proxy-cczv4                              1/1     Running   0          15m
    kube-proxy-dnlz8                              1/1     Running   0          15m
    kube-proxy-h4tgr                              1/1     Running   0          15m
    kube-proxy-m7rdc                              1/1     Running   0          17m
    kube-proxy-mxzw8                              1/1     Running   0          17m
    kube-proxy-tx8n2                              1/1     Running   0          16m
    kube-scheduler-kind-control-plane             1/1     Running   1          17m
    kube-scheduler-kind-control-plane2            1/1     Running   0          15m
    kube-scheduler-kind-control-plane3            1/1     Running   0          15m
   ```
5. Done!