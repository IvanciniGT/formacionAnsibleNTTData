
# Contenedor

Un entorno AISLADO dentro de un kernel Linux, donde puedo ejecutar procesos.

Tiene que ver con cómo desplegar/instalar software en un entorno de producción.

# Instalación tradicional

        App1 + App2 + App3
    ---------------------------------
        Sistema operativo
    ---------------------------------
        HIERRO

    Problemas graves, especialmente en un entorno de producción:
    - Conflictos entre aplicaciones por dependencias compartidas
    - Si hay un bug en una y toma control de la CPU, RAM, HDD, deja al resto fritas.
    - Problemas de seguridad. Potencialmente unas apps pueden acceder a los datos o recursos de otras aplicaciones.

# Máquinas virtuales

        App1    | App2 + App3
    ---------------------------------
        SO1     |   SO2
    ---------------------------------
        MV1     |   MV2
    ---------------------------------
        Hipervisor
    ---------------------------------
        Sistema operativo
    ---------------------------------
        HIERRO

    Las máquinas virtuales son una forma de generar ENTORNOS AISLADOS sobre un mismo hardware, donde ejecutar procesos de manera independiente, cada uno con su propio sistema operativo y recursos virtualizados, dependencias...

    Esto nos resuelve los problemas de las instalaciones tradicionales, como los conflictos de dependencias, la afectación de una aplicación sobre otra y los problemas de seguridad, ya que cada máquina virtual está aislada y tiene su propio sistema operativo y recursos.

    Pero vinieron con sus problemas:
    - Mayor consumo de recursos, ya que cada máquina virtual necesita su propio sistema operativo completo.
    - Merma en el rendimiento, ya que la virtualización introduce una capa adicional entre el hardware y las aplicaciones.
    - Más complejidad en la instalación/mantenimiento, ya que cada máquina virtual requiere su propio sistema operativo y configuración.
    - Licencias???

HAce más de 10 años surgieron los contenedores como una alternativa más ligera a las máquinas virtuales, permitiendo ejecutar aplicaciones en entornos aislados sin necesidad de virtualizar un sistema operativo completo.


# Contenedores

        App1    | App2 + App3
    ---------------------------------
        C1      |   C2
    ---------------------------------
        Gestor de contenedores:
        Docker, Podman, containerd, crio
    ---------------------------------
        Sistema operativo Linux
    ---------------------------------
        HIERRO

Los contenedores se basan en funcionalidad que existe/aporta el kernel Linux.
Con contenedores, casa Contenedor no tiene un SO completo instalado, con su kernel. 
Los contenedores comparten / hacen uso del kernel del host.
Solo hay un Kernel en funcionamiento (un sistema operativo).
Esto resuelve de un plumazo todos los problemas que traían las VMs.

Cuando trabajamos con contenedores, no instalamos software.. DESPLEGAMOS SOFTWARE.

Los contenedores se crean desde imágenes de contenedor.
Y en una imagen de contenedor viene un SOFTWARE PREINSTALADO COMPLETAMENTE por el fabricate (u otros) de ese software.
Básicamente una imagen de contenedor es un triste archivo comprimido (.tar).

En ella, los creadores de la imagen montan (instalan) todo lo que un programa necesita para funcionar:
- Código del programa
- Configuraciones
- Dependencias
- Librerías necesarias
- ...

Lo que hacemos luego es DESCOMPRIMIR esa imagen de contenedor.. y arrancar el programa que lleve dentro.

Esas imágenes de contenedor las dejamos en REGISTROS DE REPOSITORIOS DE IMAGENES DE CONTENEDOR: 
- Docker Hub
- Quay.io
- GitHub Container Registry
- Google Container Registry
- Amazon Elastic Container Registry (ECR)
- Harbor
- Artifactory
- Azure Container Registry (ACR)

Los gestores de contenedores DESCARGAN EN AUTOMATICO las imágenes de contenedor desde u nregistry.. y crean desde ellas un contenedor: ENTORNO AISLADO PARA EJECUTAR PROCESOS.

Habitualmente esas imágenes de contenedor se crean mediante unos ficheros llamados Dockerfile.

Ansible ofrece su propio lenguaje para generar imágenes de contenedor: Execution-Environments.
Nos ofrece en paralelo un programa llamado ansible-builder, que permite construir imágenes de contenedor a partir de Execution-Environments.

