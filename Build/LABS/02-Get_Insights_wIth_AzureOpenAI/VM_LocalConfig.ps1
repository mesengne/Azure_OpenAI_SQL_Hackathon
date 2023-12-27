#########################################################################

Write-Host -BackgroundColor Black -ForegroundColor Yellow "#################################################################################"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Script sucessfully started"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "This script will ||INSTALL PYTHON || CLONE THE GIT REPO FOR THE LABS || INSTALL THE REQUIREMENTS"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "This may take 5 to 8 minutes to complete"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "#################################################################################"


#########################################################################
#Set variables 
#########################################################################
$LocalGitPath_LAB2 = 'C:\_OpenAI-SQL_\OpenAIWorkshop_LAB2'
$PipReqFile_LAB2 = 'C:\_OpenAI-SQL_\OpenAIWorkshop_LAB2\scenarios\incubations\automating_analytics\requirements.txt'

$LocalGitPath_LAB3 = 'C:\_OpenAI-SQL_\OpenAIWorkshop_LAB3'
$PipReqFile_LAB3 = 'C:\_OpenAI-SQL_\OpenAIWorkshop_LAB3\'


#########################################################################
#Set environmetvariables on Win  // #Python and the pip package manager must be in the "path" in Windows for the setup scripts to work.
#########################################################################    

[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Users\DemoUser\AppData\Local\Programs\Python\Python310;C:\Users\DemoUser\AppData\Local\Programs\Python\Python310\Scripts", [EnvironmentVariableTarget]::Process)
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Users\DemoUser\AppData\Local\Programs\Python\Python310;C:\Users\DemoUser\AppData\Local\Programs\Python\Python310\Scripts", [EnvironmentVariableTarget]::Machine)


#########################################################################
#Install Python -- setup the local repo. --Install Py Requirements


 # install Python
 Start-Process -file 'C:\Install\Downloads\Python-Setup.exe' -arg '/silent /NOCANCEL /NORESTART /log C:\Install\Python_install.txt' -Wait
 

 # clone the repo for OpenAI Workshop
 git clone https://github.com/microsoft/OpenAIWorkshop.git $LocalGitPath_LAB2
 #git clone https://github.com/ElisabethWeigel/Chat-with-SQL-Insert/tree/main $LocalGitPath_LAB3


 #Install  requirements   
pip install -r $PipReqFile_LAB2
#pip install -r $PipReqFile_LAB3
