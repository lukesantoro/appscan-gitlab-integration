#appscanApiKeyId='xxxxxxxxxxxxxxx'
#appscanApiKeySecret='xxxxxxxxxxxxxxx'
#appscanAppName='xxxxxxxxxxxxxxx'
#serviceUrl='xxxxxxxxxxxxxxx'
#assetGroupId='xxxxxxxxxxxxxxx'

echo "AppScan Key is $appscanApiKeyId"
echo "AppScan Secret is $appscanApiKeySecret"
echo "AppScan App Name is $appscanAppName"

asocToken=$(curl -k -s -X POST --header 'Content-Type:application/json' --header 'Accept:application/json' -d '{"KeyId":"'"$appscanApiKeyId"'","KeySecret":"'"$appscanApiKeySecret"'"}' "https://$serviceUrl/api/v4/Account/ApiKeyLogin" | grep -oP '(?<="Token":\ ")[^"]*')
echo "AppScan Token is $asocToken"

if [ -z "$asocToken" ]; then
	echo "The token variable is empty or wrong. Check the API keys.";
    exit 1
fi

assetGroupIdExist=$(curl -k -s -X 'GET' "https://$serviceUrl/api/v4/AssetGroups" -H 'accept: application/json' -H "Authorization: Bearer $asocToken" | grep "$assetGroupId")
if [ -z "$assetGroupIdExist" ]; then
        echo "Asset Group ID does not exist or wrong. Check the Asset Group ID.";
    exit 1
fi

replace_spaces() {
    echo "$1" | sed 's/ /%20/g'
}

encodedAppName=$(replace_spaces "$appscanAppName")

appId=$(curl -s -k -X GET --header 'Authorization: Bearer '"$asocToken"'' --header 'Accept:application/json' "https://$serviceUrl/api/v4/Apps?%24top=5000&%24filter=Name%20eq%20%27$encodedAppName%27&%24select=name%2Cid&%24count=false" | grep -oP '(?<="Id":\ ")[^"]*')
if [ -z "$appId" ]; then
	appId=$(curl -s -k -X POST --header "Authorization: Bearer $asocToken" --header 'Accept:application/json' --header 'Content-Type: application/json' -d '{"Name":"'"$appscanAppName"'","AssetGroupId":"'"$assetGroupId"'","UseOnlyAppPresences":false}' "https://$serviceUrl/api/v4/Apps" | grep -oP '(?<="Id": ")[^"]*' | head -n 1);
	echo "There is no $appscanAppName application. It was created. The appId is $appId";
else 
	echo "Application name $appscanAppName exist. The appId is $appId."
fi

if [ -z "$appId" ]; then
        echo "Something went wrong while checking if the application ID exists. Check the AppScan Keys and AssetGroupId variables.";
    exit 1
fi

echo $appId > appId.txt

curl -k -s -X 'GET' "https://$serviceUrl/api/v4/Account/Logout" -H 'accept: */*' -H "Authorization: Bearer $asocToken"
