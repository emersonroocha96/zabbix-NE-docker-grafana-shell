
# 🚀 Project-NE-Zabbix-Docker

Este projeto cria um ambiente de monitoramento Zabbix totalmente distribuído e resiliente.

O nome **Project-NE-Zabbix-Docker** é uma homenagem à sua origem, tendo sido iniciado no Nordeste (NE) Brasileiro. Ele é uma simplificação de uma arquitetura real e robusta de monitoramento descentralizado, baseada em um sistema que já foi usado para monitorar os sistemas de 30 torres de controle de tráfego aéreo no Brasil.

## 🏛️ Arquitetura e Conceito

Este ambiente fictício, ele simula uma topologia de "Matriz" (`SBRF` - RECIFE ) que monitora "Filiais" (`SBSV` - SALVADOR e `SBNT`- NATAL ) através de coletores locais (Proxies). O fluxo de dados é 100% automatizado pelo Vagrant.

1.  **`ZBX-SERVER-SBRF` (A Matriz):** VM que hospeda a stack principal do Zabbix (Server, Web UI, MySQL) e o Grafana em containers Docker.
2.  **`ZBX-PROXY-SBSV` / `ZBX-PROXY-SBNT` (As Filiais):** VMs que rodam containers do Zabbix Proxy em **Modo Ativo**. Eles coletam dados localmente e *iniciam* a conexão com o Servidor (simulando filiais protegidas por firewall).
3.  **`ZBX-CLIENT-SBSV` / `ZBX-CLIENT-SBNT` (Os Clientes):** VMs que representam os endpoints monitorados. Elas rodam o Zabbix Agent e reportam **apenas** para seus proxies locais.
4.  **Auto-Monitoramento:** As próprias VMs que hospedam o Servidor e os Proxies também instalam um Agente Zabbix para que possamos monitorar a "saúde" da própria infraestrutura de monitoramento.

## 💻 Tecnologias Utilizadas

  * **Vagrant:** Ferramenta de automação de infraestrutura usada para provisionar e configurar todas as 5 VMs.
  * **Ruby:** A linguagem na qual o `Vagrantfile` é escrito.
  * **Docker:** Usado para containerizar todos os serviços (Zabbix Server, Proxies, MySQL, Grafana), garantindo isolamento e portabilidade.
  * **Zabbix Server:** O cérebro do sistema, que armazena, analisa e exibe os dados.
  * **Zabbix Proxy (SQLite):** Coletores leves usados em locais remotos (`SBSV`, `SBNT`) para coletar dados localmente antes de enviá-los ao servidor.
  * **Grafana:** Plataforma de visualização usada para criar dashboards, conectada à API do Zabbix.
  * **Linux (Ubuntu 22.04):** O sistema operacional base para todas as 5 VMs do ambiente.
  * **Shell (Bash):** Usado para todos os scripts de provisionamento (`.sh`) dentro das VMs Linux (instalação do Docker, configuração de agentes, etc.).
  * **PowerShell:** Usado no script `create_project.ps1` para gerar a estrutura de diretórios no host Windows.

-----

## 🚀 Guia de Início Rápido

Siga estes passos para subir o ambiente.

### 1\. Pré-requisitos

  * Vagrant
  * VirtualBox
  * VS Code (ou outro editor)
  * Git Bash (Recomendado para verificar os arquivos)

### 2\. Ação Obrigatória: Finais de Linha (CRLF)

Este é o erro mais comum que causa a falha no provisionamento. Scripts (`.sh`) salvos no Windows (CRLF) são inválidos no Linux (LF).

**Como Corrigir (no VS Code):**

1.  Vá para **File** \> **Preferences** \> **Settings** (ou `Ctrl + ,`).
2.  Procure por **`Files: Eol`** e mude a configuração para **`lf`**.
3.  **Abra e salve novamente** todos os 10 arquivos `.sh` do projeto para convertê-los.

### 3\. Ação Obrigatória: Interface de Rede

O Vagrant precisa saber qual placa de rede do seu computador usar para a rede "pública" (`public_network`).

1.  Abra o arquivo `Vagrantfile`.
2.  Encontre a linha: `$host_bridge_interface = "Intel(R) Dual Band Wireless-AC 7265"`.
3.  Altere o valor para o nome exato da sua placa de rede principal (ex: "Ethernet" ou "Wi-Fi").

### 4\. Subir o Ambiente

Após salvar as correções acima, execute:

```powershell
# 1. Crie a estrutura de pastas
.\create_project.ps1

# 2. Popule todos os arquivos .sh, .yml e o Vagrantfile

# 3. Destrói qualquer VM antiga
vagrant destroy -f

# 4. Cria, provisiona e inicia todas as 5 VMs
vagrant up
```

-----

## ⚙️ Passo a Passo: Configuração Pós-Deploy (Obrigatório)

Após o `vagrant up`, os serviços estão rodando, mas você precisa conectá-los na interface do Zabbix.

### 1\. Informações de Acesso

  * **Zabbix UI:** `http://10.0.0.111:8080` (Login: `Admin` / `zabbix`)
  * **Grafana UI:** `http://10.0.0.111:3000` (Login: `admin` / `admin`)

### 2\. Configurando o Zabbix

#### A. Registrar os Proxies

O servidor precisa autorizar os proxies a enviarem dados.

