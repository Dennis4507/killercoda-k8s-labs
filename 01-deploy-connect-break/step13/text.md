## Step 13 of 16 - Detective 2: what badge is the Service looking for?

> **Where we are:** Part 3, Detective. Step 2 of 4.
> **What we know so far:** DNS works. The call rings but nobody answers.
> **What we do now:** ask the Service what rule it is following and who is on its list.

### The command

```plain
kubectl describe service web-service -n learning
```{{exec}}

**What this does.** `describe` prints a detailed report about one object. When something misbehaves, it is the first command to reach for. It is like asking the reception desk "tell me everything about how you work".

**What you should see:**

```
Name:              web-service
Namespace:         learning
Labels:            <none>
Selector:          app=wrong-app
Type:              ClusterIP
IP:                10.96.12.34
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>
```

There are many lines, but **only two matter right now**. Find them:

```
Selector:          app=wrong-app
Endpoints:         <none>
```

### How to read the two lines

**`Selector: app=wrong-app`** is the desk's rule: "send callers to anyone wearing the badge `app=wrong-app`."

**`Endpoints: <none>`** is the desk's list of employees. It says `<none>`: the list is **empty**. Compare this with step 8, when the same list had three addresses. The desk looked for the badge `app=wrong-app` and found nobody.

### What we learned

**We have found the symptom.** The Service has no one to send callers to, and that is why every call fails.

But we do not yet know **why** the list is empty. It could be that the rule is wrong. It could be that the employees are gone. It could be that the employees wear a different badge. We cannot tell yet. So we look at the other side: the Pods.

> **What you now know:** the desk is looking for `app=wrong-app` and found nobody. We still need to see what badges the employees actually wear.

Click **Continue**.
