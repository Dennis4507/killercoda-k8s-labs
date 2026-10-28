## Step 4 - Find the cause and repair it

Diagnose in order, from the outside in. Run each command and read what it tells you.

**1. Does the name resolve?** If this prints an address, name lookup is fine, so it is not DNS:

```plain
kubectl exec -n learning client -- nslookup web-service
```{{exec}}

**2. Does the Service have any backends?** Look at `Selector` and `Endpoints`. An **endpoint** is the address of one Pod that the Service forwards to. `<none>` means zero backends:

```plain
kubectl describe service web-service -n learning
```{{exec}}

**3. What labels do the Pods actually carry?**

```plain
kubectl get pods -n learning --show-labels
```{{exec}}

**4. Same story from the newer API:**

```plain
kubectl get endpointslices -n learning -l kubernetes.io/service-name=web-service
```{{exec}}

You should now see the cause: the Service selects `app=wrong-app`, but the Pods carry `app=web-app`, so the match list is empty.

Repair it by putting the correct selector back, then retest:

```plain
kubectl patch service web-service -n learning -p '{"spec":{"selector":{"app":"web-app"}}}'
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

Click **Check**.
