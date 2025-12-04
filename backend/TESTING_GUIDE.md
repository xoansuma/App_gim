# Guía para Probar la API

## Opción 1: Script Automatizado (Recomendado)

He creado un script que prueba todos los endpoints automáticamente:

```bash
# 1. Iniciar la base de datos
docker compose up -d

# 2. Iniciar la aplicación en una terminal
./mvnw spring-boot:run

# 3. En otra terminal, ejecutar el script de prueba
./test-api.sh
```

## Opción 2: Usando curl (Manual)

### Crear un usuario
```bash
curl -X POST http://localhost:8080/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@gym.com",
    "nombre": "Juan Pérez",
    "password": "password123"
  }'
```

### Obtener todos los usuarios
```bash
curl -X GET http://localhost:8080/api/usuarios
```

### Crear un ejercicio
```bash
curl -X POST http://localhost:8080/api/ejercicios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Press Banca",
    "grupoMuscular": "Pecho"
  }'
```

### Crear un entrenamiento
```bash
curl -X POST http://localhost:8080/api/entrenamientos \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Día de Pecho",
    "descripcion": "Rutina de pecho completa",
    "usuarioId": 1,
    "fechaRealizacion": "2024-12-04T10:00:00"
  }'
```

### Agregar ejercicio a entrenamiento
```bash
curl -X POST http://localhost:8080/api/ejercicios-entrenamientos \
  -H "Content-Type: application/json" \
  -d '{
    "entrenamientoId": 1,
    "ejercicioId": 1,
    "orden": 1,
    "notas": "Calentar bien"
  }'
```

### Agregar una serie
```bash
curl -X POST http://localhost:8080/api/series \
  -H "Content-Type: application/json" \
  -d '{
    "ejercicioEntrenamientoId": 1,
    "numeroSerie": 1,
    "repeticiones": 12,
    "peso": 60.0,
    "notas": "Buena forma"
  }'
```

### Ver entrenamiento completo
```bash
curl -X GET http://localhost:8080/api/entrenamientos/1
```

### Ver entrenamientos de un usuario
```bash
curl -X GET http://localhost:8080/api/entrenamientos/usuario/1
```

## Opción 3: Usando Postman

1. Descarga [Postman](https://www.postman.com/downloads/)
2. Crea una nueva colección llamada "Gimnasio API"
3. Añade requests con estos datos:

**Crear Usuario:**
- Method: `POST`
- URL: `http://localhost:8080/api/usuarios`
- Headers: `Content-Type: application/json`
- Body (raw JSON):
```json
{
  "email": "juan@gym.com",
  "nombre": "Juan Pérez",
  "password": "password123"
}
```

## Opción 4: Extensión REST Client para VS Code

Si usas VS Code, instala la extensión "REST Client" y crea un archivo `api-tests.http`:

```http
### Crear Usuario
POST http://localhost:8080/api/usuarios
Content-Type: application/json

{
  "email": "juan@gym.com",
  "nombre": "Juan Pérez",
  "password": "password123"
}

### Obtener Usuarios
GET http://localhost:8080/api/usuarios

### Crear Ejercicio
POST http://localhost:8080/api/ejercicios
Content-Type: application/json

{
  "nombre": "Press Banca",
  "grupoMuscular": "Pecho"
}

### Crear Entrenamiento
POST http://localhost:8080/api/entrenamientos
Content-Type: application/json

{
  "nombre": "Día de Pecho",
  "descripcion": "Rutina de pecho",
  "usuarioId": 1,
  "fechaRealizacion": "2024-12-04T10:00:00"
}

### Agregar Ejercicio a Entrenamiento
POST http://localhost:8080/api/ejercicios-entrenamientos
Content-Type: application/json

{
  "entrenamientoId": 1,
  "ejercicioId": 1,
  "orden": 1
}

### Agregar Serie
POST http://localhost:8080/api/series
Content-Type: application/json

{
  "ejercicioEntrenamientoId": 1,
  "numeroSerie": 1,
  "repeticiones": 12,
  "peso": 60.0
}

### Ver Entrenamiento Completo
GET http://localhost:8080/api/entrenamientos/1

### Ver Entrenamientos del Usuario
GET http://localhost:8080/api/entrenamientos/usuario/1
```

Luego haz clic en "Send Request" sobre cada petición.

## Opción 5: Usando IntelliJ IDEA

IntelliJ tiene un cliente HTTP integrado:

1. Crea un archivo `api-tests.http` en el proyecto
2. Usa la misma sintaxis que en VS Code REST Client
3. Haz clic en el icono de play verde junto a cada request

## Verificar que todo funciona

Después de ejecutar las pruebas, puedes verificar en la base de datos:

```bash
# Conectar a PostgreSQL
docker exec -it gym_db_local psql -U postgres -d gimnasio_db

# Ver las tablas
\dt

# Ver usuarios
SELECT * FROM usuarios;

# Ver entrenamientos
SELECT * FROM entrenamientos;

# Ver series
SELECT * FROM series;

# Salir
\q
```

## Formato de respuesta bonito con jq

Para ver las respuestas JSON de forma más legible, instala `jq`:

```bash
# Ubuntu/Debian
sudo apt install jq

# Luego usa curl con jq:
curl -X GET http://localhost:8080/api/entrenamientos/1 | jq
```

## Solución de Problemas

**Error de conexión**: Verifica que la aplicación esté corriendo
```bash
# Ver si está corriendo en el puerto 8080
curl http://localhost:8080/actuator/health 2>/dev/null || echo "No está corriendo"
```

**Error de base de datos**: Verifica que Docker esté corriendo
```bash
docker ps | grep gym_db_local
```

**Ver logs de la aplicación**:
Los logs mostrarán las queries SQL y posibles errores.
