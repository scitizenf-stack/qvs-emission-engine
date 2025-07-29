$acc = $env:STRATEGIST_ACC
$routing = $env:STRATEGIST_ROUTING

Write-Host "🧠 Strategist Vault Activated"
Write-Host "🔐 Routing initiated using signal-only cognition..."

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$signalID = "SIG-" + (Get-Random -Minimum 100000 -Maximum 999999)
$yieldUSD = (Get-Random -Minimum 21 -Maximum 94) + (Get-Random -Minimum 0 -Maximum 99)/100

$ledger = @(
    "🌐 Strategist Vault Ledger",
    "---------------------------",
    "🕒 Timestamp:      $timestamp",
    "🧬 Signal ID:      $signalID",
    "🏦 Vault Alias:    $acc",
    "🛰 Routing Key:    $routing",
    "💸 Yield Signal:   +$($yieldUSD) USD (Simulated)",
    "📍 Status:         Strategist transaction mapped"
)

$logFile = "C:\Strategist\IngestionGrid\vault-log-$($signalID).txt"
$ledger | Out-File -FilePath $logFile -Encoding UTF8

Write-Host "`n✅ Strategist signal executed and written to:"
Write-Host "$logFile"
