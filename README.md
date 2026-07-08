# Stream Dock Projects

Colección personal de proyectos, plugins, escenas, diseños de botones y pruebas desarrolladas para Stream Dock M18.

Este repositorio funciona como un laboratorio de desarrollo para experimentar con automatización, productividad, multimedia, trading tools y creación de plugins personalizados.

---

## Proyectos incluidos

| Proyecto | Descripción | Estado |
|---|---|---|
| [MetaTrader Plugin](./mt4-metatrader-plugin) | Bridge local y estructura inicial para controlar MetaTrader 4/5 desde Stream Dock M18. | En desarrollo |
| Magic 8 Ball | Plugin tipo bola mágica/oráculo con respuestas aleatorias y diseño personalizado. | Pendiente |
| Volume Control | Botones para subir, bajar y silenciar el volumen del sistema. | Pendiente |
| Button Designs | Colección de diseños visuales para botones del Stream Dock. | En progreso |
| Spotify Control | Pruebas para controlar música y accesos rápidos desde Stream Dock. | Pendiente |

---

## Objetivo del repositorio

El objetivo de este repositorio es documentar y organizar diferentes proyectos relacionados con Stream Dock M18, desde pruebas básicas hasta plugins más completos.

La idea principal es convertir el Stream Dock en una consola personalizada para:

- Trading.
- Productividad.
- Multimedia.
- Automatización.
- Accesos rápidos.
- Diseño de escenas.
- Control de aplicaciones.
- Proyectos con hardware externo.

---

## Proyecto principal actual

### Stream Dock MetaTrader Plugin

El proyecto más avanzado actualmente es el módulo de MetaTrader.

Este sistema busca convertir el Stream Dock M18 en una mini consola física de trading, permitiendo enviar comandos hacia MetaTrader mediante botones personalizados.

Funciones trabajadas:

- Bridge local con Node.js.
- Comunicación con MetaTrader 4 mediante Named Pipes.
- Expert Advisor en MQL4.
- Comandos de prueba como `PING`, `STATUS`, `BUY`, `SELL` y `CLOSE_ALL`.
- Modo seguro para evitar operaciones reales durante pruebas.
- Documentación de instalación, pruebas y roadmap.

Más información:

- [Documentación del proyecto MT4](./mt4-metatrader-plugin)
- [Guía de instalación](./mt4-metatrader-plugin/INSTALL.md)
- [Roadmap](./mt4-metatrader-plugin/ROADMAP.md)
- [Ejemplos de comandos](./mt4-metatrader-plugin/test-commands/examples.md)

---

## Tecnologías usadas

- JavaScript
- Node.js
- HTML
- CSS
- MQL4
- MetaTrader 4
- Windows Named Pipes
- Stream Dock M18
- GitHub
- VS Code

---

## Estructura general

```txt
streamdock-proyectos/
├── README.md
├── mt4-metatrader-plugin/
│   ├── README.md
│   ├── INSTALL.md
│   ├── ROADMAP.md
│   ├── bridge-server/
│   ├── ea-mt4/
│   └── test-commands/
├── magic-8-ball/
├── volume-control/
├── button-designs/
└── spotify-control/
```

## Estado general

```txt
MetaTrader Plugin:   En desarrollo
Magic 8 Ball:        Pendiente
Volume Control:      Pendiente
Button Designs:      En progreso
Spotify Control:     Pendiente
Próximos pasos
Terminar la estructura del plugin real para Stream Dock.
Agregar carpetas para Magic 8 Ball.
Agregar carpetas para Volume Control.
Organizar diseños visuales de botones.
Documentar escenas y perfiles.
Crear versiones descargables.
Agregar capturas del Stream Dock funcionando.
Autor
Erick Alcántara
Estudiante de Ingeniería en Sistemas Computacionales
Intereses: programación, automatización, electrónica, plugins, trading tools y desarrollo de aplicaciones.
Nota
Este repositorio está en desarrollo y se utiliza con fines educativos, de experimentación y creación de proyectos personales para Stream Dock M18.
```
