$results = @()

$Server2008 = (Get-ADComputer -Properties OperatingSystem, Name -Filter {OperatingSystem -like "Windows Server* 2008 Standard"})

$Server2008 | % {
    $temp = "" | select ComputerName,OSVersion,Arch
    $temp.ComputerName = $_.Name
    $OSQuery = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $_.Name
    $temp.OSVersion = $OSQuery.Caption
    $temp.Arch = $OSQuery.OSArchitecture

    $results += $temp
}
