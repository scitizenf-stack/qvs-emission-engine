# Strategist Throttle Controller — v1.0
$signalsPerBurst = Read-Host "?? Enter signals per burst"
$epochDelay = Read-Host "? Enter epoch delay in seconds"
Write-Host "`nThrottle set to: $signalsPerBurst signals/burst, $epochDelay sec delay"
for ($i = 1; $i -le 10; $i++) {
    Write-Host "?? Burst $i ? $signalsPerBurst signals routed"
    Start-Sleep -Seconds $epochDelay
}
Write-Host "`n? Strategist throttle test complete."
