#!/bin/bash
#
# script: setup_agent_SBSV.sh (Ubuntu Version)
# Desc:   Instala o Zabbix Agent e ferramentas de teste no Ubuntu (ZBX-CLIENT-SBSV).
#

echo "--- [ZBX-CLIENT-SBSV] Iniciando provisionamento (Ubuntu) ---"
sudo apt-get update
# [MELHORIA] Instala o agente E as ferramentas de teste
sudo apt-get install -y zabbix-agent stress iperf3

CONFIG_FILE="/etc/zabbix/zabbix_agentd.conf"

# Aponta o Agente para o IP do PROXY SBSV na rede 10.10.20.x
sudo sed -i 's/Server=127.0.0.1/Server=10.10.20.10/g' $CONFIG_FILE

# Define o nome do host no Zabbix
sudo sed -i 's/Hostname=Zabbix server/Hostname=ZBX-CLIENT-SBSV/g' $CONFIG_FILE

# Inicia e habilita o serviço (usando systemctl)
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

echo "--- [ZBX-CLIENT-SBSV] Provisionamento concluído! ---"
echo "--- Agente configurado para reportar ao Proxy em 10.10.20.10 ---"