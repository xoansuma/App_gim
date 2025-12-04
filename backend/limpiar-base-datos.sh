#!/bin/bash

# Script para limpiar la base de datos de gimnasio
# ADVERTENCIA: Este script eliminará TODOS los datos

echo "======================================================================"
echo "  ⚠️  LIMPIEZA DE BASE DE DATOS - GIMNASIO"
echo "======================================================================"
echo ""
echo "Este script eliminará TODOS los datos de las siguientes tablas:"
echo "  - series"
echo "  - ejercicios_entrenamientos"
echo "  - entrenamientos"
echo "  - usuarios"
echo "  - ejercicios"
echo ""
echo -n "¿Estás seguro de que quieres continuar? (escribe 'SI' para confirmar): "
read CONFIRMACION

if [ "$CONFIRMACION" != "SI" ]; then
    echo "Operación cancelada."
    exit 0
fi

echo ""
echo "Limpiando base de datos..."

# Ejecutar comandos SQL en PostgreSQL
docker exec -i gym_db_local psql -U postgres -d gimnasio_db << EOF
-- Deshabilitar temporalmente las restricciones de claves foráneas
SET session_replication_role = 'replica';

-- Limpiar todas las tablas en el orden correcto (de más específico a más general)
TRUNCATE TABLE series CASCADE;
TRUNCATE TABLE ejercicios_entrenamientos CASCADE;
TRUNCATE TABLE entrenamientos CASCADE;
TRUNCATE TABLE usuarios CASCADE;
TRUNCATE TABLE ejercicios CASCADE;

-- Re-habilitar las restricciones de claves foráneas
SET session_replication_role = 'origin';

-- Resetear las secuencias (auto-increment) para que empiecen desde 1
ALTER SEQUENCE series_id_seq RESTART WITH 1;
ALTER SEQUENCE ejercicios_entrenamientos_id_seq RESTART WITH 1;
ALTER SEQUENCE entrenamientos_id_seq RESTART WITH 1;
ALTER SEQUENCE usuarios_id_seq RESTART WITH 1;
ALTER SEQUENCE ejercicios_id_seq RESTART WITH 1;

-- Mostrar resumen
SELECT 'series' as tabla, COUNT(*) as registros FROM series
UNION ALL
SELECT 'ejercicios_entrenamientos', COUNT(*) FROM ejercicios_entrenamientos
UNION ALL
SELECT 'entrenamientos', COUNT(*) FROM entrenamientos
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'ejercicios', COUNT(*) FROM ejercicios;
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================================================"
    echo "  ✅ Base de datos limpiada correctamente"
    echo "======================================================================"
    echo ""
    echo "Todas las tablas están vacías y las secuencias reseteadas."
    echo "Los próximos IDs empezarán desde 1."
else
    echo ""
    echo "======================================================================"
    echo "  ❌ Error al limpiar la base de datos"
    echo "======================================================================"
    exit 1
fi
