$dir = "..\\strategist-core"
$files = Get-ChildItem $dir -Filter "*.ts"

foreach ($file in $files) {
  $path = Join-Path $dir $file.Name
  $defense = @"
// 🛡️ Defense Overlay Injected
export const breachSentinel = () => {
  const rand = Math.random();
  if (rand < 0.001) {
    console.warn('🚨 Strategist breach alert triggered:', '$($file.Name)');
  }
};
"@
  if ((Get-Content $path) -notcontains "export const breachSentinel") {
    Add-Content $path "`n$defense"
    Write-Host "🛡️ Patched: $($file.Name)"
  } else {
    Write-Host "🔁 Defense exists: $($file.Name)"
  }
}
