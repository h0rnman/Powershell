function Get-LargeFileInfo {
[CmdletBinding()]

Param(
	[Parameter(Position=1)]
	[string]$Path = $PSScriptRoot,
	[Parameter(Position=2)]
	[int]$MinSize = 250MB
)

	$results = @()
	Get-ChildItem $path -recurse -ea 0 | Where-Object {$_.PSIsContainer -eq $false -and $_.length -gt $MinSize } | Foreach-Object {
		$obj = "" | select Directory, Name, Length, LengthKB, LengthMB, LengthGB, Owner
		$obj.Directory = $_.DirectoryName
		$obj.Name = $_.Name
        $obj.Length = $_.length
        $obj.LengthKB = ( ("{0:N2}" -f ($_.length/1KB)))
		$obj.LengthMB = ( ("{0:N2}" -f ($_.length/1MB)))
        $obj.LengthGB = ( ("{0:N2}" -f ($_.length/1GB)))
		$obj.Owner = ((Get-ACL $_.FullName).Owner)
		$results += $obj
	}
	$results
}