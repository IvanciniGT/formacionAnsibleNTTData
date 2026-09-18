

    CODIGO <> PRUEBAS > OK > REFACTORIZACION <> PRUEBAS -> OK  = Liberamos el programa (GENIAL!)
    <-------------------->   <----------------------------->
            8 horas                     8 horas
            50% tiempo                  50% tiempo


Desarrollador, va montando su web en su máquina:
    c:\proyectos\proyecto1\
                           CODIGO PROYECTO
                           .git

Va dejando todo en un repo remoto de git: GITLAB
    https://migitlab.com/usuario/proyecto1

Un pipeline de CI
    Decsarga ese repo en un entorno efímero (contenedor)
    Lo compila el código
    Ejecuta pruebas
    Lo empaqueta
    Y el resultado (.ZIP con html, css, imágenes, js...) lo sube a un NEXUS, ARTIFACTORY, o similar.

Un pipeline de CD
    Extraiga el paquete (.ZIP con html, css, imágenes, js...) desde NEXUS, ARTIFACTORY, o similar.
    Y lo despliegue


---

El playbook se ejecuta en un nodo: ORIGEN / NODO DE CONTROL / LOCALHOST
Las tareas se ejecutan contra un NODO_DESTINO / SERVIDOR REMOTO

modulo syncronize (internamente hace rsync) o el módulo copy (internamente hace cp) copian del NODO DE CONTROL al SERVIDOR REMOTO
    dest: Servidor REMOTO
    src: NODO DE CONTROL
Este es el comportamento por defecto.
Pero puedo cambiarlo.
En el módulo synchronize puedo usar el parámetro "mode: pull" para copiar del SERVIDOR REMOTO al NODO DE CONTROL.

Nosotros lo que queremos es que copie del destino al destino (SERVIDOR REMOTO al SERVIDOR REMOTO)
Entonces el mode pull tampoco me vale.
Hay otra opción: usar la propiedad "delegate_to" para ejecutar la tarea de copia en el SERVIDOR REMOTO, apuntando tanto al src como al dest en el SERVIDOR REMOTO.

---

# pruebas:

La prueba: Verificar que la web responde con el contenido que debe
    es suficiente. Si la prueba da OK, es que todo ha quedado COJONUDO!

Si la web no responde con el contenido que debe, dónde esta el problema? NPI
Dónde podría estar?
- El servicio no arrancó bien
- La configuración no es válida
- El puerto no está abierto en el firewall
- El contenido del paquete desplegado no es el esperado

Paso de esto. Y solo monto la prueba GORDA: Verificar que la web responde con el contenido que debe.
Y de repente, en un paso a producción: HOSTION! No funiona. Task FAILED!
En MEDIO DE UN PASO A PRODUCCION!
Qué trabajo tengo que ponerme a hacer (en medio del paso a producción, llamadas de telefono de los usaurios que no vaentre tanto, correos, mi jefe dando por saco.)? INVESTIGAR QUE HA FALLADO:
- Si ha fallado al arrancar el apache
- Si ha fallado la configuración del firewall
- Si ha fallado el despliegue del paquete

La pregunta es:
- Prefiero hacerlo en ese momento bajo presión y con los usuarios jodidos sin poder acceder
- Prefiero hacerlo ahora mientras estoy trabajando en mi playbook que tengo tranquilidad


---

La inmensa mayoría de los módulos de ansible soportan el check mode, lo que permite simular los cambios que se realizarían sin aplicarlos realmente.

Pero imaginad este módulo:

ansible.builtin.shell:
    cmd: "miscript.sh"

El módulo SHELL que hace? Ejecutar comandos.
Entiende el módulo SHELL la naturaleza del comando que ejecuta? NO. al módulo YO LE DO UN COMANDO y el lo ejecuta y punto
No entra a valorar el comando.

---

Hasta ahora hemos estado creando playbooks.
Pero para trabajar con Ansible necesitamos 2 cosas:
- Playbooks
- Inventarios

# Inventarios

Un inventario es una colección "organizada" de entornos sobre los que Ansible va a ejecutar las tareas.

Hay 3 formas de definir inventarios en ansible. Y SOLO UNA ES LA BUENA!
Y habitualmente la que poca gente conoce.

- Ini
- YAML
- Una carpeta! GUAY! Tiene lo bueno de los arhivcos .ini, lo bueno de los .yaml y además organizadito todo en subcarpetas y en archivos chiquitos.

Esos son los formatos que admite ANSIBLE. Y NO HAY MAS.

Ahora... de donde salen esos archivos?
Esto es otra pregunta.
- OPCION 1: Los puedo tener escritos en el HDD.
- OPCION 2: Puedo tener un PROGRAMA que genere los inventarios dinámicamente en esos formatos, que es lo que ansible soporta.

En lugar de un archivo .ini, puedo tener un script BASH, PYTHON que genere el archivo .ini dinámicamente.
En lugar de un archivo .yaml, puedo tener un script que genere un archivo YAML dinámicamente.

O incluso (SUPER GUAY DE LA MUERTE!) puedo tener una carpeta, donde tenga:
- Archivos.ini
- Archivos.yaml
- Subcarpetas con más archivos.ini y archivos.yaml
- Mezclados con scripts que generen inventarios dinámicamente
ESTO ES LO BUENO!

Las máquinas las sacaré de un CMDB (Configuration Management Database), que es donde tengo toda la información de los servidores y sus características.
Y variables específicas de mis playbooks, las puedo tener en ficheros YAML dentro de la misma carpeta de inventarios o en subcarpetas organizadas.

