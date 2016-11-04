#!/bin/bash

KEY=$1
TENANT=$2
#echo $KEY $TENANT
stuff=$(curl -s https://iad.servers.api.rackspacecloud.com/v2/$TENANT/servers/detail \
	-H "X-Auth-Token: $KEY")
echo $stuff


#!/bin/bash
source ./rackspace_config
function get_cred {
    curl -s -d \
    '{
        "auth":
        {
           "RAX-KSKEY:apiKeyCredentials":
           {
              "username": "'"$USER"'",
              "apiKey": "'"$KEY"'"}
        }
    }' \
    -H 'Content-Type: application/json' \
    'https://identity.api.rackspacecloud.com/v2.0/tokens'
}

RACK_JSON=$(get_cred $1 $2)
KEY=$(echo $RACK_JSON | jq .access.token.id | sed 's/\"//g')
TENANT=$(echo $RACK_JSON | jq .access.token.tenant.id | sed 's/\"//g')
echo $KEY
echo $TENANT
