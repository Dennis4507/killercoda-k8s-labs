# Lab 01 - Deploy, connect, break, repair

In this lab you will build a tiny web application on Kubernetes (a system that runs containers across several machines), then break the way traffic reaches it, then fix it using only evidence from `kubectl` (the command-line tool that talks to Kubernetes).

```
test client Pod  --->  Service "web-service"  --->  3 x Nginx Pods
```

A **Pod** is the smallest thing Kubernetes runs: one or more containers together. A **Service** is one stable internal name and address that forwards traffic to a group of Pods, so clients never need to know individual Pod addresses.

The failure you will cause is one of the most common real ones: the Service and the Pods stop agreeing on a label, so the Service forwards to nothing.

Your cluster has two nodes (machines). Wait until the terminal prompt appears, then click **Start**.
