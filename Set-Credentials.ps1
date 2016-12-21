$env:ARM_SUBSCRIPTION_ID = "abc123"
$env:ARM_CLIENT_ID = "abc123"
$env:ARM_CLIENT_SECRET = "abc13"
$env:ARM_TENANT_ID = "abc123"

Get-ChildItem env: | Where-Object {$_.name -like "ARM_*"}