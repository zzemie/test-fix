# New Tempmail provider: mail.tm (free, no API key, verified working)
# Usage: . .\tempmail-new.ps1; $inbox = New-TempMailInbox; Get-TempMailMessages $inbox
function New-TempMailInbox {
  param([string]$Prefix = "", [int]$TimeoutSec = 20)
  $base = "https://api.mail.tm"
  $domains = (Invoke-RestMethod -Uri "$base/domains" -TimeoutSec $TimeoutSec).'hydra:member'
  if (-not $domains -or -not $domains[0].domain) { throw "mail.tm: no domains available" }
  $domain = $domains[0].domain
  $chars = 'abcdefghijklmnopqrstuvwxyz0123456789'.ToCharArray()
  $rand = -join (1..10 | ForEach-Object { $chars | Get-Random })
  $login = ($Prefix.ToLower() -replace '[^a-z0-9]','')
  if (-not $login) { $login = $rand; $address = "$login@$domain" } else { $address = "$login@$domain" }
  # mail.tm password min length 8; use GUID-based
  $password = [System.Guid]::NewGuid().ToString() + "Aa1!"
  Invoke-RestMethod -Uri "$base/accounts" -Method Post -ContentType "application/json" `
    -Body (@{address=$address; password=$password} | ConvertTo-Json) -TimeoutSec $TimeoutSec | Out-Null
  $tok = Invoke-RestMethod -Uri "$base/token" -Method Post -ContentType "application/json" `
    -Body (@{address=$address; password=$password} | ConvertTo-Json) -TimeoutSec $TimeoutSec
  if (-not $tok.token) { throw "mail.tm: no token returned" }
  return [pscustomobject]@{ address=$address; token=$tok.token; password=$password; provider="mail.tm" }
}

function Get-TempMailMessages {
  param([Parameter(Mandatory=$true)]$Inbox, [int]$TimeoutSec = 20)
  $r = Invoke-RestMethod -Uri "https://api.mail.tm/messages" `
    -Headers @{Authorization="Bearer $($Inbox.token)"} -TimeoutSec $TimeoutSec
  return $r.'hydra:member'
}
