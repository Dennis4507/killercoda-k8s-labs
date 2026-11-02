# Lab 02 - Pods that won't start

In Lab 1, the Pods were healthy and the connection to them broke. In this lab the **Pods themselves** fail. You will meet the two most common ways a Pod fails to start, learn what Kubernetes is telling you, and fix each one.

## The story we will use

We continue the office story. A **Pod** is an employee. The **Deployment** is the manager who hires employees and makes sure they are at work.

This time, two different things go wrong on the employees' first day.

**Failure A: the employee never arrives.** The manager gave the wrong address for where to collect the employee's equipment, so the employee cannot even get started. In Kubernetes this shows up as `ImagePullBackOff`. (An **image** is the packaged program a Pod runs. To "pull" it means to download it.)

**Failure B: the employee arrives, reads the instructions, finds something missing, and walks out. Then comes back. And walks out again, over and over.** In Kubernetes this shows up as `CrashLoopBackOff`. (A program that stops suddenly is said to have crashed.)

These look similar from far away, because in both cases the Pod does not work. But the clues are different, and so are the fixes. Learning to tell them apart is the skill.

## The same detective method, each time

For each failure you will do the same four things:

1. **Read the status.** What word does Kubernetes use?
2. **Read the clues.** Where does Kubernetes write down what went wrong?
3. **Name the cause** in one sentence.
4. **Fix it and prove it.**

## How each step is laid out

Every step starts with a short box that says where you are, what exists so far, and what you will do. Every command is explained before and after you run it, with a sample of what you should see. Your numbers and letters will differ a little. Every step ends with what you now have.

You will use **kubectl** (say "kube-control"), the tool for giving Kubernetes instructions and asking it questions.

Wait until the terminal on the right shows a prompt, then click **Start**.
