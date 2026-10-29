# Lab 01 - Deploy, connect, break, repair

This lab is about understanding, not typing. For every command you will be told what it does, what you should see, and how to read it. Take your time. If something is unclear, re-read the explanation before moving on.

## What you will build

You will run a small web application and make it reachable by name from inside Kubernetes:

```
test client  ----->  Service "web-service"  ----->  3 copies of a web server (Nginx)
```

Then you will break the middle part on purpose, and find and fix the fault using only evidence from the cluster.

## Words you need first

**Kubernetes** is software that runs containers across several machines and keeps them running. A **container** is a packaged program with everything it needs, so it runs the same everywhere.

A **node** is one machine in the cluster. A **cluster** is all the machines working together. Yours has two nodes: one called `controlplane` (the machine that makes decisions) and one called `node01` (a worker machine that runs applications).

A **Pod** is the smallest thing Kubernetes runs. It wraps one container (sometimes a few). Pods are disposable: they can die and be replaced, and every replacement gets a new address.

A **Deployment** is an instruction saying "keep this many copies of this Pod running". If a Pod dies, the Deployment replaces it.

A **Service** gives a group of Pods one stable name and address, because the Pods' own addresses keep changing.

A **label** is a name tag attached to an object, written as `key=value`, like `app=web-app`. A **selector** is a rule that finds objects by their labels. A Service uses a selector to find its Pods. This one idea is the heart of the failure you will cause and fix.

**kubectl** (said "kube-control" or "kube-cuddle") is the command-line tool you use to talk to Kubernetes. **YAML** is the text format used to describe what you want Kubernetes to build. **DNS** (Domain Name System) turns a name like `web-service` into an address, the way a phone book turns a name into a number.

## How the steps work

Each step has text to read, commands you can click to run, and sample output. Your output will be similar but not identical: addresses, ages and random letters in names will differ. Some steps end with a **Check** button, which looks at your cluster to confirm you did the step.

Wait until the terminal on the right shows a prompt, then click **Start**.
