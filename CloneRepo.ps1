$location = Read-Host -prompt "Enter the location of the folder for the repo"
Set-Location /users/eriadhami/projects/
mkdir $location
Set-Location $location
$gitRepo = Read-Host -prompt "Enter the name of the git repo"
git clone $gitRepo