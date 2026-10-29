#!/bin/bash

kubectl exec -n learning client -- curl -s -o /dev/null -w '%{http_code}' --max-time 5 http://web-service 2>/dev/null | grep -q '^200$'
