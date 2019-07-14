<#
.SYNOPSIS
    Removes an exisitng Python virtual environment.

.DESCRIPTION
    The Remove-PythonEnvironment removes an exisitng Python virtual environment.

.PARAMETER Name
    Name of the virtual environment.

.PARAMETER Detailed
    Displays detailed information of Python environment.

.INPUTS
  System.String

.OUTPUTS
  None

.NOTES
    Version:         1.00
    Author:          David Wallace
    Updated:         -
    First Released:  21 Oct 2018


    Version History
    --------------

    1.0 (21 Oct 2018)

    * Initial Release

.EXAMPLE
  C:\PS> Get-PythonEnvironment

  Description
  -----------

  Displays all Python environments.

.EXAMPLE
  C:\PS> Get-PythonEnvironment -Name MyEnv -Detailed

  Description
  -----------

  Displays detailed information on Python environment named "MyEnv"
#>

[CmdLetBinding(SupportsShouldProcess, ConfirmImpact='High')]
Param (
        [Parameter (Position=1)]
        [String] $Name,
        [Switch] $Detailed
        )

$ErrorActionPreference = 'Stop'

$VirtualEnvironmentRoot = Get-PythonEnvironmentRoot


If ($Name)
    {
        $Result = Get-Item -Path $(Join-Path -Path $VirtualEnvironmentRoot -ChildPath $Name) | Where-Object -FilterScript { $_.PSIsContainer }
    }
else
    {
        $Result = Get-ChildItem -Path $VirtualEnvironmentRoot| Where-Object -FilterScript { $_.PSIsContainer }
    }

If ($Detailed)
    {
        $DetailedResult = @()

        ForEach ($Env in $Result)
            {
                $DetailedResult += [PSCustomObject] @{
                                                        'Name' = $Env.BaseName
                                                        'Version' =$(Try{$(& $(Join-Path -Path $VirtualEnvironmentRoot -ChildPath "$($Env.BaseName)\Scripts\python.exe") --version 2>&1).Replace('Python ','')}Catch{$_.Exception.Message.Replace('Python ','')})
                                                    }

            }

        $DetailedResult
    }
else
    {
        $Result | Select-Object -Property Name
    }
