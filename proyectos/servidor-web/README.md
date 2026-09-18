# Servidor web Apache

Playbook de ejemplo del curso. Deja un servidor web Apache instalado, configurado,
arrancado y con una aplicación desplegada, **y luego comprueba que de verdad funciona**,
tanto en máquinas de familia Debian (Debian, Ubuntu) como RedHat (RHEL, Rocky, Alma).

Lo que se pedía:

- Instalar Apache en máquinas Ubuntu y RHEL.
- Dejarlo corriendo como servicio.
- Aplicarle la configuración que nos suministren en un fichero.
- Desplegar en él una web que viene de un repositorio de git.
- Y asegurarnos de que todo queda funcionando, **accesible desde el exterior**.

Esa última línea es la que justifica la mitad del playbook.


## Cómo se lanza

Hace falta un inventario. El más simple posible:

```ini
# inventario.ini
[servidores_web]
10.0.0.21
10.0.0.22

[servidores_web:vars]
ansible_user=ansible
```

Y ya:

```bash
ansible-playbook -i inventario.ini playbook.yaml -e @defaults/datos-usuario.yaml
```

Ese `-e @fichero` no es opcional: el playbook **no carga solo** `defaults/datos-usuario.yaml`.
Sin él, variables como `aplicacion_a_desplegar` no existen y el playbook no llega a ninguna parte.
(La alternativa es declararlo en un `vars_files` del play, y entonces el `-e` sobra.)

### Por tipos de operación (tags)

Los tags no son etiquetas sueltas: son **los tipos de operación que sabe hacer este playbook**.
Sirven para pedirle que haga solo una parte.

| Tag | Para qué |
|---|---|
| `instalacion`   | Solo asegurar que el servidor web está instalado y actualizado |
| `configuracion` | Solo asegurar que está bien configurado |
| `despliegue`    | Solo asegurar que la aplicación está desplegada |
| `pruebas`       | Solo comprobar que lo que hay montado funciona |

```bash
ansible-playbook -i inventario.ini playbook.yaml --tags instalacion
ansible-playbook -i inventario.ini playbook.yaml --tags pruebas       # no toca nada, solo comprueba
```

Las pre-tareas llevan el tag `always`, así que se ejecutan siempre: sin ellas el playbook
no sabría ni en qué distro está.

### Qué hace falta tener

**En el nodo de control:** Ansible, y las colecciones `ansible.posix` (firewall y rsync) y
`community.general` (los backups). No son de `ansible.builtin`, así que hay que instalarlas
aparte — o meterlas en el *execution-environment*, que es lo suyo y es lo que se ve en el día 5.

**En cada máquina gestionada:** acceso SSH, un usuario con `sudo`, y Python 3.
Ansible no instala agentes, pero necesita Python al otro lado para ejecutar sus módulos.


## Qué rellena el usuario y qué no

Hay dos ficheros de variables y la diferencia importa:

- **`defaults/datos-usuario.yaml`** — lo que cambia en cada despliegue: qué aplicación, en qué dominio,
  en qué puerto, con qué versión de Apache. **Esto lo toca el usuario.** Lo que hay ahí es
  un ejemplo: casi todo es opcional y el playbook aguanta que no venga.
- **`vars/constantes.yaml`** — lo que NO depende del despliegue sino de la distro:
  cómo se llama el paquete de Apache en cada familia, dónde van sus ficheros de configuración.
  Esto no se toca salvo para dar soporte a una distro nueva.

### Versiones: el mínimo, no la última

En `version.name` **no se pone la última versión que ha salido, se pone la mínima que necesitas**.
Y como el playbook tiene que valer para las cuatro distros, el suelo es la más vieja de todas:

|        | Ubuntu 22.04 | Debian 12 | Rocky 8  | Rocky 9 | suelo que pedimos |
|--------|--------------|-----------|----------|---------|-------------------|
| apache | 2.4.52       | 2.4.68    | 2.4.37   | 2.4.57  | **>= 2.4.37**     |
| git    | 2.34.1       | 2.39      | 2.43     | 2.43    | **>= 2.34.0**     |
| curl   | 7.81         | 7.88      | 7.61     | 7.76    | **>= 7.61.0**     |

Si pides de más, dejas fuera a una distro perfectamente válida y el playbook falla
en una máquina que habría funcionado sin problema.


## Cómo está montado

```
playbook.yaml                 El play: pre_tasks -> tasks -> post_tasks + handlers
defaults/
  datos-usuario.yaml          Lo que rellena quien usa el playbook
vars/constantes.yaml          Lo que depende de la distro, no del despliegue

pre_tasks/
  main.yaml                     Orquesta las tres fases de abajo
  informacion-previa.yaml       Averigua en qué distro estoy y carga constantes
  validaciones-previas.yaml     Si algo no cuadra, corta AQUÍ
  preparativos-previos.yaml     Instala las dependencias (git, curl)

tasks/
  main.yaml                     Instalar -> configurar -> desplegar -> arrancar -> firewall

post_tasks/
  main.yaml                     Las pruebas: ¿esto funciona de verdad?

debian/                       Lo que solo vale para Debian/Ubuntu
redhat/                       Lo que solo vale para RHEL/Rocky/Alma
  tareas-instalacion-paquete.yaml
  reglas-firewall.yaml

templates/
  plantilla-virtual-host.j2     El VirtualHost que se genera
```

### Por qué hay una carpeta por familia

Porque la distro concreta da igual, pero **la familia no**. Las distros son «Ubuntu Mint»,
«XUbuntu», «Rocky», «AlmaLinux»...; las familias son dos, y son las que cambian el cómo:

| | Debian / Ubuntu | RedHat / Rocky |
|---|---|---|
| Paquete | `apache2` | `httpd` |
| Config  | `/etc/apache2/sites-enabled` | `/etc/httpd/conf.d` |
| Firewall | `ufw` | `firewalld` |
| Versión de un paquete | `apache2>=2.4.37` **pegado** | `httpd >= 2.4.37` **con espacios** |
| Repositorio | necesita *suite* y *componentes* | van dentro de la URL |
| SELinux | no hay | sí, y manda |

El playbook mira la familia una sola vez (`familia_sistema_operativo`) e incluye el fichero
que toca. Añadir una familia nueva es añadir una carpeta, no tocar la lógica.

### El contrato entre `tasks/` y las carpetas de familia

Los ficheros `tareas-instalacion-paquete.yaml` reciben siempre esta estructura:

```yaml
package:
  name:       apache2          # lo ÚNICO obligatorio
  version:
    name:     "2.4.37"         # opcional
    matching: ">="             # opcional ("=" si no se dice)
  repo:                        # opcional entero
    name:     mi-repo
    url:      https://...
    gpgkey:   https://.../key.asc
```

De ahí, **lo único que se puede dar por hecho es `name`**. Hay paquetes que vienen en los
repos oficiales de la distro y no llevan repo; hay paquetes de los que da igual la versión.
Por eso el código pregunta siempre por el **contenido** (`repo.name | length > 0`) y nunca
por la **existencia** (`repo is defined`): el mapa puede llegar vacío, y un mapa vacío
existe igual.


## Ver las variables por dentro (las tareas LUPA)

Repartidas por el playbook hay tareas que empiezan por `LUPA -`. No hacen nada: enseñan
las variables que el playbook va generando y capturando por el camino, justo detrás de la
tarea que las produce.

```bash
ansible-playbook -i inventario.ini playbook.yaml -e @defaults/datos-usuario.yaml -vv
```

Sin `-vv` no se imprimen (llevan `verbosity: 2`), así que en el día a día no estorban.
Con `-vv` puedes ver, en orden:

| Dónde | Qué enseña |
|---|---|
| `pre_tasks/informacion-previa.yaml` | Las constantes cargadas · **todo** lo que trae `ansible_facts` · cómo `RedHat` se convierte en `redhat` · qué claves trae un `register` |
| `pre_tasks/preparativos-previos.yaml` | El `combine` de cada dependencia, paso a paso |
| `debian/` y `redhat/` | El mismo `package` de entrada, y la orden distinta que sale para apt y para dnf |
| `tasks/main.yaml` | Qué ha respondido el `synchronize` simulado, que es de lo que cuelga todo el despliegue |
| `post_tasks/main.yaml` | Lo que se sabe del servicio · la respuesta del DNS · qué ha devuelto la web |

**Una trampa que merece la pena conocer:** que un `debug` no imprima **no** significa que no
se evalúe. Ansible resuelve los argumentos de la tarea antes de ejecutarla, así que una lupa
escondida que mire una variable inexistente tumba el playbook igual:

```
Finalization of task args failed: 'variable_que_no_existe' is undefined
```

Por eso todas las lupas llevan `| default(...)` o un `when: ... is defined`.

## Qué comprueba al final

Las post-tareas son pruebas, y son **atómicas** a propósito: cada una comprueba una sola cosa,
para que cuando una falle sepas exactamente qué está roto.

1. El servicio de Apache está corriendo.
2. Apache escucha en el puerto — probado **desde dentro** de la máquina.
3. El puerto está abierto en el firewall — probado **desde fuera**, contra la IP.
4. El dominio resuelve (DNS) — probado desde el nodo de control, que es quien lo va a usar.
5. La web responde con el código de estado esperado.
6. Y con el contenido esperado.

Fíjate en 2 y 3: es la misma pregunta hecha desde dos sitios distintos, y por eso son dos
pruebas. Si solo probaras desde fuera y fallara, no sabrías si el problema es Apache o el
cortafuegos. Y la 3 ataca la **IP** y no el dominio a propósito, porque si usara el dominio
y fallara, no sabrías si el problema es el firewall o el DNS.

Las tareas que prueban «desde fuera» llevan `delegate_to: localhost`: las tareas de un playbook
se ejecutan en la máquina remota, y para estas eso es justo lo que NO queremos.


## Lo que este playbook NO hace

Y no por olvido:

- **No hace rollback.** Este playbook instala; si algo falla, avisa. Deshacer un despliegue
  tiene otras implicaciones y es otro trabajo. Eso sí: antes de pisar nada hace copia de
  seguridad, para que quien venga detrás tenga de dónde tirar.
- **No activa el cortafuegos.** Abre el puerto, pero activar un firewall en una máquina a la
  que estás conectado por SSH es la forma clásica de quedarte fuera. Esa decisión es de quien
  administra la máquina.
- **No toca SELinux.** Con el puerto 80 no hace falta. Con un puerto no estándar en RedHat sí,
  y hay que añadirlo a mano: `semanage port -a -t http_port_t -p tcp <puerto>`.

## Pendiente para la siguiente versión

- En Debian, el `.conf` se escribe directamente en `sites-enabled`. Funciona, pero lo canónico
  es dejarlo en `sites-available` y habilitarlo con `a2ensite`.
- Parar solo el virtual host afectado antes de actualizar, en vez de todo el servicio
  (hoy es un `debug` con un TODO).
- Un `requirements.yml` que declare `ansible.posix` y `community.general`.
- Consolidar los mapas de `constantes.yaml` (hoy son tres mapas distintos indexados por la
  misma clave) en uno solo por familia.