Realmente ansible-builder transforma un fichero de Execution-Environment en un fichero Dockerfile, que luego se utiliza para construir la imagen de contenedor.

Esa imagen de contenedor posterioremte se usa para CREAR UN CONTENEDOR EFIMERO!
En ese contenedor podemos correr un playbook de ansible.

El proceso habitual es:
1. Defino un Execution-Environment con lo necesario para correr mi playbook
2. Género una imagen de contenedor a partir del Execution-Environment usando ansible-builder.
      vvv                                                                   vvvv
  ENTORNO LOCAL/Desarrollo                                             ENTORNO CENTRALIZADO (AWX, Ansible Automation Platform)

ENTORNO LOCAL:
3. Utilizo un programa llamado ansible-navigator. Ese programa me ayuda a ejecutar playbooks de Ansible dentro de contenedores efímeros creados a partir de la imagen generada.
   Así pruebo mi playbook y el entorno:
   Ansible-navigator:
      - crear un contenedor efímero con la imagen que le hemos dado.
      - Inyectar dentro de ese contenedor los archivos de mi playbook
      - Ejecutar el comando ansible-playbook dentro del contenedor efímero.
      - Guardar la salida del comando
      - Destruir el contenedor.

4. Una vez probado el entorno, SUBO LA IMAGEN DE CONTENEDOR A UN REGISTRY
5. Una vez probado el playbook, lo SUBO A UN REPOSITORIO DE GIT
6. A tomar café!

ENTORNO CENTRALIZADO:
3. Dentro del Ansible Automation Platform (o AWX), doy de alta lo que se llama un EXECUTION ENVIRONMENT, qué básicamente es dar de alta la IMAGEN DE CONTENEDOR que hemos creado y subido a un registry.
4. Creo un proyecto, que básicamente es dar de alta un repositorio de git.
5. Defino una plantilla de trabajo (vaya nombre hortera le han dado a los playbooks)
   Simplemente es ponerle un nombre humano y algunas características (como por ejemplo EN QUE EXECUCTION ENVORONMENT debe ejecutarse), un playbook que venga dentro del repositorio de git.
6. A tomar café!

En algún momento se ejecutará el playbook (bien porque alguien le pegue al cohete! o porque esté programado para ejecutarse automáticamente a ciertas horas).
Lo que hace AWX o Ansible Automation Platform en ese momento es :
- crear un contenedor efímero con la imagen que le hemos dado.
- Inyectar dentro de ese contenedor los archivos de mi playbook
- Ejecutar el comando ansible-playbook dentro del contenedor efímero.
- Guardar la salida del comando
- Destruir el contenedor.

---

En la realidad:
4. Una vez probado el entorno, SUBO LA IMAGEN DE CONTENEDOR A UN REGISTRY
    ^^^^^
   ESTO NO OCURRE

En la realidad, lo suyo es:
- Cuando tengo probado el execution-environment, lo subo a un repo de git (el archivo execution-environment.yml)
- Y tendré un proceso (pipeline) de entrega continua (CD) que se encargará de construir la imagen de contenedor y subirla al registry automáticamente.
- No es algo que quiera yo que mis compañeros de equipo tengan que hacer manualmente. ESTE PROCESO QUEDA AUTOMATIZADO.
- Si bien... eso no quita que en local, cuando una persona está haciendo su playbook, y está definiendo su execution-environment, tenga que construir y probar la imagen de contenedor de manera local antes de subir el archivo execution-environment.yml al repositorio de git.


---

Para desarrollo en windows:
1. Montar python en el sistema.
   Por qué?
   Porque ansible-navigator y ansible-builder son programas escritos en python.
2. Habilitar WSL (Windows Subsystem for Linux) 
   Por qué?    Para poder ejecutar CONTENEDORES DENTRO DE WSL.
3. Montar un gestor de contenedores: Docker, podman
   Por qué?    Para poder construir y ejecutar los contenedores que utilizará ansible-navigator y ansible-builder.
4. Instalar ansible-navigator y ansible-builder como módulos de python.

Y ya!


---

Una cosa es donde corre el playbook (Siempre un entorno UNIX-LIKE) .. Hoy en día la tendencia es usando execution-environments basados en contenedores.

