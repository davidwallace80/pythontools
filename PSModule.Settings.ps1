$BuildSettings = [Ordered] @{
                                'DefaultBuildTasks' = @('Build') #@('Build','Analyse','Test')
                                'Name' = 'PythonTools'                                                              #Module Name
                                'Author' = 'David Wallace'                                                      
                                'Description' = 'Tools to for working with Python on Microsoft Windows.'
                                'MajorVersion' = 1
                                'MinorVersion' = 0
                                'PatchVersion' = 0
                                'ArtifactPath' = '.\artifacts'
                                'SourcePath' = '.\source'
                                'TestPath' = '.\tests'
                                'InstallScope' = 'AllUsers'
                                'ScriptAnalyzerExcludeRuleSet' = @('PSPossibleIncorrectComparisonWithNull';'PSAvoidUsingWriteHost')
                                'NUnitXmlFileName' = 'TestResult.xml'
                                'AcceptedCodeCoverage' = 80
                                'PSRepositorySettings' = @{
                                                                'Name' = 'PSPrivateGallery'
                                                                'SourceLocation' = 'http://127.0.0.1:8081/repository/PSPrivateGalleryModule/'
                                                                'ScriptSourceLocation' = 'http://127.0.0.1:8081/repository/PSPrivateGalleryScript/'
                                                          }   
                            }