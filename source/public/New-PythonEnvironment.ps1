<#
.SYNOPSIS
    Creates a new Python virtual environment.

.DESCRIPTION
    The New-PythonEnvironment cmdlet creates a new Python virtual environment.

.PARAMETER Name
    Name of the virtual environment.

.PARAMETER Version
    Python version of the virtual environment.

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
  C:\PS> New-PythonEnvironment -Name MyEnv

  Description
  -----------

   Creates a new Python virtual environment named MyEnv.

#>

[CmdLetBinding()]
Param (
        [Parameter (Mandatory=$True,Position=1)]
        [String] $Name,
        [Parameter (Position=2)]
        [String] $Version = '3'
        )

$ErrorActionPreference = 'Stop'

$VirtualEnvironmentRoot = Get-PythonEnvironmentRoot
$VirtualEnvironmentPath = Join-Path -Path $VirtualEnvironmentRoot -ChildPath $Name

Switch($Version[0])
    {
        '2' {$ModuleName = 'virtualenv'}
        default {$ModuleName = 'venv'}
    }

If (Test-Path $VirtualEnvironmentPath)
    {
        Throw "The virtual environment $Name already exists!"
    }

If ($Version -eq 2)
    {
        py.exe -$Version -m pip install $ModuleName
    }

py.exe -$Version -m $ModuleName $VirtualEnvironmentPath