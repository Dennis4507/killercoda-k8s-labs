## Step 7 of 16 - Start the Service and look at it

> **Where we are:** Part 1, Build.
> **What exists so far:** three Pods wearing the badge `app=web-app`, and a file `service.yaml` that Kubernetes has not seen.
> **What we do now:** send the Service plan to Kubernetes, and look at the reception desk it creates.

### Send the plan

```plain
kubectl apply -f service.yaml
```{{exec}}

**What you should see:**

```
service/web-service created
```

### Look at the Service

```plain
kubectl get service -n learning
```{{exec}}

**What you should see:**

```
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
web-service   ClusterIP   10.96.12.34    <none>        80/TCP    10s
```

**How to read it, column by column.**

- `NAME web-service` is the desk's name.
- `TYPE ClusterIP` means only callers inside the building can reach it.
- `CLUSTER-IP` is the desk's **fixed phone number**. Yours will be a different number. Unlike a Pod's address, this number **does not change**, even when Pods are replaced. That is the whole point of a Service.
- `EXTERNAL-IP <none>` confirms nobody outside can call it.
- `PORT(S) 80/TCP` means it listens on port 80. TCP is the method of sending data that web traffic uses. It makes sure every piece arrives.

### The desk exists, but does it have anyone to send callers to?

The Service now exists, but that does not yet prove it found the Pods. Finding them is a separate thing. We check that in the next step.

> **What you now have:** a reception desk called `web-service`, with a fixed phone number, whose rule is "send callers to badge `app=web-app`".

Click **Check**.
