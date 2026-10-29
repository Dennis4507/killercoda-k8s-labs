#!/bin/bash

sel=$(kubectl get service web-service -n learning -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$sel" = "web-app" ] || exit 1
kubectl exec -n learning client -- curl -s -o /dev/null -w '%{http_code}' --max-time 5 http://web-service 2>/dev/null | grep -q '^200$'
