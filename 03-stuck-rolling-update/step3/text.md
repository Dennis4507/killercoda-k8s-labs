## Step 3 of 11 - Write the plan with a CPU booking

**Progress:** ▰▰▰▱▱▱▱▱▱▱▱ Part 1 of 4: Build

> **Where we are:** Part 1, Build.
> **What exists so far:** the folder `scheduling`, and your booking size R saved in `~/req.txt`.
> **What we do now:** write the plan for three web Pods, each booking R millicores. We only write the file in this step. We send it to Kubernetes in the next step.

### Load your number

```plain
REQ=$(cat ~/req.txt)
echo "Booking per Pod: ${REQ}m"
```{{exec}}

**What this does.** `cat ~/req.txt` prints the number saved in step 2. `REQ=$( ... )` stores that number in a **variable**, which is a named box that holds a value. The `echo` line prints it back so you can check it. You should see something like `Booking per Pod: 500m`.

> If it prints `Booking per Pod: m` with no number, the file is missing. Set it by hand with your R from step 2, for example `REQ=500` and `echo $REQ > ~/req.txt`, and run the block again.

### Read the plan in three parts

The plan is a **Deployment**, the same kind of manager as in Labs 1 and 2. It is written in YAML, a text format where indentation shows what belongs to what. We read it in three parts that together make one file.

**Part A: the name, how many Pods, and the update rules.**

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

- `replicas: 3` means "keep three Pods running".
- `strategy` says how to replace Pods when there is a new version. `RollingUpdate` means "replace them gradually, so the application stays available".
- `maxSurge: 1` means "during an update, you may have **one extra** Pod above 3, so up to 4 at once".
- `maxUnavailable: 0` means "never let the number of working Pods drop below 3".

Together these two rules say: **hire the replacement first, and release an old employee only when the replacement works.** These are Kubernetes' normal defaults for three Pods. We write them out so you can see them.

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

- `selector` and the template's `labels` are the name-badge match from Lab 1: the Deployment finds its Pods by the badge `app=web`.
- `nodeSelector` says "only place these Pods on the machine named `node01`". That keeps all of them on one small floor.

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
- `resources: requests: cpu: "500m"` is **the booking**. This Pod reserves 500 millicores. In your real file, the number will be your own R.

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
grep cpu deploy.yaml
```{{exec}}

**What this does.** In earlier labs the closing marker was written `<<'EOF'` with quotes, which saves the text exactly as typed. Here it is `<<EOF` **without** quotes, so the shell **fills in** `${REQ}` with your number before saving. The last line, `grep cpu deploy.yaml`, prints the line containing `cpu` so you can confirm your number landed in the file.

**What you should see** (with your own number):

```
              cpu: "500m"
```

If it shows `cpu: "m"` with no number, the variable was empty. Run the first block of this step again, then this one.

> **What you now have:** a file called `deploy.yaml` that books R millicores per Pod. Kubernetes does not know about it yet.

Click **Check**.
