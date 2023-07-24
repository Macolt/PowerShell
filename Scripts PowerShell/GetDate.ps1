$date=$(Get-Date -f dd-MM-yyyy_hh-mm);

Write-Host "##vso[task.setvariable variable=time]$date"