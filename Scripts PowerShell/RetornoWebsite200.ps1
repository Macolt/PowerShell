#parametros
param(
     $web = ""
)


$Retorno= "0"

try
{
    
    for ($x=0;$x -le 2 -and $Retorno -ne 200 ;$x++)
    {
        $Response = Invoke-WebRequest -Uri $web -UseBasicParsing
        $StatusCode = $Response.StatusCode
        $Retorno= $StatusCode
    }
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
}

if($StatusCode -ne 200)
{
    Write-Host "Retorno: " $StatusCode " Operação cancelada."
    exit 1
}
    
