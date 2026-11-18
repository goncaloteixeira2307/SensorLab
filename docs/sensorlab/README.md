# SensorLab — Servidor Linux srv-g3

## 1. Descrição do projeto

O SensorLab consiste na implementação de uma infraestrutura de servidor Linux, utilizando Ubuntu Server 26.04.1 LTS numa máquina virtual Oracle VirtualBox.

O projeto integra serviços de rede, segurança, alojamento web, base de dados e API.

## 2. Elementos do grupo

- Elemento 1: Gonçalo Teixeira
- Elemento 2: Gonçalo Ferreira
- Elemento 3: Ivo Bessa

## 3. Arquitetura

**Servidor:** srv-g3 (utilizador administrativo `administrator`)  
**Sistema operativo:** Ubuntu Server 26.04.1 LTS  
**Plataforma de virtualização:** Oracle VirtualBox  
**Domínio interno:** `sensorlab.lan`

O servidor utiliza duas interfaces de rede:

- `enp0s3`: NAT (`10.0.2.15/24`, gateway `10.0.2.2`), para acesso à Internet.
- `enp0s8`: rede interna `labnet`, com o endereço `192.168.50.1/24`.

A rede interna permite a comunicação entre o servidor e as máquinas clientes, que recebem endereços por DHCP (`192.168.50.100–200`) e usam o servidor como gateway e DNS. O acesso SSH a partir do anfitrião Windows é feito por port forwarding no NAT (`127.0.0.1:2222` → `10.0.2.15:22`).

## 4. Serviços implementados

| Requisito | Serviço | Descrição |
|---|---|---|
| R1 | Contas e permissões | Utilizadores `administrator`, `goncalo`, `ivo` e `ana`; grupo `sensorlab`; `sudo` apenas para `administrator`; pasta partilhada `/srv/sensorlab` (setgid e ACL por omissão para o grupo, sem acesso a outros utilizadores) |
| R2 | SSH e UFW | SSH apenas por chave (palavras-passe desativadas, `AllowUsers` restrito), hardening em `/etc/ssh/sshd_config.d/10-hardening.conf`; UFW com política `deny incoming` e `allow outgoing` |
| R3 | Kea DHCP | Serviço ativo apenas em `enp0s8`; pool `192.168.50.100–200`, com gateway e DNS `192.168.50.1`; testado com VM cliente |
| R4 | BIND9 DNS | Escuta em `127.0.0.1` e `192.168.50.1`; zonas `sensorlab.lan` (direta) e `50.168.192.in-addr.arpa` (inversa); forwarders `1.1.1.1` e `8.8.8.8` |
| R5 | Nginx e HTTPS | Site `www.sensorlab.lan` / `sensorlab.lan` com certificado TLS autoassinado; HTTP redireciona (301) para HTTPS |
| R6 | PostgreSQL | Base `sensorlab`, com dono `sensorlab_api` (sem privilégios de administração); escuta apenas em `127.0.0.1:5432` |
| R7 | Docker e Flask | API Flask com Gunicorn em Docker Compose (`restart: unless-stopped`), em `127.0.0.1:8000`; endpoints `/health` e `/leituras` (GET e POST) |
| R8 | Fail2ban e backups | Jail `sshd` (3 tentativas em 10 min, ban de 10 min); backup diário às 02:00 (base de dados e configurações), retenção de 7 dias, em `/var/backups/sensorlab` |
| R9 | Documentação | Relatório, apresentação e este README |

## 5. Dataset e fonte

**Dataset utilizado:** Intel Berkeley Research Lab Sensor Data (amostra de leituras de temperatura de sensores "mote")

**Fonte:** Intel Berkeley Research Lab / MIT CSAIL — https://db.csail.mit.edu/labdata/labdata.html

Dados recolhidos por Peter Bodik, Wei Hong, Carlos Guestrin, Sam Madden, Mark Paskin e Romain Thibaux (Intel Berkeley Research Lab, 2004). Utilização permitida mediante agradecimento.

## 6. Estrutura do repositório

- `docs/` — Documentação, apresentação e declaração de utilização de IA.
- `config/` — Cópias das configurações dos serviços.
- `compose/` — Ficheiros de configuração Docker.
- `sql/` — Scripts de criação e gestão da base de dados.
- `scripts/` — Scripts de backup e manutenção.

## 7. Reconstrução do projeto

Para reconstruir a infraestrutura:

1. Criar uma máquina virtual Ubuntu Server no VirtualBox.
2. Configurar os adaptadores de rede NAT e Rede Interna.
3. Configurar as interfaces e os endereços IP.
4. Instalar e configurar os serviços descritos neste documento.
5. Aplicar as configurações disponibilizadas na pasta `config/`.
6. Criar a base de dados através dos scripts da pasta `sql/`.
7. Configurar e iniciar a API através do Docker Compose.
8. Configurar os backups e testar os serviços.

Os ficheiros de configuração e scripts disponibilizados neste repositório servem de apoio à reconstrução.

## 8. Segurança

Por motivos de segurança, este repositório não deve conter:

- Palavras-passe reais.
- Ficheiros `.env` com credenciais.
- Chaves privadas SSH.
- Chaves privadas TLS.

As credenciais devem ser configuradas localmente durante a instalação.

## 9. Tecnologias utilizadas

- Ubuntu Server
- Oracle VirtualBox
- OpenSSH
- UFW
- Kea DHCP
- BIND9
- Nginx
- TLS
- PostgreSQL
- Python Flask
- Gunicorn
- Docker
- Fail2ban
- Git e GitHub
