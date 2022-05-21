$PSScriptRoot
& "$PSScriptRoot\CloneRepo.ps1"
& "$PSScriptRoot\BuildProject.ps1"
& "$PSScriptRoot\GetHashOfAssemblies.ps1"
& "$PSScriptRoot\Archive.ps1"
& "$PSScriptRoot\CopyToReleaseLoc.ps1"
& "$PSScriptRoot\CopyPDB.ps1"