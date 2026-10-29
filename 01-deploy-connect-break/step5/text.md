## Step 5 - Call the Service from inside the cluster

The Service is ClusterIP, so it can only be reached from inside the cluster. To test it, you need a program running inside the cluster to make the request. You will start a tiny helper Pod that does nothing but wait, and then run commands from it.

### Start the helper Pod

```plain
kubectl run client -n learning --image=curlimages/curl --restart=Never --command -- sleep 3600
```{{exec}}

**What it does, piece by piece:**

- `kubectl run client` creates a single Pod named `client`.
- `-n learning` puts it in your namespace.
- `--image=curlimages/curl` uses a small image that contains `curl`, a tool for making web requests.
- `--restart=Never` means "if it stops, leave it stopped". Without it, Kubernetes would keep restarting the container every time it exited, which is the normal behaviour for long-running applications but not what a throwaway helper needs.
- `--command -- sleep 3600` replaces the image's default program with `sleep 3600`, which just waits for an hour. Without it, the container would start, finish immediately, and exit. The `--` separates `kubectl`'s own options from the command that runs inside the container.

**What you should see:**

```
pod/client created
```

### Wait until it is ready

```plain
kubectl wait -n learning --for=condition=Ready pod/client --timeout=90s
```{{exec}}

**What it does.** It pauses until the Pod is Ready, or gives up after 90 seconds. This saves you from typing `get pods` repeatedly.

**What you should see:** `pod/client condition met`

### Make the request

```plain
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

**What it does, piece by piece:**

- `kubectl exec` runs a command **inside** an existing Pod, like opening a terminal in it.
- `-n learning client` says which namespace and which Pod.
- The `--` separates `kubectl`'s options from the command to run.
- `curl -sI http://web-service` is the command that runs inside the client Pod. `-s` means silent (no progress bar). `-I` means ask only for the response **headers**, the short summary lines, rather than the whole page. `http://web-service` is the address: the Service's name.

**What you should see:**

```
HTTP/1.1 200 OK
Server: nginx/1.xx.x
Date: Thu, 29 Oct 2026 10:00:00 GMT
Content-Type: text/html
Content-Length: 615
Connection: keep-alive
```

**How to read it.** The first line is the important one. `HTTP/1.1 200 OK` means "the request worked". HTTP is the language web servers and clients speak, and `200` is its code for success. `Server: nginx` proves your Nginx Pod answered, so the request really did reach one of your three Pods.

### What just happened, step by step

You typed only a name, `web-service`. Here is the journey of that one request:

1. The `curl` program asked the cluster's DNS (`coredns`) "what address belongs to `web-service`?".
2. CoreDNS answered with the Service's permanent ClusterIP address.
3. `curl` sent the request to that address.
4. `kube-proxy`, which had set up forwarding rules on the node, noticed the request was for a Service address and redirected it to one of the three Pod addresses from the endpoints list.
5. That Nginx Pod answered, and the answer travelled back.

The name worked without a namespace because the client Pod is in the same namespace as the Service. From another namespace you would use `web-service.learning`.

Click **Check** once you have seen `200 OK`.
