. ..\EnvironmentVerifier.ps1

ExpectServiceRunningByDisplayName "Windows Firewall" $false
ExpectServiceRunningByName "MpsSvc" $false
ExpectServiceRunningByDisplayName "Windows Firewall"
ExpectServiceRunningByName "MpsSvc"

ExpectServiceRunningByDisplayName "Remote Registry" $false
ExpectServiceRunningByName "RemoteRegistry" $false
ExpectServiceRunningByDisplayName "Remote Registry"
ExpectServiceRunningByName "RemoteRegistry"

Verify