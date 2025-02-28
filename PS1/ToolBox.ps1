function Main{
cls
echo "Liste des fonctionnalit�s :"
echo ""
echo " - 1 : Copie de droits"
echo " - 2 : Extract user d'un groupe"
echo " - 3 : MDP Admin Local"
echo " - 4 : BitLocker"
echo " - 5 : Recherche Groupes AD"
echo " - 6 : Propri�t�s d'un compte"
echo ""
echo ""
$choice = Read-Host "Que choisissez vous "

function CaCopieDur($text) {
	Add-Type -AssemblyName System.Windows.Forms
	$tb=New-Object System.Windows.Forms.TextBox
	$tb.Multiline = $true
	$tb.Text = $text
	$tb.SelectAll()
	$tb.Copy()
}
function Flip-Object
{
    param
    (
        [Object]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject
    )
    process
    {
        
        $InputObject | 
        ForEach-Object {
            $instance = $_
            $instance | 
            Get-Member -MemberType *Property |
            Select-Object -ExpandProperty Name |
            ForEach-Object {
                [PSCustomObject]@{
                    Name = $_
                    Value = $instance.$_
                }
            }
        } 
          
    }
}
cls
switch ($choice)
{
    1 { 
	$SamAccountName1 = Read-Host "Utilisateur AYANT les droits"
	$SamAccountName2 = Read-Host "Utilisateur VOULANT les droits"
	echo ""
	try {
	Get-ADUser -Identity $SamAccountName1 -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $SamAccountName2
	write-host "L'op�ration a �t� effectu�" -foregroundColor Green
	$lesGroupes = (Get-ADUser $SamAccountName2 -Properties memberof | select-object memberof).memberof
	$lesGroupes = $lesGroupes -split "," | Select-String -Pattern "CN"
	$lesGroupes = $lesGroupes -replace "CN=" , ""
	echo ""
	echo "Liste des groupes pr�sent sur le compte de $($SamAccountName2) :"
	echo "====================================================="
	echo $lesGroupes
	CaCopieDur("Profil bel et bien copi� de $($SamAccountName1) sur $($SamAccountName2)")
	}
	catch {
	write-host "L'op�ration a �chou�" -foregroundColor Red
	}
	pause
	cls
	Main
	}
    2 { 
	$groupeZbi= Read-Host "Nom du groupe "
	try {
		$users = Get-ADGroupMember -identity "$groupeZbi" | select name | Out-GridView
	}
	catch {
		write-host "Le nom du groupe est introuvable" -foreground red
	}
	pause
	CaCopieDur("Les utilisateur pr�sent dans $($groupeZbi) sont : $($users)")
	cls
	Main
	}
    3 { 
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
	Main
	}
     4 {
	$color = @('yellow','red','green','white')
        $nomDuPc = Read-Host "Le nom du PC de l'utilisateur"
	try{
	$nomDuPc = Get-ADComputer $nomDuPc
	try {
	$Bitlocker_Object = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $nomDuPc.DistinguishedName -Properties 'msFVE-RecoveryPassword'
	$name = $Bitlocker_Object | select name
	$counter = 0
	foreach($i in $name)
	{
		echo ""
		$counter++
		echo "$counter :"
		$i = $i | out-string | Convert-String -Example "test : rest=rest"
		$i = $i.substring(28,8)
		write-host $i -foreground $color[$counter-1]
	}
	echo ""
	echo ""
	$whichOne = Read-Host "Quel est le bon code"
	$Key = $Bitlocker_Object.'msFVE-RecoveryPassword' | Select-Object -Index $($whichOne-1)
	CaCopieDur($key)
	echo ""
	write-host $key -foreground green
	echo ""
	echo ""
	}
	catch {
	write-host "Cl� BitLocker introuvable" -foreground red
	}
	}
	catch {
	write-host "Nom de PC introuvable" -foreground red
	}
	pause
	cls
	Main
	}
    5 { 
	$keyword= Read-Host "Mots clef (nom/description) "
	$keyword = "*" + $keyword + "*"
	try {
        Get-ADGroup -filter{Name -like $keyword } -Properties Name, description | select name, description | ogv -title "Recherche par Nom"
        Get-ADGroup -filter{Description -like $keyword} -Properties Name, description | select name, description | ogv -title "Recherche par Description"
	}
	catch {
		write-host "Aucun groupes trouv�" -foreground red
	}
	pause
	cls
	Main
	}
    6 { 
	$user= Read-Host "Nom d'utilisateur "
	try {
        Get-ADUser $user -Properties * | Select-Object CN,CanonicalName,mail,samaccountname,enabled,AccountExpirationDate,PasswordLastSet,passwordexpired,LockedOut | Flip-Object |ogv
	}
	catch {
		write-host "Aucun groupes trouv�" -foreground red
	}
	pause
	cls
	Main
	}
	default
	{
		echo "La touche saisie n'est pas reconnue."
		pause
		cls
		Main
	}
}
}
Main
