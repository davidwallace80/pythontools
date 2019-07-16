# PythonTools
[![Build Status](https://dev.azure.com/dwallace0561/pythontools/_apis/build/status/davidwallace80.pythontools?branchName=master)](https://dev.azure.com/dwallace0561/pythontools/_build/latest?definitionId=1&branchName=master)

PowerShell module for interacting with Python on Windows

## Installing the Module

The PythonTools Module is published to the PowerShell gallery.

To install the latest module:

```powershell
Install-module -Name PythonTools
```

- To install the latest Prerelease module append the -AllowPreRelease parameter.
- To install a specific version append the -RequiredVersion parameter with the specified version number. i.e -RequiredVersion 1.0.0

To find all versions including Prerelease of the module:

```powershell
Find-Module -Name PythonTools -AllVersions -AllowPrerelease
```

## Using the Module

To use the module, it must be imported into the PowerShell session using the following command:

Note: This step can be skipped in newer versions of PowerShell where auto-importing is supported.

```powershell
Import-Module PythonTools
```

To verify the module has loaded execute the following command:

```powershell
Get-Module -Name PythonTools
```

If loaded successfully, an object will be returned containing details of the module.

To list availble Cmdlets in the module execute the following command:

```powershell
(Get-Module -Name PythonTools).ExportedCommands.Keys
```

For help and examples on each Cmdlet use the following command:

```powershell
Get-Help <CmdLetName> -Full
```

On Windows Systems the following command will open help in a window instead of the console for easier reading.

```powershell
Get-Help <CmdLetName> -ShowWindow
```

**Recommended:** All cmdlets support the -Verbose switch which will return additional information to the console.

## Building and Publishing the Module

****

All build and publish settings are defined in the **PSModule.Settings.ps1** located in the module root path.

**Any changes to the module will require a version increment to the above file before build and publishing.**

Use Semantic Versioning when incrementing the version of the module. Given a version number MAJOR.MINOR.PATCH, increment the:

1. MAJOR version when you make incompatible API changes,
2. MINOR version when you add functionality in a backwards-compatible manner, and
3. PATCH version when you make backwards-compatible bug fixes.

Additional labels including alpha,beta and prerelease and can be applied and published to the PowerShell Gallery for testing prior to general release.

Note. Prerelease versions can only be installed explicitly . Therefore, production will not be impacted by publishing prerelease versions to the gallery.

**All Pull Requests destined for master will automatically trigger a prerelease build and publish to the PowerShell Gallery if successful.**

**All Pull Requests merged to master will automatically trigger a production build and publish to the PowerShell Gallery if successful.**

For Visual Studio Code users CTRL + SHIFT + B will present you with the following build options.

1. Build Local - Builds module to the artifacts path defined in PSModule.Settings.ps1

   This will execute:

   ```powershell
   Start-Build.ps1 -BuildTasks 'Build,Analyse'
   ```

2. Build and Publish Alpha - Builds and publishes module with alpha tag.

   This will execute:

   ```powershell
   Start-Build.ps1 -PreReleaseTag 'alpha' -NugetApiKey $(If($NugetApiKey){$NugetApiKey}Else{$NugetApiKey = Read-Host -Prompt 'Nuget Api Key';$NugetApiKey})
   ```

3. Build and Publish Beta  - Builds and publishes module with beta tag.

   This will execute:

   ```powershell
   Start-Build.ps1 -PreReleaseTag 'beta' -NugetApiKey $(If($NugetApiKey){$NugetApiKey}Else{$NugetApiKey = Read-Host -Prompt 'Nuget Api Key';$NugetApiKey})
   ```

4. Build and Publish PreRelease -  Builds and publishes module with prerelease tag.

   This will execute:

   ```powershell
   Start-Build.ps1 -PreReleaseTag 'prerelease' -NugetApiKey $(If($NugetApiKey){$NugetApiKey}Else{$NugetApiKey = Read-Host -Prompt 'Nuget Api Key';$NugetApiKey})
   ```

5. Build and Publish Production -  Builds and publishes module for production use.

   This will execute:

   ```powershell
   Start-Build.ps1 -NugetApiKey $(If($NugetApiKey){$NugetApiKey}Else{$NugetApiKey = Read-Host -Prompt 'Nuget Api Key';$NugetApiKey})
   ```

Notes:

- A Nuget Api Key is required to publish to the PowerShell Gallery.