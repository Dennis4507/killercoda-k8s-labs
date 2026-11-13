# Done - what you learned

## The key idea

The scheduler places Pods by what they **book** (their `requests`), not by what they **use**. So a machine can be full on paper and nearly empty in reality, and a Pod that does not fit on paper stays `Pending`.

## The whole story in one picture

```
BEFORE THE FIX                                  AFTER THE FIX

 floor: [BBBBBBBBBBBBBBBBBB..]  87% booked       floor: [BBBBBB..............]  37% booked
 real use: [u..................]  ~0% used        real use: [u.................]  ~0% used

 update needs a 4th booking of size R            update needs a 4th booking of size R/3
 free space < R   ->  Pending, deadlock          free space > R/3 ->  fits, update finishes
```

## The chain of the incident, in plain sentences

1. The Pods booked far more CPU than they used.
2. That left the machine about 87% booked, while real use was close to zero.
3. A rolling update needs room for one extra Pod while the three old Pods are still running (`maxSurge: 1`), and it will not remove an old one until a new one works (`maxUnavailable: 0`).
4. The fourth booking did not fit, so the new Pod stayed `Pending`.
5. The old Pods could not leave, so nothing could move: a deadlock.
6. Shrinking the bookings to match real use made room, and the update completed.

## The detective method to keep

1. **Read the status.** `kubectl get pods`. `Pending` means "not placed yet", unlike `CrashLoopBackOff` or `ImagePullBackOff`, where the Pod was already placed.
2. **Read the scheduler's reason.** `kubectl get events --field-selector reason=FailedScheduling`, or `kubectl describe pod`. `Insufficient cpu` means not enough **unbooked** CPU.
3. **Compare bookings with reality.** `kubectl describe node` (the `Allocated resources` section) against real usage.
4. **Check the update rules.** `maxSurge` and `maxUnavailable` decide whether the update needs spare room.
5. **Fix the cause**, then prove the update completes with `kubectl rollout status`.

## How to say it in an interview

Use "I", not "we", for work you did yourself:

> "I had a rolling update that sat frozen for over six hours. New Pods were `Pending` and the old ones would not terminate. The node's real CPU use was only about 15 percent, but its CPU requests were at 100 percent. The scheduler counts requests, not usage, and the update needed room for a second generation of Pods at the same time. I resized every service's CPU request based on what Prometheus actually measured, cutting the total per generation from 1500 millicores to 550, on a node with 2000 millicores allocatable. I also had to delete the old generation once by hand, because running Pods keep their old reservation until they are replaced. Updates have worked on their own ever since."

Those figures come from your own incident notes in `engineering-deep-dive`, so they are safe to use.

## Try it yourself: a plain Pending Pod

Predict first, then check. With your fixed booking (one third of R), run:

```
kubectl scale deployment web -n scheduling --replicas=12
```

Before you look, work out how many Pods can fit on `node01`. The floor's free space divided by one Pod's booking gives the answer, rounded down. Then run `kubectl get pods -n scheduling` and count how many are `Running` and how many are `Pending`. Do your numbers match? Finally, use `kubectl get events -n scheduling --field-selector reason=FailedScheduling` to see the scheduler's reason. This time there is no rolling update involved, only a Pod that does not fit.

Set it back afterwards with `kubectl scale deployment web -n scheduling --replicas=3`.
