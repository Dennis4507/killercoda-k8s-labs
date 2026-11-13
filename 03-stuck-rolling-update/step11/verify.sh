#!/bin/bash

req=$(cat "$HOME/req.txt" 2>/dev/null)
[ -n "$req" ] || exit 1

cur=$(kubectl get deployment web -n scheduling -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
cur=${cur%m}
[ -n "$cur" ] && [ "$cur" -lt "$req" ] || exit 1

total=$(kubectl get deployment web -n scheduling -o jsonpath='{.status.replicas}' 2>/dev/null)
updated=$(kubectl get deployment web -n scheduling -o jsonpath='{.status.updatedReplicas}' 2>/dev/null)
ready=$(kubectl get deployment web -n scheduling -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$total" = "3" ] && [ "$updated" = "3" ] && [ "$ready" = "3" ]
