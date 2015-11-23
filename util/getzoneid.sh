#!/bin/bash
aws route53 list-hosted-zones | jq -c '.HostedZones[]|select(.Name=="$1.") | {Id}' | cut -d '"' -f 4
