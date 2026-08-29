#!/usr/bin/env bash
# Construye las dos imágenes de máquina simulada y las sube a Harbor.
#
# Se ejecuta desde el portátil del profesor, no desde el clúster. Requiere
# docker y estar autenticado en Harbor:
#     docker login registry.ivanosuna.com -u admin
#
# Uso:   ./construir.sh [version]     (por defecto 1.0)
set -euo pipefail

REGISTRO="${REGISTRO:-registry.ivanosuna.com/curso}"
VERSION="${1:-1.0}"
AQUI="$(cd "$(dirname "$0")" && pwd)"

for SISTEMA in rocky ubuntu; do
  IMAGEN="$REGISTRO/servidor-$SISTEMA:$VERSION"
  echo ">> construyendo $IMAGEN"
  docker build -f "$AQUI/Dockerfile.$SISTEMA" -t "$IMAGEN" "$AQUI"
  echo ">> subiendo $IMAGEN"
  docker push "$IMAGEN"
done

echo
echo "Listo. Las máquinas del aula usan estas imágenes; para que los alumnos"
echo "las reciban hay que recrear el aula:"
echo "    ansible-playbook ... 3-26-aula-ansible.yaml -e @parametros/desa.yaml --tags borrar"
echo "    ansible-playbook ... 3-26-aula-ansible.yaml -e @parametros/desa.yaml --tags crear"
