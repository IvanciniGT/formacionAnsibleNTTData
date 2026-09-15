Quiero un playbook para desplegar un servidor web apache/nginx en unos servidores linux.

PreTasks:
    La instalación de la paqueteria previa necesaria por el servidor web sería una pre-tarea.
Tasks:
    La instalación del servidor la haré aquí. Será una tarea
    Configurar los puertos u otras características del servidor web. Eso sería una tarea también.
    Configurar un servicio que arranque el servidor web automáticamente con el arranque del sistema. Esto sería una tarea.
PostTasks:
    Una prueba de que el servidor web contesta correctamente. Sería una post-tarea.

UN PARAMETRO de ejecución del playbook será la configruación que quiero aplicar. (LA TENDRE EN UN FICHERO)

                                                                                    SUPUESTOS DE ESTADOS INICIALES
                                                                                LIMPIO      SEGUNDA EJECUCION       Al mes... cambio la configuración
pre_tasks:
    - name: 1.Asegurar que la paquetería previa queda instalada                   CHANGED     OK                       OK
tasks:
    - name: 2.Asegurar que el servidor web queda instalado                        CHANGED     OK                       OK
      notify: CAMBIO_PENDIENTE
    - name: FORZAR EJECUCION DE HANDLERS ACTIVADOS EN ESTE PUNTO
      meta: flush_handlers
    - name: 3.Asegurar que la configuración del servidor web es la deseada        CHANGED     OK                       CHANGED
      notify: CAMBIO_PENDIENTE
    - name: 4.Asegurar el arranque automático del servidor web                    CHANGED     OK                       OK
post_tasks:
    - name: 5.Comprobar funcionamiento del servidor web                           OK          OK                       OK

handler:
    - name: 6.Reiniciar el servidor web                                           SKIPPED     SKIPPED                  CHANGED
      listen: CAMBIO_PENDIENTE

ORDEN DE EJECUCION En el caso: "al mes... cambio la configuración" sería:
- Tarea 1
- Tarea 2
- Tarea 3
- Tarea 4
- Tarea 6
- Tarea 5


Qué estamos definiendo? Nombres de LAS TAREAS

Las tareas son ACCIONES! -> VERBO (por ejemplo: Instalar, Configurar, Arrancar, Comprobar)
Además dijimos que en un playbook, el lenguaje es IMPERATIVO!
Solo que algunas tareas, por dentro me ofrencen la posibilidad de hablar en lenguaje DECLARATIVO... por dentro, pero no por fuera.
Vamos a usar siempre INFINITIVOS para nombrar las tareas