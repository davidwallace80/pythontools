
$ErrorActionPreference = 'Stop'

If (!(Get-Module -Name InvokeBuild -ListAvailable))
    {
        Install-PackageProvider NuGet -Force
        Import-PackageProvider NuGet -Force
        Install-Module -Name InvokeBuild -SkipPublisherCheck -Force -ErrorAction SilentlyContinue -Scope CurrentUser -Verbose
    }

Invoke-Expression "Invoke-Build $Args"
