configuration AppInstall 
{ 
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’;
    Node "appserver"
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

         WindowsFeature ASP
        {
            Name = "Web-Asp-Net45"
            Ensure = "Present"
          
        }
    } 

}