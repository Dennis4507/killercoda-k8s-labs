#!/bin/bash

kubectl get svc web-service -n learning >/dev/null 2>&1 || exit 1
kubectl exec -n learning client -- curl -s -o /dev/null -w '%{http_code}' --max-time 5 http://web-service 2>/dev/null | grep -q '^200$'
