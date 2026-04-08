# Exchange Calculator — Prueba Tecnica Frontend

Calculadora de intercambio de criptomonedas a monedas fiat, construida en Flutter siguiendo Clean Architecture y principios SOLID.

## Arquitectura

El proyecto sigue **Clean Architecture** con separacion clara en tres capas, organizado por features:

```
lib/
├── core/                          # Infraestructura compartida
│   ├── constants/                 # Constantes de API y configuracion
│   ├── di/                        # Inyeccion de dependencias (GetIt)
│   ├── network/                   # Cliente HTTP (Dio)
│   └── theme/                     # Design tokens (colores, spacing, radii)
│
└── features/exchange/
    ├── domain/                    # Reglas de negocio (sin dependencias externas)
    │   ├── entities/              # Currency, ExchangeResult
    │   └── repositories/          # Contrato abstracto del repositorio
    │
    ├── data/                      # Implementacion de datos
    │   ├── datasources/           # Llamadas HTTP al API
    │   ├── models/                # DTOs con parsing JSON
    │   └── repositories/          # Implementacion del contrato de dominio
    │
    └── presentation/              # UI y estado
        ├── bloc/                  # Cubit + State (flutter_bloc)
        ├── pages/                 # Pantallas
        └── widgets/               # Componentes reutilizables
```

### Por que esta estructura

- **Escalabilidad**: Cada feature es autocontenida. Agregar un nuevo feature (ej: historial, notificaciones) no impacta el codigo existente.
- **Testabilidad**: Las capas estan desacopladas por contratos abstractos. Se puede testear dominio sin UI, data sin dominio, etc.
- **Mantenibilidad**: El flujo de dependencias es unidireccional: `presentation → domain ← data`. Ningun import cruza capas hacia arriba.

## Stack Tecnico

| Herramienta | Proposito | Justificacion |
|---|---|---|
| **Flutter** | Framework UI | Multiplataforma, un solo codebase |
| **flutter_bloc (Cubit)** | State management | Predecible, testeable, separacion clara de UI y logica |
| **GetIt** | Inyeccion de dependencias | Service locator liviano, lazy singletons para evitar recrear instancias |
| **Dio** | Cliente HTTP | Interceptors, timeouts configurables, logging en debug |
| **Equatable** | Comparacion de objetos | Value equality para states y entities sin boilerplate |
| **intl** | Formato de numeros | NumberFormat para tasas y montos con separadores locales |

## Decisiones Tecnicas

### State Management: Cubit sobre BLoC

Se eligio **Cubit** en lugar de BLoC completo (events/states) porque:
- Menor boilerplate para el scope del proyecto
- La logica de negocio es directa (input → API call → resultado)
- Demuestra dominio de flutter_bloc sin complejidad innecesaria

### Inyeccion de Dependencias con GetIt

```
Dio (lazySingleton)
  └→ ExchangeRemoteDataSource (lazySingleton)
       └→ ExchangeRepository (lazySingleton)
            └→ ExchangeCubit (factory — nueva instancia por widget)
```

- **lazySingleton** para servicios compartidos (HTTP client, datasource, repositorio)
- **factory** para el Cubit — cada widget obtiene su propia instancia con estado fresco

### Debounce en Input

El Cubit implementa un **debounce de 500ms** en `updateAmount()`. Cada keystroke cancela el timer anterior, evitando llamadas innecesarias al API mientras el usuario escribe.

### Manejo de Nullable State (copyWith pattern)

Se uso `ValueGetter<T?>` en el `copyWith` del state para resolver el problema clasico de Flutter donde campos nullable no pueden resetearse a `null`:

```dart
// Antes (bug): result nunca se limpia
copyWith(result: null)  // null ?? this.result → mantiene el valor viejo

// Despues (fix): ValueGetter permite limpiar explicitamente
copyWith(result: () => null)  // ejecuta el getter → null
```

### Mapeo de Errores

El Cubit traduce excepciones tecnicas a mensajes legibles para el usuario:
- `SocketException` → mensaje de conexion
- `TimeoutException` → mensaje de timeout
- Respuesta vacia del API → "No hay ofertas disponibles"
- Otros → mensaje generico

## API

- **Endpoint**: `GET /orderbook/public/recommendations`
- **Base URL**: `https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage`

| Parametro | Tipo | Descripcion |
|---|---|---|
| `type` | int | `0` = crypto→fiat, `1` = fiat→crypto |
| `cryptoCurrencyId` | string | ID de la cripto (ej: `TATUM-TRON-USDT`) |
| `fiatCurrencyId` | string | ID del fiat (ej: `COP`, `ARS`) |
| `amount` | double | Cantidad a cambiar |
| `amountCurrencyId` | string | ID de la moneda fuente |

**Response utilizado**: `data.byPrice.fiatToCryptoExchangeRate`

## Monedas Soportadas

**Crypto**: USDT (Tether), USDC (USD Coin) — ambas en red TRON

**Fiat**: COP (Colombia), VES (Venezuela), ARS (Argentina), PEN (Peru), BRL (Brasil), BOB (Bolivia)

## UI/UX

- **Design system** con tokens consistentes: colores, spacing scale (2-40px), border radius scale
- **Custom painter** para fondo decorativo (teal + circulo naranja)
- **Bottom sheet modal** con scroll para seleccion de monedas
- **Loading states** con spinners inline en cada fila de informacion
- **Error states** con mensajes descriptivos en español
- **Input validation**: solo numeros, maximo 2 decimales, teclado numerico
- **Boton de swap** para intercambiar monedas fuente/destino con limpieza de estado
- **Hint text** en el campo de monto para guiar al usuario

## Como Ejecutar

```bash
flutter pub get
flutter run
```

### Plataformas probadas
- macOS (desktop)
- iOS / Android (compatible)
