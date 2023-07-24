#parametros
param(
     $servico = ""
)

#variaveis
$caminho = ""
$retorno = ""
$finalpath = ""
$tipo = ""
 
#retorna serviço parado com o nome informado
$retorno = Get-WmiObject win32_service | ?{$_.Name -like "Servico Tarefa " + $($servico) + "*".ToString()} | Where-Object {$_.State -eq "Stopped"} 

if ($retorno -eq $null)
{
    #Nenhum serviço parado
    Write-Host "Nenhum serviço disponivel para atualização, atualização cancelada."
    exit 1
}
else
{
    #descobre se o retorno é um array ou um unico registro
    $tipo = $retorno.GetType() | Select-Object -Property BaseType 

    $tipo = $tipo[0].BaseType.ToString()

    #recupera o caminho do exe
    if ($tipo -like "System.Array")
    {
   
        $retorno = $retorno[0].Name
    }
    else
    {
        $retorno = $retorno.Name
    }
   
	Write-Host "##vso[task.setvariable variable=ServiceExe]$retorno"
   
   }



