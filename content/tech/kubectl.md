---

title: "kubectl"
description: >
  All I've learned about/from kubectl.
categories: ["kubernetes", "technology"]

---

_This is a living document specially crafted for my personal use_

Go to [cheatsheet](#cheatsheet)

# About kubectl

Mental model:

- It is the CLI tool to interact with Kubernetes API server (apiserver).
- Basically, it is an interface for us to talk to the API server without needing to be fluent on the low level [Kubernetes API](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/).
- It shims/translates the CLI language which is more human friendly compared to the Kubernetes (RESTful) API.
  - For example:
    - from `kubectl get pods -n default`
    - to roughly like `curl -XGET https://APISERVER_ADDRESS/api/v1/namespaces/default/pods -H "Authorization: Bearer $TOKEN"`
      - Although actually it's implementing another [http client](https://github.com/kubernetes/client-go).
- Because of that, it makes human operator's life much easier.
- It has many features and keeps evolving. The tool itself is maintained by the [Kubernetes SIG CLI](https://github.com/kubernetes/community/tree/master/sig-cli).

_Learning from `kubectl`, I see this pattern too on all the CLI tools that I've seen/used. CLI is the human-friendly interface to the low level API behind a system. The API doesn't necessarily need to be HTTP/RESTful. For example, the `psql` tool speaks the [PostgreSQL protocol](https://www.postgresql.org/docs/10/protocol.html) for us, translating the human-friendly commands to the protocol so we can talk to the postgres server._

# Cheatsheet

```bash
#get all pods from all namespaces
kubectl get pods --all-namespaces

#drains a node
kubectl drain node NODE_NAME \
  --ignore-daemonsets --delete-local-data

#see the status of a deployment
kubectl rollout status deployment DEPLOYMENT_NAME

#rollback a deployment
kubectl rollout history deployment DEPLOYMENT_NAME
kubectl rollout undo deployment \
  --to-revision=REVISION_NUMBER DEPLOYMENT_NAME

#user impersonation
kubectl get pod -n default \
  --as user@domain.com

#checking api access
kubectl auth can-i delete deployment \
  --namespace default
##no

#reconcile all RBAC items
kubectl auth reconcile --recursive \
  --remove-extra-subjects \
  --remove-extra-permissions \
  -f PATH/TO/DIR/

#label nodes with kubernetes role label. e.g worker
kubectl label node NODE_NAME \
  node-role.kubernetes.io/worker=""
##this is my custom label, containing my own semantic.
##It simply means the "role"
kubectl label node NODE_NAME \
  role="worker"

#quickly make a node unschedulable
kubectl cordon NODE_NAME

#get by label
kubectl get pods -l key=value

#logs by label
kubectl logs -l key=value POD_NAME CONTAINER_NAME \
  --tail=N #with tail
  --tail=N #followwing

#list all api resources
kubectl api-resources

#monitor resource usage
kubectl top nodes
kubectl top pods
```

