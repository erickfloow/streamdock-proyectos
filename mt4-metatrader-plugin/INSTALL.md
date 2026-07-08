# Instalación y pruebas del Stream Dock MetaTrader Plugin

Esta guía explica cómo instalar, configurar y probar el bridge local entre Stream Dock M18 y MetaTrader 4.

El sistema usa un servidor local en Node.js y un Expert Advisor en MetaTrader 4 para comunicarse mediante Named Pipes en Windows.

---

## 1. Requisitos

Antes de iniciar, se necesita tener instalado:

- Windows
- MetaTrader 4
- Node.js
- Visual Studio Code o editor de texto
- Git, opcional
- Stream Dock M18, para la integración final
- Cuenta demo en MetaTrader para pruebas

---

## 2. Estructura del proyecto

La estructura principal del proyecto es:

```txt
mt4-metatrader-plugin/
├── README.md
├── INSTALL.md
├── bridge-server/
│   ├── server.js
│   ├── test-command.js
│   └── package.json
├── ea-mt4/
│   └── StreamDockPipeBridgeMT4.mq4
└── test-commands/
    └── examples.md
```
## 3. Instalar Node.js

Descargar e instalar Node.js desde su página oficial.

Después de instalarlo, abrir PowerShell o CMD y comprobar la instalación:

node -v

También comprobar npm:

npm -v

Si ambos comandos muestran una versión, Node.js quedó instalado correctamente.

## 4. Abrir la carpeta del bridge

Abrir una terminal dentro de la carpeta:

mt4-metatrader-plugin/bridge-server/

Ejemplo en PowerShell:

cd ruta/del/proyecto/mt4-metatrader-plugin/bridge-server

## 5. Iniciar el servidor bridge

Para iniciar el servidor, ejecutar:

node server.js

O si se usa package.json:

npm start

Si todo está correcto, la terminal debe mostrar algo parecido a:

StreamDock MT4 Pipe Bridge running on http://localhost:8080
Using pipe: \\.\pipe\mt4-streamdock

Esto significa que el servidor Node.js está activo y esperando comandos.

## 6. Copiar el EA a MetaTrader 4

El archivo del Expert Advisor se encuentra en:

mt4-metatrader-plugin/ea-mt4/StreamDockPipeBridgeMT4.mq4

Este archivo se debe copiar dentro de la carpeta de expertos de MetaTrader 4.

Ruta común:

MQL4/Experts/

Desde MetaTrader 4:

Abrir MetaTrader 4.
Ir a Archivo.
Seleccionar Abrir carpeta de datos.
Entrar a MQL4.
Entrar a Experts.
Pegar el archivo StreamDockPipeBridgeMT4.mq4.

## 7. Compilar el EA

Después de copiar el archivo:

Abrir MetaEditor.
Buscar el archivo StreamDockPipeBridgeMT4.mq4.
Abrirlo.
Presionar Compile.
Verificar que no aparezcan errores.

Si compila correctamente, MetaTrader generará el archivo compilado .ex4.

## 8. Cargar el EA en una gráfica

En MetaTrader 4:

Abrir una gráfica, por ejemplo XAUUSD o EURUSD.
Buscar el EA StreamDockPipeBridgeMT4 en el navegador.
Arrastrarlo a la gráfica.
Activar permisos necesarios.
Verificar que AutoTrading esté habilitado.
Confirmar que el EA aparezca cargado en la esquina superior de la gráfica.

## 9. Configuración inicial del EA

Parámetros principales:

PipeName = mt4-streamdock
AllowLiveTrading = false
DefaultLots = 0.01
Slippage = 5
MagicNumber = 18018
PipeName

Define el nombre del Named Pipe usado para comunicación.

Valor usado:

mt4-streamdock

Pipe completo en Windows:

\\.\pipe\mt4-streamdock
AllowLiveTrading

Controla si el EA puede ejecutar operaciones reales.

Por seguridad, debe iniciar en:

false

Con esta configuración, el EA responde en modo seguro y no abre ni cierra operaciones reales.

DefaultLots

Define el lotaje por defecto.

Valor inicial:

0.01
Slippage

Define la tolerancia de deslizamiento en órdenes.

Valor inicial:

5
MagicNumber

Identificador usado para reconocer operaciones del sistema.

Valor inicial:

18018
## 10. Probar conexión con PING

Con MetaTrader abierto, el EA cargado y el servidor Node.js activo, abrir otra terminal en:

mt4-metatrader-plugin/bridge-server/

Ejecutar:

node test-command.js PING

Respuesta esperada:

