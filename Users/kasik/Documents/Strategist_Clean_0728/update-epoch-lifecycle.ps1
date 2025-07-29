$dir = "..\\strategist-core"
$files = Get-ChildItem $dir -Filter "*.ts"

foreach ($file in $files) {
  $path = Join-Path $dir $file.Name
  $lines = Get-Content $path
  $updated = @()

  foreach ($line in $lines) {
    if ($line -match "epochs: (\d+)") {
      $newEpoch = [int]$matches[1] + 1
      $line = $line -replace "epochs: \d+", "epochs: $newEpoch"
    }
    if ($line -match "lastActivation: \d+") {
      $line = $line -replace "lastActivation: \d+", "lastActivation: $(Get-Date -UFormat %s)"
    }
    $updated += $line
  }

  Set-Content $path $updated
  Write-Host "📈 Evolved: $($file.Name)"
}
