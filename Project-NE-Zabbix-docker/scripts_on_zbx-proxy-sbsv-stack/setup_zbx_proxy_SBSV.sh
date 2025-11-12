#!/bin/bash
# Desc: Provisiona o Host 2 (ZBX-PROXY-SBSV).

echo "--- [ZBX-PROXY-SBSV] Iniciando provisionamento ---"

# 1. Instalar o Docker
# [MODIFICADO] Caminho atualizado para o script local
/bin/bash /home/vagrant/scripts_on_zbx-proxy-sbsv-stack/install_docker.sh

# 2. Lógica de início e teste do Docker
echo "--- [ZBX-PROXY-SBSV] Iniciando e verificando o serviço Docker ---"
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

# 3. Subir o stack do proxy SBSV
echo "--- [ZBX-PROXY-SBSV] Subindo o container do Zabbix Proxy SBSV ---"
# O destino do Vagrantfile é /home/vagrant/zbx-proxy-sbsv-stack
cd /home/vagrant/zbx-proxy-sbsv-stack
# Executa usando 'docker-compose.yml' (nome padrão)
sudo docker compose up -d

echo "--- [ZBX-PROXY-SBSV] Provisionamento concluído! ---"