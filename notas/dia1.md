
Visual Studio Code
---
Python 3.X
Docker/Podman

---

# Automatizar

Automatizar es crear una máquina (o cambiar el comportamiento de una mediante programas) que haga lo que antes hacía un humano con sus manos.

Puedo automatizar el lavado de la ropa -> LAVADORA

Incluso a esa lavadora le puedo cambiar su comportamiento (PROGRAMAS de lavado: ropa fría, prendas delicadas,....).

En nuestro mundo, la máquina la tenemos, no la creamos: COMPUTADORA
Para nosotros automatizar es CREAR PROGRAMAS que hagan el trabajo que antes hacía un humano.

AUTOMATIZAR = PROGRAMAR scripts! 

SCRIPT = Tipo de programa que se ejecuta de manera secuencial para automatizar tareas específicas.

# DEVOPS

Una cultura, un movimiento, una filosofía en pro de la AUTOMATIZACION!
Cuando en una empresa decimos: OYE CHIC@S, de ahora en adelante VAMOS A AUTOMATIZAR TODOS LOS TRABAJOS RELATIVOS AL MUNDO IT o muchos de ellos.

DEV = Desarrollo de software, creación de programas y scripts para automatizar tareas.
OPS = Operaciones de TI, gestión de infraestructura, despliegue y mantenimiento de sistemas.

Y hay 2 fases en el mundo devops:
- Fase 1: Automatizar los trabajos de cada casilla!

    DEVOPS:                         Automatizable?              Herramientas 
        Plan                        Poco
        Code                        Cada día más
        Build                       Totalmente
                                                                    JAVA: Maven, Gradle
                                                                    C, C++: Make
                                                                    C#: MSBuild, Dotnet, nuget
                                                                    JS/TS: NPM, YARN, Webpack
        Test
          Diseño de la prueba       Cada día más
          Ejecución de la prueba    Totalmente
                                                                Frameworks de pruebas de software:
                                                                    JUNIT, XUnit, MSUnit...
                                                                    Selenium, Cypress, WebDriver.IO
                                                                    Postman, ReadyAPI, SoapUI, Karate
                                                                    JMeter, Gatling, LoadRunner
                                                                    ....
            Me fío de las pruebas que ejecuto en el entorno del desarrollador?      NO me fío. Su entorno está MALEAO!
            Me fío de las pruebas que ejecuto en el entorno del tester?             NO me fío. Su entorno está MALEAO!
            Me fío de las pruebas que ejecuto en un entorno precreado de pruebas?   Antes si.. ya no!
                Cuando trabajaba con met. en cascada cuántas veces hacía pruebas?   1
                En. met. ágiles, cuantas veces hago pruebas (y por ende .. instalo en ese entorno de pruebas)?   Muchas veces
                Y después de 10-20 instalaciones.. sabéis como estará el entorno de pruebas?   MALEAO!
            Hoy en día las pruebas las hacemos en entornos efímeros, de usar y tirar.
            Que hay que hacer pruebas?, Se crea un entorno, instalo la aplicación, ejecuto las pruebas y luego se destruye el entorno.
            Que mañana hay que hacer pruebas... la misma mierda!
            Y empiezo siempre con un entorno limpio.
            Esto asegura que las pruebas sean consistentes y confiables.
            POV desarrollador:  GUAY! Que chulo!
            POV tester:         GENIAL! Entorno limpio para cada prueba.
            POV sistema:        QUE COJONES!!!! Me paso entero montando y desmontando entornos. -> SOLUCION? AUTOMATIZAR!

        Release
        Deploy                                                                              AUTOMATIZABLE?
                    Las instalaciones tienen 2 partes:
                        - Preparar la infraestructura y su configuración                        100%
                        - Propiamente instalar la aplicación y configurarla correctamente        100% 
                        Herramientas?
                            Terraform, CloudFormation, Vagrant
                            Ansible, Puppet, Chef, SaltStack
                            Scripts de la bash, ps1, python, .bat
                            Kubernetes, docker...
        Operate
        Monitor

    El provisionamiento de infraestructura se suele hacer con otro tipo de herramientas: Terraform, CloudFormation, Vagrant, Kubernetes, Helm.

    Ansible se centra principalmente en tareas de configuración de entornos/infraestructura.

    Ahora.. una cosa es que automatice tareas y otra que automatice PROCESOS!

