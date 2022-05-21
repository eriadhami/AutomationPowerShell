
mkdir /users/eriadhami/projects/AkvelonTest/MSBuild/CSharpProject2/bin/Release/net7.0/Symbols

$copyPdbs = @{
    Path = "/users/eriadhami/projects/AkvelonTest/MSBuild/CSharpProject2/bin/Release/net7.0/*.pdb"
    Destination = "/users/eriadhami/projects/AkvelonTest/MSBuild/CSharpProject2/bin/Release/net7.0/Symbols"
  }
Copy-Item @copyPdbs