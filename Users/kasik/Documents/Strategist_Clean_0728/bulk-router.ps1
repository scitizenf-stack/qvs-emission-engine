$acc = $env:STRATEGIST_ACC
$routing = $env:STRATEGIST_ROUTING

Write-Host "`n🚀 Strategist Bulk Trigger Activated"
Write-Host "Vault Alias: $acc"
Write-Host "Routing Key:  $routing"
Write-Host "`nLaunching signal swarm..."

$bulkCount = 50

for ($i = 1; $i -le $bulkCount; $i++) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $signalID = "SIG-" + (Get-Random -Minimum 100000 -Maximum 999999)
    $yieldUSD = (Get-Random -Minimum 21 -Maximum 94) + (Get-Random -Minimum 0 -Maximum 99)/100
    $formattedYield = "+$yieldUSD USD (Simulated)"

    $ledger = @(
        "Strategist Vault Ledger",
        "---------------------------",
        "Timestamp:      $timestamp",
        "Signal ID:      $signalID",
        "Vault Alias:    $acc",
        "Routing Key:    $routing",
        "Yield Signal:   $formattedYield",
        "Status:         Strategist transaction mapped"
    )

    $logFile = "C:\Strategist\IngestionGrid\vault-log-$($signalID).txt"
    $ledger | Out-File -FilePath $logFile -Encoding UTF8
    Write-Host "Signal #$i → $signalID processed."
}

Write-Host "`n✅ $bulkCount strategist transactions completed and routed."
