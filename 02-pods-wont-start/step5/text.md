## Step 5 of 10 - Fix A and prove it

> **Where we are:** Failure A, the fix.
> **What we know:** the image tag `stabel` is a typo. The correct tag is `stable-alpine` (a small, stable build of Nginx).
> **What we do now:** correct the image name in the Deployment, and watch a healthy Pod replace the broken one.

### The fix

```plain
kubectl set image deployment/pull-demo nginx=nginx:stable-alpine -n troubleshoot
```{{exec}}

**What this does.** `kubectl set image` changes which image a Deployment uses.

- `deployment/pull-demo` says which Deployment to change.
- `nginx=nginx:stable-alpine` has two parts. The part before the `=` is the **container's name** inside the Pod. `kubectl create deployment` named it `nginx`, after the image. The part after the `=` is the new, correct image.

**What you should see:**

```
deployment.apps/pull-demo image updated
```

We fixed the **Deployment**, not the Pod. The Pod is only a result of the Deployment's plan. When the plan changes, the manager makes a new Pod from the new plan and removes the old one. Fixing the Pod by hand would not last, because the Deployment would just make another broken one.

### Prove it

```plain
kubectl get pods -n troubleshoot
```{{exec}}

**What you should see.** For a few seconds there may be two Pods: the old broken one still stuck, and a new one starting.

```
NAME                         READY   STATUS              RESTARTS   AGE
pull-demo-6c8d9f7b5-x2k4j    0/1     ImagePullBackOff    0          6m
pull-demo-7f9b8d6c4-m3p8q    0/1     ContainerCreating   0          3s
```

Run it again after about ten seconds:

```
NAME                         READY   STATUS    RESTARTS   AGE
pull-demo-7f9b8d6c4-m3p8q    1/1     Running   0          15s
```

**How to read it.** The new Pod (with a different name) is `1/1 Running`. Kubernetes waited until the new Pod was healthy, and **then** removed the broken one. That is a safe way to update, and it is called a **rolling update**.

### Check the fix in the diary too

```plain
kubectl describe pods -n troubleshoot -l app=pull-demo | tail -n 6
```{{exec}}

You should now see events such as `Pulling image "nginx:stable-alpine"`, `Successfully pulled image` and `Started container nginx`. A story that ends with `Started container` is a story that ended well.

> **What you now have:** Failure A fixed. You went from status, to Events, to cause, to fix, to proof.

Click **Check**.
