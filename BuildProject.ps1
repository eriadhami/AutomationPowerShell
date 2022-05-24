Set-Location $ProjectLocation
$projectFiles = get-childitem . *.csproj -Recurse 

foreach( $projectFile in $projectFiles )
{
    dotnet build $projectFile -c Release

    Write-Host ''
}