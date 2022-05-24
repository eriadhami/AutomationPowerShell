$Location = Read-Host -prompt "Enter folder name for the repo"
Set-Location $location
$GitRepo = Read-Host -prompt "Enter the url of the git repo"

git clone $GitRepo
$ProjectFolder = $GitRepo.Substring($GitRepo.LastIndexOf("/"))
$Location = $Location + $ProjectFolder
Set-Location $Location

$ProjectFiles = get-childitem . *.csproj -Recurse 

foreach( $ProjectFile in $ProjectFiles )
{
    dotnet build $projectFile -c Release
}

Get-ChildItem -Recurse | 
Where-Object { $_.Name -like "*.dll" } |
Get-FileHash | 
ConvertTo-Json |
Out-File HashManifest.json

$ReleaseFolders = Get-ChildItem -Recurse -Directory | 
Where-Object {$_.Name -like "Release"}

foreach ( $ReleaseFolder in $ReleaseFolders)
{
    Compress-Archive -Path $ReleaseFolder.PSPath -Destination $ReleaseFolder.PSPath
    $ZipPath = $ReleaseFolder.PSPath + ".zip"
    Copy-Item -Path $ZipPath -Destination $ReleaseFolder
}

mkdir "Symbols"

$PDBFiles = get-childitem . *.pdb -Recurse 
foreach ( $PDBFile in $PDBFiles)
{
    Copy-Item $PDBFile "Symbols" -Recurse
}

Move-Item -Destination ".." -Path "Symbols"
