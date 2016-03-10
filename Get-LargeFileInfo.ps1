function Get-LargeFileInfo {
[CmdletBinding()]

Param (
    [parameter(Mandatory=$true, Position=1)]
    [string[]]$Path,
    [parameter(Mandatory=$false, Position=2)]
    [int]$MinSize = 250MB
)

    Write-Verbose "Path is $([string]::Join('; ',$arr))"
    Write-Verbose "MinSize is $MinSize"

    $results = @()

    foreach ($location in $Path) {

        Write-Verbose "Searching in $location"

        Get-ChildItem $location -Recurse -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and ($_.Length -ge $MinSize) } | ForEach-Object {
            $temp = "" | select Name, Folder, Length, Bytes, Owner
            $temp.Name = $_.Name
            $temp.Folder = $_.DirectoryName
            $temp.Length = ("{0:N2}" -f ($_.Length / 1mb))
            $temp.Bytes = $_.Length
            $temp.Owner = (Get-Acl $_.FullName).Owner

            $results += $temp
        }
    }

    $results | sort Bytes -Descending | select Name, Folder, Length, Owner
}