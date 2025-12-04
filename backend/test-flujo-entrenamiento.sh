#!/bin/bash

# Script para probar el flujo completo de un entrenamiento de pecho
# Este script simula cómo usarías la API desde tu app móvil

echo "======================================================================"
echo "  FLUJO COMPLETO: Entrenamiento de Pecho con Series en Tiempo Real"
echo "======================================================================"
echo ""

BASE_URL="http://localhost:8080/api"

# Colores para mejor visualización
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}PASO 1: Crear usuario${NC}"
echo "----------------------------------------------------------------------"
# Generar email único con timestamp
TIMESTAMP=$(date +%s)
EMAIL="usuario_${TIMESTAMP}@gym.com"
echo "Creando usuario con email: $EMAIL"

USER_RESPONSE=$(curl -s -X POST $BASE_URL/usuarios \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"nombre\": \"Usuario Test\",
    \"password\": \"password123\"
  }")
echo "$USER_RESPONSE" | jq '.'
USER_ID=$(echo "$USER_RESPONSE" | jq -r '.id')
echo -e "${GREEN}✓ Usuario creado con ID: $USER_ID${NC}"
echo ""
sleep 1

echo -e "${BLUE}PASO 2: Crear ejercicios de pecho${NC}"
echo "----------------------------------------------------------------------"

echo "Creando Press Banca..."
EJERCICIO1=$(curl -s -X POST $BASE_URL/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Press Banca",
    "grupoMuscular": "Pecho"
  }')
EJERCICIO1_ID=$(echo "$EJERCICIO1" | jq -r '.id')
echo "$EJERCICIO1" | jq '.'
echo -e "${GREEN}✓ Press Banca creado con ID: $EJERCICIO1_ID${NC}"
echo ""

echo "Creando Press Inclinado..."
EJERCICIO2=$(curl -s -X POST $BASE_URL/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Press Inclinado con Mancuernas",
    "grupoMuscular": "Pecho Superior"
  }')
EJERCICIO2_ID=$(echo "$EJERCICIO2" | jq -r '.id')
echo "$EJERCICIO2" | jq '.'
echo -e "${GREEN}✓ Press Inclinado creado con ID: $EJERCICIO2_ID${NC}"
echo ""

echo "Creando Aperturas..."
EJERCICIO3=$(curl -s -X POST $BASE_URL/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Aperturas con Mancuernas",
    "grupoMuscular": "Pecho"
  }')
EJERCICIO3_ID=$(echo "$EJERCICIO3" | jq -r '.id')
echo "$EJERCICIO3" | jq '.'
echo -e "${GREEN}✓ Aperturas creadas con ID: $EJERCICIO3_ID${NC}"
echo ""

echo "Creando Fondos..."
EJERCICIO4=$(curl -s -X POST $BASE_URL/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Fondos en Paralelas",
    "grupoMuscular": "Pecho Inferior"
  }')
EJERCICIO4_ID=$(echo "$EJERCICIO4" | jq -r '.id')
echo "$EJERCICIO4" | jq '.'
echo -e "${GREEN}✓ Fondos creados con ID: $EJERCICIO4_ID${NC}"
echo ""
sleep 1

echo -e "${BLUE}PASO 3: Crear entrenamiento 'Día de Pecho'${NC}"
echo "----------------------------------------------------------------------"
FECHA=$(date +"%Y-%m-%dT%H:%M:%S")
ENTRENAMIENTO=$(curl -s -X POST $BASE_URL/entrenamientos \
  -H "Content-Type: application/json" \
  -d "{
    \"nombre\": \"Día de Pecho\",
    \"descripcion\": \"Rutina completa de pecho - 4 ejercicios\",
    \"usuarioId\": $USER_ID,
    \"fechaRealizacion\": \"$FECHA\"
  }")
echo "$ENTRENAMIENTO" | jq '.'
ENTRENAMIENTO_ID=$(echo "$ENTRENAMIENTO" | jq -r '.id')
echo -e "${GREEN}✓ Entrenamiento creado con ID: $ENTRENAMIENTO_ID${NC}"
echo ""
sleep 1

