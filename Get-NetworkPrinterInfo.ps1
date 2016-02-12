function Decode-PrinterStatusCodes ($StatusCode) {

# The following magic values come from Microsoft: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394363(v=vs.85).aspx
    $decodedValue = `
    switch ($_.PrinterStatus) {
        1 {"Other/Offline"; break;}
        2 {"Unknown"; break;}
        3 {"Idle"; break;}
        4 {"Printing"; break;}
        5 {"Warming Up"; break;}
        6 {"Stopped"; break;}
        7 {"Offline"; break;}
        default {"Not Defined"; break;}
    }
return $decodedValue
}

function Get-NetworkPrinterInfo () {
[CmdletBinding()]

Param (

    [Parameter(Mandatory=$true,Position=1)]
        [string]$Server    
)

    # Object to hold our results
    $printerList = @()

    # CIM Query for Print Server properties

    $CIMSession = New-CimSession -ComputerName $Server
    Get-CimInstance -ClassName Win32_Printer -CimSession $CIMSession | `
    select -Property * | `
        % {
            # If there is no ShareName, then it's not a "Networked Printer"
            # It could be a Print-To-IP printer, but we don't care about those - we don't support that, so those users are on their own
            if (($_.ShareName -ne $null)) {
                $filter = "Name='" + $_.PortName + "'"
                $PortInfo = Get-CimInstance -ClassName Win32_TCPIPPrinterPort -CimSession $CIMSession -Filter $filter | select -Property *
                $printerInfo = "" | select Name,DriverName,PortName,IPAddress,Port,PortType,Status,StatusRaw,Server
                $printerInfo.Name = $_.ShareName
                $printerInfo.DriverName = $_.DriverName
                $printerInfo.PortName = $_.PortName
                $printerInfo.IPAddress = $PortInfo.HostAddress
                $printerInfo.Port = $PortInfo.PortNumber
                $printerInfo.PortType = $PortInfo.Description
                $printerInfo.StatusRaw = $_.PrinterStatus
                $printerInfo.Status = Decode-PrinterStatusCodes ($_.PrinterStatus)
                $printerInfo.Server = $Server
                $printerList += $printerInfo
            }
        }
    return $printerList
}

function Get-LocalMachinePrinterInfo ($machine) {

    # Object to hold our results
    $results = @()
    
    $InstalledPrinters = (Get-WmiObject -Class Win32_Printer -ComputerName $machine)
    $InstalledPrinters | % {
        # If there is no SystemName in the printer object, it's a local printer
        if ($_.SystemName -notcontains $machine) {
            # We found a Networked Printer
            $temp = "" | select FullName,Status,Printer,Host
            $temp.FullName = $_.Name
            $temp.Printer = $_.ShareName
            $temp.Host = $_.SystemName.replace('\\',"")
            $temp.Status = Decode-PrinterStatusCodes($_.PrinterStatus)
            $results += $temp
        }
    }
$results | select Printer, Host, Status
}
