## Step 4 of 11 - Start the Pods and check they fit

> **Where we are:** Part 1, Build.
> **What exists so far:** a plan file `deploy.yaml` booking R millicores per Pod. Kubernetes has not seen it.
> **What we do now:** send the plan, and check that all three Pods fit on `node01`.

### Send the plan

```plain
kubectl apply -f deploy.yaml
```{{exec}}

**What you should see:**

```
deployment.apps/web created
```

### Look at the Pods

```plain
kubectl get pods -n scheduling -o wide
```{{exec}}

**What you should see** (wait ten seconds and run it again if you see `ContainerCreating`):

```
NAME                  READY   STATUS    RESTARTS   AGE   IP            NODE
web-6b9f8d7c5-4kx2p   1/1     Running   0          20s   192.168.1.8   node01
web-6b9f8d7c5-9mt7q   1/1     Running   0          20s   192.168.1.9   node01
web-6b9f8d7c5-zl5vw   1/1     Running   0          20s   192.168.1.10  node01
```

**How to read it.** There are three Pods, all `Running`, and the `NODE` column shows `node01` for every one. That is the `nodeSelector` at work. The three bookings fit.

### Look at the floor again

```plain
kubectl describe node node01 | grep -A6 "^Allocated resources"
```{{exec}}

**What you should see** (the example numbers continue from step 2):

```
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests      Limits
  --------           --------      ------
  cpu                1750m (87%)   0 (0%)
```

**How to read it.** Compare it with step 2. The booked CPU went up by `3 x R`. In the example it went from 250m to 1750m (87%). So the floor is now **about 85 to 90 percent booked**. There is a small gap left, but **not enough for a fourth Pod of size R**.

Remember this picture. The floor is nearly fully booked, and the next step will show how little of it is really being used.

> **What you now have:** three healthy Pods on `node01`, and a floor that is almost fully booked.

Click **Check** when all three are `Running`.
