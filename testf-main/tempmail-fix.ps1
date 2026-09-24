# Fixed Tempmail.lol inbox creation (PowerShell) — replaces generic "Failed to create a Tempmail.lol inbox"
# Verified working: POST https://api.tempmail.lol/v2/inbox/create with {} -> {address, token}
function New-TempMailInbox {
  param(
    [string]$Prefix = "",
    [string]$Domain = "",
    [string]$ApiKey = "",
    [int]$Retries = 3,
    [int]$TimeoutSec = 20
  )
  if ($Domain -and -not $ApiKey) {
    throw "Refusing to send domain '$Domain' without -ApiKey. Free tier returns 400 'Invalid domain selected'. Omit -Domain for a random inbox."
  }
  $cleanPrefix = $Prefix.ToLower() -replace '[^a-z0-9]',''
  if ($Prefix -and $cleanPrefix.Length -lt 4) {
    throw "Invalid prefix '$Prefix': must be >=4 chars a-z0-9 after sanitizing (got '$cleanPrefix')."
  }
  $bodyObj = @{}
  if ($cleanPrefix) { $bodyObj.prefix = $cleanPrefix }
  if ($Domain) { $bodyObj.domain = $Domain }
  $body = ($bodyObj | ConvertTo-Json -Compress)
  $headers = @{ "User-Agent" = "TempMailPS/1.0" }

  for ($i = 1; $i -le $Retries; $i++) {
    try {
      $params = @{
        Uri = "https://api.tempmail.lol/v2/inbox/create"
        Method = "Post"
        ContentType = "application/json"
        Body = $body
        Headers = $headers
        TimeoutSec = $TimeoutSec
      }
      if ($ApiKey) { $params.Headers["Authorization"] = "Bearer $ApiKey" }
      $r = Invoke-RestMethod @params
      if (-not $r.address -or -not $r.token) { throw "Bad inbox response: $($r | ConvertTo-Json -Compress)" }
      return $r
    } catch {
      $msg = $_.Exception.Message
      if ($_.ErrorDetails) { $msg += " | Body: $($_.ErrorDetails.Message)" }
      if ($i -ge $Retries) { throw "Failed to create a Tempmail.lol inbox after $Retries attempt(s): $msg" }
      Start-Sleep -Seconds $i
    }
  }
}
