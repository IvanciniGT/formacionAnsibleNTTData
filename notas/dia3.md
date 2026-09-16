
# JINJA

Es una librería de python para plantillas de texto, que permite generar contenido dinámico a partir de datos y estructuras de control.
Se usa en muchas herramientas, no es algo propio de Ansible.

En jinja, hay varias formas en las que podemos crear una plantilla.
Vamos primero a lo más básico que vamos a usar en Ansible.

## Expresiones JINJA

Una expresión jinja es un trozo de código que se escribe entre {{ trozo-de-codigo }} y que devuelve un valor.
El valor puede ser un texto, puede ser un número, puede ser un booleano, incluso una lista o un mapa.

Por ejemplo:
```jinja
{{ 1 + 2 }}          # Devuelve 3
{{ "Hola " + "Mundo" }}  # Devuelve "Hola Mundo"
{{ true }}           # Devuelve True
{{ [1, 2, 3] }}      # Devuelve la lista [1, 2, 3]
{{ {"clave": "valor"} }}  # Devuelve el mapa {"clave": "valor"}
```

En ansible, dentro de las expresiones puedo hacer uso de datos externos, suministrador/gestionados por ansible:
- variables que tengo definidas en:
  - Playbook
  - Inventory
  - A nivel de un tarea concreta

La sintaxis es simple.. Para acceder a un dato, pongo el nombre de la variable.

Eso si, si la variable es un MAPA, para acceder a un valor dentro del mapa tengo 2 sintaxis:
- Usando la notación de punto: `{{ mapa.clave }}`
- Usando la notación de corchetes: `{{ mapa["clave"] }}`

Si lo que tuviera fuese una lista, para acceder a un elemento dentro de la lista uso la notación de corchetes con el índice del elemento:
- Usando la notación de corchetes: `{{ lista[0] }}`  # Accede al primer elemento de la lista
- Usando la notación de corchetes: `{{ lista[1] }}`  # Accede al segundo elemento de la lista
- El último elemento de la lista se puede acceder usando el índice -1: `{{ lista[-1] }}`  # Accede al último elemento de la lista
- El penúltimo elemento de la lista se puede acceder usando el índice -2: `{{ lista[-2] }}`  # Accede al penúltimo elemento de la lista

Además de acceder a datos, puedo operar sobre ellos.

Para operar sobre datos tengo:
- Operadores

    Los hay de distintos tipos:
    > Matemáticos: +, -, *, /
    > Comparación: ==, !=, >, <, >=, <=
    > Pertenencia: in, not in
        lista_colores: ["rojo", "verde", "azul"]
        color: "rojo"
        {{ color in lista_colores }}  # Devuelve True si color está en lista_colores, False en caso contrario
    > Hay un operador que usamos bastante en ansible: "is"
      Detrás de ese operador puedo poner muchas cosas:
        - `is defined`: Devuelve True si la variable está definida.
        - `is undefined`: Devuelve True si la variable no está definida.
        - `is string`: Devuelve True si la variable es una cadena.
        - `is number`: Devuelve True si la variable es un número.
          Estos de abajo solo si la variable es una tarea (USO EL NOMBRE DEFINIDO EN LA PROPIEDAD register) 
        - `is success`: Devuelve True si la tarea anterior fue exitosa.
        - `is failed`: Devuelve True si la tarea anterior falló.
        - `is changed`: Devuelve True si la tarea anterior realizó algún cambio.
        - `is skipped`: Devuelve True si la tarea anterior fue omitida.

- Funciones (En jinja hay una sintaxis muy especial para las funciones, se llaman filtros y se aplican usando el símbolo `|`)
  Por defecto (vienen de serie) Jinja trae más de 50 filtros predefinidos. Ansible añade otros 50 más.
  Los vamos aprendiendo con el tiempo.

    {{ nombre | default("Desconocido") }}
    {{ nombre | upper }}
    {{ nombre | lower }}
    {{ nombre | length }}
    {{ nombre | replace("a", "o") }}  # Reemplaza todas las ocurrencias de "a" por "o" en el valor de nombre
    {{ nombre | trim }}  # Elimina los espacios en blanco al inicio y al final del valor de nombre
    ....

  Puedo aplica varias en serie:
    
    {{ nombre | trim | upper }}  # Aplica primero trim y luego upper al valor de nombre


Una cosa adicional: Puedo juntar varias de estas expresiones al rellenar un valor en ansible:

    - name:  TAREA QUE HACE ALGO
      ansible.builtin.debug:
        msg: "El resultado de la tarea {{ ansible_task_name }} ha dicho: {{ nombre | default('Desconocido') | upper }}"

Hay un operador adicional que usamos bastante: Operador ternario, y es básicamente un condicional en una sola línea.

    {{ valor-si-true if expresión-booleana else valor_si-false }}

    {{ "Es mayor que 10" if numero > 10 else "No es mayor que 10" }}

    La sintaxis es rara.. estamos más acostumbrados a sintaxis del tipo:

        if expresión-booleana 
            valor-si-true
        else
            valor-si-false
            


---

A lo tonto... ya hemos aprendido un huevo de módulos de ansible:
- yum_repository
- dnf
- set_fact
- meta
- include_tasks


Eso sí, ansible tiene MILES de módulos. Los vamos aaprendiendo sobre la marcha... según los usamos / necesitamos.
Las IAs nos ayudan mucho a buscar módulos. Antes nos tocaba bucear por la documentación oficial de Ansible para encontrar el módulo adecuado.

No es objetivo del curso el aprender TODOS LOS MODULOS DE ANSIBLE. Nos llevamos un año y no hemos acabado.

En el curso veremos los 30-40 módulos más usados, en especial para administrar entornos RHEL.
Eso si... para RHEL hay CIENTOS de modulos. Ni siquiera en el curso podemos ver todos los módulos disponibles.