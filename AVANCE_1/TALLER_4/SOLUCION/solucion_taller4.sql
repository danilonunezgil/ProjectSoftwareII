--Ejecute el siguiente codigo:
ALTER TABLE entrega_elementos ADD duracion INTEGER DEFAULT 0;

UPDATE entrega_elementos SET duracion = 30;

ALTER TABLE empleados ADD clave VARCHAR(250) DEFAULT '---';

--Cree un bloque anonimo que visualice los numeros pares del 0 al 100.
DO $$
DECLARE
BEGIN
    FOR numero IN 0..100 LOOP
        IF MOD(numero, 2) = 0 THEN
           RAISE NOTICE 'NUMERO: %',numero;
        END IF;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

--Cree un bloque anonimo que visualice los numeros primos del 0 al 100.
DO $$
DECLARE
    primo BOOLEAN;
BEGIN
    FOR numero IN 0..100 LOOP
        FOR divisor IN 2..numero LOOP
            IF MOD(numero,divisor) = 0 AND numero!=divisor THEN
                primo := FALSE;
                EXIT;
            ELSE 
                primo := TRUE;
            END IF;
        END LOOP;
        IF primo = TRUE THEN
           RAISE NOTICE 'NUMERO: %',numero;
        END IF;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

--Cree un bloque anonimo que solicite dos numeros y permita conocer cual de los dos numeros es mayor o indicar si es el caso si son iguales.
DO $$
DECLARE
 numero1 INTEGER := 7;
 numero2 INTEGER := 6;
BEGIN
    IF numero1 > numero2 THEN
        RAISE NOTICE '% ES MAYOR QUE %',numero1,numero2;
    ELSIF numero1 = numero2 THEN
        RAISE NOTICE '% ES IGUAL QUE %',numero1,numero2;
    ELSE
        RAISE NOTICE '% ES MAYOR QUE %',numero2,numero1;
    END IF;
END;
$$ LANGUAGE PLPGSQL;

--Cree un bloque anonimo que ingrese 1000 registros a la siguiente tabla:
CREATE TABLE tmp_misdatos(
 id INTEGER PRIMARY KEY,
 descripcion VARCHAR(30) NOT NULL
);

DO $$
DECLARE
    primo BOOLEAN;
    descrip VARCHAR(30) := 'El identificador es';
    cantidad INTEGER := 1000;
    contador INTEGER := 1;
    numero INTEGER := 0;
BEGIN
    while contador <=cantidad LOOP
        FOR divisor IN 2..numero LOOP
            IF MOD(numero,divisor) = 0 AND numero!=divisor THEN
                primo := FALSE;
                EXIT;
            ELSE 
                primo := TRUE;
            END IF;
        END LOOP;
        IF primo = TRUE THEN
            INSERT INTO tmp_misdatos(id,descripcion) VALUES (numero,descrip||' '||numero);
            contador := contador+1;
            numero:= numero+1;
        ELSE
            numero := numero+1;
        END IF;
    END LOOP;
	COMMIT;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM tmp_misdatos;

--Cree un bloque anonimo que actualice la fecha de devolucion de la tabla ENTREGA_ELEMENTOS, donde la duracion (dias) de cada elemento esta en el campo duracion.
DO $$
BEGIN
    UPDATE entrega_elementos SET fecha_devolucion=fecha+duracion;
	COMMIT;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM entrega_elementos;

--Cree un procedimiento para el punto 1 con el nombre de: pares.
CREATE OR REPLACE PROCEDURE pares()
AS $$
BEGIN
	FOR numero IN 0..100 LOOP
		IF MOD(numero, 2) = 0 THEN
			RAISE NOTICE 'NUMERO: %',numero;
		END IF;
	END LOOP;
END;
$$ LANGUAGE PLPGSQL;
CALL pares();

--Cree un procedimiento para el punto 2 con el nombre de: primos.
CREATE OR REPLACE PROCEDURE primos()
AS $$
DECLARE
    primo BOOLEAN;
BEGIN
    FOR numero IN 0..100 LOOP
        FOR divisor IN 2..numero LOOP
            IF MOD(numero,divisor) = 0 AND numero!=divisor THEN
                primo := FALSE;
                EXIT;
            ELSE 
                primo := TRUE;
            END IF;
        END LOOP;
        IF primo = TRUE THEN
            RAISE NOTICE 'NUMERO: %',numero;
        END IF;
    END LOOP;  
