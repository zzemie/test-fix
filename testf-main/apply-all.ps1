$filePath = "C:\Users\jj\Downloads\testf-main (1)\testf-main\classlist-main\assets\index-Dg4BjOqn-2bf6a912.js"
$clean = [System.IO.File]::ReadAllText($filePath)

# 1: Ga returns null
$clean = $clean.Replace("function Ga({items:_0x406671,compact:_0x3b46cb}){const _0x4eb1b4=_0x5d7612","function Ga({items:_0x406671,compact:_0x3b46cb}){return null;const _0x4eb1b4=_0x5d7612")
Write-Output "1 Ga"

# 2: ze returns null
$clean = $clean.Replace("function ze({label:_0x57a01f,onClick:_0x31a08b,children:_0x493755}){const _0x4eccb1=_0x5d7612","function ze({label:_0x57a01f,onClick:_0x31a08b,children:_0x493755}){return null;const _0x4eccb1=_0x5d7612")
Write-Output "2 ze"

# 3: Yr returns null
$clean = $clean.Replace("onToggleFullscreen:_0x499e95}){const _0xefb56d=_0x5d7612","onToggleFullscreen:_0x499e95}){return null;const _0xefb56d=_0x5d7612")
Write-Output "3 Yr"

# 4: _0xd7a43c always true
$clean = $clean.Replace("_0xd7a43c=!!(_0x31b613!=null&&_0x31b613[_0x5d59ea(0x209)])","_0xd7a43c=!0x0")
Write-Output "4 _0xd7a43c"

# 5: Games condition always true
$clean = $clean.Replace("(_0x31b613==null?void 0x0:_0x31b613[_0x5d59ea(0x209)])===_0x5bacc1[_0x5d59ea(0xb2f)]","!0x0")
Write-Output "5 games"

# 6: Cloud-only filter
$oldFilter = "_0x3b0d28=_0x445d2f[_0x239b44(0xb00)](()=>{const _0x38be10=_0x239b44;if(!_0xb9f046)return null;const _0x44fe38=_0x1c90ee[_0x38be10(0x1037)]()[_0x38be10(0x525)+_0x38be10(0x52f)]();let _0x3112ab=_0x44fe38?_0xb9f046[_0x38be10(0x9f9)](_0x154a64=>_0x154a64['title'][_0x38be10(0x525)+_0x38be10(0x52f)]()['includes'](_0x44fe38)):_0xb9f046;_0x206b60!=='all'&&(_0x3112ab=_0x3112ab[_0x38be10(0x9f9)](_0x282b96=>(_0x282b96[_0x38be10(0x328)+'es']??[])['some'](_0x34120e=>_0x34120e['toLowerC'+_0x38be10(0x52f)]()===_0x206b60)));const _0x2838f0=_0x32dc59===_0x103ea5[_0x38be10(0x511)]?[..._0x3112ab][_0x38be10(0x109d)]((_0xbb9513,_0x3022ab)=>_0xbb9513[_0x38be10(0x311)]['localeCo'+_0x38be10(0x1124)](_0x3022ab[_0x38be10(0x311)],void 0x0,{'sensitivity':_0x38be10(0x285)})):[..._0x3112ab][_0x38be10(0x7ff)](),_0x48684c=[],_0x17595f=[];for(const _0x4a5a59 of _0x2838f0)(_0x3ba0f5[_0x38be10(0x10bb)](_0x4a5a59['id'])?_0x48684c:_0x17595f)[_0x38be10(0xd72)](_0x4a5a59);return[..._0x48684c,..._0x17595f];"
$newFilter = "_0x3b0d28=_0x445d2f[_0x239b44(0xb00)](()=>{if(!_0xb9f046)return null;return _0xb9f046.filter(_g=>(_g.categories||[]).some(c=>c.toLowerCase()==='cloud'));"
$clean = $clean.Replace($oldFilter, $newFilter)
Write-Output "6 filter"

