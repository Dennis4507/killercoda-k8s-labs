## Step 9 of 11 - Detective 3: why nothing can move

> **Where we are:** Part 3, Detective. Step 3 of 3.
> **What we know so far:** the scheduler says `Insufficient cpu` on `node01`, but real usage is almost zero.
> **What we do now:** look at the floor's bookings once more, then look at the update rules, and see why the freeze never ends by itself.

### Part 1: the floor's bookings

```plain
kubectl describe node node01 | grep -A6 "^Allocated resources"
```{{exec}}

**What you should see** (same as step 4, since the Pending Pod books nothing yet):

```
  Resource           Requests      Limits
  --------           --------      ------
  cpu                1750m (87%)   0 (0%)
```

**How to read it.** `node01` has about 87% of its allocatable CPU booked. Using the example numbers: free is `2000m - 1750m = 250m`. The new Pod needs `500m`. Since `250m` is less than `500m`, the new Pod does not fit.

Now put it side by side with step 5:

| | Amount |
|---|---|
| CPU **booked** (what the scheduler counts) | about 87% of the machine |
| CPU **really used** (what is actually happening) | almost 0% |

**The machine is full on paper and empty in reality.** This is the heart of the incident. In the real case, the machine's real CPU use was about 15%, while its bookings were at 100%.

### Part 2: why the old Pods do not make room

An obvious question: why not simply remove an old Pod, which would free `R` and let the new one in? Look at the update rules:

```plain
kubectl get deployment web -n scheduling -o jsonpath='{.spec.strategy}'
```{{exec}}

**What this does.** `-o jsonpath='{...}'` prints just one part of the object. Here, the `strategy` section.

**What you should see:**

```
{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}
```

### The circular wait (a deadlock)

Read the rules again: `maxUnavailable: 0` means "never drop below 3 working Pods". So the manager is **not allowed to release an old employee until a new one is working**.

Now follow the loop:

1. The new Pod cannot start, because there is no free booking for it.
2. Free booking can only appear if an old Pod is removed.
3. An old Pod cannot be removed until the new Pod is working.
4. Back to 1.

Each side waits for the other. Nothing will ever change by itself. That is a **deadlock**: it is the same one that froze the real update for over six hours. It does not come from a bug. It comes from arithmetic: three bookings fit, but a fourth does not, and the update needs a fourth.

### The diagnosis, in one sentence

> "The rolling update needs room for one extra Pod while the three old ones are still running, but `node01` is almost fully booked by CPU **requests**, even though real CPU use is near zero, so the new Pod stays `Pending` and the old Pods can never be released."

> **What you now know:** the exact cause. The CPU requests are far bigger than real use, and the update rules need room for one extra Pod.

Click **Continue**.
