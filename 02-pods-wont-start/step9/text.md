## Step 9 of 10 - Detective B2: read the exit code

> **Where we are:** Failure B, investigation step 2 of 2.
> **What we know so far:** the logs say `DATABASE_URL is not set`.
> **What we do now:** confirm from Kubernetes' own records exactly **how** the program stopped. Not all crashes have a message, so this is a skill you need.

Sometimes a program crashes and its logs are empty or unhelpful. Then the **exit code** is your best clue. This step shows you where to find it.

### The command

```plain
kubectl describe pods -n troubleshoot -l app=crash-demo | grep -A 6 "Last State"
```{{exec}}

**What this does, piece by piece:**

- `kubectl describe pods -n troubleshoot -l app=crash-demo` prints the long report about the Pod.
- `| grep -A 6 "Last State"` hands that report to `grep`, a search tool. It finds the line containing `Last State` and shows it plus the **6 lines After** it (`-A 6`). That is the part of the report we want.

**What you should see:**

```
    Last State:     Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Mon, 02 Nov 2026 10:00:10 +0000
      Finished:     Mon, 02 Nov 2026 10:00:10 +0000
    Ready:          False
```

### How to read it, line by line

- **`Last State: Terminated`**. The most recent run of the program has ended. (Its current state is `Waiting` for the next restart.)
- **`Reason: Error`**. It ended with a failure, not by finishing its job. If it had finished normally, this would say `Completed`.
- **`Exit Code: 1`**. This is the number our script used in `exit 1`. The exit code is a number a program hands back when it stops. Here is a small table worth knowing:

| Exit code | What it usually means |
|---|---|
| `0` | Success. The program finished normally. |
| `1` | A general failure. The program decided to quit. Check the logs for the reason. |
| `137` | The program was killed. This very often means it used too much memory (`OOMKilled`, short for "out of memory killed"). |
| `143` | The program was asked to stop politely, for example during a shutdown. |

- **`Started` and `Finished`** show the same second. The program ran for **less than a second** before quitting. A run that short means the program fails straight away at start-up. It did not run for a while and then break.

### Also check the restart count

```plain
kubectl describe pods -n troubleshoot -l app=crash-demo | grep "Restart Count"
```{{exec}}

You should see something like `Restart Count: 5`. This matches the `RESTARTS` column from `kubectl get pods`.

### Put the clues together

| Clue | What it told us |
|---|---|
| Status `CrashLoopBackOff` | The program starts and stops, over and over. |
| `RESTARTS` growing | It really does start every time. (In Failure A it stayed at 0.) |
| Logs: `DATABASE_URL is not set` | The program needs a setting that is missing. |
| Exit code `1`, ran under a second | A deliberate failure at start-up, not a memory kill or a freeze. |

> **What you now know:** the cause, confirmed by two sources. The program needs `DATABASE_URL`, and it was not given one.

Click **Continue**.