Otra cosa es sobre qué nodo se ejecutan las tareas de los playbooks.
En cualquier nodo sobre el que quiera ejecutar tareas de un playbook, debo tener:
- acceso adecuado (Entorns Unix-like mediante SSH, En entornos Windows mediante WinRM)
- Un usuario con los permisos necesarios para ejecutar las tareas definidas en el playbook.
  Habitualmente, en los entornos gestionado vía ansible, creamos un usuario específico para que Ansible ejecute las tareas del playbook.
- Tener python instalado, ya que Ansible requiere python para ejecutar sus módulos en los nodos gestionados.
  Hoy en día, un python 3 es lo normal.

---

VOY a crear un entorno de ejecución (execution-environment) para mis playbooks.
- Crear una imagen de contenedor a partir del archivo execution-environment.yml utilizando ansible-builder.
- Rematar el playbook
- Probar el execution-environment y el playbook con ansible-navigator para asegurarme de que todo funciona correctamente.

Cuando lo tengamos, subiré todo al repo de git que tenemos juntos.

---

NOS VAMOS a AWS, cada uno con vuestro usuario.
Vamos a registrar en el AWX nuestro repo de git.
Vamos a crear un proyecto en AWX utilizando ese repo de git.
Vamos a crear un template de job en AWX que utilice ese proyecto y nuestro execution-environment.
Luego, ejecutaremos ese template de job contra un inventatrio que ya os tengo dado de alta en el AWX.


---

# Vocabulario testing

- ERROR         Los humanos cometemos errores. 
- DEFECTO       Al cometer un error, podemos introducir un DEFECTO en nuestro producto.
                El DEFECTO es lo que perdura. Es la cicatriz que queda en el producto como consecuencia de mi error. 
- FALLO         Es la manifestación de un DEFECTO al usar el producto.
                Lo podemos ver como una desviación con respecto al comportamiento esperado del producto.

Dentro de las pruebas, en software hablamos de 2 tipos:
- Pruebas dinámicas: Ejecutar el programa en busca de FALLOS
- Pruebas estáticas: Revisar el código sin ejecutarlo, buscando DEFECTOS.

---

# ROLES EN ANSIBLE

¿Qué es un role?

Un role vendría a ser el equivalente en programación tradicional a una librería o un módulo.

Para instalar paquetes, definimos un fichero con un listado de tareas reutilizable. Esto era equivalente al concpto de función.

Un role es un nivel superior de REUTILIZACION DE CODIGO.

Imaginad que el día de mañana queremos hacer un despliegue más complejo.
- Despliegue de app1. Y esa app necesita un apache y un postgres        -> playbook-app1.yaml
- Despliegue de app2. Y esa app también necesita un apache y un mysql   -> playbook-app2.yaml
- Despliegue de app3. Y esa app necesita un mysql y un weblogic         -> playbook-app3.yaml

Nosotros , en este playbook ya estamos instalando un apache.

La pregunta, puedo reutilizar todo este trabajo en otros playbooks sin tener que repetirlo.

Eso es lo que me daría un ROLE.
Un role es:
- Un conjunto de tareas reutilizables que se pueden incluir en diferentes playbooks.
- Con sus propias CONSTANTES
- Con sus propias PLANTILLAS
- Con sus propios HANDLERS
- Con sus propias variables de usuario.

Hay un módulo de ansible que se llama `include_role` que permite incluir un role dentro de un playbook.
Es equivalente al módulo `include_tasks`, pero específicamente para incluir roles.

Con tasks puedo ejecutar tareas que tengo en otro fichero dentro de mi playbook.
Con include_role puedo incluir un role completo dentro de mi playbook, con todas sus tareas, handlers, plantillas y variables.

Hay una herramienta dentro de Ansible llamada ansible-galaxy que permite gestionar roles, incluyendo la creación, instalación y publicación de roles.

Un role es como un playbook, pero sin la parte de "hosts", ni la de "gather_facts".


---

# Imagenes base de contenedor

Ubuntu, Debian, CentOS, Alpine, Fedora

Lo que viene en esas imágenes es un ZIP (TAR) con:
- Las 4 carpetas estandar que define POSIX:
   bin/ 
   etc/
   home/
   var/
   tmp/
   root/
   usr/
   ...
- Los 4 comandos que define POSIX: 
  - cp
  - ls
  - mv
  - rm
  - ...
- Los programas habituales que encontramos en cada distro:
  - Ubuntu: apt, dpkg
  - Rocky: yum, dnf
  - Alpine: apk
- 