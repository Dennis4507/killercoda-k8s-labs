## Step 4 of 10 - Detective A2: read the Events

> **Where we are:** Failure A, investigation step 2 of 2.
> **What we know so far:** the Pod's status is `ImagePullBackOff`, so the image download is failing.
> **What we do now:** find out **why** it fails, by reading the Pod's Events.

### What an Event is

Kubernetes keeps a diary for every object. Each line in the diary is an **Event**: a short note saying what happened and when. When something goes wrong, the reason is almost always written in the Events.

### The command

```plain
kubectl describe pods -n troubleshoot -l app=pull-demo | tail -n 12
```{{exec}}

**What this does, piece by piece:**

- `kubectl describe pods` prints a long detailed report about Pods.
- `-n troubleshoot` means in our folder.
- `-l app=pull-demo` means "only Pods with the label `app=pull-demo`". A **label** is a name tag. The `create deployment` command added this tag for us. It saves you from having to copy the Pod's long name.
- `| tail -n 12` means "show only the last 12 lines". The `|` (pipe) hands the long report to `tail`, which keeps the end. The Events are always at the bottom of the report.

**What you should see:**

```
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  2m                 default-scheduler  Successfully assigned troubleshoot/pull-demo-6c8d9f7b5-x2k4j to node01
  Normal   Pulling    50s (x4 over 2m)   kubelet            Pulling image "nginx:stabel"
  Warning  Failed     49s (x4 over 2m)   kubelet            Failed to pull image "nginx:stabel": ... manifest for nginx:stabel not found: manifest unknown
  Warning  Failed     49s (x4 over 2m)   kubelet            Error: ErrImagePull
  Normal   BackOff    10s (x8 over 2m)   kubelet            Back-off pulling image "nginx:stabel"
  Warning  Failed     10s (x8 over 2m)   kubelet            Error: ImagePullBackOff
```

### How to read it, line by line

The columns are `Type`, `Reason`, `Age` (how long ago), `From` (who wrote the note) and `Message`. Read the `Message` column from top to bottom as a story:

1. `Successfully assigned ... to node01`. The scheduler (the part that picks a machine) chose a machine. **So scheduling worked.** That rules out a "no room on any machine" problem.
2. `Pulling image "nginx:stabel"`. The machine started downloading.
3. `Failed to pull image "nginx:stabel": ... manifest for nginx:stabel not found`. **This is the answer.** The registry (the online store of images) said "I have no image with that tag". "Manifest not found" is the registry's way of saying the image or tag does not exist.
4. `Back-off pulling image`. It is waiting before trying again.

The `(x4 over 2m)` part means "this happened 4 times in 2 minutes". Kubernetes keeps retrying.

### The cause, in one sentence

> "The Pod cannot start because the image `nginx:stabel` does not exist; the tag is misspelled."

Compare the message with the correct spelling, `nginx:stable`. The letters `e` and `l` are swapped.

### Other reasons you might see in a real Pod, in the same place

The same `Failed to pull image` event can also say: `unauthorized` or `pull access denied` (you need a password for this private registry), or a timeout (the machine cannot reach the registry). Always read the Message. It tells you which of these it is.

> **What you now know:** the exact cause, from the Events. Now we fix it.

Click **Continue**.
