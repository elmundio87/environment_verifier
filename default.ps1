properties {
  $project = 'EnvironmentVerifier'
  $changeset = 'SNAPSHOT'
  $deployment_netshare = '\\TFSBUILD2\builds'
}

# Load modules
#######################

$p = [Environment]::GetEnvironmentVariable("PSModulePath")
[Environment]::SetEnvironmentVariable("PSModulePath", ($p += ";${PWD}\ps_modules"))

$scriptPath=Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path

Import-Module Pscx

# Tasks
#######################

task default -depends deploy

taskSetup { 
  #Global calculated project properties go here
 $global:artifact_name = "${project}-${changeset}"
}

task clean {
    if(Test-Path ".\Output\"){
     Remove-Item ".\Output\*" -recurse
    }
}

task package -depends clean {
    New-Item "output" -type d -force
    Write-Host  "Output\${artifact_name}.zip"
    Write-Zip  -Path "src\*" -OutputPath "Output\${artifact_name}.zip"
}

task deploy -depends package{
    New-Item "${deployment_netshare}\${project}\${artifact_name}" -type d -force
    Copy-Item -Path "Output\${artifact_name}.zip" -Destination "${deployment_netshare}\${project}\${artifact_name}\${artifact_name}.zip"
}

task test {
  "Test task"
}

# Utility Functions
#######################
 
# Exits the script when an error occurs and prints a message to the user
function Exit-Build
{
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Message
    )
 
    Write-Host $("`nExiting build because task [{0}] failed.`n->`t$Message.`n" -f $psake.context.Peek().currentTaskName) -ForegroundColor Red
 
    Exit
}