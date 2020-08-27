Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeJsonResponse -Value @{ 'value' = 'Hello, world!' }
    }
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

}
