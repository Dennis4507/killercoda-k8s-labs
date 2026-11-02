## Step 15 of 16 - Detective 4: prove it

> **Where we are:** Part 3, Detective. Step 4 of 4.
> **What we know so far:** the desk looks for `app=wrong-app`, the Pods wear `app=web-app`, and the desk's list is empty.
> **What we do now:** prove that this is the cause, by running the desk's own search ourselves.

A good detective does not stop at "it looks like the cause". A good detective shows it.

### Run the desk's search by hand

```plain
kubectl get pods -n learning -l app=wrong-app
```{{exec}}

**What this does.** `-l` means "only show objects that have this label". So this command asks: "which Pods wear the badge `app=wrong-app`?" That is exactly the search the desk does.

**What you should see:**

```
No resources found in learning namespace.
```

**How to read it.** Nobody wears that badge. This is exactly why the desk's list is empty: it ran the same search and got the same empty answer.

### Now search for the badge the Pods really wear

```plain
kubectl get pods -n learning -l app=web-app
```{{exec}}

**What you should see:** your three `web-app` Pods, all `Running`.

**How to read it.** Searching for the correct badge finds all three employees. So the Pods are fine. If the desk used this badge, it would find them.

### Check the desk's list one more way

```plain
kubectl get endpointslices -n learning -l kubernetes.io/service-name=web-service
```{{exec}}

**What this does.** An EndpointSlice is the newer form of the endpoints list from step 8. The `-l` filter picks the one that belongs to `web-service`.

**What you should see** (the `ENDPOINTS` column is empty):

```
NAME                ADDRESSTYPE   PORTS   ENDPOINTS   AGE
web-service-abcde   IPv4          80      <unset>     20m
```

In step 8 that column held three addresses. Now it holds none.

### Write the diagnosis in one sentence

Fill in this sentence with what you found. This is also exactly how you would explain it in an interview:

> "The Service looks for Pods labelled **`app=wrong-app`**, but the Pods are labelled **`app=web-app`**, so the Service's list of endpoints is **empty**, and calls to it fail even though the Pods are healthy."

### The detective's checklist you just used

1. Did the name resolve? (read the failed call)
2. What is the Service looking for, and is its list empty? (`kubectl describe service`)
3. What do the Pods actually wear? (`kubectl get pods --show-labels`)
4. Prove the mismatch. (`kubectl get pods -l <the Service's badge>`)

> **What you now know:** the exact cause, proved. Now we fix it.

Click **Continue**.
