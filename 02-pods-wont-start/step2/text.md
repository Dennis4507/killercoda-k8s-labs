## Step 2 of 10 - Failure A: hire an employee with a wrong address

> **Where we are:** Failure A, the Pod that never gets started.
> **What exists so far:** an empty folder called `troubleshoot`.
> **What we do now:** create a Deployment with a small mistake: a typo in the name of the program to download.

### The command

```plain
kubectl create deployment pull-demo --image=nginx:stabel -n troubleshoot
```{{exec}}

**What this does, piece by piece:**

- `kubectl create deployment pull-demo` makes a **Deployment** called `pull-demo`. A Deployment is the manager that keeps the wanted number of Pods running. This command is a shortcut that writes the plan for you. In Lab 1 you wrote that plan by hand as a file. The result is the same.
- `--image=nginx:stabel` says which program package to run. An image name has two parts: the name, `nginx`, then a colon, then the **tag**, which is the version label. Here the tag is `stabel`.
- `-n troubleshoot` puts it in our folder.

**Here is the mistake.** The correct tag is `stable`. We typed `stabel` instead, with the letters swapped. This is a very common real-world slip, and there is no tag called `stabel`, so the download will fail.

**What you should see:**

```
deployment.apps/pull-demo created
```

Notice that Kubernetes happily accepted the command. It cannot tell the tag is wrong until it actually tries to download the image. So Kubernetes does not warn you at this point.

> **What you now have:** a Deployment called `pull-demo` that is trying to start one Pod from an image that does not exist. We have not looked at the result yet.

Click **Check**.
