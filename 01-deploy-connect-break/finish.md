# Done - what you learned

## The whole picture, in one drawing

```
Deployment (the manager: "keep 3 employees")
     |
     v
3 Pods (employees), each wearing the badge  app=web-app
     ^
     |  finds them by badge
Service (the reception desk)  --  rule (selector): "badge app=web-app"
     ^                             list (endpoints): the 3 Pod addresses it found
     |  phones by name
helper Pod  -->  DNS (phone book) turns "web-service" into the desk's fixed number
```

## The story in plain sentences

Pods come and go, and each new one gets a new address. So we put a Service in front of them. The Service has one fixed address and a rule that finds the Pods by their label. It keeps a list of the Pods' current addresses, called the endpoints, and sends each call to one of them.

If the Service's rule does not match the Pods' labels, the list is empty, and every call fails even though the Pods are perfectly healthy.

## The detective method to keep

When a Service does not answer, ask these questions in order:

1. **Does the name resolve?** Read the failed call with `curl -v`. If it shows a number, DNS is fine.
2. **What is the Service looking for, and is its list empty?** Run `kubectl describe service`. Read `Selector` and `Endpoints`.
3. **What badges do the Pods wear?** Run `kubectl get pods --show-labels`.
4. **Do they match? Prove it.** Run `kubectl get pods -l <the Service's selector>`.
5. **Fix the side that is wrong, then prove the fix with a real call.**

## One sentence to remember

Healthy Pods plus a Service that will not answer usually means the **label and the selector do not match**, and the fastest clue is `Endpoints: <none>`.

## Try it yourself

Without looking back, try a second break and see how the clues change. Run this:

```
kubectl patch service web-service -n learning -p '{"spec":{"ports":[{"port":80,"targetPort":8080}]}}'
```

This changes the door the desk forwards calls to (`targetPort`) from 80 to 8080. Then run the detective steps again. This time `Endpoints` will **not** be empty, because the badge still matches. So the clues will point somewhere else. Can you work out what and where?
