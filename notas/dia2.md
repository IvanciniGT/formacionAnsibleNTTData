
# Redhat

Tiene muchos proyectos de software. De todos tiene 2 versiones, ambas opensource. Una es gratuita y la otra de pago (mediante un modelo de subscripción).

- Redhat Enterprise Linux (RHEL) <- proyecto upstream -- Fedora
- JBOSS <- proyecto upstream -- WildFly
- Openshift Container Platform <- proyecto upstream -- OKD
- Ansible Automation Platform <- proyecto upstream -- AWX
- ...

---

# Repaso día 1

Es una familia de productos de Redhat orientada a tareas de autoamtización (más en el mundo de sistemas).
Entre los productos de la familia Ansible:
- Ansible Engine: Es un conjunto de comandos (se ejecutan desde un cli). Ofrece:
  - Un lenguaje (basado en YAML) para definir scripts (plays)... Y tiene una característica: Es medio/declarativo.
    - El flujo del script es IMPERATIVO
    - La definición de las tareas es DECLARATIVA casi siempre
    Gracias a ello, es más fácil crear scripts IDEMPOTENTES. 
  - Un lenguaje (de hecho 3) para definir inventarios.
  - Una serie de comandos para interactuar/ejecutar/gestionar los plays y los inventarios.
- Ansible Automation Platform (Ansible Tower, AWX):
  - App Web que rueda en un Servidor central
  - Gestiónm CENTRALIZADA de Playbooks e Inventarios
  - Además una gestión centralizada de CREDENCIALES, USUARIOS, ROLES y PERMISOS
  - Ofrece un Api HTTP Rest para ejecución REMOTA de los playbooks y gestión de inventarios.
  - Capacidades de orquestación y planificación de playbooks.

---

# Ejecución de trabajos en Ansible

Ansible se ejecuta en un nodo de control (que debe ser un entorno UNIX-LIKE).
Otra cosa es sobre que nodo se ejecuta un playbook o las tareas de un playbook.


    Nodo de Control         --------------------------------------------------------->     Nodo Remoto
    (máquina UNIX-LIKE)                                                                    (máquina UNIX-LIKE, Windows...)
                                        El nodo de control debe poder conectarse 
        playbook        (fichero)           al nodo remoto: ssh, winrm
        inventario      (fichero)
        ansible-engine  (software)

        AQUI EJECUTO EL PLAYBOOK    --------- Algunas tareas del playbook ---------->
                                           se ejecutan dentro del nodo remoto
    
    AQUI NECESITO PYTHON INSTALADO                                                          AQUI NECESITO PYTHON INSTALADO


# Estado de ejecución de una TAREA!

Un play tiene muchas tareas.
Esas tareas se van ejecutando secuencialmente.
Y cada tarea puede acabar de distinta forma / ESTADO:
- OK:          Significa que la tarea no ha generado un error al ejecutarse.
- CHANGED:     Significa que la tarea no ha generado un error, y ha introducido cambios en el sistema remoto.
- FAILED:      Significa que la tarea ha generado un error al ejecutarse.
               Por DEFECTO, Cuando una tarea acaba FAILED, Ansible DETIENE LA EJECUCION DEL PLAY en el entorno remoto.
               No sigue ejecutando el resto de tareas.
- SKIPPED:     Significa que la tarea no se ha ejecutado. Nos la hemos saltado por algún motivo.
- UNREACHABLE: Significa que Ansible no ha podido conectarse al nodo remoto para ejecutar la tarea.

---

# Estructura de los playbooks

Un playbook es un programa: SCRIPT

Y hay algo que cuando comenzamos a escribir programas no entendemos. Es lo que diferencia a un desarrollador JUNIOR DE UN SENIOR.
Que un programa funcione es lo de menos... SE DA POR DESCONTADO!

Cuando comenzamos creemos que el problema es conseguir hacer algo que funcione... Y EN ABSOLUTO. ESE NO ES EL PROBLEMA.
Que el programa funcione se da por descontado.

Os pongo un ejemplo en otra industria.. que lo vemos claro.

Que un coche ANDE. Eso es algo especial? NO.. es algo que doy por descontado. Si es un coche me tiene que llevar ade un sitio a otro. Si no anda, no es un coche... es una escultura de hieero con ruedas.

Si un programa no funciona... es un archivo de texto con pretensiones! PERO NO UN PROGRAMA. Para ser DIGNO del nombre PROGRAMA, tendrá que hacer algo y bien.

LA CLAVE! Es que lo que haga sea FACIL DE MANTENER EN EL TIEMPO! ESTO ES CRITICO!

Igual que un COCHE!

POR DEFINICION UN COCHE ES UN PRODUCTO SUJETO A MANTENIMIENTOS.
Si no lo han tenido en cuenta al crear el coche: ME HAN ESTAFADO!
Los ingenieros que diseñan el coche deben tener esto en cuenta al crear el coche. NO ES QUE EL COCHE FUNCIONES.. eso se da por descantado. Si no anda.. no es coche.
Lo importante es que ese coche , que es un producto SUJETO POR DEFECTO A MANTENIMIENTOS, sea fácil de mantener en el tiempo. Esto es lo que realmente marca la diferencia entre un buen diseño y uno mediocre.

IGUAL PASA CON UN PRODUCTO DE SOFTWARE. Un producto de software , por definición es un PRODUCTO SUJETO A MANTENIMIENTOS Y EVOLUCION CONSTANTE.
Voy a tener a lo largo del tiempo 200 versiones de ese programa (SCRIPT).
Si cada vez que voy a hacer un cambio me paso 1 mes... y 10.000 euros... Mi cliente se sentirá ESTAFADO y ENGAÑADO!
Con razón! Yo debí tenerlo en cuenta!

No nos hemos dado cuenta.. pero ya no somos ADMINISTRADORES DE SISTEMAS. 
Hoy en día somos PROGRAMADORES! Que creamos PROGRAMAS que ADMINISTRAN SISTEMAS. Yo ya no los administro. 
Y voy a tratar de aprender algo de la gente que lleva DECADAS CREANDO PROGRAMAS (desarrolladores)... algo sabrán!

Habéis oido hablar de la GRAN CRISIS DEL SOFTWARE? Fué a finales de los años 60 (hace 65 años).. tio ... llevamos muchas décadas creando software!
Después de 2 décadas de desarrollo intensivo, hubo un colapso del sistema. Los programas comenzarón a ser tan complejos, había tan poco estructura, procedimiento, patrones, diseño en la creación de esos programas que la industria acabo colapsando:
- Tiempos de entrega totalmente incumplidos.
- Costes desorbitados, incluso para cambios pequeños
- En muchas ocasiones, directamente interesaba más TIRAR lo que había y empezar de cero... por la incapacidad de evolucionar los sistema.

FUE UN DESASTRE.
AQUI SALE LA INGENIERIA DE SOFTWARE. Para dar solución a estos problemas:
Se empienzan a investigar Patrones, Diseños, Conceptos, Procedimientos para evitar los problemas que habían llevado al colapso de la industria del software.

Hay que aprender de eso!

                        Esta la abro en vscode
                        vvvvvvvvv
c:\Usuarios\YO\Desktop\cursoAnsible\
                                    formacionAnsibleNTTData\ <-- clonado de mi repo de git
                                        notas\
                                        proyectos\
                                    proyectos\
                                        servidor-web\