END;
$$ LANGUAGE PLPGSQL;
CALL primos();

--Cree un procedimiento para el punto 3 con el nombre de: comparar_numeros, este procedimiento debe recibir por par�metros los dos n�meros a comparar.
CREATE OR REPLACE PROCEDURE comparar_numeros(val OUT VARCHAR,numero1 IN INTEGER, numero2 IN INTEGER)
AS $$
BEGIN
    IF numero1 > numero2 THEN
    	val := CONCAT(numero1,' ES MAYOR QUE ',numero2);
	ELSIF numero1 = numero2 THEN
        val := CONCAT(numero1,' ES IGUAL QUE ',numero2);
    ELSE
        val := CONCAT(numero2,' ES MAYOR QUE ',numero1);
    END IF;
END;
$$ LANGUAGE plpgsql;
CALL comparar_numeros(null,4,2);

--Cree un procedimiento para actualizar la columna email de la tabla empleados con la nueva direccion de correo asignada por la empresa.
CREATE OR REPLACE FUNCTION buscar_email_repetido(correo empleados.email%TYPE,id empleados.identificacion%TYPE) 
RETURNS BOOLEAN AS $$
DECLARE
    contador INTEGER := 0;
BEGIN
    SELECT COUNT(emp.email) INTO contador FROM empleados AS emp WHERE emp.email = correo AND emp.identificacion != id;
    IF contador > 0 THEN
        return true;
    ELSE 
        return false;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE actualizar_correos()
AS $$
DECLARE
    cur_empleados CURSOR FOR SELECT nombre_1, nombre_2, apellido_1, apellido_2, identificacion FROM empleados;
    correo_nuevo empleados.email%TYPE;
    clave_nueva empleados.clave%TYPE;
    dominio VARCHAR(17) := '@UNILLANOS.EDU.CO';
    contador INTEGER;
BEGIN
    -- Creamos un cursor para recorrer la tabla de empleados
    FOR empleado IN cur_empleados LOOP
        -- Generamos la nueva direccion de correo
        correo_nuevo := CONCAT(SUBSTR(empleado.nombre_1,1,1),empleado.apellido_1,empleado.apellido_2,dominio);
        -- Generamos la clave del correo
        clave_nueva := CONCAT(SUBSTR(empleado.nombre_1,1,1),SUBSTR(empleado.nombre_2,1,1),empleado.identificacion);
        --Validamos que no se repita la direccion de correo
        WHILE buscar_email_repetido(correo_nuevo,empleado.identificacion) = true LOOP
            contador := 1;
            correo_nuevo := CONCAT(SUBSTR(empleado.nombre_1,1,1),empleado.apellido_1,empleado.apellido_2,contador,dominio);
            contador := contador + 1;
        END LOOP;
        -- Actualizamos la direccion de correo y la clave del correo en la tabla de empleados
        UPDATE empleados SET email = correo_nuevo, clave = clave_nueva WHERE identificacion = empleado.identificacion;
    	COMMIT;
	END LOOP;
	
END;
$$ LANGUAGE plpgsql;

CALL actualizar_correos();

SELECT identificacion,CONCAT_WS(' ',nombre_1,nombre_2,apellido_1,apellido_2)AS nombre_completo
,email,clave FROM empleados ORDER BY identificacion;

--Cree una funcion para conocer el precio promedio de un elemento de proteccion, la funcion debe recibir como parametro el codigo del elemento.
CREATE OR REPLACE FUNCTION precio_promedio_elemento(cod_elemento detalle_entrada.elemento%TYPE)
RETURNS detalle_entrada.v_unitario%TYPE AS $$
DECLARE
	precio_promedio detalle_entrada.v_unitario%TYPE;
BEGIN
    SELECT AVG(det.v_unitario) INTO precio_promedio FROM detalle_entrada AS det WHERE det.elemento = cod_elemento;
    RETURN precio_promedio;
END;
$$ LANGUAGE plpgsql;

SELECT precio_promedio_elemento(100);

--Cree una funcion que determine si un trabajador actualmente se le han entregado todos los elementos de proteccion que le fueron asignados, la funcion debe retornar un valor entero(1 o 0). 
CREATE OR REPLACE FUNCTION entregas_trabajador(id_empleado empleados.identificacion%TYPE)
RETURNS INTEGER AS $$
DECLARE
	contador INTEGER;