- Fase2: Automatizar procesos

    Quiero que en cuanto un desarrollador haga commit (mande su código nuevo a un repositorio de git):
    - Se cree un entorno efimero donde probarlo
    - Se configure ese entorno efímero
    - Se descargue allí el código del desarrollador
    - Se compile en ese entorno efímero
    - Se ejecuten ciertas pruebas en ese entorno efímero
    - Se genere un nuevo entorno algo más completo
    - Se despliegue la aplicación empaquetada previamente en ese nuevo entorno
    - Se realicen otro tipo de pruebas según sea necesario
    - Que si va bien, el empaquetado (artefacto) se deposite en un registro de artefactos:
        - Por ejemplo: Nexus, Artifactory, Gitlag registry, Harbor
    - Que se genere un entorno de producción (o que se actualice el entorno de proeucción eque existe según sea necesario)
    - Que se configure correctamente el entorno de producción
    - Que se despliegue la aplicación en el entorno de producción
    - Que se realicen pruebas de HUMO (smoke test) en el entorno de producción
    - Que se manden emails si va bien o si va mal.
    - Que se hagan backups previos al despliegue en producción.
    - Que si va mal se haga en automático un rollback a la versión que funcionaba
  
  Y TODO ESO SIN INTERVENCION HUMANA = AUTOMATIZADO
  - Quién configura el programa (maven) para que el código compile de forma automática?             Desarrollador
  - Quién configura Selenium para hacer unas pruebas de interfaz gráfica?                           Tester
  - Quién configura terraform o ansible para automatizar la creación y configuración de entornos?   Sys admin de toda la vida.
  En muchas empresas a este último se le denomina DEVOPS... Al sysadmin de toda la vida que ahora usa terraform, ansible y clouds.
  Pero es una desvuiación SEVERA del concepto original de DEVOPS.
  DEVOPS NO NACIO SIENDO UN PERFIL... SINO UNA CULTURA EN PRO DE LA AUTOMATIZACION.
  Lo que pasa es que ahora necesito adiestra a la gente que antes hacia trabajos manuales de distinta naturaleza para que creen programas que los hagan automáticamente.
    Desarrollador tradicional + Maven.. gradle.. npom           -> Desarrollador v2.0 (automatizador)
    Tester tradicional + Selenium.. JUnit..                     -> Tester v2.0 (automatizador)
    Sys admin tradicional + terraform.. ansible.. clouds..      -> Sys admin v2.0 (automatizador) ~ Mal llamado Devops

Ahora.. una cosa es automatizar los trabajos... y otra los procesos (la orquestación/planificación):
Que esos trabajoas que se han automatizado se ejecuten de manera coordinada y planificada, siguiendo un flujo definido.
Esos flujos son lo que llamamos habitualmente PIPELINES DE ORQUESTACIÓN. Y se definen en herramientas como Jenkins, GitLab CI/CD, Argo Workflows, etc.

Y hace falta en esta nueva visión alguien que tenga una visión 360 del proyecto (software + infraestructura) para configurar esos pipelines de orquestación -> Éste es el que originalmente se comenzó a llamar DEVOPS. ERA UN PERFIL NUEVO QUE NO EXISTIA EN LA INDUSTRIA.

Ese nombre se ha malogrado para usarse en cualquier sysadmin que ahora haga algo de automatización, perdiendo así su significado original de perfil encargado de la orquestación de pipelines. NO HAY QUE LUCHAR CON ELLO. Hay que aceptarlo.

Si automatizo el PROCESO HASTA LA ETAPA DE PRUEBAS (TEST), qué nombre recibe?
    PLAN -> CODE -> BUILD -> TEST                           INTEGRACION CONTINUA
        Tener CONTINUAmente en el entorno de INTEGRACION la última versión desarrollada del software sometida a prueba automátizadas, para producir un informe de resultados de las pruebas en tiempo REAL.


    PLAN -> CODE -> BUILD -> TEST -> RELEASE                ENTREGA CONTINUA
        Poner en manmos de mi cliente la última versión desarrollada y probada del software de manera automática .
        Puede ser dejar una imagen de contenedor en un registro de contenedores accesible por el cliente.
        Puede ser subir una app mobile al store de turno: Google Play Store o Apple App Store.
        Puede ser subir un ZIP a mi website.

    PLAN -> CODE -> BUILD -> TEST -> RELEASE -> DEPLOY       DESPLIEGUE CONTINUA

    PLAN -> CODE -> BUILD -> TEST -> RELEASE -> DEPLOY -> OPERATION -> MONITORING       DEVOPS


