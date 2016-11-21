   configuration DCInstall 
{ 
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’;
    Node "localhost"
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