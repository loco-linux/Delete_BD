-- Script para eliminar TODOS los datos de una base de datos, para comenzar desde cero.


BEGIN
    -- Eliminar todas las tablas
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;

    -- Eliminar todas las vistas
    FOR v IN (SELECT view_name FROM user_views) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v.view_name;
    END LOOP;

    -- Eliminar todas las secuencias
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;

    -- Eliminar todos los procedimientos
    FOR p IN (SELECT object_name FROM user_procedures WHERE object_type = 'PROCEDURE') LOOP
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || p.object_name;
    END LOOP;

    -- Eliminar todas las funciones
    FOR f IN (SELECT object_name FROM user_procedures WHERE object_type = 'FUNCTION') LOOP
        EXECUTE IMMEDIATE 'DROP FUNCTION ' || f.object_name;
    END LOOP;

    -- Eliminar todos los paquetes
    FOR pkg IN (SELECT object_name FROM user_objects WHERE object_type = 'PACKAGE') LOOP
        EXECUTE IMMEDIATE 'DROP PACKAGE ' || pkg.object_name;
    END LOOP;

    -- Eliminar todos los índices
    FOR idx IN (SELECT index_name FROM user_indexes WHERE index_type NOT LIKE 'LOB%') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || idx.index_name;
    END LOOP;

    -- Eliminar todos los sinónimos
    FOR syn IN (SELECT synonym_name FROM user_synonyms) LOOP
        EXECUTE IMMEDIATE 'DROP SYNONYM ' || syn.synonym_name;
    END LOOP;

    -- Eliminar todos los usuarios excepto administradores
    FOR u IN (SELECT username FROM all_users WHERE username NOT IN ('SYS', 'SYSTEM', 'ADMIN')) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP USER ' || u.username || ' CASCADE';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('No se pudo eliminar el usuario: ' || u.username || ' - ' || SQLERRM);
        END;
    END LOOP;
END;
/
