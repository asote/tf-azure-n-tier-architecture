# Install IIS
get-WindowsFeature -name Web-Server | Install-WindowsFeature -IncludeManagementTools

# Initialize Partition and Format New Disk
Get-Disk | ? {$_.PartitionStyle -eq "RAW"} | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | `
Format-Volume -Drive F -FileSystem NTFS -NewFileSystemLabel data -Confirm:$false


# Create default.html
New-Item -ItemType "file" -Path "C:\inetpub\wwwroot\default.htm"
Add-Content C:\inetpub\wwwroot\default.htm $env:COMPUTERNAME
