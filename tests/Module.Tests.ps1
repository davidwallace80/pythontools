#Import Build Settings.
. .\PSModule.Settings.ps1

Describe "Module Validation Tests" {
        
    Context "Import Module" {

        It "Module imports succesfully" {
                
                $Result = Import-Module $(Join-Path -Path $BuildSettings.ArtifactPath -ChildPath $BuildSettings.Name) -PassThru -Force
                $Result | Should -Not -BeNullOrEmpty

            }
        }  
    }

