<#
  install-ImageToPAA.ps1
  Author: Kira
  Date: 26/06/2021
  Description: Adds ImageToPAA as a Windows contextual menu item
#>

#
# DO NOT EDIT BELOW UNLESS YOU KNOWN WHAT YOU ARE DOING
#

function AddContextMenu {

    #Need to change it
    $Private:ImageToPAA = "PATH\TO\Steam\steamapps\common\Arma 3 Tools\ImageToPAA\ImageToPAA.exe"


    if ((Get-Item -Path $ImageToPAA -ErrorAction SilentlyContinue) -eq $null) {

      Write-Host "ImageToPAA.exe file was not detected in this location : '$($ImageToPAA)',`n`nOpen the file 'Single File\install-ImageToPAA' and on line 15, change the location of the ImageToPAA.exe file.`n" -ForegroundColor yellow -BackgroundColor black
      Write-Host "Press any key to exit" -ForegroundColor White
      $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    }else{
        New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA –Value 'Convert into PAA with ImageToPAA' -Force
        New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA -Name 'Icon' -PropertyType String -Value "$Private:ImageToPAA,0"
        New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA\command –Value "$Private:ImageToPAA ""%1""" -Force

        New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA –Value 'Convert into PAA with ImageToPAA' -Force
        New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA -Name 'Icon' -PropertyType String -Value "$Private:ImageToPAA,0"
        New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA\command –Value "$Private:ImageToPAA ""%1""" -Force
    }
}

#Need Administrator approval
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

AddContextMenu
