## Step 1 of 10 - How a Pod starts, and what its status words mean

> **Where we are:** Getting ready.
> **What exists so far:** an empty cluster with two machines.
> **What we do now:** make a folder for our work, and learn the words Kubernetes uses to describe a Pod's progress.

### Make a folder (a namespace)

A **namespace** is a named area of the cluster, like a folder, that keeps your things separate from Kubernetes' own parts.

```plain
kubectl create namespace troubleshoot
```{{exec}}

**What you should see:**

```
namespace/troubleshoot created
```

From now on, nearly every command ends with `-n troubleshoot`. The `-n` means "in this namespace". If you forget it, `kubectl` looks in the wrong folder and says `No resources found`.

### The life of a Pod, in order

When you ask Kubernetes for a Pod, it goes through stages. Each stage has a word in the `STATUS` column. Here is the happy path:

| Status word | What it means in plain English |
|---|---|
| `Pending` | The Pod exists on paper, but no machine has been picked to run it yet. |
| `ContainerCreating` | A machine was picked. It is now downloading the program and getting ready. |
| `Running` | The program has started. This is the goal. |

### The unhappy words

These are the words that tell you something went wrong. You will meet the first two in this lab.

| Status word | What it means in plain English |
|---|---|
| `ErrImagePull` | The machine tried to download the program and failed. |
| `ImagePullBackOff` | It failed to download, so it is waiting a while before trying again. "Back off" means "wait longer between tries". |
| `CrashLoopBackOff` | The program started, then stopped. Kubernetes restarted it, and it stopped again. It is now waiting longer between restarts. |
| `Error` | The program stopped with a failure. |
| `Completed` | The program finished its job and stopped normally. |

### The columns to watch

Whenever you run `kubectl get pods`, look at three columns first:

- **READY** such as `1/1`. It means "how many containers are ready, out of how many". `0/1` means not ready.
- **STATUS**, the words above.
- **RESTARTS**, how many times the program was restarted. A number that keeps growing is a warning sign.

> **What you now have:** a folder called `troubleshoot`, and the vocabulary to read a Pod's status.

Click **Check**.
