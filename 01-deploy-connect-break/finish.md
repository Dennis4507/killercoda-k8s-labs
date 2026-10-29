# Done - what you learned

You built and then repaired a small application, and along the way you saw how the pieces connect:

```
Deployment  ->  ReplicaSet  ->  Pods (carry the label app=web-app)
                                   ^
Service (selector app=web-app) ----+   finds Pods by label, lists them as endpoints
   ^
client asks DNS for "web-service", gets the Service address, kube-proxy forwards to an endpoint
```

## The debugging method to keep

When a Service does not answer, walk the path the request takes and ask one question at each point:

1. **Does the name resolve?** Read the verbose `curl` output.
2. **Does the Service have endpoints?** Run `kubectl describe service` and read `Selector` and `Endpoints`.
3. **Do the Pods carry the label the Service wants?** Run `kubectl get pods --show-labels`, or `kubectl get pods -l <selector>`.
4. **Are the Pods healthy?** Check the `READY` and `STATUS` columns.
5. Only then look at ports (`targetPort`), network rules, and the application itself.

## The one sentence to remember

If the Pods are healthy but the Service does not answer, the first suspect is **a label that does not match the selector**, and the fastest clue is an empty `Endpoints` list.

## Try it yourself

Without looking back, try breaking a different part and fixing it: change `targetPort` to `8080` and see how the failure differs. (Hint: the endpoints will still be full this time, so the evidence points somewhere else. What does that tell you?)
