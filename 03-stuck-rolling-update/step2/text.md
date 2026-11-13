## Step 2 of 11 - Measure the floor

**Progress:** ▰▰▱▱▱▱▱▱▱▱▱ Part 1 of 4: Build

> **Where we are:** Part 1, Build.
> **What exists so far:** an empty folder called `scheduling`.
> **What we do now:** find out how many desks `node01` has and how many are already booked. We need these numbers to build the trap.

### Why we measure first

To build the trap, we need to book **just enough** desks per employee that three employees fit but a fourth does not. We cannot guess that. It depends on the size of the machine Killercoda gave you. So first we measure, then we calculate.

We will put all our Pods on `node01` only. One small floor makes the numbers predictable, just like in the real incident, which happened on one small machine.

Here is the picture we are trying to find out about, with example numbers:

```
node01 = the floor

  Desks Pods may use ("Allocatable") ........ 2000m
  Already booked by Kubernetes' own Pods .... 250m
  Still free ................................ 1750m

  [###.......................................]
   ^ booked 250m                  ^ free 1750m
```

### Reading 1: how many desks does the floor have?

```plain
kubectl describe node node01 | grep -A6 "^Allocatable"
```{{exec}}

**What this does.** `kubectl describe node node01` prints a long report about the machine. The `|` (called a pipe) hands that report to `grep`, a search tool. `grep -A6 "^Allocatable"` finds the line starting with `Allocatable` and shows that line plus the 6 lines After it.

**What you should see** (your numbers will differ):

```
Allocatable:
  cpu:                2
  ephemeral-storage:  ...
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             ...
  pods:               110
```

**How to read it.** The machine's **Capacity** is everything it physically has. **Allocatable** is what is left for Pods after the machine keeps some for itself. Look only at the `cpu` line. A plain number like `2` means 2 full cores, which is `2000m`. A number like `1900m` is already in millicores.

### Reading 2: how many desks are already booked?

```plain
kubectl describe node node01 | grep -A8 "^Allocated resources"
```{{exec}}

**What you should see:**

```
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                250m (12%)  0 (0%)
  memory             140Mi (7%)  170Mi (9%)
```

**How to read it.** Find the `cpu` row. The `Requests` column is the CPU **already booked** by Pods on this machine. These are Kubernetes' own system Pods. Ignore the `Limits` column and the `memory` row. Only the CPU `Requests` matter, because that is what the scheduler counts.

### Now the arithmetic, in three small steps

Write your numbers down in millicores. Use the example column as a guide.

| | Example | Yours |
|---|---|---|
| **A.** Allocatable CPU (cores x 1000) | 2000m | `______` |
| **B.** Already booked (the `Requests` figure) | 250m | `______` |
| **C. Free = A minus B** | 1750m | `______` |

Now choose the booking size, which we call **R**: the number of millicores each Pod will book.

> **R = Free divided by 3.5, rounded down.**

Example: `1750 / 3.5 = 500`. So R = `500m`.

Why 3.5? Because it makes **three fit, but not four**. Check it with the example:

- Three Pods book `3 x 500 = 1500m`. That is **less** than 1750m free, so they fit.
- Four Pods would book `4 x 500 = 2000m`. That is **more** than 1750m free, so the fourth does not fit.

Why would anyone ever book so much? In the real incident, the bookings were copied from the example values of a big production cluster, and nobody resized them for the small machine. This happens a lot.

### Let a script check your arithmetic

Doing sums by hand is easy to get wrong, so here is a small script that does the same calculation and checks you. The script does four things: it reads the machine's allocatable CPU, adds up the CPU requests of every Pod on `node01`, subtracts one from the other to get the free amount, and divides by 3.5 to suggest R. It then saves R to a file called `req.txt`, which later steps read.

```plain
cat > measure.sh <<'EOF'
#!/bin/bash
NODE=node01
ALLOC=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.cpu}')
case "$ALLOC" in
  *m) ALLOC_M=${ALLOC%m} ;;
  *)  ALLOC_M=$((ALLOC * 1000)) ;;
esac
BOOKED_M=$(kubectl get pods -A --field-selector "spec.nodeName=$NODE" \
  -o jsonpath='{range .items[*].spec.containers[*]}{.resources.requests.cpu}{"\n"}{end}' \
  | awk '/m$/ {s += $1 + 0; next} /^[0-9.]+$/ {s += $1 * 1000} END {printf "%d", s}')
FREE_M=$((ALLOC_M - BOOKED_M))
R=$((FREE_M * 10 / 35 / 10 * 10))
echo "Allocatable CPU on $NODE : ${ALLOC_M}m"
echo "Already booked          : ${BOOKED_M}m"
echo "Free                    : ${FREE_M}m"
echo "Suggested booking per Pod (R): ${R}m"
echo "Check: 3 Pods book $((R * 3))m -> should be LESS than ${FREE_M}m"
echo "Check: 4 Pods book $((R * 4))m -> should be MORE than ${FREE_M}m"
echo "$R" > ~/req.txt
echo "Saved R=$R to ~/req.txt"
EOF
bash measure.sh
```{{exec}}

**What you should see** (the example numbers continue):

```
Allocatable CPU on node01 : 2000m
Already booked          : 250m
Free                    : 1750m
Suggested booking per Pod (R): 500m
Check: 3 Pods book 1500m -> should be LESS than 1750m
Check: 4 Pods book 2000m -> should be MORE than 1750m
Saved R=500 to ~/req.txt
```

**How to read it.** Compare it with your hand-worked table. The numbers should be equal or within a few millicores of each other, because the script and the `describe` report round slightly differently. Either is fine. What matters is that the last two checks are both true: three Pods fit, four do not.

> If a line shows `0m` for the booked amount, or the script prints an error, tell yourself: do the arithmetic by hand from the table above, then save your number yourself with `echo 500 > ~/req.txt` (use your own R instead of 500).

> **What you now have:** your three numbers, and a booking size R saved in `~/req.txt`.

Click **Continue**.
