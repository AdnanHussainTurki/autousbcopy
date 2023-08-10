# Set the minimum and maximum size for the SD card in GB
$minSizeGB = 100
$maxSizeGB = 150
$usernameWithHost = "autobot@truenas.local"
$destinationFolder = "/mnt/Tank/VideoProjects/Raw/autobot/Recordings"  # Change this to the desired folder on the server
$cygwinPath = "C:\cygwin64\bin"
$env:Path = "$cygwinPath;$env:Path"
$waitTimeInSeconds = 5


function Copy-SDCardFilesToServer {
    # Function to copy files from source to destination using rsync
    function Copy-FilesViaSSH {
        param (
            [string]$sourcePath,
            [string]$destinationPath
        )

        $rsyncArgs = "-a --progress -e ssh $sourcePath ${usernameWithHost}:$destinationPath"
        Start-Process -FilePath $cygwinPath\rsync.exe -ArgumentList $rsyncArgs -NoNewWindow -Wait
    }

    # Get partition data
    $partitions = Get-CimInstance Win32_DiskPartition
    $physDisc = Get-PhysicalDisk
    $arr = @()
    foreach ($partition in $partitions) {
        $cims = Get-CimInstance -Query "ASSOCIATORS OF `
                            {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} `
                            WHERE AssocClass=Win32_LogicalDiskToPartition"
        $regex = $partition.Name -match "(\d+)"
        $physDiscNr = $matches[0]
        foreach ($cim in $cims) {
            $driveLetter = $cim.DeviceID
            # Output $cim.DeviceID, $partition.Name and $physDiscNr for each partition

            if ($driveLetter -and
                $cim.Size -ge ($minSizeGB * 1GB) -and
                $cim.Size -le ($maxSizeGB * 1GB)) {
                $arr += [PSCustomObject]@{
                    Drive     = $driveLetter
                    Partition = $partition.Name
                    MediaType = $($physDisc | ? { $_.DeviceID -eq $physDiscNr } | Select-Object -ExpandProperty MediaType)
                }
            }
        }
    }
    # Output the drive letters
    Write-Host "Found SD cards on the following drive letters:"
    $arr | Format-Table -AutoSize

    # Loop through each drive and copy files to the server
    $arr | ForEach-Object {

        $driveLetter = $_.Drive
        # Get the first character of the drive letter in lowercase
        $driveLetter = $driveLetter.Substring(0, 1).ToLower()
        # Output the drive letter
        Write-Host "Found SD card on $driveLetter"
        $sourcePath = "/cygdrive/$driveletter"
        Write-Host "Source path: $sourcePath"
        Write-Host "Destination path: $destinationFolder"
        # Copy the files to the server
        Copy-FilesViaSSH -sourcePath $sourcePath -destinationPath $destinationFolder
    }

    Write-Host "File copying completed."
}

# Call the function
# Copy-SDCardFilesToServer

$usbDevices = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*USB*" }
$usbCount = $usbDevices.Count
Write-Host "Total USB devices connected: $usbCount"

while ($true) {

    $usbDevices = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*USB*" }
    $currentUsbCount = $usbDevices.Count
    if ($currentUsbCount -gt $usbCount) {
        Write-Host "USB device connected"
        Copy-SDCardFilesToServer
    }
    else {
        Write-Host "No new USB device connected"
    }
    $usbCount = $currentUsbCount
    Start-Sleep -Seconds $waitTimeInSeconds
}