Lo IMPORTANTE A ENTENDER es que nosotros (en esta formación) SOMO UN ESLABON MAS DE ESA CADENA GRANDE.
Mi trabajo es automatizar la configuración de una infraestructura.. y lo haré con un herramienta llamada Ansible (que realmente no es una herramienta.. sino un montón...)
Y es trabajo CONCRETO (TAREA) será parte de un FLUJO / PROCESO más grande que abarca desde la planificación hasta el monitoreo del software en producción. Quizás todavía no estamos en es flujo (momento)... hasta que TODAS (o muchas al menos) de las TAREAS que son necesarias para un FLUJO no han sido automatizadas, no tiene sentido automatizar EL FLUJO (Crear el pipeline).

PERO EL CAMINO ESTA MARCADO, con independencia del momento en el que nos encontremos.

# Ansible

Ansible es un nombre comercial con el que Redhat publica/agrupa una serie de productos pensados para automatizar algunos tipos de trabajos/tareas. Dentro de este paraguas encontramos:
- Ansible engine: Herramienta de linea de comandos que ofrece:
   - Lenguaje para definir automatizaciones e inventarios
   - Comandos para ejecutar tareas de automatización
- Ansible Automation Platform: (Antiguamente Ansible Tower) <- AWX
    - Interfaz web centralizada donde:
     - Gestionar inventarios
     - Ejecutar playbooks
     - Monitorear tareas
   - También un API/REST
   - Control de acceso
   - Gestión de credenciales
   - Este si tiene algo de planificación y orquestación (aunque pobre, sobre todo la parte de planificación)
- Ansible Galaxy: Repositorio de roles y colecciones compartidos por la comunidad

# Ansible engine:

Nos permite crear scripts de automatización llamados plays.
Los plays se escriben dentro de archivos llamados playbooks, que están escritos en YAML.

Pero.. antes de entrar en eso.
Llevamos décadas creando scripts de autoamtizaación de tareas propias de sistemas, usando la bash, pytho, ps1...
Para qué leches una nueva herramienta como Ansible?
Para que un lenguaje nuevo parea definisr scripts de automatización, cuando llevamos muchos años y conocemos ya otros lenguajes para hacer lo mismo: BASH, PYTHON, POWERSHELL...

Tiene que ver con un concepto lalmado IDEMPOTENCIA!

Eso es una propiedad MATEMATICA. Una operación / función es idempotente si, al aplicarla varias veces, el resultado es el mismo que si se aplicara una sola vez.
Por ejemplo, la operación MULTIPLICAR POR 1 es idempotente, porque no importa cuántas veces la apliquemos, el resultado siempre será el mismo que si la aplicáramos una sola vez.Otros ejemplos:
- Multiplicar por 0
- Valor absoluto
Saliendo del ámbito matemático: CONVERTIR UN TEXTO A MAYUSCULAS, es idempotente?

    - "Texto" -> "TEXTO" -> "TEXTO" -> "TEXTO"

En el mundo de los scripts, decimos que una tarea o un script es idempotente si, al ejecutarla varias veces, el resultado final es el mismo que si se ejecutara una sola vez. Dicho de otra forma.. que con independencia del estado inicial del sistema, tras ejecutar la tarea/script siempre llegue al mismo estado final.

Antiguamente, muchos scripts se ejecutaban una sola vez: 
- Instalar Oracle en una máquina. Cuántas veces se ejecutaba este script? Cuando instalaba el Oracle. 1 vez.
- Crear unos usuarios y abrir unos puertos. Cuántas veces se ejecutaba este script? Solo cuando era necesario crear los usuarios y abrir los puertos. 1 vez.

El problema es que hoy creamos muchos scripts (especialmente en el mundo devops) que no se van a ejecutar 1 sola vez, sino muchas veces a lo largo del tiempo. Por lo tanto, es crucial que estos scripts sean idempotentes, para que con independencia del estado actual del sistema, tras ejecutar el script siempre se llegue al mismo estado final.

