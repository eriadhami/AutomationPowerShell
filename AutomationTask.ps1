Set-Location $PSScriptRoot 
$location = Read-Host -prompt "Enter folder name for the repo"
mkdir $location
$ProjectLocation = $PSScriptRoot +"\"+ $location 
$ProjectToBeBuild = $projectLocation + "\MSBuild\CSharpProject2"
$ReleaseLocation = $ProjectToBeBuild + "\bin\Release"
$HashFolder =  $ReleaseLocation + "\net7.0"


$PSScriptRoot
& "$PSScriptRoot\CloneRepo.ps1" $projectlocation
& "$PSScriptRoot\BuildProject.ps1" $ProjectToBeBuild
& "$PSScriptRoot\GetHashOfAssemblies.ps1" $HashFolder
& "$PSScriptRoot\Archive.ps1" $ReleaseLocation
& "$PSScriptRoot\CopyToReleaseLoc.ps1" $ReleaseLocation
& "$PSScriptRoot\CopyPDB.ps1" $ReleaseLocation #$PdbLocation