#!/bin/bash

n=$(kubectl get endpointslices -n learning -l kubernetes.io/service-name=web-service -o jsonpath='{.items[*].endpoints[*].addresses[0]}' 2>/dev/null | wc -w)
[ "$n" -eq 3 ]
