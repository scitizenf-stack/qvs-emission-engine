param(
  [int]$count = 100,
  [string]$prefix = "strategist"
)

for ($i = 1; $i -le $count; $i++) {
  $name = "$prefix$i"
  $path = "..\\strategist-core\\$name.ts"
  $timestamp = Get-Date -Format o
  $content = @"
// 🚀 Strategist Handler: $name
export const $name = async () => {
  return {
    message: '$name activated',
    cluster: '$prefix',
    resilienceScore: 1.0
  };
};

export const memoryCluster = {
  name: '$name',
  deployed: '$timestamp',
  epochs: 0,
  lastActivation: 0,
  resilienceScore: 1.0
};
"@
  if (!(Test-Path $path)) {
    Set-Content $path $content
    Write-Host "🧬 Created: $name.ts"
  } else {
    Write-Host "🔁 Skipped: $name.ts already exists"
  }
}
