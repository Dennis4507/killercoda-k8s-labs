# killercoda-k8s-labs

Hands-on Kubernetes failure labs for [Killercoda](https://killercoda.com). Each folder is one scenario: build something, break it, diagnose it from evidence, repair it.

| Lab | Topic |
|---|---|
| [01-deploy-connect-break](01-deploy-connect-break) | Deployment, Service, label-selector mismatch |

## Adding a lab

Each scenario folder holds `index.json`, `intro.md`, `stepN/text.md` with an optional `stepN/verify.sh`, and `finish.md`. Use `"imageid": "kubernetes-kubeadm-2nodes"` for a two-node cluster. A `verify.sh` passes when it exits 0.

## Connecting to Killercoda

Add this repo (branch `main`) on killercoda.com/creator/repository, add the shown Deploy Key under the GitHub repo's Settings > Deploy keys, and add the shown webhook under Settings > Webhooks.