> EJEMPLO: Que aprovechamos para introducir el concepto de IaC (Infrastructure as Code)
> Terraform es un ejemplo típico de herramienta de IaC (Infrastructure as Code)... pero hoy en día tenemos un concepto más amplio de lo que llamamos infraestructura.
> Los usuarios que necesito tener en una máquina para poder instalar un programa es infraestructura? Las claves ssh que han de estar registradas en un máquina para poder acceder a ella es infraestructura? La configuración de red, los paquetes instalados, los puertos que hay abiertos en el firewall de la máquina... Todo eso es infraestructura?

Una red... Una cosa es la parte física (HARDWARE) .. cableado, switches, routers... INFRAESTRUTURA
Pero una red tiene una parte lógica (CONFIGURACIÓN DE IP, VLANs, RUTAS, REGLAS DE FIREWALL...) .. también es INFRAESTRUCTURA, aunque no sea tangible.

La infraestructura no es solo la parte física, sino también la parte lógica y de configuración de los sistemas. Esto incluye no solo el hardware, sino también la red, los usuarios, las claves, los paquetes instalados y la configuración de los servicios.

De nada me sirve una máquina (HARDWARE) que no tiene SO (SISTEMA OPERATIVO) instalado y configurado correctamente. 
La instalación del Sistema Operativo es infraestructura también, ya que forma parte de la configuración necesaria para que la máquina funcione correctamente. Sin un sistema operativo instalado y configurado, el hardware por sí solo no es útil.

Hace años venimos hablando del conceptos de Infrastructure as Code (IaC).
Muchas veces, cuando escuchamos este concepto, lo que pensamos es que en lugar de crear / provisionar infraestructura manualmente, utilizamos código/programas para automatizar este provisionamiento. En parte es cierto.
Hoy en día, para tener un servidor nuevo, o un entorno donde poder ejecutar programas, no necesito comprar e instalar Hardware físico. Llevamos muchos años trabajando de otras formas. Por ejemplo, todos los clouds (AWS, AZURE, GPC...), kubernetes (y sus distros: Openshift, tanzu...), VMWARE, Oracle Virtualization, etc., nos permiten provisionar y gestionar infraestructura virtualizada.. o obtener de alguna forma entornos listos para usar sin necesidad de gestionar el hardware subyacente. Esto incluye también REDES, ALMACENAMIENTO, SERVICIOS Y TODA LA CONFIGURACIÓN NECESARIA PARA QUE LOS SISTEMAS FUNCIONEN CORRECTAMENTE.

El concepto de IaC va mucho más allá de hacer un programa que provea infraestructura de manera automatizada. IaC implica gestionar la infraestructura como si fuera código, como un PROGRAMA CUALQUIERA!
Y lo primero que hacemos cuando creamos un programa es llevar un control FERREO de versiones.

En el mundo de la infra no hemos aplciado un control de versiones tan riguroso como en el desarrollo de software, y eso era un problema ENORME!

Imaginad que quiero desplegar en mi entorno una app/sistema que hemos desarrollado inhouse.
Ese sistema para operar en el entorno de producción necesita:
- Una BBDD PostgresSQL (por supuesto, configurada en modo mirror - cluster activo-pasivo, para HA)
- Un cluster de 3 weblogics, donde se instala la aplciación
- Un balanceador de carga para distribuir el tráfico entre los nodos del cluster de weblogics.
- Una VIPA (Virtual IP Address) para el postgres... para que si una de las instancias falla, la otra pueda asumir el tráfico sin interrupción.

Necesito cierta infra para esa aplicación en versión 1.0.0:
- 3 servidores donde montar el weblogic.
- 2 servidores donde montar la base de datos PostgresSQL.
- Un F5 para el balanceo de carga.
- Una VIPA para el Postgres.. y configurar en sus servidores un heartbeat para la alta disponibilidad.

Ahora.. sale la versión 2.0.0 de la app. La app ahora hace uso de un redis, para caché y no tirar tanto de la base de datos.
Y ese redis, necesito montarlo en cluster de 3 nodos para asegurar la alta disponibilidad y la tolerancia a fallos.

