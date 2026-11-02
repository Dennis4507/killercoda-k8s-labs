## Step 1 of 16 - Look at the cluster

> **Where we are:** Part 1, Build. We have not made anything yet.
> **What exists so far:** only the empty building (the cluster) that Killercoda gave us.
> **What we do now:** look around, so we know what we are working with.

### Command 1: which machines are in the cluster?

```plain
kubectl get nodes
```{{exec}}

**What this does.** `kubectl` sends a question to the cluster's front door, which is called the API server. (API stands for Application Programming Interface. It just means the front door that every request to Kubernetes goes through.) The question is `get nodes`, which means "list the machines". A **node** is one machine in the cluster.

**What you should see:**

```
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   10m   v1.3x.x
node01         Ready    <none>          10m   v1.3x.x
```

**How to read it.** There are two machines. The word `Ready` in the `STATUS` column means the machine is healthy and happy to run work. The `controlplane` machine is the one that makes decisions. `node01` is a worker that mainly runs applications. If a machine said `NotReady`, Kubernetes would stop giving it new work.

### Command 2: what is already running?

```plain
kubectl get pods -A
```{{exec}}

**What this does.** It lists Pods. A **Pod** is one running copy of a program. The `-A` means "all namespaces". A **namespace** is a named area of the cluster, like a folder on a computer, so that different things do not get mixed up. Without `-A`, `kubectl` only looks in one folder.

**What you should see.** A list of Pods, all in a folder called `kube-system`:

```
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   coredns-xxxxxxxxxx-xxxxx       1/1     Running   0          10m
kube-system   etcd-controlplane              1/1     Running   0          10m
kube-system   kube-apiserver-controlplane    1/1     Running   0          10m
kube-system   kube-proxy-xxxxx               1/1     Running   0          10m
kube-system   kube-scheduler-controlplane    1/1     Running   0          10m
```

(There are a few more rows, and the names will vary slightly.)

**How to read it.** These Pods are Kubernetes' own working parts, so Kubernetes is running its own programs inside itself. You will use three columns again and again, so learn them now:

- `READY 1/1` means "one container in this Pod is ready, out of one". `1/1` is good. `0/1` is not ready yet.
- `STATUS Running` means the Pod is working. Other words, such as `Pending` or `CrashLoopBackOff`, mean there is a problem.
- `RESTARTS 0` is how many times it crashed and was restarted. A rising number is a warning sign.

You do not need to remember what each system Pod does. Just notice that one of them is called **coredns**. That is the cluster's phone book, and we will use it later when we phone the reception desk by name.

> **What you now have:** nothing built yet, but you know how to list machines and Pods, and how to read `READY`, `STATUS` and `RESTARTS`.

Click **Continue**.
