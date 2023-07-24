#parametros
param(
     [string]$caminho = ""
)

CD "$($caminho)"
.\"DownloadChromeDriver.exe"