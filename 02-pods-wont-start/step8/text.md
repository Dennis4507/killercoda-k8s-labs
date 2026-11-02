## Step 8 of 10 - Detective B1: read the logs

> **Where we are:** Failure B, investigation step 1 of 2.
> **What we know so far:** the Pod is in `CrashLoopBackOff`, and the restart count keeps growing. So the program **starts**, then **stops**.
> **What we do now:** ask the program itself why it stopped, by reading its logs.

### The detective's plan for Failure B

| # | Question | How we find out |
|---|---|---|
| 1 | What status is the Pod in, and is `RESTARTS` growing? | `kubectl get pods` (done in step 7) |
| 2 | What did the program say before it stopped? | `kubectl logs` (this step) |
| 3 | How exactly did it stop? | `kubectl describe pod`, read the exit code (next step) |
| 4 | Fix it, and prove it | Step 10 |

### What logs are

A program usually prints messages as it runs: what it is doing, and any errors. Those printed messages are the **logs**. When a program crashes, the last lines it printed very often say why.

### The command

```plain
kubectl logs -n troubleshoot -l app=crash-demo
```{{exec}}

**What this does.** `kubectl logs` prints what the program has written. `-l app=crash-demo` picks the Pod by its label, so you do not have to copy the Pod's long name.

**What you should see:**

```
Starting application...
ERROR: DATABASE_URL is not set. Cannot start.
```

**How to read it.**

- The first line is the program's own start-up message, so it did start.
- The second line is **the answer**: `DATABASE_URL is not set`. The program told us exactly what it needed and did not get.

### If you see a message about the container "waiting to start"

If `kubectl logs` says the container is waiting, ask for the logs of the **previous run** instead:

```plain
kubectl logs -n troubleshoot -l app=crash-demo --previous
```{{exec}}

`--previous` means "show the logs from the run that just crashed, not the one being set up". This is the version to remember for crash loops, because the current attempt may not have printed anything yet, but the previous one has.

### The cause, in one sentence

> "The program exits because it requires an environment variable called `DATABASE_URL`, and the Pod was not given one."

Notice how different this is from Failure A. There the clue was in the **Events** (the cluster's diary). Here the clue is in the **logs** (the program's own words). Both are places to look, and the status tells you which.

| Status | Where the clue is |
|---|---|
| `ImagePullBackOff` | Events (`kubectl describe pod`) |
| `CrashLoopBackOff` | Logs (`kubectl logs`), then Events and exit code |

> **What you now know:** the program is not broken. It is missing a setting.

Click **Continue**.
