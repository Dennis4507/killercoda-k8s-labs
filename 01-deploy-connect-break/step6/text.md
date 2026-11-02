## Step 6 of 16 - Write the plan for the Service

> **Where we are:** Part 1, Build.
> **What exists so far:** three Pods, each wearing the badge `app=web-app`, with addresses that can change.
> **What we do now:** write the plan for the reception desk (the Service). Again we only write the file. We send it in the next step.

### What the reception desk needs to know

A reception desk needs answers to four questions. The plan answers each one.

### Part A: what is it, and what is it called?

```
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: learning
```

- `kind: Service` says this is a Service, the reception desk.
- `name: web-service` is the name callers will use to reach it. **Remember this exact name**, because we will phone it by name later.
- `namespace: learning` puts it in our folder.

### Part B: who can phone it?

```
spec:
  type: ClusterIP
```

`ClusterIP` means the desk's phone number only works **from inside the building** (the cluster). Nobody outside can call it. This is the default and the safest choice.

### Part C: which employees should it send callers to?

```
  selector:
    app: web-app
```

This is the **desk's rule**, called the **selector**. It says: "send callers to any Pod wearing the badge `app=web-app`."

**This is the link between the Service and the Pods.** The Service does not know the Pods' names or addresses. It only knows the badge. Each time it needs to, it looks for every Pod wearing that badge. Look back at step 4: our Pods wear exactly `app=web-app`, so the rule will find them.

### Part D: which door, and which door on the Pod?

```
  ports:
    - port: 80
      targetPort: 80
```

- `port: 80` is the door the **caller** uses on the desk. Callers ask for the Service on port 80.
- `targetPort: 80` is the door on the **Pod** where the desk forwards the call. Nginx is listening on port 80.

Here both are 80, but they do not have to be. A desk could take calls on 80 and forward to an application on 8080. A wrong `targetPort` is another common fault, but not the one we study today.

### Now write the file

```plain
cat > service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: learning
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
    - port: 80
      targetPort: 80
EOF
```{{exec}}

Look at it:

```plain
cat service.yaml
```{{exec}}

Find the line `app: web-app` under `selector`. Compare it with the badge your Pods wear. They are the same. This match is what makes the whole thing work.

> **What you now have:** a file called `service.yaml`. Kubernetes does not know about it yet.

Click **Check**.
