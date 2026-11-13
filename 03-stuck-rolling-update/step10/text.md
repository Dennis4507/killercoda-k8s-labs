## Step 10 of 11 - Choose the fix

**Progress:** ▰▰▰▰▰▰▰▰▰▰▱ Part 4 of 4: Fix

> **Where we are:** Part 3, Fix.
> **What we know:** bookings leave no room for a fourth Pod, and the update rules need one extra Pod.
> **What we do now:** think about the possible fixes, and choose one. No commands in this step. Read and decide.

A good engineer does not grab the first fix. They list the options and pick the one that attacks the **cause**.

### The options

| Option | What it does | Good | Bad |
|---|---|---|---|
| **A. Right-size the bookings** (shrink `requests`) | Book what the Pods really need. | Fixes the **cause**. Leaves room for updates and for other workloads. | You must know what the Pods really use. |
| **B. Change the update rules** (`maxSurge: 0`, `maxUnavailable: 1`) | Release one old Pod first, then start its replacement. | Needs no extra room. | For a short time there are only 2 working Pods. Risky if capacity is thin. Hides the oversized bookings. |
| **C. Add capacity** (another machine) | Give the scheduler more room. | Works quickly. | Costs money and leaves the oversized bookings in place. |

### What the real incident used

In the real incident, the fix was **Option A**. Each service's CPU booking was resized based on what Prometheus actually measured it using, instead of the example values that had been copied in. That cut the total booked per generation from `1500m` to `550m` on a machine with `2000m` of allocatable CPU, which comfortably left room for two generations of Pods at once.

### Choosing how much to book

Normally you would **measure** real usage over time, with a monitoring tool such as Prometheus, or `kubectl top` if the metrics server is installed. Then you book a bit above typical usage, with some safety margin.

Here, idle Nginx uses almost nothing, so we will cut the booking to **one third** of R. That is still generous for the real use, and it is small enough that the update fits.

### Check the maths before you run anything

With the example numbers: R is `500m`. One third is about `166m`.

- Three Pods then book `3 x 166 = 498m`.
- The floor's free space is then roughly `2000m - 250m - 498m = 1252m`.
- One extra Pod of `166m` fits easily, so the update has room to move.

### One subtle thing to expect

In the real incident, Pods that were **already running** with the old, bigger booking did not release it just because the configuration changed. Only replacing them does. In our lab, the update itself replaces them, so this will happen on its own. In the real incident, one manual deletion was needed once, because the old generation was the one blocking everything.

> **What you now have:** a chosen fix (Option A, one third of R), with the maths checked.

Click **Continue**.
