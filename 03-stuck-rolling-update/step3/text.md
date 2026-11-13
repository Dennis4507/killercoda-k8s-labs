## Step 3 of 11 - Write the plan with a CPU booking

> **Where we are:** Part 1, Build.
> **What exists so far:** the folder `scheduling`, and your booking size R from step 2.
> **What we do now:** write the plan for three web Pods, each booking R millicores. We only write the file. We send it in the next step.

### Remember your number

Type your R from step 2, in place of 500. Keep the number only, with no `m`:

```plain
REQ=500
echo $REQ > ~/req.txt
echo "Booking per Pod: ${REQ}m"
```{{exec}}

**What this does.** `REQ=500` stores your number in a **variable**, a named box that holds a value. `echo $REQ > ~/req.txt` also saves it in a file, so you can use it again later even if the terminal is restarted. The last line prints it back so you can check it.

> If your R from step 2 is not 500, edit the number in the first line before you run the block. For example `REQ=540`.

### Read the plan in three parts

**Part A: identity, how many, and the update rules.**

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: scheduling
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

- This is a **Deployment**, the manager that keeps `replicas: 3` Pods running.
- `strategy` says how to replace Pods when there is a new version. `RollingUpdate` means "replace them gradually, a few at a time", so the application stays available.
- `maxSurge: 1` means "during an update, you may have **1 extra** Pod above 3, so up to 4 at once".
- `maxUnavailable: 0` means "never let the number of working Pods drop below 3".

Together, these two rules say: **hire the replacement first, and only release an old employee once the replacement is working.** These are in fact Kubernetes' normal defaults for 3 Pods. We write them out so you can see them.

**Part B: finding the Pods, and pinning them to `node01`.**

```
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      nodeSelector:
        kubernetes.io/hostname: node01
```

- `selector` and the template's `labels` are the matching name badge from Lab 1: the Deployment finds its own Pods by the badge `app=web`.
- `nodeSelector` says "only place these Pods on the machine named `node01`". This keeps all of them on one small floor.

**Part C: the container and its booking.**

```
      containers:
        - name: nginx
          image: nginx:stable-alpine
          resources:
            requests:
              cpu: "500m"
```

- `image: nginx:stable-alpine` is the web server program package.
- `resources: requests: cpu: "500m"` is **the booking**. This Pod reserves 500 millicores. In our real file, the number is your R.

### Write the file

```plain
cat > deploy.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: scheduling
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      nodeSelector:
        kubernetes.io/hostname: node01
      containers:
        - name: nginx
          image: nginx:stable-alpine
          resources:
            requests:
              cpu: "${REQ}m"
EOF
cat deploy.yaml | grep cpu
```{{exec}}

**What this does.** In earlier labs the closing marker was written `<<'EOF'` with quotes, which saves the text exactly as typed. Here it is `<<EOF` without quotes, so the shell **fills in** `${REQ}` with your number. The last line, `grep cpu`, prints the line containing `cpu` so you can confirm the number landed in the file.

**What you should see** (with your own number):

```
              cpu: "500m"
```

If it shows `cpu: "m"` with no number, the variable was empty. Run the first block again, then this one.

> **What you now have:** a file called `deploy.yaml` that books R millicores per Pod. Kubernetes does not know about it yet.

Click **Check**.
