#parametros
param(
     $caminho = "C:\Users\Desktop\XML TESTE",
     $caminhoDLL = "C:\Users\Desktop\XML TESTE",
     $xml = "web.config",
     $xdt = "web.Release.config"
)

$xml = $caminho + "\"+ $xml
$xdt =$caminho + "\"+ $xdt

Write-Host $caminho
Write-Host $caminhoDLL
Write-Host $xml
Write-Host $xdt


if (!$xml -or !(Test-Path -path $xml -PathType Leaf)) {
    throw "Arquivo não encontrado. $xml";
}
if (!$xdt -or !(Test-Path -path $xdt -PathType Leaf)) {
    throw "Arquivo não encontrado. $xdt";
}

Add-Type -LiteralPath "$caminhoDLL\Microsoft.Web.XmlTransform.dll"

$xmldoc = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument;
$xmldoc.PreserveWhitespace = $true
$xmldoc.Load($xml);

$transf = New-Object Microsoft.Web.XmlTransform.XmlTransformation($xdt);
if ($transf.Apply($xmldoc) -eq $false)
{
    throw "Transformação falhou."
}
$xmldoc.Save($xml);
