$copy = @{
  Path = $ReleaseLocation + "\net7.0\Ziped.zip"
  Destination = $ReleaseLocation
}
Copy-Item @copy