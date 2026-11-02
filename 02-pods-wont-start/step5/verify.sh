#!/bin/bash

img=$(kubectl get deployment pull-demo -n troubleshoot -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
ready=$(kubectl get deployment pull-demo -n troubleshoot -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$img" = "nginx:stable-alpine" ] && [ "$ready" = "1" ]
