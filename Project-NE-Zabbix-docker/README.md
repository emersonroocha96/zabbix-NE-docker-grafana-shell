
1. 🌳 Nova Estrutura de Diretórios
O script create_project.ps1 abaixo irá gerar esta estrutura:

Projeto-Ne-Zabbix/
├── README.md
├── Vagrantfile
├── scripts_on_zbx-proxy-sbnt-stack/
│   ├── install_docker.sh
│   ├── setup_agent_zbx_on_proxy_SBNT.sh
│   └── setup_zbx_proxy_SBNT.sh
├── scripts_on_zbx-proxy-sbsv-stack/
│   ├── install_docker.sh
│   ├── setup_agent_zbx_on_proxy_SBSV.sh
│   └── setup_zbx_proxy_SBSV.sh
├── scripts_on_zbx_server/
│   ├── install_docker.sh
│   └── setup_zbx_server.sh
├── zbx-client-sbnt-stack/
│   └── setup_agent_SBNT.sh
├── zbx-client-sbsv-stack/
│   └── setup_agent_SBSV.sh
├── zbx-proxy-sbnt-stack-docker/
│   └── docker-compose.yml
├── zbx-proxy-sbsv-stack-docker/
│   └── docker-compose.yml
└── zbx-server-sbrf-stack-docker/
    └── docker-compose.yml