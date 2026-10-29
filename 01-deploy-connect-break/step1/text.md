## Step 1 - Meet the cluster

Before building anything, look at what you are working with.

### Command 1: list the machines

```plain
kubectl get nodes -o wide
```{{exec}}

**What it does.** `kubectl` sends a question to Kubernetes' central brain, called the **API server** (API stands for Application Programming Interface, meaning the front door that every request goes through). `get nodes` asks "which machines are in this cluster?". `-o wide` means "show extra columns".

**What you should see** (yours will differ in numbers):

```
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP   ...
controlplane   Ready    control-plane   10m   v1.3x.x   172.30.1.2    ...
node01         Ready    <none>          9m    v1.3x.x   172.30.2.2    ...
```

**How to read it.** There are two machines. `STATUS Ready` means each one is healthy and willing to run Pods. If a node said `NotReady`, Kubernetes would stop sending it new work. `ROLES control-plane` marks the machine that makes decisions; `<none>` simply means an ordinary worker.

### Command 2: list everything already running

```plain
kubectl get pods -A
```{{exec}}

**What it does.** `get pods` lists Pods. `-A` means "all namespaces". A **namespace** is a named area of the cluster that keeps groups of objects separate, like folders on a disk. Without `-A`, `kubectl` only looks in one namespace (called `default`).

**What you should see.** A list in a namespace called `kube-system`. These are Kubernetes' own parts, already running:

```
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-xxxxxxxxxx-xxxxx            1/1     Running   0          10m
kube-system   etcd-controlplane                   1/1     Running   0          10m
kube-system   kube-apiserver-controlplane         1/1     Running   0          10m
kube-system   kube-controller-manager-controlplane 1/1    Running   0          10m
kube-system   kube-proxy-xxxxx                    1/1     Running   0          10m
kube-system   kube-scheduler-controlplane         1/1     Running   0          10m
```

(You will also see a networking add-on, whose name varies.)

**How to read the columns.** `READY 1/1` means one of the Pod's one containers is ready. `STATUS Running` is healthy. `RESTARTS 0` means it has not crashed and been restarted. Remember these three columns, because you will use them every time you troubleshoot.

### Meet the parts

You do not need to memorise these, but knowing the names makes everything later make sense:

- **kube-apiserver**: the front door. Every `kubectl` command goes here.
- **etcd**: the database where the cluster stores everything it knows.
- **kube-scheduler**: decides which node each new Pod should run on.
- **kube-controller-manager**: runs the loops that notice "you asked for three Pods but only two exist" and fix it.
- **kube-proxy**: sets up the network rules that make Services work on each node.
- **coredns**: the cluster's DNS, which turns Service names into addresses.

Click **Continue** when you are ready.
