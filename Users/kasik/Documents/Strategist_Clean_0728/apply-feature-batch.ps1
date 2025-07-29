# Load strategist features
$features = Get-Content "../strategist-feature-batch.json" | ConvertFrom-Json

foreach ($feature in $features) {
  switch ($feature.type) {

    "export" {
      $indexPath = "..\\src\\index.ts"
      $importLine = "export { $($feature.name) } from \"../$($feature.source)\";         // $($feature.route)"
      $existing = Get-Content $indexPath
      if ($existing -notcontains $importLine) {
        Add-Content $indexPath "`n$importLine"
        Write-Host "➕ Exported $($feature.name) → $($feature.route)"
      }
    }

    "patch" {
      $targetPath = "..\\$($feature.source.Replace('/', '\\')).ts"
      $targetFile = "..\\strategist-core\\$($feature.target).ts"
      if (Test-Path $targetFile) {
        Add-Content $targetFile "`n$($feature.inject)"
        Write-Host "🔧 Patched $($feature.target)"
      } else {
        Write-Host "⚠️ Missing strategist file for $($feature.target)"
      }
    }

    "upgrade" {
      $targetFile = "..\\strategist-core\\$($feature.target).ts"
      if (Test-Path $targetFile) {
        Add-Content $targetFile "`n// 🔼 Strategist upgrade: $($feature.feature)"
        Write-Host "🚀 Upgrade flag inserted: $($feature.target) → $($feature.feature)"
      }
    }

    default {
      Write-Host "⚠️ Unknown feature type: $($feature.type)"
    }
  }
}

Write-Host "`n✅ Strategist batch applied.`n"