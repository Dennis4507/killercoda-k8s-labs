## Step 4 of 16 - Start the Pods and read what happened

> **Where we are:** Part 1, Build.
> **What exists so far:** the `learning` folder, and a plan file `deployment.yaml` that Kubernetes has not seen.
> **What we do now:** send the plan to Kubernetes, then look at the three Pods it creates and the badge each one wears.

### Send the plan

```plain
kubectl apply -f deployment.yaml
```{{exec}}

**What this does.** `apply` means "make the cluster match this description". `-f deployment.yaml` means "read the description from this file".

**What you should see:**

```
deployment.apps/web-app created
```

### Look at the Pods

```plain
kubectl get pods -n learning -o wide
```{{exec}}

**What this does.** It lists Pods in your `learning` folder. `-o wide` means "show extra columns", including each Pod's address and which machine it runs on.

**What you should see** (wait ten seconds and run it again if you see `ContainerCreating`; that means it is still downloading the program):

```
NAME                       READY   STATUS    RESTARTS   AGE   IP            NODE
web-app-7d9c6b5f4d-abcde   1/1     Running   0          30s   192.168.1.4   node01
web-app-7d9c6b5f4d-fghij   1/1     Running   0          30s   192.168.1.5   node01
web-app-7d9c6b5f4d-klmno   1/1     Running   0          30s   192.168.0.6   controlplane
```

**How to read it.**

- There are **three** Pods, exactly as the plan asked.
- All are `1/1` and `Running`, so they are healthy.
- The `IP` column is each Pod's own address. (IP stands for Internet Protocol. An IP address is just a number that identifies something on a network, like a house number.) **Remember that every Pod has its own different address.**
- The `NODE` column shows Kubernetes spread the Pods across the machines.
- The name has a pattern. `web-app-7d9c6b5f4d-abcde` is the Deployment name, then a code, then random letters. The middle code belongs to a helper object called a **ReplicaSet**, which Kubernetes made automatically. Its only job is to keep exactly three Pods alive. So the chain is: Deployment makes ReplicaSet, which makes Pods.

### Look at the name badges

```plain
kubectl get pods -n learning --show-labels
```{{exec}}

**What this does.** `--show-labels` adds a column showing each Pod's labels, which are the name badges.

**What you should see:**

```
NAME                       READY   STATUS    RESTARTS   AGE   LABELS
web-app-7d9c6b5f4d-abcde   1/1     Running   0          1m    app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-fghij   1/1     Running   0          1m    app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-klmno   1/1     Running   0          1m    app=web-app,pod-template-hash=7d9c6b5f4d
```

**How to read it.** Every Pod wears the badge **`app=web-app`**. That came from Part D of the plan. (The second label, `pod-template-hash`, is added by Kubernetes for its own bookkeeping, so ignore it.)

**This is the most important thing in the whole lab, so say it to yourself: the Pods wear the badge `app=web-app`.** The troubleshooting later depends on it.

> **What you now have:** three healthy Pods, each with its own address and each wearing the badge `app=web-app`.

Click **Check** when all three are `Running`.
