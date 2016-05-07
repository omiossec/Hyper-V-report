#requires -Version 4
<#
        .NOTES  

        File Name  	: Hyper-v-report.ps1  
        Version		: 0.5
        Author     	: Olivier Miossec olivier@mediactive.fr
        
        Requires   	: PowerShell V4+, Hyper-v 2012 +

        .LINK  

        http://blog.omiossec.work

        .LINK  

        http://www.mediactive-network.net

        .SYNOPSIS

         Take a  VMMeteringReportForVirtualMachine object and return an array of map

        .DESCRIPTION

         
#>

function get-HypervHost
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$HostName
    )
    Process {
        #test if the $hostname is alive and if Hyper-v is present
        if (Test-connection -computername $HostName -count 2)
        {
            if ((Get-WindowsOptionalFeature  -FeatureName Microsoft-Hyper-V -Online).state -eq 'enabled')
            {
                return $True
            }
            else {
                return $false
            }
        }
    }
}


function Enable-metering
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$HostName
    )
    Process {
        Set-VMHost –ComputerName $HostName  -ResourceMeteringSaveInterval 24:00:00
        get-vm -computername $HostName | ? ResourceMeteringEnabled -eq $false | Enable-VMResourceMetering
    }

}