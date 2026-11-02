## Step 9 of 16 - Start a helper Pod

> **Where we are:** Part 1, Build.
> **What exists so far:** three Pods, and a Service whose list of three employees matches them.
> **What we do now:** start a small extra Pod whose only job is to phone the Service for us.

### Why we need a helper

The Service's phone number only works from **inside** the cluster. Your terminal is outside it. So we start a tiny Pod inside the cluster, and from it we make the phone call. In our story, this is someone else in the building picking up a phone.

### Start it

```plain
kubectl run client -n learning --image=curlimages/curl --restart=Never --command -- sleep 3600
```{{exec}}

**What this does, piece by piece:**

- `kubectl run client` makes one Pod and names it `client`.
- `-n learning` puts it in our folder.
- `--image=curlimages/curl` chooses a small program package that contains **curl**, a tool that makes web requests, like a browser with no screen.
- `--restart=Never` means "if it stops, do not restart it". Without this, Kubernetes would restart it every time it ended, which we do not want for a throwaway helper.
- `--command -- sleep 3600` says "the only thing to do is wait for an hour". Without it, the program would start, have nothing to do, and exit at once. The `--` separates `kubectl`'s own options from the command that runs in the Pod.

**What you should see:**

```
pod/client created
```

### Wait until it is ready

```plain
kubectl wait -n learning --for=condition=Ready pod/client --timeout=90s
```{{exec}}

**What this does.** It pauses until the `client` Pod is ready, or gives up after 90 seconds. It saves you from running `get pods` over and over.

**What you should see:**

```
pod/client condition met
```

> **What you now have:** a helper Pod called `client`, waiting inside the cluster, ready to make calls.

Click **Check**.
