# Phase 2 Frontend - Autenticación JWT

## Estructura del Proyecto

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # Configuración centralizada (URLs, timeouts)
│   ├── exceptions.dart              # Excepciones base de la aplicación
│   ├── models/
│   │   └── user.dart               # Modelos de Usuario, LoginResponse
│   └── services/
│       └── api_service.dart         # Servicio HTTP con Dio + JWT interceptor
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── remote_auth_datasource.dart    # Llamadas HTTP al backend
│       │   └── repositories/
│       │       └── auth_repository_impl.dart      # Implementación repositorio
│       ├── domain/
│       │   ├── entities/
│       │   │   └── login_credentials.dart         # Entidad de credenciales
│       │   ├── repositories/
│       │   │   └── auth_repository.dart           # Abstracto repositorio
│       │   └── usecases/
│       │       └── auth_usecases.dart             # LoginUseCase, GetCurrentUserUseCase, etc.
│       └── presentation/
│           ├── bloc/
│           │   └── auth_bloc.dart                 # BLoC con eventos y estados
│           └── pages/
│               └── login_page.dart                # Pantalla de Login
└── main.dart                        # Entry point con inyección de dependencias
```

## Características Implementadas - Phase 2 Frontend

### ✅ Autenticación JWT
- **Login**: Email + Contraseña → Access + Refresh Tokens
- **Token Persistence**: Almacenamiento local con SharedPreferences
- **Auto-refresh**: Interceptor Dio refrescar token automáticamente
- **Logout**: Limpieza de tokens

### ✅ Manejo de Errores
- Excepciones tipadas: `AuthenticationException`, `ServerException`, `NetworkException`, etc.
- Manejo robusto de errores HTTP (4xx, 5xx, timeouts)
- Mensajes de error amigables al usuario

### ✅ Arquitectura Limpia
- **Clean Architecture**: Domain → Data → Presentation
- **BLoC Pattern**: Gestión de estado predecible con flutter_bloc
- **Dependency Injection**: Inyección manual en main.dart
- **Repository Pattern**: Abstracción de datasources

### ✅ UI/UX
- Formulario de login con validación
- Indicador de carga durante requests
- Mensajes de error/éxito con SnackBars
- Diseño Material Design 3 con colores personalizados

## Configuración

### Variables de Entorno
Por defecto, el backend está configurado en `http://localhost:8000`. Para cambiar:

```bash
flutter run --dart-define=BASE_URL=http://tu-servidor:8000
```

### Dependencias Principales
- `dio`: ^5.7.0 - Cliente HTTP
- `flutter_bloc`: ^8.1.6 - Gestión de estado
- `dartz`: ^0.10.1 - Either para manejo funcional de errores
- `shared_preferences`: ^2.3.2 - Almacenamiento local
- `equatable`: ^2.0.5 - Comparación de objetos

## Ejecución

### 1. Instalar dependencias
```bash
cd frontend/sr_frontend
flutter pub get
```

### 2. Ejecutar en desarrollo
```bash
# En un terminal, asegúrate que el backend esté corriendo
cd backend
python manage.py runserver

# En otro terminal, ejecuta Flutter
cd ../frontend/sr_frontend
flutter run
```

### 3. Probar Autenticación
- **Email**: student@example.com
- **Contraseña**: pass1234
- **Rol**: student

Alternativamente, usa credenciales de admin/profesor según lo que hayas creado en el backend.

## Próximas Fases

### Phase 2B - Features Adicionales (Frontend)
- [ ] Dashboard de Estudiante (listar recursos, autodiagnóstico)
- [ ] Dashboard de Profesor (crear/editar recursos)
- [ ] Detalle de Recursos
- [ ] Pantalla de Autodiagnóstico
- [ ] Perfil de Usuario

### Phase 2B - Features Adicionales (Backend)
- [ ] WebSocket en tiempo real (Channels)
- [ ] Recomendaciones de recursos
- [ ] Admin dashboard API
- [ ] Reportes de autodiagnósticos

## Testing

### Flutter Tests (Próximo)
```bash
flutter test
```

### Backend Tests
```bash
cd backend
python manage.py test catalog
```

## Notas de Desarrollo

- Los modelos `User`, `LoginResponse` coinciden exactamente con la respuesta del backend
- El `ApiService` maneja automáticamente la renovación de tokens expirados
- Los BLOCs son agnósticos de cómo se obtienen los datos (data layer abstracción)
- La UI reacciona automáticamente a cambios de estado del BLoC

## Troubleshooting

### "Connection refused"
- Asegúrate que Django backend está corriendo en `http://localhost:8000`
- Usa `flutter run --dart-define=BASE_URL=<tu-ip:puerto>` si está en otra máquina

### "Invalid token"
- Los tokens están almacenados en SharedPreferences
- En Android emulator, los datos persisten entre ejecuciones
- Para limpiar: Settings > Apps > sr_frontend > Storage > Clear Data

### CORS Issues
- Agrega `django-cors-headers` al backend si haces requests desde web
- Configura `CORS_ALLOWED_ORIGINS` en settings.py
