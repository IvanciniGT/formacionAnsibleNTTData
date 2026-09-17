

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
