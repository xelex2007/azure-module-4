﻿Configuration main
{
 
Param ( [string] $nodeName = "$env:computername" )
 
Import-DscResource -ModuleName PSDesiredStateConfiguration,xWebAdministration,xNetworking
 
Node $nodeName
  {
    #Install the IIS Role
    WindowsFeature IIS
    {
      Ensure = “Present”
      Name = “Web-Server”
    }
 
    #Install ASP.NET 4.5
    WindowsFeature ASP
    {
      Ensure = “Present”
      Name = “Web-Asp-Net45”
    }
 
     WindowsFeature WebServerManagementConsole
    {
        Name = "Web-Mgmt-Console"
        Ensure = "Present"
    }

    xWebsite DefaultWebsite
{
Ensure = "Present"
Name = "Default Web Site"
State = "Started"
PhysicalPath = "C:\inetpub\wwwroot"
BindingInfo = MSFT_xWebBindingInformation
{
Protocol = "HTTP"
Port = 8080
}
DependsOn = "[WindowsFeature]IIS"
}

xFirewall DockerSwarmTCP
        {
            Name        = 'allow_iis_8080'
            DisplayName = 'Allow IIS 8080'
            Action      = 'Allow'
            Direction   = 'Inbound'
            LocalPort   = ('8080')
            Protocol    = 'TCP'
            Profile     = 'Any'
            Enabled     = 'True'
}
    
  }
}