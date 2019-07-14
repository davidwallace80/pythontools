<#
.SYNOPSIS
    Exit the active Python virtual environment.

.DESCRIPTION
    The Exit-PythonEnvironment exits the active Python environment.

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
  C:\PS> Exit-PythonEnvironment

  Description
  -----------

   Exits the active Python virtual environment.

#>

$ErrorActionPreference = 'Stop'

Function global:prompt {Write-Host -NoNewline $Env:_OLD_VIRTUAL_PATH}

$Env:_OLD_VIRTUAL_PROMPT = $Null

Copy-Item -Path Function:_OLD_VIRTUAL_PROMPT -Destination Function:prompt

If ($Env:_OLD_VIRTUAL_PATH_PYTHONHOME)
    {
        $Env:PYTHONHOME = $Env:_OLD_VIRTUAL_PATH_PYTHONHOME
    }

If ($Env:_OLD_VIRTUAL_PATH)
    {
        $Env:_OLD_VIRTUAL_PATH = $Null
    }

$Env:VIRTUAL_ENV = $Null
