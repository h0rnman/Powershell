function Install-OpenSSHWin() {

	function Get-UserAdminStatus() {
		return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
	}

	if (Get-UserAdminStatus) {


		$URL = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/11_09_2015/OpenSSH-Win32.zip"

		Add-Type -Assembly System.IO.Compression.FileSystem

		Invoke-WebRequest -Uri $URL -OutFile "$env:temp\OpenSSH-Win32.zip"
		[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:temp\OpenSSH-Win32.zip","$env:ProgramFiles")
		
		Invoke-Expression "netsh advfirewall firewall add rule name='SSH Port' dir=in action=allow protocol=TCP localport=22"

		Set-Location "$env:ProgramFiles\OpenSSH-Win32"
		& ".\ssh-keygen.exe " "-A"
		& ".\sshd.exe" "install"
		
		Set-Service -Name "SSHD" -Description "SSH Service for Windows" -StartupType Automatic
		Start-Service SSHD
	}

	else {
		Write-Host "This script must be run as an Administrator"
	}
}
Install-OpenSSHWin