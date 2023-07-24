#parametros
param(
     [string]$caminho = ""
)

CD "$($caminho)migration"
.\"Cobmais.Migrations.exe"