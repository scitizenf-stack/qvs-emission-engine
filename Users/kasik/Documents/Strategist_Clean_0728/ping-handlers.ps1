# Read strategist-endpoints.json
$json = Get-Content "./strategist-endpoints.json" | ConvertFrom-Json

$baseUrl = "http://localhost:5001/vaultrx/us-central1"

foreach ($entry in $json) {
  $name = $entry.handler
  $endpoint = $entry.endpoint
  $url = "$baseUrl/$name"

  Write-Host "`n🔍 Pinging $endpoint ($name)..."

  try {
    $response = Invoke-WebRequest $url -UseBasicParsing
    if ($response.StatusCode -eq 200) {
      Write-Host "✅ $name is online. Response:"
      Write-Host $response.Content
    } else {
      Write-Host "⚠️ $name returned unexpected status: $($response.StatusCode)"
    }
  } catch {
    Write-Host "❌ $name failed:`n$($_.Exception.Message)"
  }
}