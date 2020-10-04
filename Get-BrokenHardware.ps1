<# 
.SYNOPSIS 
    This script gets a list of non-working hardware 
.DESCRIPTION 
    This script re-implements another TechNet Scripting 
    Gallery script that was written in VB (see  
    http://tinyurl.com/y4hmtbr).  
    This script first uses WMI to get system details, then 
    gets and displays hardware that has errored. 
.NOTES 
    File Name  : Get-BrokenHardware.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk (modified by Morgan Gardner) 
    Requires   : PowerShell Version 2.0 
.LINK 
    This script posted to: 
        http://www.pshscripts.blogspot.com 
    This script posted to TechNet Script Centre at: 
  
.EXAMPLE 
    PSH [C:\foo]: Get-BrokenHardware.ps1 
    Computer Details: 
    Manufacturer: Dell Inc. 
    Model:        Precision WorkStation T7400 
    Service Tag:  6Y84C3J 
 
    Hardware that's not working list 
    Description:  WD My Book Device USB Device 
    Device ID:    USBSTOR\OTHER&VEN_WD&PROD_MY_BOOK_DEVICE&REV_1010\7&2A4E07C&0&575532513130303732383932&1 
    Error ID:     28 
#> 
 
# Display Computer details 
"Computer Details:" 
$comp = gwmi Win32_ComputerSystem 
"Manufacturer: {0}" -f $comp.Manufacturer 
"Model:        {0}" -f $comp.Model 
$computer2 = Get-WmiObject Win32_ComputerSystemProduct 
"Service Tag:  {0}" -f $computer2.IdentifyingNumber 
"" 
 
#Get hardware that is errored 
"Hardware that's not working list"  
""
$broken = Get-WmiObject Win32_PnPEntity | where {$_.ConfigManagerErrorCode -ne 0} 
 
$dictionary = New-Object 'system.collections.generic.dictionary[uint32,string]'
$dictionary[0] = "Device is working properly."
$dictionary[1] = "Device is not configured correctly."
$dictionary[2] = "Windows cannot load the driver for this device."
$dictionary[3] = "The driver for this device might be corrupted, or your system may be running low on memory or other resources."
$dictionary[4] = "This device is not working properly. One of its drivers or your registry might be corrupted."
$dictionary[5] = "The driver for this device needs a resource that Windows cannot manage."
$dictionary[6] = "The boot configuration for this device conflicts with other devices."
$dictionary[7] = "Cannot filter."
$dictionary[8] = "The driver loader for the device is missing."
$dictionary[9] = "This device is not working properly because the controlling firmware is reporting the resources for the device incorrectly."
$dictionary[10] = "This device cannot start."
$dictionary[11] = "This device failed."
$dictionary[12] = "This device cannot find enough free resources that it can use."
$dictionary[13] = "Windows cannot verify this device's resources."
$dictionary[14] = "This device cannot work properly until you restart your computer."
$dictionary[15] = "This device is not working properly because there is probably a re-enumeration problem."
$dictionary[16] = "Windows cannot identify all the resources this device uses."
$dictionary[17] = "This device is asking for an unknown resource type."
$dictionary[18] = "Reinstall the drivers for this device."
$dictionary[19] = "Failure using the VxD loader."
$dictionary[20] = "Your registry might be corrupted."
$dictionary[21] = "System failure: Try changing the driver for this device. If that does not work, see your hardware documentation. Windows is removing this device."
$dictionary[22] = "This device is disabled."
$dictionary[23] = "System failure: Try changing the driver for this device. If that doesn't work, see your hardware documentation."
$dictionary[24] = "This device is not present, is not working properly, or does not have all its drivers installed."
$dictionary[25] = "Windows is still setting up this device."
$dictionary[26] = "Windows is still setting up this device."
$dictionary[27] = "This device does not have valid log configuration."
$dictionary[28] = "The drivers for this device are not installed."
$dictionary[29] = "This device is disabled because the firmware of the device did not give it the required resources."
$dictionary[30] = "This device is using an Interrupt Request (IRQ) resource that another device is using."
$dictionary[31] = "This device is not working properly because Windows cannot load the drivers required for this device."
 
#Display broken hardware 
foreach ($obj in $broken){     
"Description:  {0}" -f  $obj.Description 
"Device ID:    {0}" -f  $obj.DeviceID 
"Error Status:     {0}" -f  $dictionary[$obj.ConfigManagerErrorCode]
"" 
}

Read-Host