echo -e "${BLUE}PASO 4: Agregar ejercicios predefinidos al entrenamiento${NC}"
echo "----------------------------------------------------------------------"

echo "Agregando Press Banca (ejercicio 1)..."
EJ_ENT_1=$(curl -s -X POST $BASE_URL/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d "{
    \"entrenamientoId\": $ENTRENAMIENTO_ID,
    \"ejercicioId\": $EJERCICIO1_ID,
    \"orden\": 1,
    \"notas\": \"Calentar bien antes, ejercicio principal\"
  }")
EJ_ENT_1_ID=$(echo "$EJ_ENT_1" | jq -r '.id')
echo -e "${GREEN}✓ Press Banca agregado - EjercicioEntrenamientoId: $EJ_ENT_1_ID${NC}"
echo ""

echo "Agregando Press Inclinado (ejercicio 2)..."
EJ_ENT_2=$(curl -s -X POST $BASE_URL/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d "{
    \"entrenamientoId\": $ENTRENAMIENTO_ID,
    \"ejercicioId\": $EJERCICIO2_ID,
    \"orden\": 2,
    \"notas\": \"Trabajar pecho superior\"
  }")
EJ_ENT_2_ID=$(echo "$EJ_ENT_2" | jq -r '.id')
echo -e "${GREEN}✓ Press Inclinado agregado - EjercicioEntrenamientoId: $EJ_ENT_2_ID${NC}"
echo ""

echo "Agregando Aperturas (ejercicio 3)..."
EJ_ENT_3=$(curl -s -X POST $BASE_URL/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d "{
    \"entrenamientoId\": $ENTRENAMIENTO_ID,
    \"ejercicioId\": $EJERCICIO3_ID,
    \"orden\": 3,
    \"notas\": \"Estirar bien el pecho\"
  }")
EJ_ENT_3_ID=$(echo "$EJ_ENT_3" | jq -r '.id')
echo -e "${GREEN}✓ Aperturas agregadas - EjercicioEntrenamientoId: $EJ_ENT_3_ID${NC}"
echo ""

echo "Agregando Fondos (ejercicio 4)..."
EJ_ENT_4=$(curl -s -X POST $BASE_URL/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d "{
    \"entrenamientoId\": $ENTRENAMIENTO_ID,
    \"ejercicioId\": $EJERCICIO4_ID,
    \"orden\": 4,
    \"notas\": \"Ejercicio de finalización\"
  }")
EJ_ENT_4_ID=$(echo "$EJ_ENT_4" | jq -r '.id')
echo -e "${GREEN}✓ Fondos agregados - EjercicioEntrenamientoId: $EJ_ENT_4_ID${NC}"
echo ""
sleep 1

echo -e "${YELLOW}======================================================================"
echo "  AHORA EMPEZAMOS EL ENTRENAMIENTO - Añadiendo series en tiempo real"
echo "======================================================================${NC}"
echo ""
sleep 2

echo -e "${BLUE}📋 EJERCICIO 1: Press Banca${NC}"
echo "----------------------------------------------------------------------"
echo "Haciendo serie 1..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_1_ID,
    \"numeroSerie\": 1,
    \"repeticiones\": 12,
    \"peso\": 60.0,
    \"notas\": \"Calentamiento\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 1 completada: 12 reps x 60kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 2..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_1_ID,
    \"numeroSerie\": 2,
    \"repeticiones\": 10,
    \"peso\": 70.0,
    \"notas\": \"Buena forma\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 2 completada: 10 reps x 70kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 3..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_1_ID,
    \"numeroSerie\": 3,
    \"repeticiones\": 8,
    \"peso\": 80.0,
    \"notas\": \"Serie pesada\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 3 completada: 8 reps x 80kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 4..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_1_ID,
    \"numeroSerie\": 4,
    \"repeticiones\": 6,
    \"peso\": 85.0,
    \"notas\": \"Al fallo muscular\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 4 completada: 6 reps x 85kg - ¡AL FALLO!${NC}"
echo ""
sleep 2

