#!/bin/bash

scanId=$(cat scanId.txt)
appscanToken=$(curl -k -s -X POST --header 'Content-Type:application/json' --header 'Accept:application/json' -d '{"KeyId":"'"$appscanApiKeyId"'","KeySecret":"'"$appscanApiKeySecret"'"}' "https://$serviceUrl/api/v4/Account/ApiKeyLogin" | grep -oP '(?<="Token":\ ")[^"]*')

if [ -z "$appscanToken" ]; then
        echo "The token variable is empty. Check the authentication process.";
    exit 1
fi

scanExec=$(curl -k -s -X GET "https://$serviceUrl/api/v4/Scans/Sca/$scanId" -H 'accept:application/json' -H "Authorization:Bearer $appscanToken" | jq  -r '.LatestExecution.Id')

curl -k -s -X GET "https://$serviceUrl/api/v4/OSLibraries/GetLicensesForScope/ScanExecution/$scanExec" -H 'accept:application/json' -H "Authorization:Bearer $appscan   Token" > scanScaResult.txt

cat scanScaResult.txt |  jq -r '.Items[] | .LibraryName, .RiskLevel'

curl -k -s -X 'GET' "https://$serviceUrl/api/v4/Account/Logout" -H 'accept: */*' -H "Authorization: Bearer $appscanToken"