# Stream Dock MetaTrader Plugin

Proyecto personal enfocado en crear un sistema de control para MetaTrader 4/5 usando Stream Dock M18.

La idea principal es convertir el Stream Dock en una mini consola de trading, permitiendo ejecutar acciones rápidas como compra, venta, cierre de operaciones, selección de símbolo y control de lotaje mediante botones físicos.

## Objetivo

Desarrollar un plugin para Stream Dock M18 capaz de comunicarse con MetaTrader mediante un bridge local, permitiendo enviar comandos desde el dispositivo hacia MetaTrader de forma rápida y organizada.

## Funciones trabajadas

- Comunicación entre Stream Dock y un servidor local.
- Bridge desarrollado con Node.js.
- Pruebas de conexión mediante HTTP.
- Pruebas posteriores mediante Named Pipes en Windows.
- Integración inicial con MetaTrader 4 usando un Expert Advisor en MQL4.
- Envío de comandos como:
  - PING
  - STATUS
  - BUY
  - SELL
  - CLOSE_ALL
- Pruebas con símbolos como:
  - XAUUSD
  - EURUSD
- Control básico de lotaje:
  - 0.01
  - 0.20
  - 1.00
- Diseño de botones personalizados para Stream Dock.
- Planeación de escenas para trading.

## Tecnologías usadas

- Stream Dock M18
- JavaScript
- Node.js
- MetaTrader 4
- MQL4
- Named Pipes
- HTTP Localhost
- Windows
- VS Code
- GitHub

## Estructura planeada

```txt
mt4-metatrader-plugin/
├── README.md
├── bridge-server/
│   ├── server.js
│   └── test-command.js
├── ea-mt4/
│   ├── StreamDockBridgeMT4.mq4
│   └── StreamDockPipeBridgeMT4.mq4
├── test-commands/
│   └── examples.md
└── assets/
    └── button-designs/