BEGIN
    SELECT COUNT(ea.empleado) INTO contador FROM elementos_asignados AS ea LEFT JOIN entrega_elementos AS ee ON ea.elemento = ee.elemento WHERE ee.id_entrega IS NULL AND ea.empleado = id_empleado;
    IF contador >= 1 THEN
       	RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

--Mostrara 0 si aun tiene entregas pendientes y 1 si ya se le entrego todo.
SELECT entregas_trabajador(827209090);

--Realizar una consulta que muestre: la identificacion, el nombre del empleado, el cargo y una columna que indique si le entregaron (S/N) los elementos de proteccion. 
SELECT emp.identificacion, CONCAT_WS(' ',emp.nombre_1,emp.nombre_2,emp.apellido_1,emp.apellido_2) AS nombre_empleado,
c.cargo,
CASE 
	WHEN entregas_trabajador(emp.identificacion) = 1 
		THEN 'SI'
	ELSE 'NO'
END AS entrega_elementos
FROM empleados AS emp
INNER JOIN historial_laboral AS hl ON emp.identificacion = hl.empleado
INNER JOIN cargos AS c ON hl.cargo = c.cod_cargo;

/*Cree una funcion para conocer si un estudiante esta matriculado actualmente, se entiende por
matriculado que el estudiante por lo menos halla inscrito una materia en un periodo y año determinado.
La funcion debe recibir como parametro el codigo del estudiante, periodo y año, debe retornar un valor
booleano.*/
CREATE OR REPLACE FUNCTION estudiante_matriculado(cod_est inscripciones.estudiante%TYPE, periodo_ins inscripciones.periodo%TYPE, ano_ins INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
	est_matriculado INTEGER;
BEGIN    
    SELECT COUNT(*) INTO est_matriculado FROM inscripciones WHERE estudiante = cod_est AND periodo = periodo_ins AND ano = ano_ins;

    IF est_matriculado >= 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT estudiante_matriculado(1,1,2008);

--Cree una funcion que devuelva el año de la fecha que tienen el servidor de Oracle. La funcion no recibe parametros, pero devuelve un valor numerico.
CREATE OR REPLACE FUNCTION year_servidor()
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(year FROM NOW());
END;
$$ LANGUAGE plpgsql;
SELECT year_servidor();

/*Cree una funcion que determine el semestre del año en que se encuentra actualmente, tener
como base la fecha del servidor de Oracle. La funcion no recibe parametros, pero devuelve un valor
numerico.*/
CREATE OR REPLACE FUNCTION semestre_servidor()
RETURNS INTEGER AS $$
BEGIN
    IF EXTRACT(MONTH FROM NOW()) <=6 THEN
        RETURN 1;
    ELSE 
        RETURN 2;
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT semestre_servidor();

/*Cree una funcion para conocer el promedio de carrera de un estudiante, solo tener en cuenta
las materias aprobadas, la funcion debe recibir como parametro el codigo del estudiante. */
CREATE OR REPLACE FUNCTION promedio_carrera(cod_est inscripciones.estudiante%TYPE)
RETURNS inscripciones.nota%TYPE AS $$
DECLARE
	promedio inscripciones.nota%TYPE;
BEGIN
    SELECT AVG(ins.nota) INTO promedio FROM inscripciones AS ins WHERE ins.estudiante = cod_est AND ins.nota >=3;
    RETURN promedio;
END;
$$ LANGUAGE plpgsql;

--Cree un procedimiento que muestre en pantalla la siguiente informaci�n de un estudiante:
CREATE TABLE tmp_estudiantes(
    codigo INTEGER NOT NULL,
    facultad VARCHAR(50) NOT NULL,
    programa VARCHAR(50) NOT NULL,
    estudiante VARCHAR(200) NOT NULL,
    promedio NUMERIC(5,3) NOT NULL,
    matriculado VARCHAR(1) NOT NULL,
    ano INTEGER NOT NULL,
    periodo INTEGER NOT NULL
);

CREATE OR REPLACE PROCEDURE informacion_estudiantes()
AS $$
DECLARE
    cur_estudiantes CURSOR FOR
    SELECT est.codigo AS codigo_estudiante, fac.nombre AS facultad, pr.nombre AS programa,
    CONCAT_WS(' ',est.nombres,est.apellido1,est.apellido2) AS nombre_completo FROM estudiante AS est
    INNER JOIN programa AS pr ON est.facultad = pr.facultad AND est.programa = pr.id_programa
    INNER JOIN facultad AS fac ON est.facultad = fac.id_facultad;
   
    prom_est tmp_estudiantes.promedio%TYPE;
    est_matriculado VARCHAR(1);
    ano_actual INTEGER;
    periodo_actual INTEGER;
BEGIN 
    DELETE FROM tmp_estudiantes;
    ano_actual := year_servidor();
    periodo_actual := semestre_servidor();
    RAISE NOTICE 'informacion academica de los estudiantes';
    FOR v_estudiante IN cur_estudiantes LOOP
        prom_est := promedio_carrera(v_estudiante.codigo_estudiante);
        IF estudiante_matriculado(v_estudiante.codigo_estudiante,periodo_actual,ano_actual) = TRUE THEN
            est_matriculado := 'S';
        ELSE
            est_matriculado := 'N';
        END IF;
        IF prom_est >=3.8 THEN
            RAISE NOTICE 'CODIGO---> %',v_estudiante.codigo_estudiante;
            RAISE NOTICE 'FACULTAD---> %',v_estudiante.facultad;
            RAISE NOTICE 'PROGRAMA---> %',v_estudiante.programa;
            RAISE NOTICE 'NOMBRES Y APELLIDOS---> %',v_estudiante.nombre_completo;
            RAISE NOTICE 'PROMEDIO DE CARRERA---> %',prom_est;
            RAISE NOTICE 'MATRICULADO---> %',est_matriculado;
            RAISE NOTICE 'AÑO ACTUAL---> %',ano_actual;
            RAISE NOTICE 'PERIODO ACTUAL---> %',periodo_actual;
            INSERT INTO tmp_estudiantes(codigo,facultad,programa,estudiante,promedio,matriculado,ano,periodo)
            VALUES(v_estudiante.codigo_estudiante,v_estudiante.facultad,v_estudiante.programa,v_estudiante.nombre_completo
            ,prom_est,est_matriculado,ano_actual,periodo_actual);
        END IF;
    END LOOP;
    COMMIT;
END;
$$ LANGUAGE plpgsql;
CALL informacion_estudiantes();
SELECT * FROM tmp_estudiantes;

/*Cree una funcion que retorne el numero de estudiantes inscritos por materia, la funcion debe
recibir como parametros el codigo de la materia, el codigo del programa, codigo de facultad, el año y
periodo.*/
CREATE OR REPLACE FUNCTION est_inscritos_materia(cod_mat materias.id_materia%TYPE, cod_pro programa.id_programa%TYPE, cod_fac facultad.id_facultad%TYPE, ano_ins inscripciones.ano%TYPE, periodo_ins inscripciones.periodo%TYPE)
RETURNS INTEGER AS $$ 
DECLARE
	cantidad INTEGER;
BEGIN 
    SELECT COUNT(*) INTO cantidad FROM inscripciones AS ins WHERE ins.materia = cod_mat AND 
    ins.programa = cod_pro AND ins.facultad = cod_fac AND ins.ano = ano_ins AND ins.periodo = periodo_ins;
    RETURN cantidad;
END;
$$ LANGUAGE plpgsql;

SELECT est_inscritos_materia(2,1,1,2008,1);


/*Cree un dato compuesto de tipo tabla, que almacene la informacion del punto 18 (Solo la primera parte), con base en esta informacion debe mostrar:
1.	El indice de la tabla y los datos.
2.	Total de datos de la tabla.
3.	Validar si la clave 10 existe, y si existe debe mostrar la informacion que contiene, si no, debe indicar que no existe.
4.	Mostrar la informacion de la primera y la ultima clave.
5.	Eliminar los indices de la tabla comprendidos entre 1 y 5, utilice la funcion delete (m, n).*/
----------------------------------------
CREATE TYPE inscripciones_tabla AS (
    indice BIGINT,
    materia VARCHAR(255),
    cantidad INTEGER
);

CREATE OR REPLACE PROCEDURE informacion_18()
AS $$
DECLARE
    inscritos_tabla inscripciones_tabla[];
	rm_inscritos_tabla inscripciones_tabla[];
	pos INTEGER := 0;
    cur_inscripciones CURSOR FOR
    SELECT row_number() OVER() AS indice, t.materia, t.cantidad FROM(SELECT nombre as materia, COUNT(id_materia) as cantidad FROM inscripciones ins
 	INNER JOIN materias ON ins.materia = materias.id_materia
 	group by nombre) AS t;
	
BEGIN
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE '1. EL INDICE DE LA TABLA Y LOS DATOS:';
	FOR v_inscritos IN cur_inscripciones LOOP
		RAISE NOTICE '----------------------------------------------------';
		inscritos_tabla[v_inscritos.indice]:= v_inscritos;
    	RAISE NOTICE 'INDICE: %',inscritos_tabla[v_inscritos.indice].indice;
		RAISE NOTICE 'MATERIA: %',inscritos_tabla[v_inscritos.indice].materia;
		RAISE NOTICE 'CANTIDAD: %',inscritos_tabla[v_inscritos.indice].cantidad;
	END LOOP;
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE '2. TOTAL DE DATOS DE LA TABLA.';
	RAISE NOTICE '----------------------------------------------------';
		RAISE NOTICE 'TOTAL DE DATOS: %',ARRAY_LENGTH(inscritos_tabla,1);
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE '3. VALIDAR SI LA CLAVE 10 EXISTE, Y SI EXISTE DEBE MOSTRAR LA INFORMACION QUE CONTIENE, SI NO, DEBE INDICAR QUE NO EXISTE.';
	IF inscritos_tabla[10] IS NOT NULL THEN
		RAISE NOTICE '----------------------------------------------------';
		RAISE NOTICE 'INDICE: %',inscritos_tabla[10].indice;
		RAISE NOTICE 'MATERIA: %',inscritos_tabla[10].materia;
		RAISE NOTICE 'CANTIDAD: %',inscritos_tabla[10].cantidad;
	ELSE 
		RAISE NOTICE '----------------------------------------------------';
		RAISE NOTICE 'LA CLAVE 10 NO EXISTE';
	END IF;
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE '4. MOSTRAR LA INFORMACION DE LA PRIMERA Y LA ULTIMA CLAVE';
	RAISE NOTICE '----------------------------------------------------';
	RAISE NOTICE 'PRIMER INDICE: %',inscritos_tabla[ARRAY_LOWER(inscritos_tabla,1)].indice;
	RAISE NOTICE 'MATERIA: %',inscritos_tabla[ARRAY_LOWER(inscritos_tabla,1)].materia;
	RAISE NOTICE 'CANTIDAD: %',inscritos_tabla[ARRAY_LOWER(inscritos_tabla,1)].cantidad;
	RAISE NOTICE '----------------------------------------------------';
	RAISE NOTICE 'ULTIMO INDICE: %',inscritos_tabla[ARRAY_UPPER(inscritos_tabla,1)].indice;
	RAISE NOTICE 'MATERIA: %',inscritos_tabla[ARRAY_UPPER(inscritos_tabla,1)].materia;
	RAISE NOTICE 'CANTIDAD: %',inscritos_tabla[ARRAY_UPPER(inscritos_tabla,1)].cantidad;
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE '5. ELIMINAR LOS INDICES DE LA TABLA COMPRENDIDOS ENTRE 1 Y 5, UTILICE LA FUNCION DELETE(M,N)';
	RAISE NOTICE '----------------------------------------------------';
	FOR i IN 1..ARRAY_LENGTH(inscritos_tabla, 1) LOOP
		IF i > 5 THEN 
			pos := pos+1;
			rm_inscritos_tabla[pos] := inscritos_tabla[i];
		END IF;
	END LOOP;
	RAISE NOTICE 'ELIMINADOS';
	RAISE NOTICE '/////////////////////////////////////////////////////';
	RAISE NOTICE 'DATOS ACTUALES';
	RAISE NOTICE '----------------------------------------------------';
	inscritos_tabla := rm_inscritos_tabla;
	FOR i in 1..ARRAY_LENGTH(inscritos_tabla,1) LOOP
		RAISE NOTICE 'INDICE: %',inscritos_tabla[i].indice;
		RAISE NOTICE 'MATERIA: %',inscritos_tabla[i].materia;
		RAISE NOTICE 'CANTIDAD: %',inscritos_tabla[i].cantidad;
		RAISE NOTICE '----------------------------------------------------';
	END LOOP;
END;
$$ LANGUAGE plpgsql;
CALL informacion_18();







