# Lab 01 - Deploy, connect, break, repair

This lab teaches you to understand Kubernetes, not just type commands. It moves in very small steps. Each step has one idea, and every command is explained before and after you run it.

## The story we will use

Imagine an office building. Inside it, three employees are sitting at desks, ready to answer web requests. Each employee wears a **name badge** that says `app=web-app`. At the front of the building there is a **reception desk** with one fixed phone number. When somebody calls the reception desk, the desk looks at its rule, which says "send callers to anyone wearing the badge `app=web-app`", and passes the call to one of those employees.

Later in the lab we will secretly change the desk's rule so it looks for the wrong badge. The employees will still be at work, and the phone number will still ring, but nobody will answer. You will then investigate like a detective and fix it.

That story is exactly how Kubernetes works. Here is how the story matches the real words:

| In the story | The real Kubernetes word | What it really is |
|---|---|---|
| The building | **Cluster** | The group of machines that Kubernetes controls |
| One floor of the building | **Namespace** | A named area that keeps your things separate from other things |
| An employee | **Pod** | One running copy of your application |
| The name badge | **Label** | A small tag like `app=web-app` stuck on an object |
| The manager who keeps three employees at work | **Deployment** | An instruction saying "always keep three Pods running" |
| The reception desk with one fixed number | **Service** | One stable name and address that forwards to Pods |
| The desk's rule "send callers to badge X" | **Selector** | A rule that finds objects by their labels |
| The desk's current list of employees | **Endpoints** | The addresses of the Pods the Service found |
| Phoning the desk by name | **DNS** (Domain Name System) | The cluster's phone book that turns a name into an address |

## The three parts of the lab

1. **Build** (steps 1 to 10): create the Pods, create the Service, and make a call that works.
2. **Break** (step 11): change one thing so the call fails.
3. **Detective and fix** (steps 12 to 16): follow clues, find the cause, repair it, and prove it.

## How each step is laid out

Every step starts with a short box telling you **where you are** and **what exists so far**, so you never lose track. Then comes the explanation, then the commands. After each command you will see **what you should see** (your numbers and letters will differ a little) and **how to read it**. Every step ends with **what you now have**.

You will use a tool called **kubectl** (say "kube-control"). It is how you give Kubernetes instructions and ask it questions.

Wait until the terminal on the right shows a prompt, then click **Start**.
