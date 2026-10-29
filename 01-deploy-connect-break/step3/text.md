## Step 3 - Deploy three web Pods

### First, read the YAML

This is the instruction you will give Kubernetes. Read it here first. The next block, with the command, comes afterwards.

```
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
```

YAML describes what you **want**. You never say "start three containers". You say "I want three copies to exist", and Kubernetes works out how. Indentation matters in YAML: two spaces show that a line belongs to the line above it.

**Line by line:**

- `apiVersion: apps/v1` says which version of Kubernetes' rulebook this object follows. Deployments live in the group called `apps`.
- `kind: Deployment` says what type of object this is.
- `metadata:` introduces the object's identity. `name: web-app` is what you call it. `namespace: learning` puts it in the folder you made.
- `spec:` means "specification", the description of what you want.
- `replicas: 3` means "keep three identical Pods running".
- `selector: matchLabels: app: web-app` tells the Deployment which Pods are **its own**: any Pod labelled `app=web-app`. This is how it counts "do I have three yet?".
- `template:` is the blueprint for every Pod the Deployment creates.
- Inside it, `metadata: labels: app: web-app` is the label stuck on every new Pod. **This must match the selector above**, otherwise the Deployment could not find its own Pods.
- `containers:` lists the containers in each Pod. Here there is one, named `nginx`.
- `image: nginx:stable-alpine` says which container image to run. An **image** is the packaged program. `nginx` is a popular web server, `stable-alpine` is a small, stable build of it.
- `containerPort: 80` records that the program listens on port 80. A **port** is a numbered door on a machine, and 80 is the standard door for web traffic. This line is documentation; it does not open anything by itself.

### Now create it

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
kubectl apply -f deployment.yaml
```{{exec}}

**What it does.** The first part, `cat > deployment.yaml <<'EOF' ... EOF`, writes the text between the markers into a file called `deployment.yaml`. The second part, `kubectl apply -f deployment.yaml`, sends that file to the API server. `apply` means "make the cluster match this description", and `-f` means "from this file".

**What you should see:**

```
deployment.apps/web-app created
```

### Watch what Kubernetes built

```plain
kubectl get deployments,replicasets,pods -n learning -o wide
```{{exec}}

**What it does.** It lists three kinds of object in one go. You asked for one Deployment, but you will see three layers.

**What you should see** (the random letters will differ):

```
NAME                      READY   UP-TO-DATE   AVAILABLE   ...
deployment.apps/web-app   3/3     3            3           ...

NAME                                 DESIRED   CURRENT   READY   ...
replicaset.apps/web-app-7d9c6b5f4d   3         3         3       ...

NAME                           READY   STATUS    RESTARTS   AGE   IP            NODE
pod/web-app-7d9c6b5f4d-abcde   1/1     Running   0          30s   192.168.x.x   node01
pod/web-app-7d9c6b5f4d-fghij   1/1     Running   0          30s   192.168.x.x   controlplane
pod/web-app-7d9c6b5f4d-klmno   1/1     Running   0          30s   192.168.x.x   node01
```

**How to read it.**

- The **Deployment** line says `READY 3/3`: three wanted, three ready.
- Between the Deployment and the Pods, Kubernetes created a **ReplicaSet**. A ReplicaSet's only job is "keep exactly this many Pods alive". The Deployment manages ReplicaSets, which is what lets it do safe updates later.
- Look at the Pod names: `web-app-7d9c6b5f4d-abcde`. The middle part, `7d9c6b5f4d`, is the ReplicaSet's name suffix; the last five letters are random per Pod. The names show you the chain: Deployment, then ReplicaSet, then Pod.
- The `IP` column shows each Pod's own address. **Write down the three addresses** (or just keep this output visible), because you will meet them again in the next step.
- The `NODE` column shows which machine each Pod landed on. The scheduler spread them across both nodes.

If a Pod shows `ContainerCreating`, it is still downloading the image; wait ten seconds and run the command again. When all three say `Running` and `READY 1/1`, click **Check**.
