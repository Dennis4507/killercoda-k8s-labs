## Step 7 of 11 - Detective 1: see the symptom

> **Where we are:** Part 3, Detective. Step 1 of 3 in the investigation.
> **What we know so far:** the update froze. Nothing crashed.
> **What we do now:** look at the Pods and the ReplicaSets, and see exactly what is stuck.

### The detective's plan

| # | Question | How we find out |
|---|---|---|
| 1 | Which Pods are stuck, and in what status? | `kubectl get pods` (this step) |
| 2 | Why does the scheduler say it cannot place the stuck Pod? | The scheduler's event message (step 8) |
| 3 | Is the machine really out of CPU, and why can nothing move? | The node's bookings, and the update rules (step 9) |
| 4 | Pick and apply a fix, and prove it | Steps 10 and 11 |

### Look at the Pods

```plain
kubectl get pods -n scheduling
```{{exec}}

**What you should see:**

```
NAME                   READY   STATUS    RESTARTS   AGE
web-6b9f8d7c5-4kx2p    1/1     Running   0          8m
web-6b9f8d7c5-9mt7q    1/1     Running   0          8m
web-6b9f8d7c5-zl5vw    1/1     Running   0          8m
web-7c4d6f9b8-n8w2j    0/1     Pending   0          2m
```

**How to read it.**

- **Four Pods.** Three are the old ones, `Running`, with the same names and ages as before. They are still serving.
- **One new Pod**, with a different middle code (`7c4d6f9b8`), is `0/1 Pending`. `Pending` means the Pod exists on paper, but **no machine has been chosen to run it**.
- `RESTARTS 0` is zero because the program never even started. This is not a crash.

Compare with Lab 2: there, a Pod stuck in `ImagePullBackOff` had been placed on a machine but could not get its program. Here the Pod has **not even been placed**. That is the difference, and `Pending` is the word that tells you.

### Look at the ReplicaSets

```plain
kubectl get replicasets -n scheduling
```{{exec}}

**What you should see:**

```
NAME             DESIRED   CURRENT   READY   AGE
web-6b9f8d7c5    3         3         3       8m
web-7c4d6f9b8    1         1         0       2m
```

**How to read it.** A **ReplicaSet** is the object that keeps a fixed number of Pods alive. Each version of the Deployment gets its own. The **old** one (`6b9f8d7c5`) wants 3, has 3, and all 3 are ready. The **new** one (`7c4d6f9b8`) wants 1, has 1, but **0 are ready**. This matches the story: the manager hired one new employee first, and that employee cannot be seated.

### What we learned

One new Pod is `Pending`, and the three old Pods are healthy and are not being removed. The question for step 8 is why that new Pod has not been placed.

> **What you now know:** the stuck Pod is the new one, and it is `Pending`, not crashed.

Click **Continue**.
