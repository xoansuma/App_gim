# API Gimnasio - Documentación

API REST para aplicación móvil de gimnasio que permite gestionar usuarios, entrenamientos, ejercicios y series.

## Estructura de la Base de Datos

### Entidades:
- **Usuario**: Usuarios de la aplicación
- **Ejercicio**: Catálogo de ejercicios disponibles
- **Entrenamiento**: Entrenamientos realizados por usuarios
- **EjercicioEntrenamiento**: Relación entre ejercicios y entrenamientos
- **Serie**: Series realizadas en cada ejercicio de un entrenamiento

## Endpoints de la API

### 1. Usuarios (`/api/usuarios`)

#### Crear usuario
```
POST /api/usuarios
Content-Type: application/json

{
  "email": "usuario@ejemplo.com",
  "nombre": "Juan Pérez",
  "password": "miPassword123"
}
```

#### Obtener usuario por ID
```
GET /api/usuarios/{id}
```

#### Obtener usuario por email
```
GET /api/usuarios/email/{email}
```

#### Obtener todos los usuarios
```
GET /api/usuarios
```

#### Actualizar usuario
```
PUT /api/usuarios/{id}
Content-Type: application/json

{
  "email": "nuevo@ejemplo.com",
  "nombre": "Juan Actualizado",
  "password": "nuevoPassword"
}
```

#### Eliminar usuario
```
DELETE /api/usuarios/{id}
```

---

### 2. Ejercicios (`/api/ejercicios`)

#### Crear ejercicio
```
POST /api/ejercicios
Content-Type: application/json

{
  "nombre": "Press Banca",
  "grupoMuscular": "Pecho"
}
```

#### Obtener ejercicio por ID
```
GET /api/ejercicios/{id}
```

#### Obtener todos los ejercicios
```
GET /api/ejercicios
```

#### Buscar por grupo muscular
```
GET /api/ejercicios/grupo/{grupoMuscular}
Ejemplo: GET /api/ejercicios/grupo/Pecho
```

#### Buscar por nombre
```
GET /api/ejercicios/buscar?nombre=press
```

#### Actualizar ejercicio
```
PUT /api/ejercicios/{id}
Content-Type: application/json

{
  "nombre": "Press Banca Inclinado",
  "grupoMuscular": "Pecho Superior"
}
```

#### Eliminar ejercicio
```
DELETE /api/ejercicios/{id}
```

---

### 3. Entrenamientos (`/api/entrenamientos`)

#### Crear entrenamiento
```
POST /api/entrenamientos
Content-Type: application/json

{
  "nombre": "Rutina Pecho y Tríceps",
  "descripcion": "Entrenamiento enfocado en pecho y tríceps",
  "usuarioId": 1,
  "fechaRealizacion": "2024-12-03T10:30:00"
}
```

#### Obtener entrenamiento por ID (con ejercicios y series)
```
GET /api/entrenamientos/{id}
```

#### Obtener entrenamientos por usuario
```
GET /api/entrenamientos/usuario/{usuarioId}
```

#### Obtener todos los entrenamientos
```
GET /api/entrenamientos
```

#### Actualizar entrenamiento
```
PUT /api/entrenamientos/{id}
Content-Type: application/json

{
  "nombre": "Rutina Actualizada",
  "descripcion": "Descripción actualizada",
  "fechaRealizacion": "2024-12-04T11:00:00"
}
```

#### Eliminar entrenamiento
```
DELETE /api/entrenamientos/{id}
```

---

### 4. Ejercicios en Entrenamientos (`/api/ejercicios-entrenamientos`)

#### Agregar ejercicio a entrenamiento
```
POST /api/ejercicios-entrenamientos
Content-Type: application/json

{
  "entrenamientoId": 1,
  "ejercicioId": 1,
  "orden": 1,
  "notas": "Calentar bien antes"
}
```

#### Obtener ejercicio-entrenamiento por ID
```
GET /api/ejercicios-entrenamientos/{id}
```

#### Obtener ejercicios de un entrenamiento
```
GET /api/ejercicios-entrenamientos/entrenamiento/{entrenamientoId}
```

#### Actualizar ejercicio-entrenamiento
```
PUT /api/ejercicios-entrenamientos/{id}
Content-Type: application/json

{
  "orden": 2,
  "notas": "Aumentar peso en la próxima sesión"
}
```

#### Eliminar ejercicio de entrenamiento
```
DELETE /api/ejercicios-entrenamientos/{id}
```

---

### 5. Series (`/api/series`)

#### Agregar serie a un ejercicio
```
POST /api/series
Content-Type: application/json

{
  "ejercicioEntrenamientoId": 1,
  "numeroSerie": 1,
  "repeticiones": 12,
  "peso": 60.5,
  "duracionSegundos": null,
  "notas": "Buena forma"
}
```

#### Obtener serie por ID
```
GET /api/series/{id}
```

#### Obtener series de un ejercicio-entrenamiento
```
GET /api/series/ejercicio-entrenamiento/{ejercicioEntrenamientoId}
```

#### Actualizar serie
```
PUT /api/series/{id}
Content-Type: application/json

{
  "numeroSerie": 1,
  "repeticiones": 10,
  "peso": 65.0,
  "duracionSegundos": null,
  "notas": "Aumentado peso"
}
```

#### Eliminar serie
```
DELETE /api/series/{id}
```

---

## Flujo de Trabajo Típico

### 1. Crear un nuevo usuario
```
POST /api/usuarios
{
  "email": "juan@gym.com",
  "nombre": "Juan",
  "password": "password123"
}
```

### 2. Crear ejercicios (si no existen)
```
POST /api/ejercicios
{
  "nombre": "Press Banca",
  "grupoMuscular": "Pecho"
}
```

### 3. Crear un entrenamiento
```
POST /api/entrenamientos
{
  "nombre": "Día de Pecho",
  "usuarioId": 1,
  "fechaRealizacion": "2024-12-04T10:00:00"
}
```

### 4. Agregar ejercicio al entrenamiento
```
POST /api/ejercicios-entrenamientos
{
  "entrenamientoId": 1,
  "ejercicioId": 1,
  "orden": 1
}
```

### 5. Registrar series
```
POST /api/series
{
  "ejercicioEntrenamientoId": 1,
  "numeroSerie": 1,
  "repeticiones": 12,
  "peso": 60.0
}

POST /api/series
{
  "ejercicioEntrenamientoId": 1,
  "numeroSerie": 2,
  "repeticiones": 10,
  "peso": 65.0
}
```

### 6. Ver historial del usuario
```
GET /api/entrenamientos/usuario/1
```

---

## Características Importantes

1. **Separación por Usuario**: Cada entrenamiento está asociado a un usuario específico
2. **Orden de Ejercicios**: Los ejercicios en un entrenamiento se ordenan según el campo `orden`
3. **Historial Completo**: Al obtener un entrenamiento, se incluyen todos los ejercicios y series
4. **Timestamps Automáticos**: Las fechas de creación y registro se asignan automáticamente
5. **Eliminación en Cascada**: Al eliminar un entrenamiento, se eliminan sus ejercicios y series asociadas

---

## Configuración

Asegúrate de tener PostgreSQL corriendo con Docker:

```bash
docker-compose up -d
```

O usa el archivo `compose.yaml` que viene con el proyecto.

La base de datos se configurará automáticamente al iniciar la aplicación gracias a `spring.jpa.hibernate.ddl-auto=update`.

## Iniciar la Aplicación

```bash
./mvnw spring-boot:run
```

La API estará disponible en: `http://localhost:8080`
