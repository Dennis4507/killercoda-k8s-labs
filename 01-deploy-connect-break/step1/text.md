## Step 1 - Deploy three web Pods

First check the cluster is healthy. Both nodes should say `Ready`:

```plain
kubectl get nodes -o wide
```{{exec}}

Create a **namespace** (a named area that keeps your objects separate from Kubernetes' own system components):

```plain
kubectl create namespace learning
```{{exec}}

Now create a **Deployment**, which is a standing instruction: "keep three copies of this Pod running, and replace any that die".

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

Note the label `app: web-app` on the Pods. A label is a name tag. Remember it, because the failure later is about this exact tag.

Watch the Pods appear (press Ctrl+C when all three show `Running`):

```plain
kubectl get pods -n learning -o wide -w
```{{exec}}

Click **Check** when all three are running.
