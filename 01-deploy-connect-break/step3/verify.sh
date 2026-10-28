#!/bin/bash

sel=$(kubectl get svc web-service -n learning -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$sel" = "wrong-app" ]
