## Step 11 of 11 - Apply the fix and prove it

**Progress:** ▰▰▰▰▰▰▰▰▰▰▰ Part 4 of 4: Fix

> **Where we are:** Part 3, Fix. The last step.
> **What we know:** the fix is to cut each Pod's CPU booking to one third of R.
> **What we do now:** apply it, watch the frozen update finish, and check the floor.

### Apply the fix

```plain
REQ=$(cat ~/req.txt)
kubectl set resources deployment/web -n scheduling --requests=cpu=$((REQ/3))m
```{{exec}}

**What this does, piece by piece:**

- `REQ=$(cat ~/req.txt)` reads your saved number back into the variable `REQ`.
- `$((REQ/3))` is **arithmetic**: it divides `REQ` by 3 and fills in the answer.
- `kubectl set resources deployment/web --requests=cpu=...m` changes the booking in the Deployment's blueprint to that smaller number.

**What you should see:**

```
deployment.apps/web resource requirements updated
```

Changing the blueprint starts a **new** rolling update. Its new Pods book only a third as much, and the stuck Pending Pod from the earlier attempt is replaced as part of it.

### Watch it finish

```plain
kubectl rollout status deployment/web -n scheduling --timeout=120s
```{{exec}}

**What you should see:**

```
Waiting for deployment "web" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "web" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "web" rollout to finish: 1 old replicas are pending termination...
deployment "web" successfully rolled out
```

**How to read it.** The count moves forward: 1 of 3, then 2 of 3, then done. The last line, `successfully rolled out`, is what a healthy update ends with. Compare it with step 6, where it never got past the first line.

### Prove it: the Pods

```plain
kubectl get pods -n scheduling
```{{exec}}

You should see **three** Pods, all `1/1 Running`, with a new middle code and a young `AGE`. No `Pending` Pod, and no fourth Pod.

### Prove it: the floor

```plain
kubectl describe node node01 | grep -A6 "^Allocated resources"
```{{exec}}

You should see the `cpu` `Requests` figure **much lower** than before. In the example, `250m + 3 x 166m` is about `750m`, around 37%, instead of 87%. There is now plenty of room for an update, or for other workloads.

### What changed, in one sentence

The bookings now match reality more closely, so the floor has room for one extra Pod, and the circular wait is gone.

> **What you now have:** a rolling update that completes, and a floor with room to spare.

Click **Check**.