1.  Vá para **Administration** -\> **Proxies**.
2.  Clique em **Create proxy**.
3.  **Configurar Proxy 1 (SBSV):**
      * **Proxy name:** `ZBX-PROXY-SBSV-Host` (Nome exato do `docker-compose.yml` do proxy)
      * **Proxy mode:** `Active`
4.  Clique em **Add**.
5.  **Configurar Proxy 2 (SBNT):**
      * Clique em **Create proxy** novamente.
      * **Proxy name:** `ZBX-PROXY-SBNT-Host`
      * **Proxy mode:** `Active`
6.  Clique em **Add**.
7.  **Checagem:** Aguarde 1-2 minutos. A coluna "Last seen" deve atualizar, confirmando a conexão.

#### B. Registrar os 5 Hosts

Diga ao Zabbix quais máquinas monitorar e quem (Servidor ou Proxy) deve monitorá-las.

1.  Vá para **Data collection** -\> **Hosts** e clique em **Create host**.

2.  **Host 1: `zbx-server-sbrf` (O próprio Servidor)**

      * **Host name:** `zbx-server-sbrf`
      * **Host groups:** `Linux servers`
      * **Monitored by proxy:** `(no proxy)`
      * **Templates (Aba):** `Linux by Zabbix agent`
      * **Interfaces (Aba):** Adicione `Agent` com IP `192.168.50.10` (Este é o IP da VM do servidor, que o container Docker do servidor pode acessar).

3.  **Host 2: `zbx-proxy-sbsv` (O Host do Proxy 1)**

      * **Host name:** `zbx-proxy-sbsv`
      * **Host groups:** `Linux servers`
      * **Monitored by proxy:** `(no proxy)` (O Servidor principal irá monitorá-lo).
      * **Templates (Aba):** `Linux by Zabbix agent`
      * **Interfaces (Aba):** Adicione `Agent` com IP `192.168.50.20`.

4.  **Host 3: `zbx-proxy-sbnt` (O Host do Proxy 2)**

      * **Host name:** `zbx-proxy-sbnt`
      * **Host groups:** `Linux servers`
      * **Monitored by proxy:** `(no proxy)`
      * **Templates (Aba):** `Linux by Zabbix agent`
      * **Interfaces (Aba):** Adicione `Agent` com IP `192.168.50.30`.

5.  **Host 4: `ZBX-CLIENT-SBSV` (O Cliente 1)**

      * **Host name:** `ZBX-CLIENT-SBSV`
      * **Host groups:** `Linux servers`
      * **Monitored by proxy:** `ZBX-PROXY-SBSV` (Este é monitorado pelo Proxy).
      * **Templates (Aba):** `Linux by Zabbix agent`
      * **Interfaces (Aba):** Adicione `Agent` com IP `10.10.20.20`.

6.  **Host 5: `ZBX-CLIENT-SBNT` (O Cliente 2)**

      * **Host name:** `ZBX-CLIENT-SBNT`
      * **Host groups:** `Linux servers`
      * **Monitored by proxy:** `ZBX-PROXY-SBNT`
      * **Templates (Aba):** `Linux by Zabbix agent`
      * **Interfaces (Aba):** Adicione `Agent` com IP `10.10.30.20`.

**Checagem Final:** Aguarde 5 minutos. Todos os 5 hosts na tela **Hosts** devem ficar verdes na coluna **Availability**.

### 3\. Configurando o Grafana

1.  Acesse `http://10.0.0.111:3000` (Login: `admin` / `admin`). Mude a senha.
2.  **Instalar Plugin:** Vá para **Administration** -\> **Plugins**, procure e instale o plugin "Zabbix".
3.  **Adicionar Data Source:**
      * Vá para **Connections** -\> **Data sources** -\> **Add new data source** -\> **Zabbix**.
      * No campo **URL**, cole o caminho completo da API (esta foi a correção final):
        `http://zabbix-web:8080/api_jsonrpc.php`
      * Role para baixo, insira o **User** `Admin` e a **Password** `zabbix`.
      * Clique em **Save & Test**. Você deve ver uma mensagem de sucesso.

-----

## 🧪 Plano de Testes de Carga

As ferramentas `stress` e `iperf3` foram automaticamente instaladas nas VMs dos Clientes (`ZBX-CLIENT-*`) pelos scripts de provisionamento.

#### A. Teste de CPU

1.  Acesse o cliente: `vagrant ssh ZBX-CLIENT-SBSV`
2.  Execute o teste: `stress --cpu 1 --timeout 120`
3.  **Checagem:** Observe o gráfico "CPU utilization" do host `ZBX-CLIENT-SBSV` no Zabbix/Grafana subir para 100%.

#### B. Teste de Disco I/O

1.  No mesmo cliente, execute: `dd if=/dev/zero of=tempfile bs=1M count=500 oflag=direct`
2.  **Checagem:** Observe os gráficos de "Disk read/write" no Zabbix.
3.  (Limpe o arquivo: `rm tempfile`)

#### C. Teste de Rede (Cliente para Proxy)

1.  **Terminal 1 (Proxy):**
    ```bash
    vagrant ssh ZBX-PROXY-SBSV
    sudo apt-get install -y iperf3
    iperf3 -s
    ```
2.  **Terminal 2 (Cliente):**
    ```bash
    vagrant ssh ZBX-CLIENT-SBSV
    # iperf3 já está instalado
    iperf3 -c 10.10.20.10 -t 60
    ```
3.  **Checagem:** Observe os gráficos de tráfego de rede (`Network traffic`) para `ZBX-CLIENT-SBSV` no Zabbix.