Por lo tanto, la infra necesaria para la versión 2.0.0 de la app sería:
- 3 servidores donde montar el weblogic.
- 2 servidores donde montar la base de datos PostgresSQL.
- Un F5 para el balanceo de carga.
- Una VIPA para el Postgres.. y configurar en sus servidores un heartbeat para la alta disponibilidad.
- 3 servidores donde montar el cluster de Redis.

Es otra versión de la infra.

En la primera versión de la infra puedo desplegar la v1.0.0 de la app? SI
Y en la segunda versión de la infra puedo desplegar la v1.0.0 de la app? SI... solo que tengo 3 máquinas paradas: Los servidores de REDIS.
En la primera versión de la infra puedo desplegar la v2.0.0 de la app? NO... me faltan los servidores de Redis.
Y en la segunda versión de la infra puedo desplegar la v2.0.0 de la app? SI

Monto la versión 2 de la aplciación... y falla.. y decido que volvemos a la v1.0.0 de la aplicación.. que haría con la infra?
Dejo los cambios que hice en la infra? NO QUERRIA.. es perder pasta!
Tendré que deshacer esos cambios. Tengo controlados los cambios que se hicieron? ESO ES PRECISAMENTE LO QUE ME OFRECE UN CONTROL DE VERSIONES.

La infra estaba en v1.0.0... y luego generé una versión con los 3 servidores de redis.. La versión: 1.1.0

En el mundo del software llevamos muchos años usando lo que se denomina el ESQUEMA SEMANTICO DE VERSIONADO: semver

    vA.B.C

                    Cuándo se incrementan?
    A = Major       Cuando se introduce un breaking change... Un cambio que rompe compatibilidad hacia versiones anteriores.
    B = Minor       Cuando se añade funcionalidad o una funcionalidad se marca como obsoleta (deprecated)
                        Adicionalmente, pueden venir fixes de bugs... pero si solo vienen fixes de bugs, lo que se incrementa es la C (Patch).
    C = Patch       Cuando hay un arreglo de un bug (defecto). Lo que llamamos un fix (arreglo menor)

La versión 2.0.0 de nuestra app puede funcionar en el mismo entorno/infra en el que estaba la versión 1.0.0? NO PUEDO.. no hay espacio para los redis. Eso es una incompatibilidad con versiones anteriores.
La versión nueva de la infra, es compatible con la versión vieja (que no tenía los 3 servidores de Redis)? SI...de hecho ya hemos dicho que el sistema/app v1.0.0 puede correr sobre la nueva versión de la infra.
En la nueva versión de la infra SOLO HEMOS AÑADIDO FUNCIONALDIAD: 3 servidores para redis. 
Por eso esta versión de la infra se considera una versión menor (Minor), ya que añade funcionalidad sin romper compatibilidad con la versión anterior. Y la hemos llamado v1.1.0

Esto es IaC.. tratar la infra como si fuera código. De esta manera, podemos versionarla, controlando cambios y revertir cambios de la misma forma que lo hacemos con el software.

Como no lleve control de evrsiones en la infra... estoy jodido.. como me pidan.. vuelve a la versión anterior... EIN? Que versión...
Si yo solo he ido haciendo cambios a medida que he ido necesitando.. pero no llevo control de ellos.

Este concepto se está extendiendo como la polvoira hoy en día! 
IaC se está convirtiendo en una práctica estándar para gestionar infraestructuras de manera eficiente y controlada.

Partiendo de esto... 
Quiero montar un programa que cree la infraestructura v1.0.0 -> SCRIPT.
Cuándo se va a ejecutar ese programa? Cuando necesite un nuevo entornopara la app.
SOLO? Y me temo que no.
Qué pasa si estoy en v1.1.0 de la infra y necesito devolver esa infra a la v1.0.0? Me serviría ese script?

La respuesta es DEPENDE DE COMO HAYA MONTADO EL SCRIPT:

```
# MODELO 1 DE SCRIPT:
Tarea 1: Crear 3 servidores para Weblogic
Tarea 2: Crear 2 servidores para PostgreSQL
Tarea 3: Definir una VIPA (Virtual IP Address) para el postgresql
Tarea 4: Configurar un F5 Load Balancer para que punte a los servidores de Weblogic
```
Ese script funcionaría cuando no hay nada de infra (DIA 0)? SI
Ese script funcionaría para hacer un downgrade de la v1.1.0 de la infra a la v.1.0.0? NO
Esta borrando los servidores REDIS? Tenemos alguna tarea para ello? NO

