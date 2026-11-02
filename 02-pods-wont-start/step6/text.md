## Step 6 of 10 - Failure B: write the plan for an app that needs a setting

> **Where we are:** Failure B, the Pod that starts and then keeps dying.
> **What exists so far:** a fixed `pull-demo` Deployment from Failure A.
> **What we do now:** write the plan for a small program that **refuses to run unless it is given a setting**. We only write the file in this step. We start it in the next step.

### The idea

Most real programs need settings to run, such as the address of a database. These settings are often passed in as **environment variables**. An environment variable is a named value handed to a program when it starts, like a note slipped into its pocket: `DATABASE_URL = the address of the database`.

Our program is a tiny script. It checks whether `DATABASE_URL` is set. If it is missing, it prints an error and quits. If it is there, it carries on. This copies a very common real situation: someone forgot to give the app a setting.

### The plan, in parts

This is a Deployment like the one in Lab 1, so we only look at the new bits.

**Part A: identity (same as always).**

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crash-demo
  namespace: troubleshoot
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crash-demo
  template:
    metadata:
      labels:
        app: crash-demo
```

This makes a Deployment called `crash-demo` that keeps one Pod wearing the label (name badge) `app=crash-demo`. The selector and the template's label must match, as in Lab 1.

**Part B: the container and the script.**

```
    spec:
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh", "-c"]
          args:
            - |
              echo "Starting application..."
              if [ -z "$DATABASE_URL" ]; then
                echo "ERROR: DATABASE_URL is not set. Cannot start." >&2
                exit 1
              fi
              echo "Connected to $DATABASE_URL"
              sleep 3600
```

- `image: busybox:1.36` is a tiny package containing basic Linux tools. We use it to run a script.
- `command: ["sh", "-c"]` says "run the shell (a program that runs typed commands), and give it the script that follows".
- `args:` holds the script. The `|` means "keep the following lines exactly as written".
- `echo "Starting application..."` prints a message. Printed text like this ends up in the program's **logs**, which we read in step 8.
- `if [ -z "$DATABASE_URL" ]; then ... fi` means "if `DATABASE_URL` is empty or missing, do the next lines".
- `echo "ERROR: ..."` prints the error message. The `>&2` sends it to the error channel, which is where programs normally write errors.
- `exit 1` **quits the program with a failure code**. The number after `exit` is called the **exit code**. `0` means success. Any other number means something went wrong. We use `1`.
- `echo "Connected to $DATABASE_URL"` runs only if the setting exists.
- `sleep 3600` keeps the program alive for an hour, so a working version stays up.

### Now write the file

```plain
cat > crash-demo.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crash-demo
  namespace: troubleshoot
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crash-demo
  template:
    metadata:
      labels:
        app: crash-demo
    spec:
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh", "-c"]
          args:
            - |
              echo "Starting application..."
              if [ -z "$DATABASE_URL" ]; then
                echo "ERROR: DATABASE_URL is not set. Cannot start." >&2
                exit 1
              fi
              echo "Connected to $DATABASE_URL"
              sleep 3600
EOF
```{{exec}}

The quotes around `'EOF'` matter. They make the shell save `$DATABASE_URL` as plain text instead of trying to fill it in itself.

> **What you now have:** a file called `crash-demo.yaml`. Kubernetes does not know about it yet.

Click **Check**.
