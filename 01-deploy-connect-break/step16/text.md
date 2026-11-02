## Step 16 of 16 - Fix it and prove it

> **Where we are:** Part 3, Fix. This is the last step.
> **What we know:** the desk looks for `app=wrong-app`, but the Pods wear `app=web-app`.
> **What we do now:** set the desk's rule back to the correct badge, and check that everything works again.

### The fix

The cause is the desk's rule, so the fix is to change the rule. We leave the Pods alone, because they were never the problem.

```plain
kubectl set selector service web-service app=web-app -n learning
```{{exec}}

**What this does.** The same command as in step 11, but now it sets the rule back to `app=web-app`, the badge the Pods really wear.

**What you should see:**

```
service/web-service selector updated
```

### Proof 1: the desk's list is full again

```plain
kubectl get endpoints web-service -n learning
```{{exec}}

You should see **three addresses again**, the same three as your Pods. Kubernetes noticed the change and rebuilt the list within a second or two. If it still says `<none>`, wait a few seconds and run it again.

### Proof 2: a real call works again

```plain
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

You should see `HTTP/1.1 200 OK` again.

**Always prove a fix with a real call.** Do not just trust that the change was applied. You have now proved it twice: the list is full, and the call succeeds.

> **What you now have:** a working application again, and a method for finding this kind of fault.

Click **Check**.