Es decir: ESE SCRIPT NO ES IDEMPOTENTE!
Partiendo de estados distintos de la infra no me deja siempre el mismo estado final de la infra!
Es más, ese script, tal y como está escrito, fallaría si lo intento ejecutar sobre la infra ya creada en v1.0.0. y por supuesto sobre la v1.1.0

Tengo la infra en v1.0.0.. y ejecuto de nuevo el script... sabéis que va a pasar? ERROR: ExistCode 127
Cuando vaya a crear los 3 servidores... YA ESTAN CREADOS: ERROR No puedo crear los servidores duplicados.

---

El concepto puede ser menos sofisticado: Tengo 3 weblogics.. la aplciación va tirando.. más usuarios, y quiero 4 weblogics.
Pero dentro de un mes son las vacaciones... y quiero 3 weblogics de nuevo.... Y luego quiero otra vez 4 weblogics...

---

# Dónde esta el problema?

Por supuesto yo podría haber creado un script idempotente:

```
# MODELO 2 DE SCRIPT IDEMPOTENTE:
Tarea 1: SI NO EXISTEN SERVIDORES DE WEBLOGIC:
    Crear 3 servidores para Weblogic 
Tarea 2: SI NO EXISTEN 2 servidores para PostgreSQL :
    Crear 2 servidores para PostgreSQL
Tarea 3: SI NO EXISTE LA VIPA (Virtual IP Address) PARA EL POSTGRESQL:
    Definir una VIPA (Virtual IP Address) para el postgresql
Tarea 4: Si no está configurado el F5 Load Balancer:
    Configurar un F5 Load Balancer para que punte a los servidores de Weblogic
Tarea 5: Si hay cualquier otra cosa en la infra, la crujes!
```

Ese script serviría para instalar la v1.0.0 de la infra desde CERO? SI
Ese script serviría para hacer ewl downgrade de la 1.1.0 a la 1.0.0? SI
PERO EL SCRIPT SE EMPIEZA A HACER COMPLEJO...
Y aparece eso que nos encanta del mundo del desarrollo de software: CONDICIONALES! IF

---

Cuando creamos un programa (Y ES LO QUE VAMOS A AHCER CON ANSIBLE!), usamos un lenguaje.
Y hay varias formas diferentes de usar los lenguajes. Los desarrolladores, que somos unos horteras buscando nombres.. a esas formas de usar u nlenguaje les llamamos PARADIGMAS DE PROGRAMACION...
El concepto es simple.. y lo tenemos en los lenguajes naturales (los que hablamos los seres humanos):

> Felipe, debajo de la ventana pon una silla               IMPERATIVO

En el mundo IT estamos muy acostumbrados al paradigma imperativo... PERO CADA DIA LO ODIAMOS MAS.. es una mierda!
He escrito en la termian antes: mkdir ventana...

mkdir = "Make Directory ventana" . Esa frase en inglés que tipo de frase es? IMPERATIVO (en inglés el imperativo se monta sin Sujeto)
rmdir = "Remove Directory ventana" . Esa frase en inglés que tipo de frase es? IMPERATIVO (en inglés el imperativo se monta sin Sujeto)

El lenguaje imperativo es una mierda... porque es muy complejo hacer programas IDEMPOTENTES usando esta forma de hablar.

> Felipe, si hay algo que no sea una silla debajo de la ventana,    CONDICIONAL
>   QUITALO!                                                        IMPERATIVO
> Felipe, IF Not silla debajo de la ventana                          CONDICIONAL
    >  Felipe, IF SILLA == FALSE (NO HAY SILLAS) Then:
    > GOTO IKEA: 
    >    COMPRA SILLA!                                                 IMPERATIVO
    > Felipe, PON SILLA                                             IMPERATIVO

Todo ese guarreo es el que necesito para montar un script con cierta IDEMPOTENCIA!
Que independientemente de la situación inicial:
- Que haya algo ya debajo de la ventana
- Que no haya sillas disponibles
- Que no haya ya una silla debajo de la ventana
- Que no haya nada debajo de la ventana
Siempre acabe con la misma situación final (ESTADO FINAL):
- Que haya una silla debajo de la ventana

