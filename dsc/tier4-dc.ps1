   configuration DCInstall 
{ 
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’;
    Node "dcserver"
    { 
        WindowsFeature ADDSInstall             
        {             
            Ensure = "Present"             
            Name = "AD-Domain-Services"             
        }            
            
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }   
    } 

}