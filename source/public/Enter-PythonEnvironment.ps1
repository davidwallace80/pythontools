<#
.SYNOPSIS
    Enter a Python virtual environment.

.DESCRIPTION
    The Enter-PythonEnvironment enters into a named Python environment.

.PARAMETER Name
    Name of the virtual environment.

.PARAMETER ChangeDirectory
    Change location to the environment directory.

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
  C:\PS> Enter-PythonEnvironment -Name MyEnv

  Description
  -----------

   Enters the Python virtual environment named MyEnv.

#>

[CmdLetBinding(SupportsShouldProcess, ConfirmImpact='High')]
Param (
        [Parameter (Mandatory=$True,Position=1)]
        [String] $Name,
        [Switch] $ChangeDirectory
        )

$ErrorActionPreference = 'Stop'

$VirtualEnvironmentRoot = Get-PythonEnvironmentRoot
$VirtualEnvironmentPath = Join-Path -Path $VirtualEnvironmentRoot -ChildPath $Name


If (Test-Path $VirtualEnvironmentPath)
    {
        #Required for Activate.ps1
        If (!(Test-Path -Path Function:\_OLD_VIRTUAL_PROMPT))
            {
                function global:_OLD_VIRTUAL_PROMPT {""}
            }

        If ($Env:VIRTUAL_ENV)
            {
                Throw 'Already in virtual environment, use Exit-PythonEnvironment!'
            }
        else
            {
                $ActivatePath = Join-Path -Path $VirtualEnvironmentPath -ChildPath 'Scripts\Activate.ps1'
                . $ActivatePath
                & python.exe --version

                If ($ChangeDirectory)
                    {
                        Set-Location -Path $VirtualEnvironmentPath
                    }

            }
    }
else
    {
        Throw "The virtual environment $Name can not be found!"
    }