El problema es que el lenguaje imperativo lo que me obliga es a DESCRIBIR A FELIPE EL PROCEDIMIENTO QUE DEBE SERGUIR PARA CONSEGUIR MI OBJETIVO FINAL.

Pero hay oltros paradigmas de programación (otras formas de usar el lenguaje):
> Felipe, debajo de la ventana tiene que haber una silla. Es tu responsabiliad.        ESTO ES IMPERATIVO? NO

Esto es lenguaje DECLARATIVO: Solo digo "cómo deben ser las cosas" sin preocuparme de los pasos que Felipe debe seguir para conseguirlo.
Acabo de pasarle la pelota a FELIPE.
Ya no es mi problema cómo conseguir que haya una silla debajo de la ventana. Eso es ahora problema de FELIPE!

Muchas herramienats en el mundo IT están triunfando y subiendo como la espuma:
- Kubernetes
- Ansible
- Terraform
- Springboot
- Angular

Todas esas herramientas tienen una cosa en común: HABLAN LENGUAJE DECLARATIVO!
En mayor o menor medida.

Terraform es una herramienta 100% DECLARATIVA. Mejor dicho, el lenguaje en el que terraform habla es completamente declarativo.
Kubernetes habla un lenguaje 100% declarativo en sus archivos de manifestación, que es lo que habitualmente usamos para definir el estado deseado de nuestros clústeres.
Ansible... es rarete.
En ansible, dentro de los plays, definimos tareas.
Esas tareas las ejecutan PLUGINS que son los que realmente hacen el trabajo.
El 99% de esos plugins ofrecen un lenguaje DECLARATIVO.
Es decir, para definir los trabajos que necesitan hacerse, en el 99% de los casos vamos a poder usar un lenguaje DECLARATIVO.
AUNQUE la orquestación de todos esos trabajos SE HACE EN LENGUAJE IMPERATIVO.
Es miti-miti el Ansible.

La ventaja de Ansible frente a hacer scripts de la bash es que me ayuda bastante (no al 100%) a crear escripts idempotentes.

Y es que el lenguaje DECLARATIVO, por definición es idempotente.

> Felipe, debajo de la ventana tiene que haber una silla. Es tu responsabiliad.        ESTO ES IMPERATIVO? NO
    ESTO ES UN SCRIPT / ORDEN declarativa.
    Qué pasaría si no hay nada debajo de la ventana y le pido esto a Felipe.. Cómo acaba la cosa? CON UNA SILLA DEBAJO DE LA VENTANA
    Qué pasaría si ya hay una silla debajo de la ventana y le pido esto a Felipe.. Cómo acaba la cosa? CON UNA SILLA DEBAJO DE LA VENTANA
    Y si hubiera un mueble debajo de la ventana? CON UNA SILLA DEBAJO DE LA VENTANA

```
# MODELO DE SCRIPT PARA NUESTRA INFRA v1.0.0 idempotente, usando lenguaje declarativo
1. Asegurate que haya 3 servidores para el weblogic
2. Asegurate que haya 2 servidores para la base de datos
3. Asegurate que haya una VIPA disponible para los postgsql
4. Asegurate que el F5 esté configurado correctamente
5. Asegurate que no haya nada más en la infra.
```

Ese script funcionaría bien el día que empiezo (y la infra esta vacía).? SI
Y funcionaría bien para un downgrade de la 1.1.0 a la 1.0.0? SI

El lenguaje DECLARATIVO nos ayuda a crear scripts IDEMPOTENTES de forma mucho más sencilla.
No me preocupo de los procedimientos. Solo de lo que quiero conseguir.

Y ESTO ES LA CLAVE DE ANSIBLE!

Si entiendo bien este concepto... y uso bien el lenguaje (ESPAÑOL, podré crear scripts idempotentes mucho más fácilmente que usando un lenguaje imperativo)

POR ESO ANSIBLE LO HA PETADO y ha desplazado a las herramienats tradicionales (BASH, PS1, PYTHON) que usaban lenguajes imperativos.

Nuestra primera fase de la formación será aprender a usar ese lenguaje DECLARATIVO QUE OFRECE ANSIBLE APRA CREAR LOS PLAYS.
La segunda fase, será aprender a usar otro lenguaje (de hecho 3) que ofrece ansible para definir INVENTARIOS

