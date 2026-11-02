## Step 12 of 16 - Detective 1: see the symptom

> **Where we are:** Part 3, Detective. Step 1 of 4 in the investigation.
> **What exists so far:** healthy Pods, and a Service with a secretly broken rule.
> **What we do now:** make the call, watch it fail, and work out what the failure tells us.

### The detective's plan

A detective does not guess. A detective asks a short list of questions, one at a time, and rules things out. Here are ours. We answer them over the next four steps.

| # | Question | How we find out |
|---|---|---|
| 1 | Does the phone book give a number for `web-service`? (Is DNS working?) | Read the call's output (this step) |
| 2 | What badge is the desk looking for? | Ask the Service (step 13) |
| 3 | What badge are the employees wearing? | Ask the Pods (step 14) |
| 4 | Do those two match? | Compare, and prove it (step 15) |

### Make the call again

```plain
kubectl exec -n learning client -- curl -v --max-time 5 http://web-service
```{{exec}}

**What this does.** It is the same call as in step 10, with two changes. `-v` means verbose: "show me every step as it happens". `--max-time 5` means "give up after five seconds", so it never waits forever.

**What you should see.** Most likely a quick refusal like this:

```
* Host web-service:80 was resolved.
* IPv4: 10.96.12.34
*   Trying 10.96.12.34:80...
* connect to 10.96.12.34 port 80 failed: Connection refused
curl: (7) Failed to connect to web-service port 80 after 2 ms: Could not connect to server
```

On some clusters it instead waits the full five seconds and ends with `curl: (28) Connection timed out after 5001 milliseconds`. Both mean the same thing in this lab.

### How to read it, line by line

- **Line 1:** `Host web-service:80 was resolved.` and the next line shows a number. That means the phone book gave a number for the name. (Older versions print `Trying 10.96.12.34:80...` instead, which also shows a number was found.)
- **The last lines:** `Connection refused` or `timed out`. The call was placed to that number, and nobody picked up.

### What we learned

**Question 1 is answered: yes, DNS is working.** The name turned into a number, so the phone book is fine. We can cross it off.

The problem is **after** the name lookup. The phone number rings, but nobody answers. That narrows the search a lot. We do not need to look at the phone book any more.

So now we need to know: why does the desk have nobody to send the call to? That leads to question 2.

> **What you now know:** the name works, but the connection fails. The fault is between the Service and the Pods.

Click **Continue**.
