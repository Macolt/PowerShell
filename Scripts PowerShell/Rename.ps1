#parametros
param(     
    $DiretorioDestino = "C:\Users\Documents\arquivosrenomear",
    $CaminhoLista = "C:\Users\Documents\renamelist.txt"
)

#vars
$quantidade = 1
$quantidadefalha = 0

try { 
    $Lista = Get-Content $CaminhoLista -ErrorAction Stop
}
catch {
   Write-host "Lista não encontrada em $CaminhoLista"
   exit
}

Write-host "INICIANDO RENAME"
Write-host "LISTA $CaminhoLista"
Write-host "DESTINO $DiretorioDestino"
Write-host "`n`n-----------------------//-----------------------------------------------//----------------------------`n`n"


Write-host "Quantidade arquivos:"$Lista.Length

Foreach($Item in $Lista){
              
        try { 
            write-host "["$quantidade "/" $Lista.Length"] Arquivos - " ((100/$Lista.Length)*$quantidade).ToInt32($Null)"%"

            $ItemSplit = $Item.Split("|")

            $antigo = $DiretorioDestino+"\"+$ItemSplit[0]
            $novo = $DiretorioDestino+"\"+$ItemSplit[1]
           
            Write-host $antigo
            Write-host $novo

            Write-host $antigo " Renomeando para: " $novo
        	
            Rename-Item -Path $antigo -NewName $novo -ErrorAction Stop
        
            Write-host $antigo " Renomeado para: " $novo
        }
        catch {
            Write-Host "Arquivo não encontrado" 
            $arquivosfalha +=  "`n"+$antigo
            $quantidadefalha++        
        }       

        $quantidade++
}

Write-host "`n`n-----------------------//-----------------------------------------------//----------------------------`n`n"
Write-host "Quantidade arquivos não encontrados/falhas: "$quantidadefalha
Write-host "`n $arquivosfalha"