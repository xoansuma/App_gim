#!/bin/bash

# Script de prueba para la API de Gimnasio
# Asegúrate de que la API esté corriendo en http://localhost:8080

echo "=== Probando API de Gimnasio ==="
echo ""

# 1. Crear un usuario
echo "1. Creando usuario..."
curl -X POST http://localhost:8080/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@gym.com",
    "nombre": "Juan Pérez",
    "password": "password123"
  }'
echo -e "\n"

# 2. Obtener todos los usuarios
echo "2. Obteniendo todos los usuarios..."
curl -X GET http://localhost:8080/api/usuarios
echo -e "\n"

# 3. Crear ejercicios
echo "3. Creando ejercicios..."
curl -X POST http://localhost:8080/api/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Press Banca",
    "grupoMuscular": "Pecho"
  }'
echo -e "\n"

curl -X POST http://localhost:8080/api/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Sentadilla",
    "grupoMuscular": "Piernas"
  }'
echo -e "\n"

# 4. Obtener todos los ejercicios
echo "4. Obteniendo todos los ejercicios..."
curl -X GET http://localhost:8080/api/ejercicios
echo -e "\n"

# 5. Crear un entrenamiento
echo "5. Creando entrenamiento..."
curl -X POST http://localhost:8080/api/entrenamientos \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Día de Pecho",
    "descripcion": "Entrenamiento enfocado en pecho",
    "usuarioId": 1,
    "fechaRealizacion": "2024-12-04T10:00:00"
  }'
echo -e "\n"

# 6. Agregar ejercicio al entrenamiento
echo "6. Agregando ejercicio al entrenamiento..."
curl -X POST http://localhost:8080/api/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d '{
    "entrenamientoId": 1,
    "ejercicioId": 1,
    "orden": 1,
    "notas": "Calentar bien antes"
  }'
echo -e "\n"

# 7. Agregar series
echo "7. Agregando series..."
curl -X POST http://localhost:8080/api/series \
  -H "Content-Type: application/json" \
  -d '{
    "ejercicioEntrenamientoId": 1,
    "numeroSerie": 1,
    "repeticiones": 12,
    "peso": 60.0
  }'
echo -e "\n"

curl -X POST http://localhost:8080/api/series \
  -H "Content-Type: application/json" \
  -d '{
    "ejercicioEntrenamientoId": 1,
    "numeroSerie": 2,
    "repeticiones": 10,
    "peso": 65.0
  }'
echo -e "\n"

curl -X POST http://localhost:8080/api/series \
  -H "Content-Type: application/json" \
  -d '{
    "ejercicioEntrenamientoId": 1,
    "numeroSerie": 3,
    "repeticiones": 8,
    "peso": 70.0
  }'
echo -e "\n"

# 8. Obtener entrenamiento completo con ejercicios y series
echo "8. Obteniendo entrenamiento completo (ID=1)..."
curl -X GET http://localhost:8080/api/entrenamientos/1
echo -e "\n"

# 9. Obtener entrenamientos del usuario
echo "9. Obteniendo entrenamientos del usuario (ID=1)..."
curl -X GET http://localhost:8080/api/entrenamientos/usuario/1
echo -e "\n"

echo "=== Pruebas completadas ==="
