#!/bin/bash

# Script de despliegue para aplicación de gimnasio
# Compila frontend Flutter y backend Spring Boot, y los envía al servidor

set -e  # Salir si hay algún error

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuración
SERVIDOR="xoanserver@server"
RUTA_REMOTA="~/gym-deploy"
DIR_ACTUAL=$(pwd)

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}  Script de Despliegue - Aplicación GYM ${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""

# 1. Compilar Frontend Flutter
echo -e "${GREEN}[1/4] Compilando Frontend Flutter...${NC}"
cd "$DIR_ACTUAL/frontend_gym"
flutter build web --release
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend compilado exitosamente${NC}"
else
    echo -e "${RED}✗ Error al compilar frontend${NC}"
    exit 1
fi
echo ""

# 2. Compilar Backend Spring Boot
echo -e "${GREEN}[2/4] Compilando Backend Spring Boot...${NC}"
cd "$DIR_ACTUAL/backend"
./mvnw clean package -DskipTests
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend compilado exitosamente${NC}"
else
    echo -e "${RED}✗ Error al compilar backend${NC}"
    exit 1
fi
echo ""

# 3. Enviar archivos al servidor
echo -e "${GREEN}[3/4] Enviando archivos al servidor...${NC}"

# Enviar frontend
echo "  → Enviando frontend..."
cd "$DIR_ACTUAL"
scp -r frontend_gym/build/web $SERVIDOR:$RUTA_REMOTA/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Frontend enviado${NC}"
else
    echo -e "${RED}  ✗ Error al enviar frontend${NC}"
    exit 1
fi

# Enviar docker-compose
echo "  → Enviando docker-compose..."
scp docker-compose-prod.yml $SERVIDOR:$RUTA_REMOTA/docker-compose.yml
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Docker-compose enviado${NC}"
else
    echo -e "${RED}  ✗ Error al enviar docker-compose${NC}"
    exit 1
fi

# Enviar backend (JAR)
echo "  → Enviando backend..."
scp backend/target/*.jar $SERVIDOR:$RUTA_REMOTA/app.jar
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Backend enviado${NC}"
else
    echo -e "${RED}  ✗ Error al enviar backend${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}  ✓ Despliegue completado exitosamente  ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo ""
echo "Archivos desplegados en: $SERVIDOR:$RUTA_REMOTA"
echo "  - Frontend:        $RUTA_REMOTA/web/"
echo "  - Backend:         $RUTA_REMOTA/app.jar"
echo "  - Docker Compose:  $RUTA_REMOTA/docker-compose.yml"
