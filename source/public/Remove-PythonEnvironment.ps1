<#
.SYNOPSIS
    Removes an exisitng Python virtual environment.

.DESCRIPTION
    The Remove-PythonEnvironment removes an exisitng Python virtual environment.

.PARAMETER Name
    Name of the virtual environment.

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
  C:\PS> Remove-PythonEnvironment -Name MyEnv

  Description
  -----------

   Removes the existing Python virtual environment named MyEnv.

#>

[CmdLetBinding(SupportsShouldProcess, ConfirmImpact='High')]
Param (
        [Parameter (Mandatory=$True,Position=1)]
        [String] $Name
        )

$ErrorActionPreference = 'Stop'

$VirtualEnvironmentRoot = Get-PythonEnvironmentRoot
$VirtualEnvironmentPath = Join-Path -Path $VirtualEnvironmentRoot -ChildPath $Name

If (Test-Path $VirtualEnvironmentPath)
    {

        If ($Env:VIRTUAL_ENV -eq $VirtualEnvironmentPath)
            {
                Throw 'Virtual environment in use, use Exit-PythonEnvironment!'
            }
        Else
            {
                If ($PSCmdlet.ShouldProcess("Removing virtual path $VirtualEnvironmentPath"))
                    {
                        Remove-Item -Path $VirtualEnvironmentPath -Recurse
                    }

            }
    }
Else
    {
       Throw "Python environment $Name can not be found!"
    }