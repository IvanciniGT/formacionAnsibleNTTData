# Esqueleto de los cursos de Ansible

Todo lo necesario para levantar un aula de Ansible desde cero y dejarla
limpia al terminar. Pensado para reutilizarse en cada impartición.

El aula vive en el clúster de Kubernetes: cada alumno tiene su namespace, dos
máquinas simuladas y sus credenciales. Los playbooks que la crean están en el
repositorio del clúster, en `nuevo/playbooks/3-extras/`.

---

## Lo que recibe cada alumno

| Qué | Dónde |
|---|---|
| Namespace propio | `alumnoN` |
| Dos máquinas | `servidor-rocky` y `servidor-ubuntu` |
| Clave SSH | Secret `ansible-clave` |
| Inventario y `ansible.cfg` | ConfigMap `ansible-inventario` |
| Acceso a Kubernetes | Secret `kubeconfig` |
| Usuario en Keycloak | `alumnoN` |

**Los nombres de las máquinas son iguales para todos.** Es lo que hace que un
playbook escrito por el profesor funcione en el entorno de cualquier alumno
sin tocar una línea: el alias del inventario no cambia nunca, sólo el
`ansible_host`, que apunta al namespace de cada uno.

---

## Empezar un curso

Desde el repositorio del clúster, en `nuevo/`.

**1. Borrar el curso anterior.** Siempre, aunque parezca que no queda nada.

```bash
ansible-playbook -i inventarios/nuevoinventario.ini \
  playbooks/3-extras/3-26-aula-ansible.yaml \
  -e @parametros/desa.yaml --tags borrar
```

**2. Ajustar el número de alumnos** en `parametros/desa.yaml`:

```yaml
alumnos:
  cantidad: 15        # <- el de esta impartición
  prefijo: "alumno"
  password: "Alumno.2026$"
```

**3. Crear los usuarios y sus namespaces.**

```bash
ansible-playbook -i inventarios/nuevoinventario.ini \
  playbooks/3-extras/3-24-oidc-alumnos.yaml \
  -e @parametros/desa.yaml --tags alumnos,alumnos-ns
```

**4. Levantar las máquinas del laboratorio.**

```bash
ansible-playbook -i inventarios/nuevoinventario.ini \
  playbooks/3-extras/3-26-aula-ansible.yaml \
  -e @parametros/desa.yaml --tags crear
```

**5. Comprobar antes de que entre nadie.**

```bash
kubectl get pods -A -l proposito=aula-ansible --no-headers | grep -c Running
# tiene que dar: cantidad_de_alumnos x 2
```

---

## Terminar un curso

```bash
# Máquinas, claves e inventarios
ansible-playbook -i inventarios/nuevoinventario.ini \
  playbooks/3-extras/3-26-aula-ansible.yaml \
  -e @parametros/desa.yaml --tags borrar

# Namespaces enteros, si no se reutilizan
kubectl delete ns -l proposito=aula
```

Los usuarios de Keycloak se quedan: crearlos otra vez es instantáneo y
borrarlos no gana nada.

---

## Qué hace el alumno el primer día

**1. Entra en Headlamp** con su usuario de Keycloak. Es la puerta: no
necesita nada instalado.

**2. Recoge sus credenciales** de su namespace:

- Secret `ansible-clave` → guardarla como `~/.ssh/aula` con permisos `600`
- ConfigMap `ansible-inventario` → su inventario ya relleno
- Secret `kubeconfig` → si va a usar `kubectl`

**3. Clona este repositorio** y prueba que todo responde:

```bash
cd ejemplo
ansible-playbook playbook-prueba.yml
```

Tiene que salir el nombre y la familia de cada sistema. Si sale, el
laboratorio está listo.

---

## Contenido del repositorio

```
imagenes/                    Las dos máquinas simuladas
  Dockerfile.rocky           Rocky 9 + sshd + python3 + sudo
  Dockerfile.ubuntu          Ubuntu 24.04, lo mismo
  arranque.sh                Genera claves de host y copia las autorizadas
  construir.sh               Construye y sube a Harbor

entornos-de-ejecucion/       Execution environments
  basico/                    El del primer día: ansible-core y poco más
  avanzado/                  Con colecciones y paquetes añadidos

ansible-navigator.yml        Para quien use navigator en local

ejemplo/                     Lo que el alumno ejecuta primero
  inventario.ini
  ansible.cfg
  playbook-prueba.yml        gather_facts + nombre y familia del SO
```

---

## Detalles que cuestan una tarde si no se saben

Están documentados en cada fichero, pero conviene tenerlos a mano.

**Las imágenes llevan `python3` a propósito.** Sin él Ansible no puede
ejecutar módulos en el destino y sólo funciona `raw`. Es el fallo típico de
quien monta un contenedor SSH pelado.

**`sshd` en contenedor necesita las capacidades `SYS_CHROOT` y
`AUDIT_WRITE`.** Sin ellas arranca, escucha y cierra cada conexión sin decir
por qué; el cliente sólo ve `Connection closed by ... port 22`.

**Las claves de host se regeneran en cada arranque.** Es deliberado: da pie a
explicar `host_key_checking = False`, que ya viene puesto en el
`ansible.cfg` de ejemplo.

**Harbor necesita `disableredirect` con almacenamiento S3.** Si no, sirve las
capas redirigiendo a un nombre DNS interno del clúster que el kubelet no
resuelve. Desde un pod funciona y desde el nodo no, que despista mucho.
