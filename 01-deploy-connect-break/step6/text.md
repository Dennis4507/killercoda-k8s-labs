## Step 6 - Break the Service on purpose

Everything works. Now you will cause one of the most common real Kubernetes faults: a Service whose selector no longer matches any Pod's label. This happens in real life through a typo, a renamed label, or a copy-and-paste mistake.

### Make the change

```plain
kubectl patch service web-service -n learning -p '{"spec":{"selector":{"app":"wrong-app"}}}'
```{{exec}}

**What it does.** `kubectl patch` changes part of an existing object without rewriting the whole file. `-p` supplies the change, written as JSON (another text format, like YAML with braces). The change reads: inside `spec`, inside `selector`, set `app` to `wrong-app`. The Service now looks for Pods labelled `app=wrong-app`, and no such Pods exist.

**What you should see:**

```
service/web-service patched
```

### Notice what did NOT change

```plain
kubectl get pods -n learning
```{{exec}}

You should still see your three `web-app` Pods, all `1/1 Running`, plus the `client`. Nothing happened to the Pods. They are healthy, and Nginx inside them is still running perfectly. Only the connection **from the Service to the Pods** broke. Keep this in mind, because it is the essence of the failure: healthy applications behind a broken pointer.

### See the failure

```plain
kubectl exec -n learning client -- curl -v --max-time 5 http://web-service
```{{exec}}

**What it does.** The same request as before, but with `-v` (verbose, meaning "show every step") and `--max-time 5` (give up after five seconds instead of waiting forever).

**What you should see.** Most likely a quick refusal:

```
* Host web-service:80 was resolved.
* IPv4: 10.96.x.x
*   Trying 10.96.x.x:80...
* connect to 10.96.x.x port 80 failed: Connection refused
curl: (7) Failed to connect to web-service port 80 ...: Couldn't connect to server
```

On some setups the request instead hangs and ends with `curl: (28) Connection timed out after 5000 milliseconds`. Both mean the same thing here.

**How to read it.** Look at the first lines: `Host web-service:80 was resolved` followed by an IP address. That means the **name lookup worked**, so DNS is fine. The failure comes later, when connecting. You have already eliminated one whole category of problem just by reading the output carefully.

So the picture is: the name resolves, the Pods are healthy, yet the connection fails. In the next step you will find out why. Before you move on, think about which part of the chain, name to Service to endpoints to Pods, could be broken.

Click **Check** once you have run the failing request.
