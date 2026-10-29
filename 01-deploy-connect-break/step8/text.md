## Step 8 - Repair and prove it

The fix is to make the Service's selector match the Pods' label again.

### Apply the fix

```plain
kubectl patch service web-service -n learning -p '{"spec":{"selector":{"app":"web-app"}}}'
```{{exec}}

**What it does.** The same `patch` command as in step 6, but setting the selector back to `app=web-app`.

**What you should see:** `service/web-service patched`

### Prove the backends are back

```plain
kubectl get endpoints web-service -n learning
```{{exec}}

You should see **three addresses again**, the same three Pod addresses as in step 4. Kubernetes noticed the selector change and rebuilt the endpoint list within a second or two. If it still shows `<none>`, wait a few seconds and run it again.

### Prove the request works

```plain
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

You should see `HTTP/1.1 200 OK` again. The fault is repaired, and you proved it two ways: the endpoint list is full and a real request succeeds. Always verify a fix with real traffic, not just by trusting that the change was applied.

Click **Check**.
