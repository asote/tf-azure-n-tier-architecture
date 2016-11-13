# Install IIS
import-module ServerManager
Add-WindowsFeature Web-Server,web-management-console

# Initialize Partition and Format New Disk
Get-Disk | Where {$_.partitionstyle -eq 'raw'} | `
Initialize-Disk -PartitionStyle MBR -PassThru | `
New-Partition -AssignDriveLetter -UseMaximumSize | `
Format-Volume -FileSystem NTFS -NewFileSystemLabel "data" -Confirm:$false

# Create default.html
New-Item -ItemType "file" -Path "C:\inetpub\wwwroot\default.html"
Add-Content C:\inetpub\wwwroot\default.html $env:COMPUTERNAME
