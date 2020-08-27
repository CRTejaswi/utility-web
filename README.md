    Copyright(c) 2020-
    Author: Chaitanya Tejaswi (github.com/CRTejaswi)    License: GPL v3.0+

# [Utility: Web](https://crtejaswi.github.io/utility-web/)
> PowerShell-stack web utility.

See: [Pode](https://badgerati.github.io/Pode/Getting-Started/FirstApp) <br>

__Basic__ <br>
Creates an HTTP Web-Server that accepts GET requests, responding with 'Hello World'. <br>
```powershell
# .\server.ps1
Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeJsonResponse -Value @{ 'value' = 'Hello, world!' }
    }
}
```
Downloads lyrics of songs & writes to page. <sup>[BROKEN]</sup><br>
```powershell
# .\server.ps1
# ...
Add-PodePage -Name 'lyrics' -ScriptBlock {
    $Url='https://crtejaswi.github.io/api/songs2.json'
    $LyricsUrl = 'https://www.azlyrics.com/lyrics'
    $entries = Invoke-RestMethod $Url

    $songs = @{}; $entries.singer | Get-Unique | forEach {$songs.Add($_,@())}
    # Update Values using Keys
    forEach ($entry in $entries){
        if ($songs.containsKey($entry.singer)){
            $songs[$entry.singer] += $entry.title
        }
    }
    # Download Lyrics for 'Guy Sebastian'
    $songs.keys -notmatch '^Guy' | forEach {$songs.Remove($_)}
    $lyrics = @{}
    forEach ($key in $songs.keys){
        forEach ($title in $songs[$key]){
            $response = Invoke-WebRequest "$LyricsUrl/$($key.toLower().replace(" ",''))/$($title.toLower().replace(" ",'').replace("'",'')).html"
            $lyrics[$title] += ($response.allElements | where {$_.class -match 'container main-page'}).innerText
        }
    }
    Write-PodeViewResponse -Path 'lyrics' -Data @{
        Keys = $lyrics.keys
        Values = $lyrics.values
    }
}
```
