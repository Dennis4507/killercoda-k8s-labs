## Step 6 of 11 - Release a new version

**Progress:** ▰▰▰▰▰▰▱▱▱▱▱ Part 2 of 4: Break

> **Where we are:** Part 2, Break.
> **What exists so far:** three healthy Pods running version `nginx:stable-alpine`, on a floor that is about 87% booked but nearly empty in reality.
> **What we do now:** release a new version of the application, and watch the update freeze.

### The change

A **rolling update** replaces the old Pods with new ones gradually. We trigger one by changing the image (the program package) to a different version.

```plain
kubectl set image deployment/web nginx=nginx:alpine -n scheduling
```{{exec}}

**What this does.** `kubectl set image` changes which image a Deployment uses. `deployment/web` says which Deployment. `nginx=nginx:alpine` has two parts: the container's name (`nginx`) and the new image (`nginx:alpine`). Any change to the Pod's blueprint, like this, makes the Deployment start a rolling update.

**What you should see:**

```
deployment.apps/web image updated
```

### What the manager now does, in the story

The manager follows the two rules from step 3: `maxSurge: 1` and `maxUnavailable: 0`.

1. Hire **one** new employee (the new version) while all three old employees keep working. That makes four employees on the floor.
2. Only when the new employee is working, release one old employee.
3. Repeat until all three are new.

Step 1 needs **a fourth booking of size R**. But the floor has no room for one. Let us watch what happens.

Here is what the manager wants, and what is actually possible:

```
What the manager wants during the update:

   old   old   old    +   NEW      = 4 employees on the floor
   [R]   [R]   [R]        [R]      = 4 bookings needed (4 x R)

What the floor can hold:

   3 x R fits,  but  4 x R does NOT fit
```

### Watch the update

```plain
kubectl rollout status deployment/web -n scheduling --timeout=30s
```{{exec}}

**What this does.** `rollout status` waits and reports progress while an update runs. `--timeout=30s` means "give up after 30 seconds", so it does not wait forever.

**What you should see:**

```
Waiting for deployment "web" rollout to finish: 1 out of 3 new replicas have been updated...
error: timed out waiting for the condition
```

**How to read it.** It says "1 out of 3 new replicas have been updated" and then **times out**. After 30 seconds, nothing has progressed. A healthy update would have moved on within a few seconds. The update is **stuck**.

Nothing crashed, and no error message says why. That is why we need to investigate.

> **What you now have:** a frozen update. We know it is stuck, but not why.

Click **Check**.
