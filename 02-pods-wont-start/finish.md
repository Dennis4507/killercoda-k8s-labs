# Done - what you learned

You met the two most common ways a Pod fails to start, and learned that the **status word tells you where to look next**.

## The two failures side by side

| | Failure A | Failure B |
|---|---|---|
| Status | `ErrImagePull`, then `ImagePullBackOff` | `Error`, then `CrashLoopBackOff` |
| `RESTARTS` | `0` (the program never started) | Growing (it starts, then stops, again and again) |
| Story | The employee never arrives. | The employee arrives, finds something missing, walks out, repeatedly. |
| Where the clue is | **Events**: `kubectl describe pod` | **Logs**: `kubectl logs` (use `--previous` if needed), then the exit code in `describe` |
| The cause here | A typo in the image tag | A required setting was not given |
| The fix | `kubectl set image` | `kubectl set env` |

## The method to keep

1. **Read the status** with `kubectl get pods`. Watch `READY`, `STATUS` and `RESTARTS`.
2. **Read the clues** in the right place for that status.
3. **Say the cause in one sentence.**
4. **Fix the Deployment** (the plan), not the Pod.
5. **Prove the fix** with the status, the logs, or a real request.

## Two sentences to remember

If the Pod **never starts**, look at the Events. If the Pod **starts and then dies**, look at the logs.

`RESTARTS 0` with a failing Pod usually means something stopped the program from starting at all. A growing `RESTARTS` means the program starts but cannot stay up.

## Try it yourself: a third failure

There is a third very common failure, called **`Pending`**: a Pod that is never placed on a machine. Make one, without looking at hints, and work out why:

```
kubectl run big-pod -n troubleshoot --image=nginx:stable-alpine --overrides='{"spec":{"containers":[{"name":"big-pod","image":"nginx:stable-alpine","resources":{"requests":{"memory":"64Gi"}}}]}}'
```

Then use the detective method. What is the status? Where is the clue? (Hint: the status is `Pending`, and the clue is in the **Events**, just like Failure A, because the Pod never reached a machine. Look for the word "Insufficient".)
