#!/bin/bash

ready=$(kubectl get deployment web-app -n learning -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$ready" = "3" ]
