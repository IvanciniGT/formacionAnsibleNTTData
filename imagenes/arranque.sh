#!/bin/bash
# Arranque de una maquina simulada del aula.
set -e

# Claves de host: se generan en el primer arranque. Al reiniciarse el
# contenedor cambian, y el alumno vera el aviso de "host key changed". Es
# deliberado: se le ensena a poner host_key_checking=false en ansible.cfg,
# que es justo lo que hara en cualquier laboratorio real.
ssh-keygen -A >/dev/null 2>&1

# Claves autorizadas: llegan montadas desde un Secret en /claves. Se COPIAN
# a .ssh porque sshd rechaza un authorized_keys cuyos permisos no controle.
if [ -f /claves/authorized_keys ]; then
  install -o ansible -g ansible -m 600 /claves/authorized_keys \
    /home/ansible/.ssh/authorized_keys
fi

mkdir -p /run/sshd
exec /usr/sbin/sshd -D -e
