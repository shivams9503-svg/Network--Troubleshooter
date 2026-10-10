Write-Host "Network Troubleshooter"
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
if($adapter){
    Write-Host "Pass: $($adapter.Name)" -ForegroundColor Yellow
}else{
    Write-Host "Fail: No active network adapter found." -ForegroundColor Red
}
Write-Host "`n[2] IP Address Check"
$Ip = Get-NetIPAddress -AddressFamily IPv4 | 
Where-Object {$_.IPAddress -ne "127.0.0.1" -and $_.IPAddress -notlike "169.254.*"}
if($Ip){
    Write-Host "PASS: IP found =$($ip[0].IPAddress)" -ForegroundColor Magenta
}else{
    Write-Host "FAIL: No valid IP address found." -ForegroundColor Red
}
Write-Host "`n[3]Gateway (Router) Check"
$gateway = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop
If ($gateway -and (Test-Connection -ComputerName $gateway -Count 2 -Quiet)) {
    Write-Host "PASS: Router($gateway) is reachable." -ForegroundColor Cyan
} else {
    Write-Host "FAIL: Router($gateway) is not reachable." -ForegroundColor Pink
}
Write-Host "`n[4] Internet check"
if (Test-Connection -ComputerName google.com -Count 2 -Quiet) {
    Write-Host "PASS: Internet is reachable." -ForegroundColor blue
}else {
    Write-Host "FAIL: Internet is not reachable." -ForegroundColor Red
}