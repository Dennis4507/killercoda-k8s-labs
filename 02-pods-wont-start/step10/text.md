## Step 10 of 10 - Fix B and prove it

> **Where we are:** Failure B, the fix.
> **What we know:** the program quits because `DATABASE_URL` is missing.
> **What we do now:** give the Deployment the missing setting, and check the program stays up.

### The fix

```plain
kubectl set env deployment/crash-demo DATABASE_URL=postgres://db.example:5432/app -n troubleshoot
```{{exec}}

**What this does.** `kubectl set env` adds an environment variable to a Deployment. Here it adds `DATABASE_URL` with the value `postgres://db.example:5432/app`. (That is a made-up address for practice. Our script only checks that the setting exists, so any value works.)

**What you should see:**

```
deployment.apps/crash-demo env updated
```

As in Failure A, we fix the **Deployment** (the plan), not the Pod. The Deployment now makes a new Pod with the setting, and removes the old crashing one.

### Prove it: the status

Wait about ten seconds, then:

```plain
kubectl get pods -n troubleshoot -l app=crash-demo
```{{exec}}

**What you should see:**

```
NAME                          READY   STATUS    RESTARTS   AGE
crash-demo-6d8c7b9f5-q9w2e    1/1     Running   0          15s
```

`1/1`, `Running` and `RESTARTS 0`. The new Pod started and **stayed up**. Compare it with step 7, where the status kept flipping.

### Prove it: the logs

```plain
kubectl logs -n troubleshoot -l app=crash-demo
```{{exec}}

You should now see:

```
Starting application...
Connected to postgres://db.example:5432/app
```

The error message is gone. The program found its setting and carried on. **Always prove a fix with the logs or a real test**, not just by seeing that the command worked.

> **What you now have:** both failures fixed, and a method for each.

Click **Check**.
