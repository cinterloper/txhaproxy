#!/bin/bash
aws route53 list-hosted-zones | jq -c -r '.HostedZones[]|select(.Name=="'$1.'").Id' 
