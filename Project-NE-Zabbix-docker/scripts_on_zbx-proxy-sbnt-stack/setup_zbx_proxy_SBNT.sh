#!/bin/bash
# Desc: Provisiona o Host 3 (ZBX-PROXY-SBNT).

echo "--- [ZBX-PROXY-SBNT] Iniciando provisionamento ---"

# 1. Instalar o Docker
# [MODIFICADO] Caminho atualizado para o script local
/bin/bash /home/vagrant/scripts_on_zbx-proxy-sbnt-stack/install_docker.sh

# 2. Lógica de início e teste do Docker
echo "--- [ZBX-PROXY-SBNT] Iniciando e verificando o serviço Docker ---"
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

# 3. Subir o stack do proxy SBNT
echo "--- [ZBX-PROXY-SBNT] Subindo o container do Zabbix Proxy SBNT ---"
# O destino do Vagrantfile é /home/vagrant/zbx-proxy-sbnt-stack
cd /home/vagrant/zbx-proxy-sbnt-stack
# Executa usando 'docker-compose.yml' (nome padrão)
sudo docker compose up -d

echo "--- [ZBX-PROXY-SBNT] Provisionamento concluído! ---"