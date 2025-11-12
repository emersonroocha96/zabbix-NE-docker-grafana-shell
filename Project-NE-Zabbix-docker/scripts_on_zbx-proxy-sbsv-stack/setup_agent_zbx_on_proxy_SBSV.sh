#!/bin/bash
# Desc: Instala o Zabbix Agent NA PRÓPRIA VM do Proxy SBSV.

echo "--- [ZBX-PROXY-SBSV] Instalando o Zabbix Agent no Host ---"
sudo apt-get update
sudo apt-get install -y zabbix-agent

CONFIG_FILE="/etc/zabbix/zabbix_agentd.conf"

# IPs de Configuração

echo "Configurando agente para Hostname=zbx-proxy-sbsv"
sudo sed -i "s/Hostname=Zabbix server/Hostname=zbx-proxy-sbsv/g" $CONFIG_FILE

echo "Configurando Server= (Passivo) para 192.168.50.10"
sudo sed -i "s/Server=127.0.0.1/Server=192.168.50.10/g" $CONFIG_FILE

echo "Configurando ServerActive= (Ativo) para 192.168.50.10"
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=192.168.50.10/g" $CONFIG_FILE

# Reinicia e habilita o agente
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

echo "--- [ZBX-PROXY-SBSV] Agente Zabbix no Host concluído! ---"