Param (
        [String] $PreReleaseTag,
        [String] $NugetApiKey
      )

#Import Build Settings.
. .\PSModule.Settings.ps1

#Global Variables
$ModuleRootPath = $(Join-Path -Path $BuildSettings.ArtifactPath -ChildPath $BuildSettings.Name)
$ModulePath = Join-Path -Path $ModuleRootPath -ChildPath "$($BuildSettings.Name).psm1"
$ManifestPath = Join-Path -Path $ModuleRootPath -ChildPath "$($BuildSettings.Name).psd1"

Task . $BuildSettings.DefaultBuildTasks

Task Build {
                $ErrorActionPreference = 'Stop'

                #Remove existing artifacts.
                Write-Build Yellow  "Removing existing artifacts..."               
                $Null = Remove-Item -Path $BuildSettings.ArtifactPath -Recurse -Force -ErrorAction SilentlyContinue
                $Null = New-Item -Path $BuildSettings.ArtifactPath -ItemType Container -Force
                $Null = New-Item -Path $ModuleRootPath -ItemType Container -Force

                $ManifestConfiguration = @{
                                            Author = $BuildSettings.Author 
                                            Description = $BuildSettings.Description 
                                            RootModule = "$($BuildSettings.Name).psm1"                           
                                            ModuleVersion = "$($BuildSettings.MajorVersion).$($BuildSettings.MinorVersion).$($BuildSettings.PatchVersion)"
                                            AliasesToExport = '*'
                                        }

                Write-Build Yellow  "Building $($BuildSettings.Name) module version $($ManifestConfiguration.ModuleVersion)..." 
                Write-Build Yellow  "Generating module manifiest..."
                New-ModuleManifest @ManifestConfiguration -Path $ManifestPath
                        
                If ($PreReleaseTag)
                    {
                        Write-Build Yellow  "Setting build version to prerelease..."
                        
                        $ModifiedManifest = @()

                        ForEach ($Line in $(Get-Content -Path $ManifestPath))
                            {    
                                $ModifiedManifest += $Line

                                    If ($Line -like "*PSData = @{*")
                                        {
                                            $ModifiedManifest += "`n`t`tPrerelease = '-$($PreReleaseTag)'"
                                        }
                            }

                        $ModifiedManifest | Set-Content -Path $ManifestPath -Force                
                    }
                
                $SpecialFolders = @('private','public')
                $SourceFiles = Get-ChildItem -Path $BuildSettings.SourcePath

                ForEach ($Item in $SourceFiles)
                    {
                        If (!($SpecialFolders.Contains($Item.BaseName)))
                            {
                                $Null = Copy-Item -Path $Item.PSPath -Destination $ModuleRootPath -Recurse -Force
                            }     
                    }

                #Get public and private function definition files.
                $Private = @( Get-ChildItem -Path "$($BuildSettings.SourcePath)\private\*.ps1" -Exclude '*.Alias.ps1' -ErrorAction SilentlyContinue )
                $Public  = @( Get-ChildItem -Path "$($BuildSettings.SourcePath)\public\*.ps1" -Exclude '*.Alias.ps1' -ErrorAction SilentlyContinue )
                    
                Set-Content -Value '' -Path $ModulePath -Force

                Foreach($Function in @($Private + $Public))
                    {
                        Try
                            {
                                Write-Build Yellow "Adding function $($Function.BaseName) to module..."
                                Add-Content -Value "Function $($Function.BaseName)`n{`n" -Path $ModulePath
                                Get-Content $Function.Fullname | Add-Content -Path $ModulePath
                                Add-Content -Value "`n}`n" -Path $ModulePath

                                If ($Public.Contains($Function))
                                    {
                                        $AliasContent = Get-Content -Path "$($BuildSettings.SourcePath)\public\$($Function.BaseName).Alias.ps1" -ErrorAction SilentlyContinue

                                        If ($AliasContent)
                                            {
                                                Write-Build Yellow "Setting alias for function $($Function.BaseName)."
                                                $AliasContent | Add-Content -Path $ModulePath        
                                            }
                                        
                                        Write-Build Yellow "Setting function $($Function.BaseName) to export."
                                        Add-Content -Value "Export-ModuleMember -Alias '*' -Function $($Function.Basename)`n" -Path $ModulePath
                                    
                                    }

                            }
                        Catch
                            {
                                Throw "Failed to add function $($Function.BaseName): $_"
                            }
                    }

           }

Task Analyse {
                $ErrorActionPreference = 'Stop'

                Write-Build Yellow  "Analysing $($BuildSettings.Name) module..."
                
                If (!(Get-Module -Name PSScriptAnalyzer -ListAvailable))
                    {
                        Install-Module -Name PSScriptAnalyzer -SkipPublisherCheck -Force -ErrorAction SilentlyContinue -Scope $BuildSettings.InstallScope
                    }

                $Private = @( Get-ChildItem -Path "$($BuildSettings.SourcePath)\private\*.ps1" -ErrorAction SilentlyContinue )
                $Public  = @( Get-ChildItem -Path "$($BuildSettings.SourcePath)\public\*.ps1" -ErrorAction SilentlyContinue )

                $ScriptErrors = Foreach($Function in @($Private + $Public))
                                    {
                                        Invoke-ScriptAnalyzer -Path $Function.PSPath -ExcludeRule $BuildSettings.ScriptAnalyzerExcludeRuleSet
                                    }
                
                If ($ScriptErrors)
                    {
                        $ScriptErrors
                        Throw "$($ScriptErrors.Count) PSScriptAnalyzer error/warnings detected!"
                    } 
                        
           }

Task Test {
                $ErrorActionPreference = 'Stop'

                Remove-Module -Name $BuildSettings.Name -Force -ErrorAction SilentlyContinue
                Import-Module -Name $ModuleRootPath -Force

                If (!(Get-Module -Name Pester -ListAvailable))
                    {
                        Install-Module -Name Pester -SkipPublisherCheck -Force -ErrorAction SilentlyContinue -Scope $BuildSettings.InstallScope
                    }

                $NUnitXmlPath = Join-Path -Path $BuildSettings.ArtifactPath -ChildPath $BuildSettings.NUnitXmlFileName

                $Pester = Invoke-Pester -CodeCoverage $ModulePath -OutputFile $NUnitXmlPath -OutputFormat NUnitXml -PassThru

                assert($Pester.FailedCount -eq 0) ("$($Pester.FailedCount) test(s) failed!")

                $CodeCoverage = [Math]::Round($Pester.CodeCoverage.NumberOfCommandsExecuted / $Pester.CodeCoverage.NumberOfCommandsAnalyzed * 100,2)

                assert($CodeCoverage -ge $BuildSettings.AcceptedCodeCoverage) ("Code coverage must be greater or equal to $($BuildSettings.AcceptedCodeCoverage)%! Code Coverage is $CodeCoverage%")
          }

Task Archive {
                $ErrorActionPreference = 'Stop'

                Write-Build Yellow  "Creating archive for $($BuildSettings.Name) module..."
                Compress-Archive -Path $ModuleRootPath -DestinationPath "$ModuleRootPath.zip" -Force
             }

Task Publish {
                $ErrorActionPreference = 'Stop'

                Write-Build Yellow  "Publishing $($BuildSettings.Name) module to $($BuildSettings.PSRepositorySettings.Name)..."
                Publish-Module -Path $ModuleRootPath -Repository $BuildSettings.PSRepositorySettings.Name -NuGetApiKey $NugetApiKey -Force
             }