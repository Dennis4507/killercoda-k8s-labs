#!/bin/bash

[ -f deployment.yaml ] || [ -f /root/deployment.yaml ] || [ -f "$HOME/deployment.yaml" ]