PONG

Si aparece PONG, la comunicación entre Node.js y MetaTrader funciona correctamente.

## 11. Probar estado de MetaTrader

Ejecutar:

node test-command.js STATUS

Respuesta esperada:

OK|MT4_CONNECTED|symbol=XAUUSD|bid=...|ask=...|account=...|balance=...|equity=...

Este comando confirma que el EA puede devolver información de MetaTrader.

## 12. Probar compra en modo seguro

Ejecutar:

node test-command.js BUY|XAUUSD|0.01

Respuesta esperada:

SAFE_MODE|BUY|XAUUSD|0.01

Esto significa que el comando de compra fue recibido, pero no se ejecutó una orden real porque AllowLiveTrading está en false.

## 13. Probar venta en modo seguro

Ejecutar:

node test-command.js SELL|XAUUSD|0.01

Respuesta esperada:

SAFE_MODE|SELL|XAUUSD|0.01
## 14. Probar cierre total en modo seguro

Ejecutar:

node test-command.js CLOSE_ALL

Respuesta esperada:

SAFE_MODE|CLOSE_ALL
## 15. Probar el servidor por HTTP

El bridge también se puede probar mediante endpoints HTTP.

Health check
curl http://localhost:8080/health

Respuesta esperada:

{
  "ok": true,
  "service": "StreamDock MT4 Pipe Bridge",
  "pipe": "\\\\.\\pipe\\mt4-streamdock",
  "port": 8080
}
Estado de MetaTrader
curl http://localhost:8080/mt4/status
Compra por HTTP

En PowerShell:

curl -X POST http://localhost:8080/mt4/buy `
  -H "Content-Type: application/json" `
  -d "{\"symbol\":\"XAUUSD\",\"lots\":0.01}"
Venta por HTTP

En PowerShell:

curl -X POST http://localhost:8080/mt4/sell `
  -H "Content-Type: application/json" `
  -d "{\"symbol\":\"XAUUSD\",\"lots\":0.01}"
Cierre total por HTTP
curl -X POST http://localhost:8080/mt4/close-all

## 16. Problemas comunes
Error: no se conecta al pipe

Revisar que:

MetaTrader esté abierto.
El EA esté cargado en una gráfica.
El servidor Node.js esté ejecutándose.
El nombre del pipe sea el mismo en Node.js y en MT4.
No haya otra instancia bloqueando el pipe.
No aparece PONG

Revisar que el EA esté mostrando mensajes en la pestaña Experts.

Mensajes esperados:

StreamDock Named Pipe Bridge iniciado...
Pipe: \\.\pipe\mt4-streamdock
Pipe creado correctamente
El servidor inicia, pero STATUS falla

Revisar que el EA esté cargado y que MetaTrader no esté congelado.

También cerrar y volver a abrir:

El servidor Node.js
El EA
MetaTrader, si es necesario
Las órdenes no se ejecutan

Por defecto el sistema está en modo seguro:

AllowLiveTrading = false

Para ejecutar operaciones reales se tendría que cambiar a:

AllowLiveTrading = true

Usar solamente en cuenta demo o bajo responsabilidad propia.

## 17. Seguridad

Este proyecto debe probarse primero en cuenta demo.

Antes de activar operaciones reales, verificar:

Que los comandos no se dupliquen.
Que el cierre de operaciones funcione correctamente.
Que el lotaje sea correcto.
Que el símbolo exista en el broker.
Que AutoTrading esté habilitado.
Que el EA tenga permiso para operar.
Que el Stream Dock no mande comandos accidentales.

## 18. Flujo general del sistema
Stream Dock M18
      ↓
Plugin o botón configurado
      ↓
Servidor local Node.js
      ↓
Named Pipe de Windows
      ↓
Expert Advisor en MetaTrader 4
      ↓
Respuesta hacia Node.js
      ↓
Confirmación del comando

## 19. Estado actual

Actualmente el proyecto permite:

Iniciar un servidor local con Node.js.
Enviar comandos hacia MetaTrader mediante Named Pipes.
Recibir respuesta PONG.
Consultar estado con STATUS.
Probar comandos BUY y SELL en modo seguro.
Probar CLOSE_ALL en modo seguro.
Mantener operaciones reales desactivadas por seguridad.

## 20. Siguiente etapa

La siguiente etapa del proyecto es crear la estructura real del plugin para Stream Dock M18, conectando botones físicos con los endpoints HTTP del bridge.


Cuando hagas commit, usa este mensaje:

```txt
Agregar guía de instalación del proyecto MT4
