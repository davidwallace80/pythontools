<#
.SYNOPSIS
    Executes Python script from PowerShell.

.DESCRIPTION
    The Invoke-PythonScript cmdlet executes Python script from PowerShell.

.PARAMETER Path
    The path of the Python script to execute.

.PARAMETER ConvertJsonOutput
    Returns Converts JSON output from the Python Script to a PSObject.

.INPUTS
  System.String

.OUTPUTS
  System.String

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
  C:\PS> Invoke-PythonScript -FilePath myscript.py

  Description
  -----------

   Executes a script using the python interpreter.

.EXAMPLE
  C:\PS> Invoke-PythonScript -FilePath myscript.py -ConvertJsonOutput

  Description
  -----------

   Converts Python script json output to a Powershell Object.


#>

[CmdLetBinding()]
Param (
        [Parameter (Mandatory=$True,Position=1)]
        [String] $Path,
        [Switch] $ConvertJsonOutput
        )

$ErrorActionPreference = 'Stop'

$PythonOutput = python.exe $(Get-Command -Name $Path).Source

If ($ConvertJsonOutput)
  {
    $PythonOutput | ConvertFrom-Json
  }
Else
  {
    $PythonOutput
  }