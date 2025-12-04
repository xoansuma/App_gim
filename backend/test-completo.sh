#!/bin/bash

# Script completo: Limpia la base de datos y ejecuta el test de entrenamiento

echo "======================================================================"
echo "  🧪 TEST COMPLETO - Limpieza + Flujo de Entrenamiento"
echo "======================================================================"
echo ""

# Verificar que Docker esté corriendo
if ! docker ps | grep -q gym_db_local; then
    echo "❌ Error: PostgreSQL no está corriendo"
    echo "Ejecuta: docker compose up -d"
    exit 1
fi

# Verificar que la API esté corriendo
if ! curl -s http://localhost:8080/api/usuarios > /dev/null 2>&1; then
    echo "❌ Error: La API no está corriendo en http://localhost:8080"
    echo "Ejecuta en otra terminal: ./mvnw spring-boot:run"
    exit 1
fi

echo "✅ Docker y API están corriendo"
echo ""

# Limpiar base de datos
echo "🧹 Limpiando base de datos..."
./limpiar-base-datos-auto.sh

if [ $? -ne 0 ]; then
    echo "❌ Error al limpiar la base de datos"
    exit 1
fi

echo ""
echo "🏃 Ejecutando test de flujo de entrenamiento..."
echo ""

# Ejecutar el test
./test-flujo-entrenamiento.sh

echo ""
echo "======================================================================"
echo "  ✅ TEST COMPLETO FINALIZADO"
echo "======================================================================"