echo -e "${BLUE}📋 EJERCICIO 2: Press Inclinado con Mancuernas${NC}"
echo "----------------------------------------------------------------------"
echo "Haciendo serie 1..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_2_ID,
    \"numeroSerie\": 1,
    \"repeticiones\": 12,
    \"peso\": 25.0,
    \"notas\": \"Mancuernas de 25kg cada una\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 1 completada: 12 reps x 25kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 2..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_2_ID,
    \"numeroSerie\": 2,
    \"repeticiones\": 10,
    \"peso\": 27.5,
    \"notas\": \"Aumentando peso\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 2 completada: 10 reps x 27.5kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 3..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_2_ID,
    \"numeroSerie\": 3,
    \"repeticiones\": 8,
    \"peso\": 30.0,
    \"notas\": \"Buena congestión\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 3 completada: 8 reps x 30kg${NC}"
echo ""
sleep 2

echo -e "${BLUE}📋 EJERCICIO 3: Aperturas con Mancuernas${NC}"
echo "----------------------------------------------------------------------"
echo "Haciendo serie 1..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_3_ID,
    \"numeroSerie\": 1,
    \"repeticiones\": 15,
    \"peso\": 15.0,
    \"notas\": \"Estiramiento completo\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 1 completada: 15 reps x 15kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 2..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_3_ID,
    \"numeroSerie\": 2,
    \"repeticiones\": 12,
    \"peso\": 17.5,
    \"notas\": \"Movimiento controlado\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 2 completada: 12 reps x 17.5kg${NC}"
echo ""
sleep 1

echo "Haciendo serie 3..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_3_ID,
    \"numeroSerie\": 3,
    \"repeticiones\": 10,
    \"peso\": 20.0,
    \"notas\": \"Conexión mente-músculo\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 3 completada: 10 reps x 20kg${NC}"
echo ""
sleep 2

echo -e "${BLUE}📋 EJERCICIO 4: Fondos en Paralelas${NC}"
echo "----------------------------------------------------------------------"
echo "Haciendo serie 1..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_4_ID,
    \"numeroSerie\": 1,
    \"repeticiones\": 15,
    \"peso\": 0.0,
    \"notas\": \"Peso corporal\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 1 completada: 15 reps (peso corporal)${NC}"
echo ""
sleep 1

echo "Haciendo serie 2..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_4_ID,
    \"numeroSerie\": 2,
    \"repeticiones\": 12,
    \"peso\": 0.0,
    \"notas\": \"Bajando despacio\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 2 completada: 12 reps (peso corporal)${NC}"
echo ""
sleep 1

echo "Haciendo serie 3..."
sleep 1
curl -s -X POST $BASE_URL/series \
  -H "Content-Type: application/json" \
  -d "{
    \"ejercicioEntrenamientoId\": $EJ_ENT_4_ID,
    \"numeroSerie\": 3,
    \"repeticiones\": 10,
    \"peso\": 0.0,
    \"notas\": \"Al fallo - finalización perfecta\"
  }" | jq '.'
echo -e "${GREEN}✓ Serie 3 completada: 10 reps (peso corporal) - ¡FINALIZADO!${NC}"
echo ""
sleep 2

echo ""
echo -e "${YELLOW}======================================================================"
echo "  ✅ ENTRENAMIENTO COMPLETADO"
echo "======================================================================${NC}"
echo ""
echo "Resumen del entrenamiento:"
echo "- 4 ejercicios completados"
echo "- 13 series totales realizadas"
echo "- Todas las series registradas con peso y repeticiones"
echo ""
sleep 1

echo -e "${BLUE}Ver entrenamiento completo con todos los ejercicios y series:${NC}"
echo "----------------------------------------------------------------------"
curl -s -X GET "$BASE_URL/entrenamientos/$ENTRENAMIENTO_ID" | jq '.'
echo ""

echo -e "${BLUE}Ver historial de entrenamientos del usuario:${NC}"
echo "----------------------------------------------------------------------"
curl -s -X GET "$BASE_URL/entrenamientos/usuario/$USER_ID" | jq '.'
echo ""

echo -e "${GREEN}======================================================================"
echo "  🎉 SCRIPT COMPLETADO EXITOSAMENTE"
echo "======================================================================${NC}"
