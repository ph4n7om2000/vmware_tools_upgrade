$URL = "https://packages.vmware.com/tools/esx/latest/windows/x64/"
$LogFilePath= "C:\temp\VMwareToolsUpdateScript.log"
(Get-Date).ToString() +" :  "+"Script Initated" >> $logfilepath
$PSversion= Get-Host | Select-Object Version
(Get-Date).ToString() +" : PowerShellversion=" + $PSversion >> $logfilepath
$QueryVMWareToolsVersion = Invoke-WebRequest $URL -UseBasicParsing

$VMWareToolsSetupName = $QueryVMWareToolsVersion.Links.HREF | Select -Skip 1
[string]$VMWareToolsNewestVersion = $VMWareToolsSetupName -replace ".*VMware-tools-" -replace "-.*"
$VMWareToolsInstalledVersion = Get-WmiObject Win32_Product -Filter "Name like 'VMware Tools'" | Select-Object -ExpandProperty Version
[string]$VMWareToolsInstalledVersion = $VMWareToolsInstalledVersion.Substring(0,$VMWareToolsInstalledVersion.lastIndexOf('.'))
If ([version]$VMWareToolsInstalledVersion -lt [version]$VMWareToolsNewestVersion) 
    {
    $DownloadURL = $URL+$VMWareToolsSetupName
try{
    Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\temp\$VMWareToolsSetupName"
    (Get-Date).ToString() +" :  "+"Download Finished!" >> $logfilepath
    }
catch{
         (Get-Date).ToString() +" :  "+"Download Failed" >> $logfilepath
      }
    $ArgumentList = "/S /v " + '"/qn REBOOT=R ADDLOCAL=ALL"' + "/l C:\temp\VMwareToolsSetup.log"
    $FilePath = "C:\temp\" + $VMWareToolsSetupName
    try{
         Start-Process -FilePath $FilePath -ArgumentList $ArgumentList
         (Get-Date).ToString() +" :  "+"Installtion Finished!" >> $logfilepath
        }
    catch{
            (Get-Date).ToString() +" :  "+"Installtion failed" >> $logfilepath
          }
         }    
Else {(Get-Date).ToString() +" :  "+"VMware latest verison is already installed!" >> $logfilepath}

(Get-Date).ToString() +" :  "+"Script has been executed successfully" >> $logfilepath
