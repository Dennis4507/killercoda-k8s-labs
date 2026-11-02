## Step 8 of 16 - See who the Service sends callers to

> **Where we are:** Part 1, Build.
> **What exists so far:** three Pods wearing `app=web-app`, and a Service whose rule is "send callers to `app=web-app`".
> **What we do now:** look at the desk's list of employees, and see that it matches the Pods. **This is the most important step to understand.**

### How the desk finds its employees

The moment you created the Service, Kubernetes did this on its own:

1. Read the desk's rule: "badge `app=web-app`".
2. Look through every Pod in the folder for that badge.
3. Write down the **address of every Pod wearing it**. That written list is called the **endpoints**.

The list is kept up to date automatically. When a Pod is replaced, the list changes.

### First, the Pods' current addresses

```plain
kubectl get pods -n learning -o wide
```{{exec}}

Look at the `IP` column and note the three addresses. For example: `192.168.1.5`, `192.168.0.6`, `192.168.1.7`.

### Now, the desk's list

```plain
kubectl get endpoints web-service -n learning
```{{exec}}

**What you should see:**

```
NAME          ENDPOINTS                                          AGE
web-service   192.168.0.6:80,192.168.1.5:80,192.168.1.7:80       2m
```

(Newer Kubernetes may print a short warning that "Endpoints is deprecated". That is only a notice that a newer type of list is replacing this one. The information is the same, so ignore the warning.)

**How to read it.** The `ENDPOINTS` column has three addresses, each followed by `:80`. The `:80` is the door on the Pod. **Compare these three addresses with the three Pod addresses you just noted. They are the same three.**

That is the whole mechanism:

> The Service did not memorise the Pods by name. It looked for Pods wearing `app=web-app` and wrote down their addresses.

### What would a broken one look like?

If the list were empty, the `ENDPOINTS` column would say `<none>`. That would mean "the desk found nobody wearing the badge". The desk would have nobody to send callers to, and every call would fail. **Remember what `<none>` means here, because we will see it soon.**

> **What you now have:** a working desk whose list of three employees matches your three Pods.

Click **Check** when you can see three addresses.
