## Step 3 - Break the Service on purpose

Change the Service's selector to a label no Pod has:

```plain
kubectl patch service web-service -n learning -p '{"spec":{"selector":{"app":"wrong-app"}}}'
```{{exec}}

Nothing happened to the Pods. They are still running and healthy. Prove it:

```plain
kubectl get pods -n learning
```{{exec}}

Now call the Service again. It should fail or hang. The `--max-time 5` stops waiting after five seconds:

```plain
kubectl exec -n learning client -- curl -v --max-time 5 http://web-service
```{{exec}}

Healthy Pods, but no working connection. Before the next step, think: what are the possible reasons? (Name lookup? The Pods? The Service?)

Click **Check** once you have run the failing request.
