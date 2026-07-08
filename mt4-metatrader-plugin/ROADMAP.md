# Roadmap del Stream Dock MetaTrader Plugin

Este documento muestra el plan de desarrollo del proyecto Stream Dock MetaTrader Plugin.

El objetivo es convertir el Stream Dock M18 en una mini consola física para controlar funciones básicas de MetaTrader 4/5 mediante botones personalizados.

---

## Estado actual

Actualmente el proyecto cuenta con una primera base funcional para comunicar Node.js con MetaTrader 4 mediante Named Pipes en Windows.

Se han realizado pruebas con comandos básicos como:

- `PING`
- `STATUS`
- `BUY`
- `SELL`
- `CLOSE_ALL`

Las pruebas se han realizado en modo seguro, evitando ejecutar operaciones reales mientras se valida la comunicación.

---

## Fase 1: Bridge local con Node.js

Estado: En desarrollo avanzado.

### Objetivo

Crear un servidor local que reciba comandos y los envíe hacia MetaTrader 4.

### Avances

- Servidor HTTP local en Node.js.
- Comunicación con MetaTrader mediante Named Pipes.
- Endpoint `/health`.
- Endpoint `/mt4/status`.
- Endpoint `/mt4/buy`.
- Endpoint `/mt4/sell`.
- Endpoint `/mt4/close-all`.
- Script de pruebas `test-command.js`.

### Pendiente

- Mejorar manejo de errores.
- Agregar logs más claros.
- Separar rutas HTTP en archivos independientes.
- Agregar archivo de configuración.
- Preparar una versión estable del bridge.

---

## Fase 2: Expert Advisor para MetaTrader 4

Estado: Base funcional inicial.

### Objetivo

Crear un Expert Advisor capaz de recibir comandos externos y responder a Node.js.

### Avances

- EA `StreamDockPipeBridgeMT4.mq4`.
- Creación del Named Pipe.
- Lectura de comandos enviados desde Node.js.
- Respuesta a `PING`.
- Respuesta a `STATUS`.
- Modo seguro con `AllowLiveTrading = false`.
- Soporte inicial para `BUY`.
- Soporte inicial para `SELL`.
- Soporte inicial para `CLOSE_ALL`.

### Pendiente

- Cierre individual por ticket.
- Cierre por símbolo.
- Obtener lista de operaciones abiertas.
- Validar lotajes permitidos por broker.
- Validar símbolo antes de operar.
- Mejorar mensajes de error.
- Agregar soporte para break even.
- Agregar cierre parcial.
- Agregar trailing stop en futuras versiones.

---

## Fase 3: Plugin real para Stream Dock M18

Estado: Pendiente.

### Objetivo

Crear la estructura formal del plugin para Stream Dock M18 usando el SDK correspondiente.

### Funciones planeadas

- Botón de compra.
- Botón de venta.
- Botón de cierre total.
- Botón de cierre por símbolo.
- Botón de selección de lotaje.
- Botón de selección de símbolo.
- Botón de estado de conexión.
- Botón de modo seguro.
- Cambio de escenas o perfiles.

### Pendiente

- Crear `manifest.json`.
- Crear acciones del plugin.
- Crear interfaz del Property Inspector.
- Conectar botones con el bridge HTTP.
- Mostrar estado visual en botones.
- Agregar íconos personalizados.
- Empaquetar plugin.

---

## Fase 4: Mini consola de trading

Estado: Planeación.

### Objetivo

Diseñar un perfil de Stream Dock que funcione como una consola física para trading.

### Diseño inicial de botones

Posible distribución:

```txt
[ BUY ] [ SELL ] [ CLOSE ]
[ 0.01 ] [ 0.20 ] [ 1.00 ]
[ XAUUSD ] [ EURUSD ] [ STATUS ]
```

Funciones planeadas
Compra rápida.
Venta rápida.
Selección de lotaje.
Selección de símbolo.
Cierre total.
Cierre individual.
Estado de conexión.
Modo seguro.
Confirmación visual del comando enviado.

## Fase 5: Diseño visual de botones

Estado: En progreso.

Objetivo

Crear una colección de botones personalizados para Stream Dock con estilos visuales propios.

Estilos explorados
Hacker green.
Luxury diamond.
Neon trading.
Dark premium.
Crystal buttons.
Iridescent opal.
Botones con estilo futurista.
Pendiente
Organizar diseños en carpeta assets.
Exportar botones en tamaño adecuado.
Crear versión clara y oscura.
Crear botones para BUY, SELL, CLOSE, LOT y SYMBOL.
Documentar cada set visual.

## Fase 6: Seguridad

Estado: Prioridad alta.

Objetivo

Evitar operaciones accidentales o errores peligrosos durante el uso del Stream Dock.

Medidas planeadas
Mantener AllowLiveTrading = false por defecto.
Usar cuenta demo durante pruebas.
Confirmar comandos antes de operar en real.
Evitar comandos duplicados.
Agregar bloqueo de emergencia.
Agregar botón de desconexión.
Validar símbolo y lotaje.
Agregar logs de cada comando enviado.

## Fase 7: Soporte para MetaTrader 5

Estado: Futuro.

Objetivo

Adaptar el sistema para funcionar también con MetaTrader 5.

Pendiente
Crear versión del EA para MQL5.
Revisar diferencias entre MQL4 y MQL5.
Adaptar ejecución de órdenes.
Adaptar cierre de posiciones.
Probar comunicación con Node.js.
Documentar instalación para MT5.

## Fase 8: Versión instalable

Estado: Futuro.

Objetivo

Crear una versión más fácil de instalar para otros usuarios.

Pendiente
Crear instalador del bridge.
Crear archivo .env o configuración.
Crear script de inicio automático.
Crear instrucciones para Windows.
Crear release en GitHub.
Agregar capturas y video demo.
Crear documentación completa.
Comandos futuros propuestos

Algunos comandos que se podrían implementar en siguientes versiones:

CLOSE_SYMBOL|XAUUSD
CLOSE_TICKET|123456
SET_LOT|0.20
SET_SYMBOL|EURUSD
GET_OPEN_ORDERS
GET_LAST_ORDER
CLOSE_LAST
BREAK_EVEN
PARTIAL_CLOSE|123456|50
TRAILING_STOP|XAUUSD|100
Prioridades inmediatas

Las siguientes tareas tienen prioridad:

Terminar documentación básica.
Crear estructura real del plugin Stream Dock.
Conectar botones con endpoints HTTP.
Diseñar botones visuales finales.
Agregar selección de símbolo.
Agregar selección de lotaje.
Mejorar cierre de operaciones.
Probar todo en cuenta demo.
Estado general del proyecto
Bridge Node.js:          En desarrollo
EA MetaTrader 4:         Base funcional
Comandos básicos:        Probados en modo seguro
Plugin Stream Dock:      Pendiente
Diseño de botones:       En progreso
Documentación:           En progreso
Versión estable:         Pendiente
Nota final

Este proyecto se desarrolla con fines educativos, de experimentación y automatización personal.

Antes de usar cualquier función con operaciones reales, se recomienda realizar pruebas completas en cuenta demo.


Mensaje para el commit:

```txt
Agregar roadmap del proyecto MT4
