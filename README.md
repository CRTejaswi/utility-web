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
