# Lab 03 - The update that got stuck

This lab comes from a real incident. A new version of an application would not roll out. New Pods sat in `Pending`, the old Pods would not leave, and it stayed frozen for over six hours, even though the machine was almost idle. The cause was not a crash or a bug. It was arithmetic.

In this lab you will build the same trap on purpose, then investigate it like a detective, and fix it.

## The story we will use

We continue the office story, with two new ideas.

The machine (a **node**) is **a floor of the building with a fixed number of desks**. Each desk is one slice of the floor's processing power, called CPU. Each Pod is an employee who needs desks.

When an employee is hired, the Pod asks for desks to be **booked** for them. Kubernetes calls this booking a **request**. The building's room-planner, called the **scheduler**, uses one simple rule: it will only place a new employee on a floor if enough **unbooked** desks are left. It counts the bookings. **It does not look at how many desks are actually being used.**

So a floor can be completely booked while the chairs are almost all empty. The next hire is then turned away, and the employees already working cannot be released either, as you will see. That is the trap.

## The whole lab in one picture

```
BUILD                         BREAK                 DETECTIVE                     FIX
(steps 1-5)                   (step 6)              (steps 7-9)                   (steps 10-11)

measure the floor   --->   release a new   --->   see Pending             --->   shrink the
hire 3 employees           version                 read the reason               bookings
book lots of desks         (needs a 4th            see why nothing               watch the update
see they use few           booking: none free)     can move                      finish
```

Plan for about 30 to 40 minutes. You have 60 minutes in a Killercoda session, so there is room to go slowly.

## If you get lost

- Each step starts with a **Progress** line and a **Where we are** box. Read those first, and you will know what already exists.
- If a command shows something unexpected, run it again after ten seconds. Pods take a moment to start.
- If a step says `No resources found`, check that the command ends with `-n scheduling`.
- If you cannot continue, the commands in each step are safe to re-run. You can also close the session and start the lab again from the top.

## The three parts of the lab

1. **Build** (steps 1 to 5): measure the floor, hire three employees with a booking, and see how little they actually use.
2. **Break** (step 6): release a new version, and watch the update freeze.
3. **Detective and fix** (steps 7 to 11): find out why it is frozen, choose a fix, and prove it works.

## How each step is laid out

Every step starts with a short box that says where you are, what exists so far, and what you will do. Every command is explained before and after you run it, with a sample of what you should see. Your numbers will differ, because the numbers depend on the machine Killercoda gives you. Every step ends with what you now have.

You will use **kubectl** (say "kube-control"), the tool for giving Kubernetes instructions and asking it questions.

Wait until the terminal on the right shows a prompt, then click **Start**.
