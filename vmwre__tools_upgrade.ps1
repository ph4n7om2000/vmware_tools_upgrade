$URL = "https://packages.vmware.com/tools/esx/latest/windows/x64/"
$QueryVMWareToolsVersion = Invoke-WebRequest $URL -UseBasicParsing
$VMWareToolsSetupName = $QueryVMWareToolsVersion.Links.HREF | Select -Skip 1
$VMWareToolsNewestVersion = $VMWareToolsSetupName -replace ".*VMware-tools-" -replace "-.*"
$VMWareToolsInstalledVersion = Get-WmiObject Win32_Product -Filter "Name like 'VMware Tools'" | Select-Object -ExpandProperty Version
If ($VMWareToolsInstalledVersion -lt $VMWareToolsNewestVersion) 
    {

    $DownloadURL = $URL+$VMWareToolsSetupName
    Invoke-WebRequest -Uri $DownloadURL -OutFile "C:\temp\$VMWareToolsSetupName"
    Write-Host "Download Finished!"
    $ArgumentList = "/S /v " + '"/qn REBOOT=R ADDLOCAL=ALL"' + "/l C:\temp\VMwareToolsSetup.log"
    $FilePath = "C:\temp\" + $VMWareToolsSetupName
    Start-Process -FilePath $FilePath -ArgumentList $ArgumentList

     }

     Else {Write-Host "VMware latest verison is already installed!"}
