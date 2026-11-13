## Step 2 of 11 - Measure the floor

> **Where we are:** Part 1, Build.
> **What exists so far:** an empty folder called `scheduling`.
> **What we do now:** find out how many desks the machine `node01` has, and how many are already booked. We need these numbers to build the trap.

We will put all our Pods on `node01` only. That makes the floor small and the numbers predictable, just as the real incident happened on one small machine.

### How many desks does the floor have?

```plain
kubectl describe node node01 | grep -A6 "^Allocatable"
```{{exec}}

**What this does.** `kubectl describe node node01` prints a long report about the machine. The `|` (pipe) hands that report to `grep`, a search tool. `grep -A6 "^Allocatable"` finds the line starting with `Allocatable` and shows it plus the 6 lines After it.

**What you should see** (your numbers will differ):

```
Allocatable:
  cpu:                2
  ephemeral-storage:  ...
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             ...
  pods:               110
```

**How to read it.** `Allocatable` means "what is left for Pods to use, after the machine keeps some for itself". The machine's **Capacity** is everything it has. **Allocatable** is Capacity minus what is held back for the system. Look at the line `cpu`. A plain number like `2` means **2 full cores**, which is `2000m`. If you see something like `1900m`, that is already in millicores.

### How many desks are already booked?

```plain
kubectl describe node node01 | grep -A8 "^Allocated resources"
```{{exec}}

**What you should see:**

```
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                250m (12%)  0 (0%)
  memory             140Mi (7%)  170Mi (9%)
```

**How to read it.** Find the `cpu` row. The `Requests` column is the CPU **already booked** by Pods on this machine. These are Kubernetes' own system Pods. Only the `Requests` column matters for us, because that is what the scheduler counts.

### Work out the free desks

Write your two numbers down in millicores:

| | Your number |
|---|---|
| Allocatable CPU (convert cores to millicores: 2 means 2000m) | `______` m |
| Already booked (the `cpu` row, `Requests` column) | `______` m |
| **Free = Allocatable minus Booked** | `______` m |

Example: allocatable `2000m`, booked `250m`, so free = `1750m`.

### Choose the booking size for each Pod

We want a booking size, call it **R**, where **three Pods fit but a fourth does not**. That is the trap.

The rule: **R = Free divided by 3.5**, rounded down.

Check with the example. Free is `1750m`, so R = `1750 / 3.5 = 500m`.

- Three Pods need `3 x 500 = 1500m`. That is less than 1750m free, so they **fit**.
- A fourth Pod would need `4 x 500 = 2000m`. That is more than 1750m free, so it **does not fit**.

Work out **your own R** now and write it down. Your two checks must both be true: `3 x R` is less than your free number, and `4 x R` is more than it.

Why would a real team ever book so much? In the real incident, the bookings were copied from the example numbers of a large production cluster, and nobody resized them for the small machine. Plenty of real setups copy bookings the same way.

> **What you now have:** your three numbers (allocatable, booked, free) and a booking size R that sets the trap.

Click **Continue**.
