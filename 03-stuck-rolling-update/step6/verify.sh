#!/bin/bash

img=$(kubectl get deployment web -n scheduling -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:alpine" ]
