## Step 5 of 16 - Watch a Pod die and come back

> **Where we are:** Part 1, Build.
> **What exists so far:** three healthy Pods in `learning`, each with its own address and the badge `app=web-app`.
> **What we do now:** delete one Pod on purpose, and see why having only the Pods is not enough.

This step explains **why we need a reception desk** at all. Read it carefully, because it makes the next steps make sense.

### Look at the addresses now

```plain
kubectl get pods -n learning -o wide
```{{exec}}

Pick any one Pod and note its **name** and its **IP address**. For example, `web-app-7d9c6b5f4d-abcde` with `192.168.1.4`.

### Delete one Pod

```plain
kubectl delete pod -n learning $(kubectl get pods -n learning -o name | head -n 1)
```{{exec}}

**What this does.** It has two parts. The inner part, `kubectl get pods -n learning -o name | head -n 1`, lists the Pod names and keeps only the first one. The outer part, `kubectl delete pod -n learning ...`, deletes whichever name the inner part found. So it deletes one Pod, the first in the list.

**What you should see:**

```
pod "web-app-7d9c6b5f4d-abcde" deleted
```

It may take a few seconds to finish, because Kubernetes lets the program shut down politely.

### Look again, straight away

```plain
kubectl get pods -n learning -o wide
```{{exec}}

**What you should see:**

```
NAME                       READY   STATUS    RESTARTS   AGE    IP            NODE
web-app-7d9c6b5f4d-fghij   1/1     Running   0          3m     192.168.1.5   node01
web-app-7d9c6b5f4d-klmno   1/1     Running   0          3m     192.168.0.6   controlplane
web-app-7d9c6b5f4d-pqrst   1/1     Running   0          10s    192.168.1.7   node01
```

**How to read it.**

- There are still **three** Pods. The manager (the Deployment) noticed one employee was missing and hired a replacement straight away. That is the Deployment doing its job.
- But look at the new Pod. It has a **new name** (`...-pqrst`) and a **new IP address** (`192.168.1.7`). It is **not** the same address as the Pod you deleted.

### Why this matters

Pods come and go. They can crash, be moved to another machine, or be replaced during an update. Every replacement gets a **new address**. If another program had saved the old address, it would now be calling an empty chair.

So we need something with **one fixed address that never changes**, which always knows who the current employees are. That is the reception desk, a **Service**. We build it next.

> **What you now have:** the same three Pods as before, but one is brand new. You have seen that Pod addresses are not reliable. This is the reason Services exist.

Click **Continue**.
