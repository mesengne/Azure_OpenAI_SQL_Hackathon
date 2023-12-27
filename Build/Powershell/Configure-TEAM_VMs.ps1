param (
    [string]$SASURIKey, 
    [string]$StorageAccount,
    [string]$Installed = "0"
)
$ErrorActionPreference = "Stop"
$InstallPath = 'C:\Install'
$LabsPath = 'C:\_SQLHACK_'
$FullLabsPath = 'C:\_SQLHACK_\LABS'
$Labs4Path = 'C:\_SQLHACK_\LABS\04-SSIS_Migration'
#$LocalGitPath = 'C:\_OpenAI-SQL_'


##################################################################
#Create Folders for Labs and Installs
##################################################################
If(!(test-path $LabsPath))
{
    md -Path $LabsPath
}
If((test-path $FullLabsPath))
{
    Remove-Item $FullLabsPath -Force -Recurse
}
If(!(test-path $InstallPath))
{
    md -Path $InstallPath
}

# md -Path $InstallPath
#If(!(test-path $LocalGitPath))
#{
#    md -Path $LocalGitPath
#}

$Key = $SASURIKey | ConvertFrom-Json

$StorageContext = New-AzStorageContext -StorageAccountName $StorageAccount -SasToken $Key
Get-AzStorageBlob -Context $StorageContext.Context -Container "build" -Prefix "LABS" | Get-AzStorageBlobContent -Force  -Destination $LabsPath |out-null
Get-AzStorageBlob -Context $StorageContext.Context -Container "build" -Prefix "Downloads" | Get-AzStorageBlobContent -Force  -Destination $InstallPath |out-null



#########################################################################
#Set environmetvariables  // #Python and the pip package manager must be in the "path" in Windows for the setup scripts to work.
#Done in local confog file now due to user specific authentication requirements
#########################################################################    
#[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Users\DemoUser\AppData\Local\Programs\Python\Python310", [EnvironmentVariableTarget]::User)
#[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Users\DemoUser\AppData\Local\Programs\Python\Python310\Scripts", [EnvironmentVariableTarget]::User)


#########################################################################
#Install Applications
#########################################################################
if($Installed -eq "1")
{
    # Install SSDT
   Start-Process -file 'C:\Install\Downloads\SSDT-Setup-ENU.exe' -arg '/layout c:\Install\vs_install_bits /quiet /log C:\Install\SSDTLayout_install.txt' -wait 
   start-sleep 10
   Start-Process -file 'C:\Install\vs_install_bits\SSDT-Setup-enu.exe' -arg '/INSTALLVSSQL /install INSTALLALL /norestart /passive /log C:\Install\SSDT_install.txt' -wait 

  # Install Data Mirgation Assistant
   Start-Process -file 'C:\Install\Downloads\DataMigrationAssistant.msi' -arg '/qn /l*v C:\Install\dma_install.txt' -passthru 

  # Install Storage Explorer
   Start-Process -file 'C:\Install\Downloads\StorageExplore.exe' -arg '/VERYSILENT /ALLUSERS /norestart /LOG C:\Install\StorageExplore_install.txt'

    # Install SQL Server Management Studio
    #$pathArgs = {C:\Install\SSMS-Setup.exe /S /v/qn}
    #Invoke-Command -ScriptBlock $pathArgs 
    Start-Process -file 'C:\Install\Downloads\SSMS-Setup-ENU.exe' -arg '/passive /install /norestart /quiet /log C:\Install\SSMS_install.txt' -wait 

    # install .netcore 3.1 for DMA sizing console
    Start-Process -file 'C:\Install\Downloads\windowsdesktop-runtime-3.1.21-win-x64.exe' -arg '/install /quiet /norestart /log C:\Install\DotNet31x86-Install.log' -wait 
    # install ADS extensions
    # Start-Process -file 'azuredatastudio' -arg '--install-extension "C:\Install\Downloads\sql-migration-1.0.4.vsix" --force' -wait 
    # Start-Process -file 'azuredatastudio' -arg '--install-extension "C:\Install\Downloads\managed-instance-dashboard-0.4.2.vsix" --force' -wait 
    
    # install VSCode
    Start-Process -file 'C:\Install\Downloads\VSCode-Setup.exe' -arg '/verysilent /mergetasks=!runcode /norestart /log C:\Install\VSCode-Setup.txt' -Wait
    
    # install GitHub
    Start-Process -file 'C:\Install\Downloads\Github-Setup.exe' -arg '/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS' -Wait <#/LOADINF=""$git_install_inf excluded#>

    # install Python
    #Done in local confog file now due to user specific authentication requirements
    #REMOVED TO LOCAL CONFIG FILE 
    #Start-Process -file 'C:\Install\Downloads\Python-Setup.exe' -arg '/silent /NOCANCEL /NORESTART /log C:\Install\Python_install.txt' -Wait
    #Failing to install Python. Need to find why.
    
    # clone the repo for OpenAI Workshop
    #REMOVED TO LOCAL CONFIG FILE 
    #git clone https://github.com/microsoft/OpenAIWorkshop.git $LocalGitPath
    
    #Install  requirements  
     #Done in local confog file now due to user specific authentication requirements
    #REMOVED TO LOCAL CONFIG FILE 
    #$PipReqFile = 'C:\_OpenAI-SQL_\OpenAIWorkshop\scenarios\incubations\automating_analytics\requirements.txt'
    #pip install -r C:\_OpenAI-SQL_\OpenAIWorkshop\scenarios\incubations\automating_analytics\requirements.txt
    
}

$message="Configuration Successfull"
Write-host  $message
$message | out-file -FilePath "$InstallPath\SetupCompleted.txt" -Force
