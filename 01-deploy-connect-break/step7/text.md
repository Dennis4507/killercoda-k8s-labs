## Step 7 - Diagnose from the evidence

Good troubleshooting follows an order, working along the path the request takes: **name, then Service, then backends, then Pods**. At each point you ask one question, run one command, and either rule the point out or find the fault. Nothing in this step changes anything. It is all read-only.

### Question 1: does the name resolve?

You have already answered this from step 6. The verbose output said `Host web-service:80 was resolved`, so DNS works. **Ruled out.**

### Question 2: what does the Service think its job is?

```plain
kubectl describe service web-service -n learning
```{{exec}}

**What it does.** `describe` prints a detailed report on one object: its settings and its recent events. It is the first thing to run on any object that misbehaves.

**What you should see** (trimmed):

```
Name:              web-service
Namespace:         learning
Selector:          app=wrong-app
Type:              ClusterIP
IP:                10.96.x.x
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         <none>
Events:            <none>
```

**How to read it.** Two lines matter. `Selector: app=wrong-app` shows what the Service is searching for. `Endpoints: <none>` shows it found nothing. A Service with no endpoints has nowhere to send traffic, so every request fails. **You have found the symptom.** The question is now: why did it find nothing?

### Question 3: what labels do the Pods actually have?

```plain
kubectl get pods -n learning --show-labels
```{{exec}}

**What it does.** `--show-labels` adds a column listing every label on each Pod.

**What you should see:**

```
NAME                       READY   STATUS    RESTARTS   AGE   LABELS
client                     1/1     Running   0          8m    run=client
web-app-7d9c6b5f4d-abcde   1/1     Running   0          12m   app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-fghij   1/1     Running   0          12m   app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-klmno   1/1     Running   0          12m   app=web-app,pod-template-hash=7d9c6b5f4d
```

**How to read it.** Compare two facts side by side. The Service wants `app=wrong-app`. The Pods carry `app=web-app`. They do not match. **You have found the cause.**

### Question 4: prove it by running the Service's own search

```plain
kubectl get pods -n learning -l app=wrong-app
```{{exec}}

**What it does.** `-l` means "filter by label". This runs exactly the search the Service runs.

**What you should see:**

```
No resources found in learning namespace.
```

That is the proof: searching for what the Service is looking for returns nothing. Now try the correct label:

```plain
kubectl get pods -n learning -l app=web-app
```{{exec}}

This returns your three Pods. The technique of running the Service's selector as a Pod search is one of the fastest ways to debug this kind of problem in real life.

### Question 5: confirm from the endpoint list

```plain
kubectl get endpointslices -n learning -l kubernetes.io/service-name=web-service
```{{exec}}

**What it does.** EndpointSlices are the newer form of the endpoints list you saw in step 4. The label filter finds the slice that belongs to `web-service`.

**What you should see:** a row whose `ENDPOINTS` column is `<unset>` (empty). In step 4 it held three addresses. Now it holds none.

### The diagnosis, in one sentence

The Pods are healthy and the name resolves, but the Service's selector `app=wrong-app` matches no Pod labelled `app=web-app`, so its endpoint list is empty and it has nowhere to forward traffic.

Click **Continue** to fix it.
