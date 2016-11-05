#!/bin/bash

user=thecontolgroup
key=1f2a9861e6b54caaa4839bb54e796b5d
tenant=925275

#stuff=$(curl -s https://iad.servers.api.rackspacecloud.com/v2/$tenant/servers/detail \
#	-H "X-Auth-Token: $key")
#echo $stuff


function get_cred {
    curl -s -d \
    '{
        "auth":
        {
           "RAX-KSKEY:apiKeyCredentials":
           {
              "username": "'"$user"'",
              "apiKey": "'"$key"'"}
        }
    }' \
    -H 'Content-Type: application/json' \
    'https://identity.api.rackspacecloud.com/v2.0/tokens'
}

RACK_JSON=$(get_cred)
echo $RACK_JSON
#KEY=$(echo $RACK_JSON | jq .access.token.id | sed 's/\"//g')
#TENANT=$(echo $RACK_JSON | jq .access.token.tenant.id | sed 's/\"//g')
#echo $KEY
#echo $TENANT
