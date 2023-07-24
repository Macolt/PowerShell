#parametros
param(
     $path = ""
)

#Lendo um arquivo txt
$Text = Get-Content -Path $path
$NovoTexto = ""

foreach ($item in $Text) {
$NovoTexto=$NovoTexto+$item.Trim()+"%0D%0A"
}

Write-Host "##vso[task.setvariable variable=WebConfigText]$NovoTexto"