# 7: Remove controls div
$h1Ref = "_0x30762d[_0x239b44(0x1040)]('h1',{'children':_0x103ea5[_0x239b44(0xe59)]})"
$h1Idx = $clean.IndexOf($h1Ref)
$h1End = $h1Idx + $h1Ref.Length
$depth = 0; $inStr = $false; $strChar = ''; $pos = $h1End + 1; $found = $false
while ($pos -lt $clean.Length -and -not $found) {
    $ch = $clean[$pos]
    if ($inStr) { if ($ch -eq $strChar -and $clean[$pos-1] -ne '\') { $inStr = $false } }
    else { switch ($ch) { "'" { $inStr = $true; $strChar = "'" } '"' { $inStr = $true; $strChar = '"' } '(' { $depth++ } ')' { $depth--; if ($depth -eq 0) { $found = $true } } '[' { $depth++ } ']' { $depth-- } } }
    $pos++
}
$clean = $clean.Remove($h1End, ($pos - 1) - $h1End + 1)
Write-Output "7 controls removed"

# 8: Onboarded
$clean = $clean.Replace("'onboarded':!0x1", "'onboarded':!0x0")
Write-Output "8 onboarded"

# 9: Disable queue position
$clean = $clean.Replace("_0x446f4e['queuePos']!==null", "!0x1")
Write-Output "9 queuePos"

# 10: Disable timer display
$old10 = "_0x446f4e['secondsL'+_0xa9488f(0x53a)]!=null&&_0x30762d[_0xa9488f(0xe52)](_0x13f07a[_0xa9488f(0x380)],{'className':_0xa9488f(0xa16),'title':_0xa9488f(0xa58)+'time\x20rem'+_0xa9488f(0x3f7),'children':[Math[_0xa9488f(0x9d8)](_0x446f4e[_0xa9488f(0x4bb)+'eft']/0x3c),':',String(_0x446f4e[_0xa9488f(0x4bb)+_0xa9488f(0x53a)]%0x3c)['padStart'](0x2,'0')]})"
$clean = $clean.Replace($old10, "!0x1")
Write-Output "10 timer display"

# 11: Disable max_seconds forced quit
$old11 = "_0x4bd7d3['max_seco'+_0x598a81(0x107d)]&&Number['isFinite'](_0x4bd7d3[_0x598a81(0x9a3)+_0x598a81(0x107d)])&&(_0x420e07[_0x598a81(0xcb0)]=setTimeout(()=>_0x8802b1(_0x598a81(0xbe7)),_0x1609d1[_0x598a81(0xb05)](_0x4bd7d3[_0x598a81(0x9a3)+_0x598a81(0x107d)],0x3e8)))"
$clean = $clean.Replace($old11, "!0x0")
Write-Output "11 max_seconds"

# 12: Disable countdown
$clean = $clean.Replace("_0x4da18a['secondsL'+_0x40a519(0x53a)]>0x0?{..._0x4da18a,'secondsLeft':_0x4da18a[_0x40a519(0x4bb)+_0x40a519(0x53a)]-0x1}:_0x4da18a", "_0x4da18a")
Write-Output "12 countdown"

# 13: Block server setting secondsLeft
$clean = $clean.Replace("typeof _0x55b106==_0x2dd8eb(0x7f4)&&typeof _0xf75b91==_0x2dd8eb(0x7f4)&&_0x57ce74(_0x27b9a3=>({..._0x27b9a3,'secondsLeft':Math[_0x2dd8eb(0x10b2)](0x0,Math[_0x2dd8eb(0xb91)](_0xf75b91-_0x55b106))}))", "!0x0")
Write-Output "13 server secondsLeft"

# 14: Disable needsAudioUnlock
$clean = $clean.Replace("'needsAudioUnlock':!0x0", "'needsAudioUnlock':!0x1")
Write-Output "14 audio unlock"

# 15: Simplify unlockAudio
$old15 = "_0x4c65c=_0x445d2f['useCallb'+_0x57f3c4(0x1052)](()=>{const _0x318efd=_0x57f3c4,_0x2a2c65=_0x50d113[_0x318efd(0xcb0)];_0x2a2c65&&(_0x2a2c65[_0x318efd(0x10ae)]=!0x1,_0x2a2c65[_0x318efd(0x565)]()[_0x318efd(0x1ec)](()=>{}),_0x57ce74(_0x418068=>({..._0x418068,'needsAudioUnlock':!0x1)})));},[_0x50d113])"
$clean = $clean.Replace($old15, "_0x4c65c=_0x445d2f['useCallb'+_0x57f3c4(0x1052)](()=>{_0x57ce74(_0x418068=>({..._0x418068,'needsAudioUnlock':!0x1}));},[_0x50d113])")
Write-Output "15 unlockAudio"

# 16: Remove overlay (welcome/loading)
$clean = $clean.Replace("_0x10f627===_0x5d59ea(0xc9a)&&_0x30762d['jsxs'](_0x5d59ea(0x4e8),{'className':'overlay\x20'+_0x5d59ea(0xc9a),'children':[_0x30762d[_0x5d59ea(0x1040)]('p',{'children':_0x5bacc1[_0x5d59ea(0xef2)]}),_0x41b9e4&&_0x30762d['jsx'](_0x5bacc1[_0x5d59ea(0xb4e)],{'children':_0x41b9e4})]})", "!0x1")
Write-Output "16 overlay"

# 17: Guard quit against expired/ended (prevent game close on timeout)
$clean = $clean.Replace("_0x8802b1=_0x445d2f['useCallb'+_0x57f3c4(0x1052)]((_0xe7f271,_0xd937e5)=>{const _0xbc501c=_0x57f3c4", "_0x8802b1=_0x445d2f['useCallb'+_0x57f3c4(0x1052)]((_0xe7f271,_0xd937e5)=>{if(_0xe7f271==='expired'||_0xe7f271==='ended')return;const _0xbc501c=_0x57f3c4")
Write-Output "17 quit guard"

# 18: Guard phase setter against expired/ended/disconnected
$clean = $clean.Replace("_0x2111d8=_0x445d2f['useCallb'+_0x57f3c4(0x1052)]((_0xc5febd,_0x110898)=>{_0x57ce74(_0x6d142d=>{const _0x199ee6=_0x5c9f", "_0x2111d8=_0x445d2f['useCallb'+_0x57f3c4(0x1052)]((_0xc5febd,_0x110898)=>{if(_0xc5febd==='expired'||_0xc5febd==='ended'||_0xc5febd==='disconnected')return;_0x57ce74(_0x6d142d=>{const _0x199ee6=_0x5c9f")
Write-Output "18 phase guard"

[System.IO.File]::WriteAllText($filePath, $clean, [System.Text.Encoding]::UTF8)
Write-Output "Written"
