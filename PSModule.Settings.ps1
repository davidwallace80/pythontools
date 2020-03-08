$BuildSettings = [Ordered] @{
                                'DefaultBuildTasks' = @('Build') #@('Build','Analyse','Test')
                                'Name' = 'PythonTools'                                                              #Module Name
                                'Author' = 'David Wallace'
                                'Description' = 'PowerShell module for interacting with Python on Windows'
                                'CopyRight' = '2018 David Wallace. All Rights Reserved.'
                                'ProjectUri' = 'https://github.com/davidwallace80/pythontools'
                                'ReleaseNotes' = 'https://github.com/davidwallace80/pythontools/blob/master/CHANGELOG.md'
                                'LicenseUri' = 'https://github.com/davidwallace80/pythontools/blob/master/LICENSE.md'
                                'Tags' = @('Python')
                                'MajorVersion' = 1
                                'MinorVersion' = 1
                                'PatchVersion' = 3
                                'ArtifactPath' = '.\artifacts'
                                'SourcePath' = '.\source'
                                'TestPath' = '.\tests'
                                'InstallScope' = 'AllUsers'
                                'ScriptAnalyzerExcludeRuleSet' = @('PSPossibleIncorrectComparisonWithNull';'PSAvoidUsingWriteHost')
                                'NUnitXmlFileName' = 'TestResult.xml'
                                'CodeCoverageFileName' = 'Coverage.xml'
                                'PesterMinVersion' = '4.0.0'
                                'AcceptedCodeCoverage' = 0
                                'PSRepositorySettings' = @{
                                                                'Name' = 'PSGallery'
                                                                'SourceLocation' = ''
                                                                'ScriptSourceLocation' = ''
                                                          }
                            }