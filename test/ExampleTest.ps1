. ..\EnvironmentVerifier.ps1


#Program "Wibble" should be present on the VM
ExpectInstalled "Wibble"


#Program "Wibble" should NOT be present on the VM
ExpectInstalled "Wibble" $false


#Program "Wibble" should be present with the version "4.20.9876.0"
ExpectInstalledWIthVersion "Wibble"  "4.20.9876.0"


#Program "Wibble" with version "5.01.4321.0" should not be installed
ExpectInstalledWIthVersion "Wibble" "5.01.4321.0" $false


#Service with DisplayName "Wibble" should be running
ExpectServiceRunningByDisplayName "Wibble"


#Service with service ID "wbl" should be running
ExpectServiceRunningByName "wbl"


#Service with DisplayName "Wibble" should not be running
ExpectServiceRunningByDisplayName "Wibble" $false


#Service with service ID "wbl" should  not be running
ExpectServiceRunningByName "wbl" $false


Verify