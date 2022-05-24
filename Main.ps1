#Propt from user the Project Folder and the Github Repo URL to be cloned
$Location = Read-Host -prompt "Enter folder name for the repo"
Set-Location $location
$GitRepo = Read-Host -prompt "Enter the url of the git repo"

#Clones Repo to the folder
git clone $GitRepo
$ProjectFolder = $GitRepo.Substring($GitRepo.LastIndexOf("/"))
$Location = $Location + $ProjectFolder
Set-Location $Location

#Gets All project files (if there is two or more projects) to be builded in Release Config
$ProjectFiles = get-childitem . *.csproj -Recurse 

foreach( $ProjectFile in $ProjectFiles )
{
    dotnet build $projectFile -c Release
}

#Creates Hash Manifest with the Hash used, File location and the Hash
Get-ChildItem -Recurse | 
Where-Object { $_.Name -like "*.dll" } |
Get-FileHash | 
ConvertTo-Json |
Out-File HashManifest.json

#Get the Release folders and makes a zip file with them
$ReleaseFolders = Get-ChildItem -Recurse -Directory | 
Where-Object {$_.Name -like "Release"}

foreach ( $ReleaseFolder in $ReleaseFolders)
{
    Compress-Archive -Path $ReleaseFolder.PSPath -Destination $ReleaseFolder.PSPath
    $ZipPath = $ReleaseFolder.PSPath + ".zip"
    Copy-Item -Path $ZipPath -Destination $ReleaseFolder
}

#Creates a folder named Symbols to any release location and copyes there all .pdb files
$PDBFiles = get-childitem . *.pdb -Recurse 
foreach ( $PDBFile in $PDBFiles)
{
    Copy-Item $PDBFile -Destination(new-item -type directory -force ($PDBFile.PSParentPath + "\Symbols")) -force -ea 0
}