## Step 1 of 11 - The desk-booking story

> **Where we are:** Part 1, Build.
> **What exists so far:** an empty cluster with two machines.
> **What we do now:** learn four words, then make a folder (namespace) for our work.

### Four words, in plain English

**CPU** (Central Processing Unit) is the machine's thinking power. Kubernetes measures it in **millicores**. One full CPU core is `1000m`. The `m` means "milli", a thousandth. So `500m` is half a core, and `100m` is a tenth of a core.

In the office story, think of a floor with a number of desks. `1000m` is one full desk's worth of thinking power.

A Pod can say three different things about CPU:

| Word | What it means | In the story |
|---|---|---|
| **Request** | "Please reserve this much for me." | Booking desks for an employee. |
| **Limit** | "Never let me use more than this." | A hard ceiling, like a locked door. |
| **Usage** | How much CPU the program is really using right now. | How many desks the employee is actually sitting at. |

### The most important rule in this lab

When the **scheduler** decides which machine a new Pod goes on, it adds up the **requests** (bookings) on each machine. It places the Pod only if enough is left unbooked. **It does not look at real usage.**

That means a machine can be 100% booked and 5% used at the same moment. To the scheduler it is full. In reality it is nearly empty. Keep that picture in mind, because the incident hinges on it.

### Make a folder for our work

A **namespace** is a named area of the cluster, like a folder.

```plain
kubectl create namespace scheduling
```{{exec}}

**What you should see:**

```
namespace/scheduling created
```

From now on, nearly every command ends with `-n scheduling`. The `-n` means "in this namespace". If you leave it off, `kubectl` looks in the wrong folder and says `No resources found`.

> **What you now have:** a folder called `scheduling`, and the key rule: the scheduler counts bookings, not real usage.

Click **Check**.
