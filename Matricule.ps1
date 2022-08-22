$text = import-csv .\oui.csv -Header "EmployeeID", "Name", "a", "b", "c" -Delimiter ";"
foreach($i in $text){
    $leNom = $i.Name
    $lId = $i.EmployeeID
    $user = Get-ADUser -Filter "displayname -eq '$leNom'"|
    Select-Object -first 1 -ExpandProperty 'SamAccountName' 
    try {
        Set-ADUser $user -EmployeeID $lId
        Write-Host "$leNom OK " -ForegroundColor Green;
    }
    catch{
        Write-Host "Erreur pour " -ForegroundColor Red -NoNewline;
        Write-Host "$leNom" -ForegroundColor Red -BackgroundColor Yellow;
    }
}
pause