$filePath = "C:\Users\jj\Downloads\testf-main (1)\testf-main\classlist-main\assets\index-Dg4BjOqn-2bf6a912.js"
$clean = [System.IO.File]::ReadAllText($filePath)

# EDIT 1: Ga returns null
$clean = $clean.Replace(
    "function Ga({items:_0x406671,compact:_0x3b46cb}){const _0x4eb1b4=_0x5d7612",
    "function Ga({items:_0x406671,compact:_0x3b46cb}){return null;const _0x4eb1b4=_0x5d7612"
)
Write-Output "1 Ga: OK"

# EDIT 2: ze returns null
$clean = $clean.Replace(
    "function ze({label:_0x57a01f,onClick:_0x31a08b,children:_0x493755}){const _0x4eccb1=_0x5d7612",
    "function ze({label:_0x57a01f,onClick:_0x31a08b,children:_0x493755}){return null;const _0x4eccb1=_0x5d7612"
)
Write-Output "2 ze: OK"

# EDIT 3: Yr returns null
$clean = $clean.Replace(
    "onToggleFullscreen:_0x499e95}){const _0xefb56d=_0x5d7612",
    "onToggleFullscreen:_0x499e95}){return null;const _0xefb56d=_0x5d7612"
)
Write-Output "3 Yr: OK"

# EDIT 4: _0xd7a43c always true
$clean = $clean.Replace(
    "_0xd7a43c=!!(_0x31b613!=null&&_0x31b613[_0x5d59ea(0x209)])",
    "_0xd7a43c=!0x0"
)
Write-Output "4 _0xd7a43c: OK"

# EDIT 5: Games condition always true
$clean = $clean.Replace(
    "(_0x31b613==null?void 0x0:_0x31b613[_0x5d59ea(0x209)])===_0x5bacc1[_0x5d59ea(0xb2f)]",
    "!0x0"
)
Write-Output "5 games: OK"

# EDIT 6: Cloud-only filter (remove search, category, sort)
$oldFilter = "_0x3b0d28=_0x445d2f[_0x239b44(0xb00)](()=>{const _0x38be10=_0x239b44;if(!_0xb9f046)return null;const _0x44fe38=_0x1c90ee[_0x38be10(0x1037)]()[_0x38be10(0x525)+_0x38be10(0x52f)]();let _0x3112ab=_0x44fe38?_0xb9f046[_0x38be10(0x9f9)](_0x154a64=>_0x154a64['title'][_0x38be10(0x525)+_0x38be10(0x52f)]()['includes'](_0x44fe38)):_0xb9f046;_0x206b60!=='all'&&(_0x3112ab=_0x3112ab[_0x38be10(0x9f9)](_0x282b96=>(_0x282b96[_0x38be10(0x328)+'es']??[])['some'](_0x34120e=>_0x34120e['toLowerC'+_0x38be10(0x52f)]()===_0x206b60)));const _0x2838f0=_0x32dc59===_0x103ea5[_0x38be10(0x511)]?[..._0x3112ab][_0x38be10(0x109d)]((_0xbb9513,_0x3022ab)=>_0xbb9513[_0x38be10(0x311)]['localeCo'+_0x38be10(0x1124)](_0x3022ab[_0x38be10(0x311)],void 0x0,{'sensitivity':_0x38be10(0x285)})):[..._0x3112ab][_0x38be10(0x7ff)](),_0x48684c=[],_0x17595f=[];for(const _0x4a5a59 of _0x2838f0)(_0x3ba0f5[_0x38be10(0x10bb)](_0x4a5a59['id'])?_0x48684c:_0x17595f)[_0x38be10(0xd72)](_0x4a5a59);return[..._0x48684c,..._0x17595f];"
$newFilter = "_0x3b0d28=_0x445d2f[_0x239b44(0xb00)](()=>{if(!_0xb9f046)return null;return _0xb9f046.filter(_g=>(_g.categories||[]).some(c=>c.toLowerCase()==='cloud'));"
$clean = $clean.Replace($oldFilter, $newFilter)
Write-Output "6 filter: OK"

# EDIT 7: Remove search+dropdowns div from header
$h1Ref = "_0x30762d[_0x239b44(0x1040)]('h1',{'children':_0x103ea5[_0x239b44(0xe59)]})"
$h1Idx = $clean.IndexOf($h1Ref)
Write-Output "h1 at: $h1Idx"
$h1End = $h1Idx + $h1Ref.Length
$charAfter = $clean[$h1End]
Write-Output "Char after h1: '$charAfter'"

$depth = 0
$inStr = $false
$strChar = ''
$pos = $h1End + 1
$found = $false

while ($pos -lt $clean.Length -and -not $found) {
    $ch = $clean[$pos]
    if ($inStr) {
        if ($ch -eq $strChar -and $clean[$pos-1] -ne '\') { $inStr = $false }
    } else {
        switch ($ch) {
            "'" { $inStr = $true; $strChar = "'" }
            '"' { $inStr = $true; $strChar = '"' }
            '(' { $depth++ }
            ')' { $depth--; if ($depth -eq 0) { $found = $true } }
            '[' { $depth++ }
            ']' { $depth-- }
        }
    }
    $pos++
}

$controlsEnd = $pos - 1
Write-Output "Controls ends at: $controlsEnd"
$removeLen = $controlsEnd - $h1End + 1
Write-Output "Remove length: $removeLen"
$clean = $clean.Remove($h1End, $removeLen)
Write-Output "7 Removed controls"

[System.IO.File]::WriteAllText($filePath, $clean, [System.Text.Encoding]::UTF8)
Write-Output "File written"
