## Step 5 of 11 - Booked versus actually used

**Progress:** ▰▰▰▰▰▱▱▱▱▱▱ Part 1 of 4: Build

> **Where we are:** Part 1, Build. The last build step.
> **What exists so far:** three healthy Pods, with the floor about 87% booked.
> **What we do now:** look at how much CPU the Pods **really use**, so you see the gap between booking and usage.

### Why this matters

Everything in this lab depends on one fact: **booked is not the same as used**. Here is how to see real usage for yourself.

### Read the CPU a Pod has really used

```plain
kubectl exec -n scheduling $(kubectl get pods -n scheduling -o name | head -n 1) -- cat /sys/fs/cgroup/cpu.stat
```{{exec}}

**What this does, piece by piece:**

- `kubectl get pods -n scheduling -o name | head -n 1` lists the Pod names and keeps only the first one.
- `kubectl exec ... -- cat /sys/fs/cgroup/cpu.stat` runs the command `cat` (print a file) **inside** that Pod. The file `cpu.stat` is the machine's own running tally of CPU used by that container. (It lives in something called a **cgroup**, the Linux feature that measures and limits what each container uses.)

**What you should see** (the numbers will differ):

```
usage_usec 14250
user_usec 9800
system_usec 4450
nr_periods 0
...
```

**How to read it.** `usage_usec` is the **total CPU time this container has used since it started, in microseconds** (millionths of a second). In the example, `14250` is about **14 milliseconds** of work. The Pod has been running for a few minutes, so that is a tiny fraction of one second out of hundreds. Idle Nginx uses almost nothing.

Now compare:

| | Amount |
|---|---|
| What the Pod **booked** (request) | R millicores, for example 500m, half of a core |
| What the Pod **really used** | roughly 0m: a few thousandths of a second in total |

The Pod has reserved half a desk and is barely sitting down.

> If the command says `No such file or directory`, your machine uses an older layout for these files. You can skip this step, because the point stands anyway: an idle web server uses almost no CPU, however much it booked. In the real incident, the monitoring system Prometheus measured the real usage.

### The lesson

The scheduler will **never see** this tiny usage. It only counts the booking. So for the scheduler, `node01` is about 87% full. For reality, it is nearly empty. Next, we release a new version and watch that gap cause trouble.

> **What you now have:** proof that the booking is far bigger than the real use.

Click **Continue**.
