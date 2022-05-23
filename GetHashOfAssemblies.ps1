Get-ChildItem $HashFolder -Recurse | 
Get-FileHash | 
ConvertTo-Json |
Out-File $ReleaseLocation/hashManifest.json