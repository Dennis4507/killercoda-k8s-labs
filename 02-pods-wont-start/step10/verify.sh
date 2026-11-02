#!/bin/bash

ready=$(kubectl get deployment crash-demo -n troubleshoot -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
env=$(kubectl get deployment crash-demo -n troubleshoot -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="DATABASE_URL")].value}' 2>/dev/null)
[ "$ready" = "1" ] && [ -n "$env" ]
