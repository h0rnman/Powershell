function Get-ObjectProperties() {
    [CmdletBinding()]

    Param (
        [parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true
        )]
        [ValidateScript(
            {if ( (Get-Member -InputObject $_ | Where-Object {$_.MemberType -eq 'Property'}).count -gt 0)
                {
                $true
                }
            else {
                throw "Object has no properties to display"
            }}
        
        )]
        [Object]$InputObject
    )

    # ValidateScript is just a Where-Object block, so even if I Exit/Return, we still come down to this point in the script
    if ($InputObject -eq $null) {return}

    $Properties = Get-Member -InputObject $InputObject | Where-Object {$_.MemberType -eq 'Property'}
    $results = @()

    foreach ($item in $properties) {
        $temp = "" | select Name,Value
        $temp.Name = $item.Name
        $temp.Value = $InputObject.($item.Name)
        $results += $temp
    }
$results
}