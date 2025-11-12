#!/bin/bash
# Desc: Instala o Docker (Docker-CE) e o Docker Compose (plugin)

echo "--- Iniciando a instalação do Docker (Oficial) ---"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Adicionar a chave GPG oficial do Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Configurar o repositório oficial
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar o Docker Engine e o Compose Plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Adicionar o usuário 'vagrant' ao grupo 'docker'
sudo usermod -aG docker vagrant
echo "--- Docker (Oficial) instalado com sucesso! ---"