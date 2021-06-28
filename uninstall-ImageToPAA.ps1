<#
  install-ImageToPAA.ps1
  Author: Kira
  Date: 26/06/2021
  Description: Remove  ImageToPAA as a Windows contextual menu item
#>

function RemoveContextMenu {
    Remove-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.png\shell\ImageToPAA -Recurse -Force
    Remove-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\.tga\shell\ImageToPAA -Recurse -Force
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

RemoveContextMenu
