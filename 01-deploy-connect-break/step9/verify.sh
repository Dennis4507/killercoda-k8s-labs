#!/bin/bash

kubectl wait -n learning --for=condition=Ready pod/client --timeout=5s >/dev/null 2>&1
