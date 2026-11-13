## Step 8 of 11 - Detective 2: read the scheduler's reason

> **Where we are:** Part 3, Detective. Step 2 of 3.
> **What we know so far:** the new Pod is `Pending`: it has not been placed on any machine.
> **What we do now:** ask the scheduler why. It writes its reasons down as Events.

### What an Event is

Kubernetes keeps a diary. Each line is an **Event**: a short note saying what happened and why. When the scheduler cannot place a Pod, it writes the reason as an Event with the label `FailedScheduling`.

### The command

```plain
kubectl get events -n scheduling --field-selector reason=FailedScheduling
```{{exec}}

**What this does.** `kubectl get events` lists the diary notes in the `scheduling` folder. `--field-selector reason=FailedScheduling` keeps only the notes where the reason is a failure to place a Pod.

**What you should see:**

```
LAST SEEN   TYPE      REASON             OBJECT                  MESSAGE
90s         Warning   FailedScheduling   pod/web-7c4d6f9b8-n8w2j 0/2 nodes are available: 1 Insufficient cpu, 1 node(s) didn't match Pod's node affinity/selector. preemption: 0/2 nodes are available: ...
```

### How to read the message, piece by piece

**`0/2 nodes are available`** means "I checked 2 machines, and none of them can take this Pod".

**`1 Insufficient cpu`** is **the answer**. One machine, `node01`, does not have enough **unbooked** CPU for this Pod's request. The scheduler counted the bookings. The bookings left no room for one more Pod of size R.

**`1 node(s) didn't match Pod's node affinity/selector`** is the other machine, `controlplane`. It was ruled out for a different reason: our `nodeSelector` said "only `node01`". That one is our own choice, not a problem.

**`preemption: ...`** is the scheduler saying it also checked whether it could evict (push out) some less important Pod to make room, and found nothing it was allowed to evict. You can ignore that part.

### What we learned

The scheduler says **`Insufficient cpu`**. But in step 5 you saw that the Pods use almost no CPU. So how can the machine be "out of CPU"?

The answer is that the scheduler is not talking about usage. It is talking about **bookings**. That is what step 9 shows.

> **What you now know:** the new Pod is Pending because the scheduler says `node01` has insufficient CPU, which means insufficient **unbooked** CPU.

Click **Continue**.
