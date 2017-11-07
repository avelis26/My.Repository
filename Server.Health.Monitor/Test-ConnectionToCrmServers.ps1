$servers = @()
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-ALT2";
	"Ip" = "172.22.163.68"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-User";
	"Ip" = "172.22.163.36"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-ANA";
	"Ip" = "172.22.163.84"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-ANA2";
	"Ip" = "172.22.163.86"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-SFTP";
	"Ip" = "172.22.163.53"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-MGMT";
	"Ip" = "172.22.163.116"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "mssslcrmfw2";
	"Ip" = "172.22.162.136"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-TBLU";
	"Ip" = "172.22.163.21"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "mssslcrmfw1";
	"Ip" = "172.22.162.134"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-TERX";
	"Ip" = "172.22.163.23"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-DC2";
	"Ip" = "172.22.163.101"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-ALT1";
	"Ip" = "172.22.163.20"
}
$servers += $obj
$obj = New-Object -TypeName PsObject -Property @{
	"HostName" = "MS-SSW-CRM-DC1";
	"Ip" = "172.22.163.100"
}
$servers += $obj
Write-Output '-----------------------'
ForEach ($server in $servers) {
    Write-Verbose "Pinging $($server.HostName)..."
    $result = Test-Connection -ComputerName $server.Ip -Quiet
    If ($result -eq $true) {
        Write-Output "$($server.HostName) is alive :)"
    }
    ElseIf ($result -eq $false) {
        Write-Output "$($server.HostName) is dead :("
    }
    Else {
        Write-Error -Message "Something went wrong!!!"
    }
}