AWX (Ansible Automation Platform) nos ofrece SCRIPTS PRECREADOS POR LA GENTE DE REDHAT para generar inventarios dinámicament
desde algunas fuentes estandar:
- Clouds (AWS, Azure, GCP)
- VMware
- ..

---

# DONDE VAMOS A CORRER EL PLAYBOOK? = ENTORNOS DE EJECUCION

En un entorno que hemos llamado NODO DE CONTROL.
Que tiene que tener instalado:
- Entorno UNIX-LIKE (Linux, MacOS...)
- Ansible
- Python
- Las colecciones que use en mis tareas
- Dependencias que necesiten mis playbooks:
  - paquetería de SO
  - módulos de Python necesarios

---

Pregunta. En el entorno (que ponga la empresa) donde esté instalado toda esta mierda... 
Desde el que se vayan a ejecutar mis playbooks... (= NODO DE CONTROL)
- Va a estar instalada la colección X que necesita mi playbook A? NPI... ya...
- Y va a tener la dependencia Y (curl) que necesita mi playbook B? NPI... ya...
- Y... que versión de ansible va a estar instalada? NPI... ya...

Entonces... que hago?
- Le pongo perejil a San Pancracio? Y rezo un poquito.. a ver si cuando suba funciona?
- O me aseguro de que el NODO DE CONTROL tenga todo lo necesario antes de ejecutar mis playbook <<<<< ESTO QUIERO

Pero.. en la empresa me van a dejar instalar LO QUE A MI ME VENGA EN GANA EN UN ENTORNO DONDE TODO EL MUNDO VA A A EJECUTAR SUS PLAYBOOKS?
Sería razonable? NO
- Es más.. una persona puede tener unas necesidades y otra persona otras disntintats (incluso incompatibles entre si)

Esta mierda, nos la comíamos cuando empezamos a trabajar con Ansible.. La solución que teníamos era:
- PONER PEREJIL A SAN PANCRACIO Y REZAR UN POQUITO

Hoy en día por suerte disponemos del concepto de EXECUTION ENVIRONMENTS (ENTORNOS DE EJECUCIÓN)

Un entorno de ejecución es una IMAGEN de contenedor, desde la que se generará un CONTENEDOR donde se ejecutará mi playbook.
Yo, oh, creador del playbook! no solo creo el playbook, también creo EL ENTORNO DE EJECUCIÓN donde ese playbook correrá.

Esos entornos de ejecución, en local, los puedo gestionar con una herramienta de ansible llamada: ansible-navigator.
Esos entornos en remoto los gestiona AWX (Ansible Automation Platform).

Crearé un entorno de ejecución en local con ayuda del ansible navigator (en concreto con un programa que viene dentro de ansible-navigator llamado "ansible-builder"

Eso creará una IMAGEN DE CONTENEDOR.
Esa, la publicaré y la cargaré en un AWX.

Y cuando se configura mi playbook en AWX, le indicaré que use ese ENTORNO DE EJECUCIÓN específico, asegurándome así de que todas las dependencias y colecciones necesarias estén presentes.
---

# Linux

Kernel de SO.

Es un Sistema Operativo? NO
Cómo se llama el Sistema operativo? GNU/Linux
Que se ofrece en forma de distros:
    - Debian
    - Ubuntu
    - CentOS
    - Fedora
    - Arch Linux


AWX de pruebas / certificacion
    Inventario de maquinas de juguette
    Playbook A
        v
    Entorno de Ejecución de playbooks 17

    vvv

AWX de producción
    Inventario de maquinas reales
    Playbook A
        v
    Entorno de Ejecución de playbooks 17

---

# Qué era UNIX?

Unix era un Sistema Operativo que fabricaba los lab Bell de la amreicana de telco AT&T.
Dejo de producirse a principios de los 2000.
AT&T licenciaba UNIX de forma diferente a como hoy en día se licencian los Sistema Operativos. 
Hoy en día tenemos un EULA (End User License Agreement), que es el acuerdo de licencia que regula el uso de los sistemas operativos modernos.

AT&T licenciaba Unix para empresas, universidades y otras organizaciones bajo términos específicos que variaban según el tipo de licencia.

Grandes fabricantes de computadoras tomaban UNIX y lo adaptaban a su hardware:
- Commodore -> Amiga
- Olivetti -> Unix PC

Llevo a haber más de 400 variaciones de Unix (distros y adaptaciones de hardware).
Y presentaban incompatibilidades entre sí.

Salieron 2 estandares para poner control a cómo debían evolucionar esas distros:
    - POSIX (Portable Operating System Interface)
    - Single UNIX Specification (SUS)

# Qué es UNIX?

Hoy en día un SO Unix es un Sistema que cumple con los estándares POSIX y la Especificación Única de UNIX (SUS).

HP: HP-UX (Unix®)
IBM: AIX (Unix®)
Oracle: Solaris (Unix®)
Apple: macOS (Unix®)

Luego hay sistemas operativos que parece (creemos) que cumplen con esos estándares, aunque no estén oficialmente certificados como Unix:
    - BSD
    - GNU/Linux

Cuando nos referimos a SO Unix-like, nos referimos a sistemas operativos que cumplan (o que supuestamente cumplan) con esos estándares.

POSIX:
Se define el concpto de la SH, los comandos ls, cp, cat. y otras utilidades básicas que deben estar presentes en un sistema compatible con POSIX.

