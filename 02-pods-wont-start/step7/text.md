## Step 7 of 10 - Start it and watch it crash

> **Where we are:** Failure B.
> **What exists so far:** a file `crash-demo.yaml` describing a program that quits if `DATABASE_URL` is missing. Kubernetes has not seen it.
> **What we do now:** send the plan, and watch what the status does over about a minute.

### Send the plan

```plain
kubectl apply -f crash-demo.yaml
```{{exec}}

**What you should see:**

```
deployment.apps/crash-demo created
```

### Watch the status

Wait about ten seconds, then run this. Then run it again every 15 seconds or so, for about a minute.

```plain
kubectl get pods -n troubleshoot -l app=crash-demo
```{{exec}}

**What you should see over time.** The status changes between a few words:

```
NAME                          READY   STATUS             RESTARTS      AGE
crash-demo-5b7f6c8d9-h4j2k    0/1     Error              0             8s
```

A little later:

```
crash-demo-5b7f6c8d9-h4j2k    0/1     CrashLoopBackOff   2 (20s ago)   40s
```

Later still:

```
crash-demo-5b7f6c8d9-h4j2k    0/1     CrashLoopBackOff   4 (35s ago)   2m
```

### How to read it

Compare this carefully with Failure A.

- `STATUS Error`, then `CrashLoopBackOff`. In Failure A the word was `ImagePullBackOff`. This one says **Crash** and **Loop**. The program started, crashed, got restarted, crashed again, and so on in a loop.
- `RESTARTS` is **not zero**, and it grows: `2`, then `4`. **In Failure A it stayed at 0**, because the program never started. Here the program really starts every time, and each start counts as a restart. This is the clue that separates the two failures.
- `BackOff` again means Kubernetes waits longer between restarts: 10 seconds, 20, 40, and so on up to 5 minutes. The text `(35s ago)` tells you when the last restart happened.

### What is happening, step by step

1. Kubernetes starts the container.
2. The script runs. It finds `DATABASE_URL` missing, prints an error, and quits with `exit 1`.
3. Kubernetes sees the container stopped. By default it restarts containers that stop. So it starts it again.
4. The same thing happens. Again, and again, with longer waits.

In our story: the employee arrives, reads the instructions, finds a required item missing, walks out. The manager sends them back in. Same result, over and over.

> **What you now have:** a Pod in `CrashLoopBackOff`, with a growing `RESTARTS` count. We know **that** it crashes, but not **why**.

Click **Check**.
