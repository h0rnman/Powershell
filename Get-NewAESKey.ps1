function Get-NewAESKey{
[CmdletBinding()]

Param (
    [parameter(Mandatory=$true, Position=1)]
    [ValidateSet(128,192,256)]
    [int]$Length,
    [parameter(Mandatory=$false, Position=2)]
    [string]$Path
)

$key = New-Object Byte[]( ($Length/8) )
$rng = [Security.Cryptography.RNGCryptoServiceProvider]::Create()
$rng.GetBytes($key)

if ($Path) {
    [System.IO.File]::WriteAllBytes($path, $key)
}
$key
}