## Step 11 of 16 - Break the Service on purpose

> **Where we are:** Part 2, Break.
> **What exists so far:** everything works. A call to `web-service` returns `200 OK`.
> **What we do now:** change one thing, the desk's rule, so that the call stops working.

### The change

In our story, someone walks up to the reception desk and swaps its rule from "send callers to badge `app=web-app`" to "send callers to badge `app=wrong-app`". Nobody wears that badge. The employees are still at their desks. The desk's rule just points at nobody.

This kind of mistake happens in real life: a typo, a renamed label, a copy-and-paste slip.

```plain
kubectl set selector service web-service app=wrong-app -n learning
```{{exec}}

**What this does.** `kubectl set selector` changes the **selector**, the desk's rule, on an existing Service. We changed it to `app=wrong-app`.

**What you should see:**

```
service/web-service selector updated
```

### Notice what did NOT change

```plain
kubectl get pods -n learning
```{{exec}}

You should see your three `web-app` Pods and the `client`, all `Running`. **The Pods are completely fine.** Nginx inside them is still working. Only the desk's rule changed.

So the situation is:

- The Pods are healthy.
- The Service exists.
- But the Service's rule points to a badge nobody wears.

Nothing has said "error" yet. The system looks healthy from the outside, which is what makes this kind of fault hard. That is why we need a method to investigate. In the next four steps you will be the detective.

> **What you now have:** a broken Service. The Pods are healthy, but the Service cannot find them.

Click **Check**.
