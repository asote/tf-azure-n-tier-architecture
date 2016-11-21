configuration IISInstall 
{ 
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’;
    Node "localhost"
    { 
        WindowsFeature InstallIIS 
        { 
            
            Name = "Web-Server"   
            Ensure = "Present" 
                    
        } 
         WindowsFeature InstallIISConsole
        {
            Name = "Web-Mgmt-Console"
            Ensure = "Present"
        }
    } 

}