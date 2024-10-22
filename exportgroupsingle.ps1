# Defina o nome do grupo do Active Directory do qual você deseja exportar os usuários
$groupName = "vpn"

# Defina o caminho do arquivo onde você deseja salvar a lista de usuários
$outputFile = "C:\vpn.csv"

# Importa o módulo do Active Directory (caso não esteja importado)
Import-Module ActiveDirectory

# Obtém todos os membros do grupo especificado
$groupMembers = Get-ADGroupMember -Identity $groupName -Recursive

# Cria uma lista para armazenar informações dos usuários
$userList = @()

# Itera sobre cada membro do grupo e coleta informações
foreach ($member in $groupMembers) {
    if ($member.objectClass -eq "user") {
        $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName, EmailAddress
        $userList += [pscustomobject]@{
            SamAccountName = $user.SamAccountName
            DisplayName    = $user.DisplayName
            EmailAddress   = $user.EmailAddress
        }
    }
}

# Exporta a lista de usuários para um arquivo CSV
$userList | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Exportação concluída. O arquivo foi salvo em $outputFile"
