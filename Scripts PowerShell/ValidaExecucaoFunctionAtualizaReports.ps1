#parametros
param(
     $ReturnFunction = ""
)

$params = $ReturnFunction.Split('|')

if ($params[1] -eq '1')
{
    'Executado com sucesso'
    'LOG: ' + $params[0]
}
else
{
    'Erro: ' + $params[0]
    exit 1
}
