#!/bin/bash

sel=$(kubectl get service web-service -n learning -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$sel" = "wrong-app" ]
