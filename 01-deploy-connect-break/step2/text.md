## Step 2 - Create a namespace

Everything running so far belongs to Kubernetes itself. You should never mix your own application in with those system parts, so you create your own area first.

```plain
kubectl create namespace learning
```{{exec}}

**What it does.** It creates a namespace called `learning`. Think of it as making a new empty folder. Everything you build in this lab will go inside it, which also means you can wipe it all with one command at the end.

**What you should see:**

```
namespace/learning created
```

**How to read it.** The format `type/name created` is how `kubectl` confirms most actions. It says the object of type `namespace` called `learning` now exists.

### Prove it exists

```plain
kubectl get namespaces
```{{exec}}

You should see `learning` in the list, with `STATUS Active`, alongside `default`, `kube-system`, `kube-public` and `kube-node-lease`.

### Why `-n learning` appears in every later command

From now on, almost every command ends with `-n learning`. The `-n` is short for namespace. It tells `kubectl` which folder to look in. If you forget it, `kubectl` looks in `default` and says something like `No resources found`, or `Error from server (NotFound)`. When a command seems to find nothing, a missing `-n learning` is the first thing to check.

Click **Check** when the namespace exists.
