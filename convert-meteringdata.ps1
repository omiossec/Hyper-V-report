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

         Take a VMMeteringReportForVirtualMachine object and return an array of map

        .DESCRIPTION

         
#>

function Convert-VMMeteringData
{
    
        param (
            [Parameter(Mandatory = $true)]
            $VmMeteringData
        )
        
$ArrVmMetering = @()
if ($VMReports.getType() -eq [System.Array])
{
    foreach ($VMReport in $VMReports) 
    {
    
    if ($VMReport.GetType() -eq [Microsoft.HyperV.PowerShell.VMMeteringReportForVirtualMachine])
        {
            
            # We want the network traffic for all vmnetadapter, a vm can have up to 8 netadapter, I use measure-object with -sum to calcul the trafic from all the adapter
            $Outbound = $VMReport.NetworkMeteredTrafficReport | Where-Object { $_.RemoteAddress -eq "0.0.0.0/0" -AND $_.Direction -eq "OutBound" } |  Measure-Object TotalTraffic -Sum 
            $inbound = $VMReport.NetworkMeteredTrafficReport | Where-Object { $_.RemoteAddress -eq "0.0.0.0/0" -AND $_.Direction -eq "InBound" } |  Measure-Object TotalTraffic -Sum 
        
             
            $Report=@{"AvgCPU"=$VMReport.AvgCPU.ToString();"AvgRam"=$VMReport.AvgRAM.ToString();"TotalDisk"=$VMReport.TotalDisk.ToString();"AggregatedAverageLatency" = $VMReport.AggregatedAverageLatency.ToString(); "AggregatedAverageNormalizedIOPS" = $VMReport.AggregatedAverageNormalizedIOPS.ToString();  "AggregatedDiskDataRead" = $VMReport.AggregatedDiskDataRead.ToString();  "AggregatedDiskDataWritten" = $VMReport.AggregatedDiskDataWritten.ToString(); "OutboundTraffic" = $Outbound.Sum; "InboundTraffic" = $inbound.Sum  }
            $ArrVmMetering.add($Report)
        }
        else {
            throw "No VM Metering data"
        }
    }
}   
elseif ($VMReport.GetType() -eq [Microsoft.HyperV.PowerShell.VMMeteringReportForVirtualMachine]) {
            # We want the network traffic for all vmnetadapter, a vm can have up to 8 netadapter, I use measure-object with -sum to calcul the trafic from all the adapter
            $Outbound = $VMReport.NetworkMeteredTrafficReport | Where-Object { $_.RemoteAddress -eq "0.0.0.0/0" -AND $_.Direction -eq "OutBound" } |  Measure-Object TotalTraffic -Sum 
            $inbound = $VMReport.NetworkMeteredTrafficReport | Where-Object { $_.RemoteAddress -eq "0.0.0.0/0" -AND $_.Direction -eq "InBound" } |  Measure-Object TotalTraffic -Sum 
        
              
            $Report=@{"AvgCPU"=$VMReport.AvgCPU.ToString();"AvgRam"=$VMReport.AvgRAM.ToString();"TotalDisk"=$VMReport.TotalDisk.ToString();"AggregatedAverageLatency" = $VMReport.AggregatedAverageLatency.ToString(); "AggregatedAverageNormalizedIOPS" = $VMReport.AggregatedAverageNormalizedIOPS.ToString();  "AggregatedDiskDataRead" = $VMReport.AggregatedDiskDataRead.ToString();  "AggregatedDiskDataWritten" = $VMReport.AggregatedDiskDataWritten.ToString(); "OutboundTraffic" = $Outbound.Sum; "InboundTraffic" = $inbound.Sum  }
            $ArrVmMetering.add($Report)
}
else
{
    throw "No VM Metering data"
}

    return $ArrVmMetering
}