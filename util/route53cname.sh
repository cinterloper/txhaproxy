#!/bin/bash

function cleanup { 
  rm /tmp/$$  
}

export SUBDOM=$1
export ENDPOINT=$2
export ROOTDOMAIN=$3

trap "cleanup " 0 1 2 3 15 #call cleanup function if we exit before job is finished

read -d '' JSON <<EOF
{
  "Comment": "$SUBDOM",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$SUBDOM",
        "Type": "CNAME",
        "TTL": 600,
        "ResourceRecords": [
          {
            "Value": "$ENDPOINT"
          }
        ]
      }
    }
  ]
}

EOF


echo $(echo $JSON | jq -c .) > /tmp/$$
aws route53 change-resource-record-sets --hosted-zone-id $(bash getzoneid.sh $ROOTDOMAIN) --change-batch file:///tmp/$$
rm /tmp/$$

