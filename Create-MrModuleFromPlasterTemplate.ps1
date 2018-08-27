#Create a new PowerShell Script module
$plasterParams = @{
    TemplatePath      = 'U:\GitHub\Plaster\Template'
    DestinationPath   = 'U:\GitHub'
    Name              = 'MrHyperV'
    Description       = 'PowerShell Scripts, Functions, and Modules for managing Hyper-V'
    Version           = '1.0.0'
    Author            = 'Mike F. Robbins'
    CompanyName       = 'mikefrobbins.com'
    PowerShellVersion = '3.0'
    Folders           = 'functions'
    Git               = $true
    GitRepoName       = 'Hyper-V'
    TechName          = 'Hyper-V'
    Options           = ('License', 'Readme', 'GitIgnore', 'GitAttributes')
}
If (-not(Test-Path -Path $plasterParams.DestinationPath -PathType Container)) {
    New-Item -Path $plasterParams.DestinationPath -ItemType Directory | Out-Null
}
Invoke-Plaster @plasterParams


#Remove '*' from module manifest. Don't export anything unless explicitly told to do so.
if ($plasterParams.Git) {
    $ModulePath = "$($plasterParams.DestinationPath)\$($plasterParams.GitRepoName)\$($plasterParams.Name)"
}
else {
    $ModulePath = "$($plasterParams.DestinationPath)\$($plasterParams.Name)"
}

if (Test-Path -Path $ModulePath -PathType Container) {
    Update-ModuleManifest -Path "$ModulePath\MrHyperV.psd1" -FunctionsToExport '@()' -AliasesToExport '@()' -VariablesToExport '@()' -CmdletsToExport '@()'
}
else {
    Write-Warning -Message "'$ModulePath' path does not exist or is not valid!"
}

Update-ModuleManifest -Path "$ModulePath\MrHyperV.psd1" -FunctionsToExport (Get-MrFunctionsToExport -Path $ModulePath\functions -Simple)
Test-MrFunctionsToExport -ManifestPath "$ModulePath\MrHyperV.psd1"

$DestinationPath = "C:\tmp2\$($plasterParams.Name)"
If (-not(Test-Path -Path $DestinationPath -PathType Container)) {
    New-Item -Path $DestinationPath -ItemType Directory | Out-Null
}
Copy-Item -Path $ModulePath\MrHyperV.psd1 -Destination $DestinationPath
Get-ChildItem -Path $ModulePath\functions | Get-Content
$a -match '#Requires' | select -Unique

Get-ChildItem -Path $ModulePath\functions | Get-Content | Out-File -FilePath $DestinationPath\MrHyperV.psm1


show-ast $DestinationPath\MrHyperV.psm1