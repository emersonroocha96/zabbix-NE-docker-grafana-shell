# Define o nome do diretório raiz do projeto
$projectName = "Project-NE-Zabbix-Docker"

# Cria o diretório raiz
New-Item -ItemType Directory -Name $projectName -ErrorAction SilentlyContinue | Out-Null
Write-Host "--- Criando diretório raiz: $projectName ---"

Write-Host "--- Criando subdiretórios ---"
# Define e cria os subdiretórios necessários
$dirs = @(
    # Novos diretórios de script
    "$projectName\scripts_on_zbx_server",
    "$projectName\scripts_on_zbx-proxy-sbsv-stack",
    "$projectName\scripts_on_zbx-proxy-sbnt-stack",
    # Novos diretórios de Docker Compose
    "$projectName\zbx-server-sbrf-stack-docker",
    "$projectName\zbx-proxy-sbsv-stack-docker",
    "$projectName\zbx-proxy-sbnt-stack-docker",
    # Diretórios de cliente
    "$projectName\zbx-client-sbsv-stack",
    "$projectName\zbx-client-sbnt-stack"
)
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path $dir -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Criado: .\$dir"
}

Write-Host "--- Criando arquivos de configuração ---"
# Cria os arquivos vazios que serão populados
$files = @(
    "$projectName\Vagrantfile",
    "$projectName\README.md",
    
    # Scripts do Servidor
    "$projectName\scripts_on_zbx_server\install_docker.sh",
    "$projectName\scripts_on_zbx_server\setup_zbx_server.sh",
    
    # Scripts do Proxy SBSV
    "$projectName\scripts_on_zbx-proxy-sbsv-stack\install_docker.sh",
    "$projectName\scripts_on_zbx-proxy-sbsv-stack\setup_zbx_proxy_SBSV.sh",
    "$projectName\scripts_on_zbx-proxy-sbsv-stack\setup_agent_zbx_on_proxy_SBSV.sh",
    
    # Scripts do Proxy SBNT
    "$projectName\scripts_on_zbx-proxy-sbnt-stack\install_docker.sh",
    "$projectName\scripts_on_zbx-proxy-sbnt-stack\setup_zbx_proxy_SBNT.sh",
    "$projectName\scripts_on_zbx-proxy-sbnt-stack\setup_agent_zbx_on_proxy_SBNT.sh",

    # Arquivos Docker Compose
    "$projectName\zbx-server-sbrf-stack-docker\docker-compose.yml",
    "$projectName\zbx-proxy-sbsv-stack-docker\docker-compose.yml",
    "$projectName\zbx-proxy-sbnt-stack-docker\docker-compose.yml",

    # Scripts dos Clientes
    "$projectName\zbx-client-sbsv-stack\setup_agent_SBSV.sh",
    "$projectName\zbx-client-sbnt-stack\setup_agent_SBNT.sh"
)

foreach ($file in $files) {
    New-Item -ItemType File -Path $file -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Criado: .\$file"
}

Write-Host "------------------------------------------------------"
Write-Host "Estrutura do projeto '$projectName' criada com sucesso!"

Write-Host "Copie o conteúdo de cada arquivo."
Write-Host "------------------------------------------------------"
