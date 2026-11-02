## Step 3 of 16 - Write the plan for three web Pods

> **Where we are:** Part 1, Build.
> **What exists so far:** an empty folder (namespace) called `learning`.
> **What we do now:** write a plan, as a text file, that says "I want three web servers running". We only write the file in this step. We send it to Kubernetes in the next step.

### What a plan looks like

The plan is written in a format called **YAML** (it reads like an indented list). You describe what you **want**, not how to do it. You do not say "start three programs". You say "I want three to exist", and Kubernetes works out how to make that true and keeps it true.

In YAML, **indentation matters**. A line indented two more spaces belongs to the line above it. We will look at the plan in four parts. Together they make one file.

### Part A: what kind of thing is this, and what is it called?

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: learning
```

- `kind: Deployment` says we are making a **Deployment**. In our story, that is the manager who makes sure three employees are always at work.
- `apiVersion: apps/v1` says which version of Kubernetes' rulebook this kind of object follows. Just copy it.
- `name: web-app` is the Deployment's name.
- `namespace: learning` puts it in our folder.

### Part B: how many?

```
spec:
  replicas: 3
```

- `spec` is short for "specification", which means "what I want".
- `replicas: 3` means "I want three copies". A replica is just one copy.

### Part C: how does the manager recognise its own employees?

```
  selector:
    matchLabels:
      app: web-app
```

This says: "The Pods that are mine are the ones wearing the badge `app=web-app`." The manager counts badges to check whether three employees exist.

### Part D: the template for each new employee

```
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: nginx
          image: nginx:stable-alpine
          ports:
            - containerPort: 80
```

- `template` is the blueprint used to make every new Pod.
- `labels: app: web-app` is the **name badge** that every new Pod wears. Notice it says the same thing as Part C. **The two must match.** If Part D gave a different badge, the manager could never find its own employees.
- `containers` lists what runs inside each Pod. We have one container, called `nginx`. A **container** is a packaged program that carries everything it needs.
- `image: nginx:stable-alpine` says which package to run. **Nginx** is a very common web server (a program that answers web requests). `stable-alpine` is a small, stable version.
- `containerPort: 80` notes that the program listens on port 80. A **port** is a numbered door on a machine, and 80 is the usual door for web traffic.

### Now write the file

This command saves all four parts into a file called `deployment.yaml`. It does not send anything to Kubernetes yet.

```plain
cat > deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: learning
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: nginx
          image: nginx:stable-alpine
          ports:
            - containerPort: 80
EOF
```{{exec}}

Everything between `<<'EOF'` and the final `EOF` is the text that gets saved. The `cat >` part means "write it into this file".

Check the file was written:

```plain
cat deployment.yaml
```{{exec}}

You should see the same text you just read, all in one piece. Notice `app: web-app` appears **twice**: once in the selector (Part C) and once in the template's labels (Part D).

> **What you now have:** a file called `deployment.yaml` on this machine. Kubernetes does not know about it yet.

Click **Check**.
