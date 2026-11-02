## Step 3 of 10 - Detective A1: read the status

> **Where we are:** Failure A, investigation step 1 of 2.
> **What we know so far:** we created a Deployment called `pull-demo`. We have not looked at its Pod yet.
> **What we do now:** read the Pod's status, which is always the first thing to read.

### The detective's plan for Failure A

| # | Question | How we find out |
|---|---|---|
| 1 | What status is the Pod in? | `kubectl get pods` (this step) |
| 2 | What does Kubernetes say went wrong? | `kubectl describe pod`, read the Events (next step) |
| 3 | What is the cause? | Put the two clues together |
| 4 | Fix it, and prove it | Step 5 |

### Look at the Pod

```plain
kubectl get pods -n troubleshoot
```{{exec}}

**What this does.** It lists the Pods in the `troubleshoot` folder.

**What you should see.** Run it two or three times, a few seconds apart, because the status changes:

First you may see:

```
NAME                         READY   STATUS         RESTARTS   AGE
pull-demo-6c8d9f7b5-x2k4j    0/1     ErrImagePull   0          12s
```

A little later:

```
NAME                         READY   STATUS             RESTARTS   AGE
pull-demo-6c8d9f7b5-x2k4j    0/1     ImagePullBackOff   0          45s
```

### How to read it

- `READY 0/1` means the container is **not** ready.
- `STATUS ErrImagePull` means "I tried to download the image and failed".
- `STATUS ImagePullBackOff` means "I failed, so I am waiting before trying again". The word **BackOff** means that the waits between tries get longer: a few seconds, then more, up to five minutes. This stops the machine from hammering the download server.
- `RESTARTS 0` is zero because the program **never started**. Nothing was running to restart. Remember this. A Pod that never started and a Pod that keeps crashing are different problems, and the `RESTARTS` column is one clue that tells them apart.

### What we learned

The status words contain the word **Image**, and **Pull** means download. So the problem is with downloading the image. We still do not know **why** the download failed. The Pod's status only says that it did. The reason is written down somewhere else, which we read in the next step.

> **What you now know:** this is an image download problem, not a program problem. The program never started.

Click **Continue**.
