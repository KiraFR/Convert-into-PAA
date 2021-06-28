<#
  install-ImageToPAA.ps1
  Author: Kira
  Date: 26/06/2021
  Description: Adds ImageToPAA as a Windows contextual menu item
#>

#
# DO NOT EDIT BELOW UNLESS YOU KNOWN WHAT YOU ARE DOING
#

Function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select the path of ImageToPAA"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
function AddContextMenu($ImageToPAA){
    New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA –Value 'Convert into PAA with ImageToPAA' -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA -Name 'Icon' -PropertyType String -Value "$ImageToPAA,0"
    New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA\command –Value "$ImageToPAA ""%1""" -Force

    New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA –Value 'Convert into PAA with ImageToPAA' -Force
    New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA -Name 'Icon' -PropertyType String -Value "$ImageToPAA,0"
    New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA\command –Value "$ImageToPAA ""%1""" -Force
}
function checkPath {

    #Need to change it
    $ImageToPAA = Get-ItemPropertyValue  -Path 'Registry::HKEY_CURRENT_USER\SOFTWARE\Bohemia Interactive\ImageToPAA' -Name 'tool'

    if ((Get-Item -Path $ImageToPAA -ErrorAction SilentlyContinue) -eq $null) {
        Write-Host 'Select the path of ImageToPAA'
        $ImageToPAA = Get-Folder
        $ImageToPAA = $ImageToPAA + "\ImageToPAA.exe"

        if ((Get-Item -Path $ImageToPAA -ErrorAction SilentlyContinue) -eq $null) {
            Write-Host "ImageToPAA.exe file was not detected in this location : '$($ImageToPAA)',`n`n" -ForegroundColor yellow -BackgroundColor black
            Write-Host "Press any key to exit" -ForegroundColor White
            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }else{
            AddContextMenu $ImageToPAA
        }
    }else{
        AddContextMenu $ImageToPAA
    }
}

#Need Administrator approval
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

checkPath
