## Step 14 of 16 - Detective 3: what badge do the Pods wear?

> **Where we are:** Part 3, Detective. Step 3 of 4.
> **What we know so far:** DNS works. The desk looks for `app=wrong-app`, and its list is empty.
> **What we do now:** look at the employees' badges, so we can compare them with the desk's rule.

### The command

```plain
kubectl get pods -n learning --show-labels
```{{exec}}

**What this does.** It lists the Pods, with an extra `LABELS` column showing every name badge. You ran it in step 4. Now you run it again as a detective.

**What you should see:**

```
NAME                       READY   STATUS    RESTARTS   AGE   LABELS
client                     1/1     Running   0          9m    run=client
web-app-7d9c6b5f4d-fghij   1/1     Running   0          15m   app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-klmno   1/1     Running   0          15m   app=web-app,pod-template-hash=7d9c6b5f4d
web-app-7d9c6b5f4d-pqrst   1/1     Running   0          12m   app=web-app,pod-template-hash=7d9c6b5f4d
```

### How to read it

Look only at the three `web-app` Pods and their `LABELS` column. Each one wears the badge:

```
app=web-app
```

(The `client` Pod wears a different badge, `run=client`. It is not part of the web application, so ignore it.)

Also notice that all three `web-app` Pods are `1/1` and `Running`. So the employees are present and working.

### Put the two clues side by side

| | Badge |
|---|---|
| What the **desk** is looking for (step 13) | `app=wrong-app` |
| What the **employees** are wearing (this step) | `app=web-app` |

**They are different.** That is the cause. The desk is looking for a badge that nobody wears, so it finds nobody, so its list is empty, so the calls fail.

> **What you now know:** the Pods are fine, the desk's rule is wrong, and the two do not match. Next we prove it, so that we are certain and not just guessing.

Click **Continue**.
