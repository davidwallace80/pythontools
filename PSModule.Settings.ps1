$BuildSettings = [Ordered] @{
                                'DefaultBuildTasks' = @('Build') #@('Build','Analyse','Test')
                                'Name' = 'PythonTools'                                                              #Module Name
                                'Author' = 'David Wallace'
                                'Description' = 'PowerShell module for interacting with Python on Windows'
                                'CopyRight' = '2018 David Wallace. All Rights Reserved.'
                                'Tags' = @('Python')
                                'MajorVersion' = 1
                                'MinorVersion' = 0
                                'PatchVersion' = 1
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