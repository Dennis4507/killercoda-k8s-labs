#!/bin/bash

ready=$(kubectl get deployment web -n scheduling -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$ready" = "3" ]
