## Step 2 of 16 - Make your own folder

> **Where we are:** Part 1, Build.
> **What exists so far:** only Kubernetes' own system Pods, in the `kube-system` folder.
> **What we do now:** make a separate folder (a namespace) for our own work, called `learning`.

### Why a separate folder?

You should never mix your own application in with Kubernetes' own parts. A namespace keeps them apart. It also makes cleaning up easy, because deleting the namespace deletes everything inside it.

### The command

```plain
kubectl create namespace learning
```{{exec}}

**What this does.** `create namespace learning` makes a new, empty namespace called `learning`.

**What you should see:**

```
namespace/learning created
```

**How to read it.** This is the way `kubectl` confirms most actions: `type/name created`. It means "an object of type `namespace`, named `learning`, now exists".

### Check it is there

```plain
kubectl get namespaces
```{{exec}}

You should see `learning` in the list, with `Active` in the `STATUS` column, next to `default`, `kube-system` and a couple of others.

### One habit to learn now: `-n learning`

In almost every command from now on you will see `-n learning` at the end. The `-n` stands for namespace. It tells `kubectl` which folder to look in. If you leave it off, `kubectl` looks in a different folder (called `default`) and will say `No resources found`, even though your things exist.

So if a command ever seems to find nothing, check first that you included `-n learning`.

> **What you now have:** an empty folder called `learning`.

Click **Check**.
