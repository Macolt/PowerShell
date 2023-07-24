#parametros
param(
     
    $Assessoria = "*",
    $Pasta = "*",
    $Caminho = "*",
    $Diretorio = "*",
    $IpBanco = "*",
    $CatalogoBanco = "*",
    $UsuarioBanco = "*",
    $SenhaBanco = "*",
    $Query = "* = $Assessoria",
    $Ext = ".*",
    $Deleta = "0"
)


#vars

$DiretorioOrigem = $Caminho+$Pasta
$DiretorioDestino = $Diretorio+"DevOps\Arquivos\$Assessoria\Storage-$Pasta"
$DiretorioLog = $Diretorio+"DevOps\Arquivos\$Assessoria\Log"
$CaminhoLista = $Diretorio+"DevOps\Arquivos\$Assessoria\Storage-$Pasta.txt"
$quantidade = 1


Write-host "Criando pastas..."


if ( -not (Test-Path -Path $Diretorio'DevOps'))
{
    New-Item -Path $Diretorio'DevOps' -ItemType Directory | Out-Null
}

if ( -not (Test-Path $Diretorio'DevOps\Arquivos'))
{
    New-Item -Path $Diretorio'DevOps\Arquivos' -ItemType Directory
}

if ( -not (Test-Path $Diretorio'DevOps\Arquivos\'$Assessoria))
{
    New-Item -Path $Diretorio'DevOps\Arquivos\'$Assessoria -ItemType Directory
}

if ( -not (Test-Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log'))
{
    New-Item -Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log' -ItemType Directory
}

if ( -not (Test-Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log\copiados-'$Pasta'.txt'))
{
    New-Item -Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log\copiados-'$Pasta'.txt' -ItemType file
}

if ( -not (Test-Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log\naoencontrados-'$Pasta'.txt'))
{
    New-Item -Path $Diretorio'DevOps\Arquivos\'$Assessoria'\Log\naoencontrados-'$Pasta'.txt' -ItemType file
}

if ( -not (Test-Path $DiretorioDestino))
{
    New-Item -Path $DiretorioDestino -ItemType Directory
}

if ( -not (Test-Path $CaminhoLista))
{
    New-Item -Path $CaminhoLista -ItemType file
}



 try
 {
     $ErrorActionPreference = "Stop"
     $cn = new-object System.Data.SqlClient.SqlConnection("Data Source=$IpBanco,1433;Network Library=DBMSSOCN;Initial Catalog=$CatalogoBanco;User ID=$UsuarioBanco;Password=$SenhaBanco;")
     Write-host "Realizando Conexão com o banco."
     $cn.open()
     $cmd = new-object "System.Data.SqlClient.SqlCommand" ($Query , $cn)    
     Write-host "Realizando Query."
     $reader = $cmd.ExecuteReader()
     Clear-Content $CaminhoLista   
     Write-host "Criando lista de arquivos a serem extraídos: " $CaminhoLista
     while ($reader.Read())
     {
        for ($i = 0; $i -lt $Reader.FieldCount; $i++)
        {
            Add-Content $CaminhoLista -Value $Reader.GetValue($i)
        }
    }
 }
 catch
 {
     write-host $_.Exception.Message
     $_.Exception.Message >> $DiretorioLog"\errorquery.txt"
 }

try { 
    $Lista = Get-Content $CaminhoLista -ErrorAction Stop
}
catch {
   Write-host "Lista não encontrada em $CaminhoLista"
   exit
}

Write-host "INICIANDO EXTRAÇÃO $Assessoria"
Write-host "LISTA $CaminhoLista"
Write-host "ORIGEM $DiretorioOrigem"
Write-host "DESTINO $DiretorioDestino"
Write-host "LOG $DiretorioLog"
Write-host "Ext $Ext"
Write-host "Deleta $Deleta"
Write-host "`n`n-----------------------//-----------------------------------------------//----------------------------`n`n"

clear-content $DiretorioLog"\copiados-"$Pasta".txt"
clear-content $DiretorioLog"\naoencontrados-"$Pasta".txt"


Write-host "Quantidade arquivos:"$Lista.Length

Foreach($Item in $Lista){
        
        write-host "["$quantidade "/" $Lista.Length"] Arquivos - " ((100/$Lista.Length)*$quantidade).ToInt32($Null)"%"
        
        try { 
            $completo = Get-Item ($DiretorioOrigem+"\"+$Item+$Ext) -ErrorAction Stop
            Write-host "$Item Encontrado no diretório,`nInicio Copia:"
            Write-host "`n  copiando: " + ($completo) " para " ($DiretorioDestino+"\"+$completo.Name)
            copy-item ($completo) ($DiretorioDestino+"\"+$completo.Name)
            Write-host "`nArquivo copiado."            
            Add-Content $DiretorioLog"\copiados-"$Pasta".txt" -Value $Item
            if ($Deleta -match "1")
            {
                Write-host "`nDeletando arquivo origem: $completo"
                Remove-Item -Path ($completo) -Force
                Write-host "Arquivo origem deletado."
            }
            Write-host "`n-----/------/-----"
        }
        catch {
            Write-Host "Arquivo não encontrado"
            Add-Content $DiretorioLog"\naoencontrados-"$Pasta".txt" -Value $Item     
        }       

        $quantidade = $quantidade + 1
}