$compress = @{
    Path = $ReleaseLocation
    DestinationPath = $ReleaseLocation + "\net7.0\Ziped"
  }
Compress-Archive @compress