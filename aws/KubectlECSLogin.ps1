# (Get-ECRLoginCommand).Password | docker login --username AWS --password-stdin 022499028145.dkr.ecr.ap-southeast-1.amazonaws.com

$ACCOUNT = "aws-account-id"
$REGION = "ap-southeast-1"
$SECRET_NAME = "$REGION-ecr-registry"
$EMAIL = "dummy@email.com"

# Get the authorization token from AWS ECR

# Unix
# TOKEN=`aws ecr get-login-password --region ap-southeast-1 \
#     --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

# Windows
# $TOKEN = ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String( `
#             (aws ecr --region=ap-southeast-1 get-authorization-token --output text --query authorizationData[].authorizationToken) `
#         )) -split ":")[1]
$TOKEN = (aws ecr get-login-password --region $REGION)

Write-Output $TOKEN

# Create or replace the registry secret in Kubernetes
kubectl delete secret --ignore-not-found $SECRET_NAME
kubectl create secret docker-registry $SECRET_NAME `
    --docker-server="https://$ACCOUNT.dkr.ecr.$REGION.amazonaws.com" `
    --docker-username="AWS" `
    --docker-password="$TOKEN" `
    --docker-email="$EMAIL"