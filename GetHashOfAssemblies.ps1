$location = "/users/eriadhami/projects/AkvelonTest/MSBuild/CSharpProject2/bin/Release/net7.0/"

Get-ChildItem $location -Recurse | 
Get-FileHash | 
ConvertTo-Json |
Out-File $location/reference_manifest.json