Y luego, cuando ya tengamos esto, aprenderemos a cómo ejecutar esos trabajos (PLAYS) sobre los INVENTARIOS que hayamos definido.
Y a como hacerlo con calidad, de manera reproducible y consistente, como se hace hoy en día: EXECUTION ENVIRONMENTS (CONTENEDORES).

---

# Los plays se escriben en YAML

Antes de aprender el lenguaje PROPIO DE ANSIBLE, necesitamos aprender bien YAML...

VER ARCHIVO: plantilla.yaml

## Esquema YAML de ANSIBLE

Un playbook (es el concepto que manejamos en ansible) es un documento YAML que contiene PLAYS.
En ansible un documento es una LISTA ORDENADA de PLAYS.

```yaml
- # Play1

- # Play2
```

Cada play es un MAPA (un conjunto de pares clave-valor) que debe/puede contener las siguientes claves:

```yaml

-   # PLAY N
    name: "Nombre del play"   # Nombre del play
    hosts: "valor"   
            # Esto se usa para LIMITAR el conjunto por defecto de hosts de mi inventario sobre el que se ejecutará este play. Pero esto se puede (Y QUERRE) darlo en tiempo de ejecución.
    gather_facts: false   
            # Esto indica si Ansible debe recopilar información del entorno remoto sobre el que se ejecutarán las tareas. Si voy a instalar un APACHE en un servidor, si quiero traer antes de nada infoprmación de ese servidor:
            # - SO tipo de sistema operativo
            # - Versión del sistema operativo
            # - Arquitectura de microprocesador
            # - Información de red
            # - Información de hardware
            # SIEMPRE A FALSE! NUNCA PONEMOS TRUE: 
            # Por si no queda claro: NUNCA NUNCA PONEMOS TRUE
            # Se ve mucho. ES VAAGANCIA GUARRERA! NO SE HACE. ya lo veremos con calma
    vars:   # ESTO SIRVE PARA DEFINIR CONSTANTES! ES UNA CAGADOTA DE NOMBRE DE ANSIBLE! Ya lo veremos.
            # constante1: valor1
            # constante2: valor2
    pre_tasks:   # Aquí se definen las tareas que se ejecutarán antes de las tareas principales del play.
    tasks:   # Aquí se definen las tareas principales del play.
    post_tasks:   # Aquí se definen las tareas que se ejecutarán después de las tareas principales del play.
    # En cualquiera de esos bloques metemos una lista de tareas:
      - name: "Nombre de la tarea"
        plugin_que_la_ejecute: 
            # Estos valores que pongo dentro, no los declara ANSIBLE. Los declara cada PLUGIN.
            # Hay MILES DE ELLOS. Literalmente MILES!
            # NEcesito estar todo el día enchufado a la documentación de los mismos.
            parametyro_configuración_1_del_plugin: valor1
            parametyro_configuración_2_del_plugin: valor2
        # modificadores adicionales que si define ANSIBLE:
        # when:
        # changed_when:  # Condición para determinar si la tarea se considera cambiada.
        # failed_when:  # Condición para determinar si la tarea se considera fallida.
        # notify:  # Lista de handlers que se deben notificar si la tarea cambia.
        # register:  # Variable en la que se almacenará el resultado de la tarea.
        # delegate_to:  # Especifica un host al que se debe delegar la ejecución de la tarea.
        # run_once:  # Indica si la tarea debe ejecutarse solo una vez, independientemente del número de hosts.
    handlers:   # Que también definirá tareas... pero muy especiales.. con un comportamiento especial.


```

En nuestro caso, tengo preparado un entorno de laboratorio, donde trabajareis.
Tenemos un cluster de kubernetes (6 nodos/máquinas físicas)
Dentro hay instalado un AWX (la interfaz web para gestionar Ansible).
Cada uno tenéis vuestro entorno (namespace propio).
Dentro de esos entornos teneís 2 "maquinas" . Una RHEL (Rocky) + Una Ubuntu.
Cada uno vuestro usuario, con vuestras credenciales.
Cada uno vuestra propia organizacion dentro de AWX, y vuestro inventario.

Todo esto lo tengo montado yo en mi casa!
Y la instalación de todo eso, mediante PLAYBOOKS!