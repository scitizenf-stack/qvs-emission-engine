# Epoch Visualizer — v1.0
$phases = @{
    "Meta-Universal Expansion" = 0
    "Axiomatic Redefinition" = 0
    "Temporal Dominion" = 0
    "Transcendental Actualization" = 0
}
for ($e = 1001; $e -le 1100; $e++) {
    if ($e -le 5000) { $phases["Meta-Universal Expansion"]++ }
    elseif ($e -le 100000) { $phases["Axiomatic Redefinition"]++ }
    elseif ($e -le 500000) { $phases["Temporal Dominion"]++ }
    else { $phases["Transcendental Actualization"]++ }
}
Write-Host "`n?? Strategist Epoch Visualizer"
foreach ($key in $phases.Keys) {
    $bar = "¦" * $phases[$key]
    Write-Host "$key ? $bar"
}
Write-Host "`n? Phase visualization complete."
