## Step 10 of 16 - Call the Service

> **Where we are:** Part 1, Build. This is the last build step.
> **What exists so far:** three Pods, a Service with three employees on its list, and a helper Pod called `client`.
> **What we do now:** make the helper phone the Service by name, and see a successful answer.

### Make the call

```plain
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

**What this does, piece by piece:**

- `kubectl exec` means "run a command **inside** an existing Pod", like sitting at that Pod's keyboard.
- `-n learning client` says which folder and which Pod.
- `--` separates `kubectl`'s own options from the command to run.
- `curl -sI http://web-service` is the command that runs inside the helper. `-s` means silent, so no progress bar. `-I` means "ask only for the short summary lines at the top of the answer (the headers)" instead of the whole web page. `http://web-service` is where to call: the Service **by name**.

**What you should see:**

```
HTTP/1.1 200 OK
Server: nginx/1.27.0
Date: Mon, 02 Nov 2026 10:00:00 GMT
Content-Type: text/html
Content-Length: 615
Connection: keep-alive
```

**How to read it.** The first line matters most. **HTTP** is the language web programs speak. `200 OK` is its code for "yes, that worked". The line `Server: nginx` proves the answer really came from one of your Nginx Pods.

### What happened, one step at a time

You typed only the name `web-service`. Here is the journey of that one call:

1. The helper asked the cluster's phone book (**DNS**, run by the `coredns` Pods you saw in step 1): "what number is `web-service`?"
2. The phone book replied with the Service's fixed phone number (the `CLUSTER-IP` from step 7).
3. The helper called that number.
4. The Service checked its list of employees (the endpoints from step 8) and picked one.
5. That Nginx Pod answered, and the reply came back: `200 OK`.

If you run the command several times, different Pods answer, because the Service shares calls between everyone on its list.

The name `web-service` worked on its own because the helper is in the same folder (`learning`) as the Service. From another folder you would write `web-service.learning`.

> **What you now have:** a complete, working chain: helper, then phone book, then Service, then one of three Pods, then `200 OK`.

Click **Check** once you have seen `200 OK`.
