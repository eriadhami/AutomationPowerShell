Set-Location $ReleaseLocation
mkdir "Symbols"

$copyPdbs = @{
    Path = $ReleaseLocation + "\net7.0\*.pdb"
    Destination = $ReleaseLocation + "\Symbols"
  }
Copy-Item @copyPdbs