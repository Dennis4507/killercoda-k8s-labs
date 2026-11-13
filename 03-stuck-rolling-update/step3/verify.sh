#!/bin/bash

[ -s "$HOME/req.txt" ] || exit 1
[ -f deploy.yaml ] || [ -f "$HOME/deploy.yaml" ] || [ -f /root/deploy.yaml ] || exit 1
grep -Eq 'cpu: "[0-9]+m"' deploy.yaml 2>/dev/null || grep -Eq 'cpu: "[0-9]+m"' "$HOME/deploy.yaml" 2>/dev/null
