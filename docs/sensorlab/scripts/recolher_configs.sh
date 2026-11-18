#!/usr/bin/env bash
# Recolhe cópias das configurações do srv-g3 para a pasta config/.
# Executar no servidor, a partir da raiz do repositório:
#   sudo bash scripts/recolher_configs.sh
# Depois rever os ficheiros (sem palavras-passe nem chaves privadas).
set -u
DEST="$(cd "$(dirname "$0")/.." && pwd)/config"

copiar() {   # copiar <origem> <subpasta>
  for f in $1; do
    if [ -e "$f" ]; then
      mkdir -p "$DEST/$2"
      cp -r "$f" "$DEST/$2/"
      echo "OK    $f"
    else
      echo "FALTA $f"
    fi
  done
}

copiar "/etc/netplan/*.yaml"            netplan
copiar "/etc/ssh/sshd_config.d/*.conf"  ssh
copiar "/etc/kea/kea-dhcp4.conf"        kea
copiar "/etc/bind/named.conf.local"     bind
copiar "/etc/bind/named.conf.options"   bind
copiar "/etc/bind/db.*"                 bind
copiar "/etc/nginx/sites-available/*"   nginx
copiar "/etc/fail2ban/jail.local"       fail2ban
copiar "/etc/fail2ban/jail.d/*.local"   fail2ban

mkdir -p "$DEST/ufw"
ufw status verbose > "$DEST/ufw/ufw-status.txt" 2>/dev/null && echo "OK    ufw status"

# Chaves privadas TLS nunca devem ser copiadas
find "$DEST" \( -name "*.key" -o -name "*.pem" \) | while read -r k; do
  echo "AVISO: a remover possível chave privada: $k"; rm -f "$k"
done

echo "Concluído. Rever $DEST antes do commit."
