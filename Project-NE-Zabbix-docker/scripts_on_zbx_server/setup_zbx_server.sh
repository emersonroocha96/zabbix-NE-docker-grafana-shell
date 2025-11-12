#!/bin/bash
# Desc: Provisiona o Host 1 (ZBX-SERVER-SBRF).

echo "--- [ZBX-SERVER-SBRF] Iniciando provisionamento ---"

# 1. Instalar o Docker
# [MODIFICADO] Caminho atualizado para o script local
/bin/bash /home/vagrant/scripts_on_zbx_server/install_docker.sh

# 2. Lógica de início e teste do Docker
echo "--- [ZBX-SERVER-SBRF] Iniciando e verificando o serviço Docker ---"
sudo systemctl start docker
sudo systemctl enable docker

COUNT=0
echo "Aguardando o Docker daemon ficar pronto..."
while ! sudo docker ps > /dev/null 2>&1; do
  if [ $COUNT -gt 10 ]; then
    echo "Falha: Docker daemon não iniciou. Abortando."
    exit 1
  fi
  echo "Tentativa $COUNT: Docker não está pronto. Aguardando 2s..."
  sleep 2
  sudo systemctl start docker
  COUNT=$((COUNT+1))
done
echo "Docker daemon está ativo!"

# 3. Subir a stack de monitoramento
echo "--- [ZBX-SERVER-SBRF] Subindo os containers ---"
# O destino do Vagrantfile é /home/vagrant/zbx-server-sbrf-stack
cd /home/vagrant/zbx-server-sbrf-stack
# Executa usando 'docker-compose.yml' (nome padrão)
sudo docker compose up -d

echo "--- [ZBX-SERVER-SBRF] Provisionamento concluído! ---"