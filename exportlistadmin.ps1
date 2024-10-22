# Importar o módulo Active Directory
Import-Module ActiveDirectory

# Definir os grupos administrativos com nomes em português
$adminGroups = @("Administradores", "Admins. do Dominio", "Administradores de Esquema", "Administradores de Empresa")

# Definir o caminho do arquivo onde a lista será salva
$outputFilePath = "C:\Users\administrador\Desktop\AD_Admins_List.txt"

# Função para obter e salvar membros dos grupos administrativos
function Get-AdminUsers {
    param (
        [string[]]$Groups,
        [string]$OutputFile
    )

    # Verificar se o arquivo de saída já existe e removê-lo
    if (Test-Path $OutputFile) {
        Remove-Item $OutputFile
    }

    # Iterar sobre cada grupo administrativo
    foreach ($group in $Groups) {
        # Adicionar cabeçalho para o grupo no arquivo de saída
        Add-Content -Path $OutputFile -Value "`nMembros do grupo '$group':`n"

        try {
            # Obter membros do grupo (somente usuários)
            $members = Get-ADGroupMember -Identity $group -Recursive | Where-Object { $_.objectClass -eq "user" }
            
            if ($members.Count -eq 0) {
                Add-Content -Path $OutputFile -Value "Nenhum membro encontrado.`n"
            } else {
                # Iterar sobre cada membro e adicionar ao arquivo
                foreach ($member in $members) {
                    $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName
                    $line = "$($user.DisplayName) ($($user.SamAccountName))"
                    Add-Content -Path $OutputFile -Value $line
                }
            }
        } catch {
            Add-Content -Path $OutputFile -Value "Erro ao processar o grupo '$group': $_`n"
        }

        # Adicionar uma linha em branco para separar os grupos
        Add-Content -Path $OutputFile -Value "`n"
    }
}

# Executar a função para listar os usuários administradores e salvar a lista em um arquivo
Get-AdminUsers -Groups $adminGroups -OutputFile $outputFilePath

# Informar ao usuário onde a lista foi salva
Write-Output "A lista de administradores foi salva em $outputFilePath"
