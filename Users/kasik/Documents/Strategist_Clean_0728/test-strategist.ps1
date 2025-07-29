# Load endpoint manifest
$manifest = Get-Content "./strategist-endpoints.json" | ConvertFrom-Json

# Load test payloads
$payloads = Get-Content "./strategist-payloads.json" | ConvertFrom-Json
$payloadMap = @{}
foreach ($p in $payloads) { $payloadMap[$p.handler] = $p.payload }

$projectId = "vaultrx"
$baseUrl = "http://localhost:5001/$projectId/us-central1"

foreach ($entry in $manifest) {
  $name = $entry.handler
  $url = "$baseUrl/$name"
  $payload = $payloadMap[$name]

  Write-Host "`n🚀 POST to $entry.endpoint ($name)..."

  try {
    $response = Invoke-WebRequest -Uri $url -Method POST -Body ($payload | ConvertTo-Json -Depth 5) -ContentType "application/json" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
      Write-Host "✅ $name responded:"
      Write-Host $response.Content
    } else {
      Write-Host "⚠️ $name returned status $($response.StatusCode)`n$response.Content"
    }
  } catch {
    Write-Host "❌ $name failed:`n$($_.Exception.Message)"
  }
}