# Ejemplos de comandos para probar MetaTrader

Este documento contiene ejemplos básicos para probar la comunicación entre Node.js y MetaTrader 4 mediante Named Pipes.

La finalidad de esta sección es documentar cómo se realizaron las pruebas del bridge local, qué comandos se enviaron y qué respuestas se esperaban desde MetaTrader.

---

## Requisitos previos

Antes de ejecutar cualquier prueba, se debe tener listo lo siguiente:

- MetaTrader 4 abierto.
- El Expert Advisor `StreamDockPipeBridgeMT4.mq4` cargado en una gráfica.
- El servidor bridge de Node.js activo.
- Node.js instalado en Windows.
- La terminal abierta dentro de la carpeta `bridge-server`.
- El pipe configurado como:

```txt
\\.\pipe\mt4-streamdock
