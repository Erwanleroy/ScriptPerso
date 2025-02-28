#Récupération du mdp admin local avec LAPS-UI 
function CaCopieDur($text) {
	Add-Type -AssemblyName System.Windows.Forms
	$tb=New-Object System.Windows.Forms.TextBox
	$tb.Multiline = $true
	$tb.Text = $text
	$tb.SelectAll()
	$tb.Copy()
}
$nomDuPc = Read-Host "Le nom du PC "
try {
    $pwdAdmLocal = Get-ADComputer $nomDuPc -Properties * | select -ExpandProperty ms-Mcs-AdmPwd
    write-host $pwdAdmLocal -foreground green
    CaCopieDur($pwdAdmLocal)
}
catch {
    write-host "Nom de PC introuvable" -foreground red
}
pause
cls
