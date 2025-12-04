#!/bin/bash

# Script para limpiar la base de datos de gimnasio (SIN CONFIRMACIÓN)
# Útil para pipelines de testing automáticos

echo "======================================================================"
echo "  Limpiando base de datos..."
echo "======================================================================"

# Ejecutar comandos SQL en PostgreSQL
docker exec -i gym_db_local psql -U postgres -d gimnasio_db << EOF > /dev/null 2>&1
SET session_replication_role = 'replica';
TRUNCATE TABLE series CASCADE;
TRUNCATE TABLE ejercicios_entrenamientos CASCADE;
TRUNCATE TABLE entrenamientos CASCADE;
TRUNCATE TABLE usuarios CASCADE;
TRUNCATE TABLE ejercicios CASCADE;
SET session_replication_role = 'origin';
ALTER SEQUENCE series_id_seq RESTART WITH 1;
ALTER SEQUENCE ejercicios_entrenamientos_id_seq RESTART WITH 1;
ALTER SEQUENCE entrenamientos_id_seq RESTART WITH 1;
ALTER SEQUENCE usuarios_id_seq RESTART WITH 1;
ALTER SEQUENCE ejercicios_id_seq RESTART WITH 1;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Base de datos limpiada correctamente"
else
    echo "❌ Error al limpiar la base de datos"
    exit 1
fi
