#Propt from user the Project Folder and the Github Repo URL to be cloned
$Location = Read-Host -prompt "Enter folder name for the repo"
Set-Location $location
$GitRepo = Read-Host -prompt "Enter the url of the git repo"

#Clones Repo to the folder
git clone $GitRepo
$ProjectFolder = $GitRepo.Substring($GitRepo.LastIndexOf("/"))
$Location = $Location + $ProjectFolder
Set-Location $Location

#Gets All project files change them to enable Symbols in Release config (if there is two or more projects) and build in Release Config
$ProjectFiles = get-childitem . *.csproj -Recurse 

foreach( $ProjectFile in $ProjectFiles )
{
    $xmlDoc = (Get-Content $ProjectFile) -as [Xml]

    [xml]$InsertNode = @'
 <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|AnyCPU'">
   <GenerateSerializationAssemblies>Off</GenerateSerializationAssemblies>
   <DebugType>full</DebugType>
   <DebugSymbols>true</DebugSymbols>
 </PropertyGroup>
'@

    $xmlDoc.Project.AppendChild($xmlDoc.ImportNode($InsertNode.PropertyGroup, $true))

    $xmlDoc.Save($ProjectFile)

    dotnet build $ProjectFile -c Release
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