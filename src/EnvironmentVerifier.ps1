Write-Host "Loading Environment Verifier"

Import-Module ServerManager 

$global:failures = 0
Write-Host "Getting list of installed programs"
$global:programs =  Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall |  Get-ItemProperty |  Select-Object -Property DisplayName, DisplayVersion
$global:programs2 = Get-WmiObject Win32_Product |  Select-Object -Property Name, Version
$global:features =  Get-WindowsFeature | Where-Object {$_.Installed -match “True”} | Select-Object -Property Name

Write-Host "Getting list of running services"
$global:services =  Get-Service | Select Name, Status, DisplayName


Function ExpectInstalled ($program, $bool = $true){

   $search = $global:programs | where-object -filter {$_.DisplayName -eq $program}
   $search2 = $global:programs2 | where-object -filter {$_.Name -eq $program}

   if(((($search | measure).Count -eq 0) -and (($search2 | measure).Count -eq 0)) -eq $bool)
   {
         $ErrorMessageMap = @{
            $false = "Expected: Not Installed | Actual: Installed"
            $true = "Expected: Installed | Actual: Not Installed"
         }

      $ErrorMessage = $ErrorMessageMap[$bool]

      Write-Host "FAILED: ${program} | ${ErrorMessage}"
      $global:failures += 1
   }
   else
   {
      Write-Host "PASSED: ${program}"
   }
}

Function ExpectInstalledWithVersion ($program, $version, $bool = $true){

   $search = $global:programs | where-object -filter {$_.DisplayName -eq $program -and $_.DisplayVersion -eq $version}
   $search2 = $global:programs2 | where-object -filter {$_.Name -eq $program -and $_.Version -eq $version}

   if(((($search | measure).Count -eq 0) -and (($search2 | measure).Count -eq 0)) -eq $bool)
   {

         $ErrorMessageMap = @{
            $false = "Expected: Not Installed | Actual: Installed"
            $true = "Expected: Installed | Actual: Not Installed"
         }

      $ErrorMessage = $ErrorMessageMap[$bool]

      Write-Host "FAILED: ${program}@${version} | ${ErrorMessage}"
      $global:failures += 1
   }
   else
   {
      Write-Host "PASSED: ${program}@${version}"
   }
}

Function ExpectServiceRunning($service, $propertyToCheck, $bool)
{
   $search = $global:services | where-object -filter {$_."${propertyToCheck}" -eq $service -and $_.Status -eq "Running"} 

   if((($search | measure).Count -eq 0) -eq $bool)
   {

         $ErrorMessageMap = @{
            $false = "Expected: Not Running | Actual: Running"
            $true = "Expected: Running | Actual: Not Running"
         }

      $ErrorMessage = $ErrorMessageMap[$bool]

      Write-Host "FAILED: SERVICE with ${propertyToCheck} ${service} | ${ErrorMessage}"
      $global:failures += 1
   }
   else
   {
      Write-Host "PASSED: SERVICE with ${propertyToCheck} ${service}"
   }
}

Function ExpectServiceRunningByName ($service, $bool = $true){

   ExpectServiceRunning $service "Name" $bool

}

Function ExpectServiceRunningByDisplayName ($service, $bool = $true){

   ExpectServiceRunning $service  "DisplayName" $bool 
  
}

Function ExpectFolderExists ($folder, $bool = $true){

   if(Test-Path $folder -ne $bool)
   {

	  $ErrorMessageMap = @{
		  $false = "Expected: Folder does not exist | Actual: Folder exists"
		  $true = "Expected: Folder exists | Actual: Folder does not exist"
	  }

      $ErrorMessage = $ErrorMessageMap[$bool]

      Write-Host "FAILED: ${folder} | ${ErrorMessage}"
      $global:failures += 1
   }
   else
   {
      Write-Host "PASSED: ${folder}"
   }
  
}


Function ExpectWindowsFeature ($feature, $bool = $true){

	$search = $global:features | where-object -filter {$_.Name -eq $feature} 

	if((($search | measure).Count -eq 0) -eq $bool)
	{

         $ErrorMessageMap = @{
            $false = "Expected: Not Installed | Actual: Installed"
            $true = "Expected: Installed | Actual: Not Installed"
         }

		$ErrorMessage = $ErrorMessageMap[$bool]

		Write-Host "FAILED: FEATURE ${feature} | ${ErrorMessage}"
		$global:failures += 1
	}
	else
	{
		Write-Host "PASSED: FEATURE ${feature}"
	}
}

Function Verify()
{
   if($global:failures -gt 0)
   {
	  throw "${global:failures} failures!"
   }
   else
   {
      Write-Host "Configuration verified!"
   }
   Exit $global:failures
}


