# Install IIS
get-WindowsFeature -name Web-Server | Install-WindowsFeature -IncludeManagementTools

# Initialize Partition and Format New Disk
Get-Disk -Number 2 | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter F -UseMaximumSize
Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel data -Confirm:$false


# Create default.html
New-Item -ItemType "file" -Path "C:\inetpub\wwwroot\default.htm"
Add-Content C:\inetpub\wwwroot\default.html $env:COMPUTERNAME
