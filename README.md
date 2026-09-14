# Curso de Ansible — NTT Data

Aquí tienes lo que vas a necesitar durante el curso: los ficheros con los que
trabajaremos y las instrucciones para conectarte al laboratorio.

**No hace falta que instales Ansible en tu portátil.** El laboratorio vive en un
clúster de Kubernetes y se usa desde el navegador. Si además quieres ejecutar en
local, al final se explica cómo — pero es opcional.

---

## Lo que tienes montado

Cada alumno tiene su propio espacio, aislado del de los demás.

| Qué | El tuyo |
|---|---|
| Usuario | `alumnoN` — tu número te lo doy el primer día |
| Dos máquinas Linux | `servidor-rocky` y `servidor-ubuntu` |
| Tres bases de datos | `alumnoN_dev`, `alumnoN_test`, `alumnoN_pro` |
| Espacio en Kubernetes | un *namespace* con tu nombre |

**Las máquinas se llaman igual para todos, y eso es a propósito.** Un playbook
escrito contra `servidor-rocky` funciona en el entorno de cualquiera sin tocar
una línea; lo que cambia por debajo es a qué máquina apunta ese nombre. Así
podemos compartir código en clase sin que nadie adapte nada.

Las dos traen Python y un usuario `ansible` que puede hacer `sudo` sin
contraseña, que es lo que Ansible necesita para trabajar.

**Son Rocky Linux y Ubuntu a propósito.** Casi todo lo que veremos sobre
condicionales, familias de sistema operativo y módulos según la distribución se
practica teniendo las dos delante.

---

## Dónde se entra

| Para qué | Dirección |
|---|---|
| Ejecutar tus playbooks | https://awx.ivanosuna.com |
| Ver tu espacio en Kubernetes | https://cluster.ivanosuna.com |
| Tu identidad | https://iam.iochannel.tech |
| Bases de datos por navegador | https://bbdd.ivanosuna.com |

**Las tres primeras usan el mismo usuario y la misma contraseña.** El usuario es
`alumnoN`; la contraseña la doy de viva voz el primer día. No está escrita en
ningún sitio de este repositorio, y no tienes que cambiarla.

Si la pierdes, pídemela. No la busques en el material.

---

## Qué hay en cada carpeta

```
proyectos/
  ejemplo/                  el primer playbook, para comprobar que todo va
  entornos-de-ejecucion/    como se empaqueta Ansible en un contenedor
  ansible-navigator.yml     configuracion para ejecutar en local (opcional)

notas/                      apuntes de clase, dia a dia
```

### `proyectos/ejemplo/`

Tres ficheros, y ninguno sobra:

- **`inventario.ini`** — quiénes son tus máquinas. Verás que los nombres son
  alias y que `ansible_host` apunta al sitio de verdad.
- **`ansible.cfg`** — la configuración. Lleva `host_key_checking = False` porque
  las máquinas del laboratorio regeneran su clave en cada arranque y, si no,
  cada conexión daría un aviso. **En producción eso no se hace nunca**, y
  hablaremos de por qué.
- **`playbook-prueba.yml`** — no cambia nada en las máquinas. Sólo demuestra que
  Ansible conecta, que recoge datos del sistema y que sabe distinguir Rocky de
  Ubuntu. Es lo primero que vas a ejecutar.

### `proyectos/entornos-de-ejecucion/`

Un *execution environment* es un contenedor con Ansible y sus dependencias
dentro. En vez de «instalar Ansible», se construye una imagen y se ejecuta ahí:
así todo el mundo ejecuta exactamente lo mismo.

Hay dos, y la diferencia importa:

- **`basico/`** — con lo que empezamos: `ansible-core` y poco más.
- **`avanzado/`** — al que llegaremos, añadiendo colecciones y paquetes según
  vayan haciendo falta.

**Ése es el ejercicio**: que el entorno de ejecución también es código, se
versiona y se reconstruye cuando cambia. No es un detalle de instalación.

---

## Cómo se trabaja

El circuito del curso es éste, y es el mismo que usarías en una empresa:

```
escribes en tu portatil  ->  subes a tu repositorio de Git  ->  AWX lo ejecuta
```

1. **Escribes** tus playbooks donde te apetezca: VS Code, vim, lo que uses.
2. **Los subes** a tu repositorio de Git.
3. **AWX los ejecuta** contra tus máquinas. Allí tienes tu propia organización,
   con tu inventario (`alumnoN-laboratorio`) y tus dos máquinas ya dadas de alta
   en el grupo `servidores`.

El inventario no tienes que configurarlo: ya está puesto y apunta a lo tuyo.

### Lo que necesitas en tu portátil

Poco, y probablemente ya lo tienes:

- **Un editor de texto.** VS Code va bien; cualquiera sirve.
- **Git**, para subir tu trabajo.
- **Un navegador.**

Ansible no hace falta instalarlo.

### Si además quieres ejecutar en local (opcional)

Se puede, y a partir de cierto punto del curso resulta cómodo para probar sin
subir nada. Necesitas:

- **Podman o Docker**, para el entorno de ejecución.
- **`ansible-navigator`** — `pip install ansible-navigator`.
- **Tu clave SSH**, que sacas de tu espacio en Kubernetes y guardas como
  `~/.ssh/aula` con permisos `600`. En clase vemos cómo.

`proyectos/ansible-navigator.yml` ya está configurado para eso: monta tu clave
dentro del contenedor y usa el entorno básico.

```bash
cd proyectos
ansible-navigator run ejemplo/playbook-prueba.yml
```

---

## La primera comprobación

Antes de escribir nada tuyo, lanza el playbook de prueba. Si sale bien, el
laboratorio está entero y puedes empezar.

Debería decirte qué sistema operativo tiene cada máquina. Si eso funciona,
funciona todo lo demás: conexión, credenciales, permisos y red.

**Si falla, no pierdas el tiempo peleándote.** Dímelo y lo miramos: el primer
día es justo cuando salen las cosas del laboratorio, y es más probable que sea
de él que tuyo.

---

## Cosas que te van a pasar, y por qué

**«No me conecta a la máquina».** Lo más habitual el primer día es la clave SSH:
tiene que estar en `~/.ssh/aula` y con permisos `600`. Si la puede leer
cualquiera, SSH la rechaza — y el mensaje no siempre lo dice claro.

**«A mí me funciona y a mi compañero no».** Cada uno tiene sus propias máquinas.
Si le pasas un *playbook* a alguien, le funcionará, porque los nombres son los
mismos. Si le pasas tu *inventario*, no: ése sí apunta a las tuyas.

**«He roto mi máquina».** No pasa nada, para eso está. Dímelo y la reconstruimos
en un minuto. Es un laboratorio, no un servidor de producción: rómpelo, que es
como se aprende.

**«Se me ha borrado lo que tenía».** Lo que esté en tu repositorio de Git
sobrevive a todo. Lo que esté sólo dentro de una máquina, no. Sube tu trabajo.

---

## Al terminar el curso

El laboratorio se desmonta y las máquinas desaparecen. **Tu repositorio de Git es
tuyo y se queda contigo**, con todo lo que hayas escrito.

Sube lo que quieras conservar antes del último día.
