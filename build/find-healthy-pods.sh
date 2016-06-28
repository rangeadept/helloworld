#!/bin/sh

kubectl get pods --selector=name=$APP_NAME \
            -o=jsonpath='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'| \
             tr ';' "\n" |  grep "Ready=True" 
