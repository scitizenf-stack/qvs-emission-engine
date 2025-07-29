# Strategist Epoch Reader — v1.0
$path = "C:\Strategist\OmegaEpoch-Summary.txt"
if (-not (Test-Path $path)) {
    Write-Host "`n? Omega Epoch summary file not found at $path"
    return
}
$content = Get-Content $path
$phases = @()
$cognition = @()
foreach ($line in $content) {
    if ($line -match '^-\s\d') { $phases += $line }
    elseif ($line -match '^-\s\S') { $cognition += $line }
}
Write-Host "`n?? Omega Epoch Core Phases:`n"
$phases | ForEach-Object { Write-Host $_ }
Write-Host "`n?? Cognitive Milestones:`n"
$cognition | ForEach-Object { Write-Host $_ }
Write-Host "`n? Strategist memory scan complete."
