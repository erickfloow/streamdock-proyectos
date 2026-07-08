// Stream Dock MT4 Test Command
// Script para probar comandos directos hacia MetaTrader mediante Named Pipes

const net = require("net");

const PIPE_NAME = "\\\\.\\pipe\\mt4-streamdock";

// Comando por defecto si no escribes ninguno
const command = process.argv.slice(2).join(" ") || "PING";

console.log("Enviando comando a MT4:");
console.log(command);
console.log("");

const client = net.createConnection(PIPE_NAME, () => {
  client.write(command);
});

let response = "";

client.on("data", (data) => {
  response += data.toString();
  client.end();
});

client.on("end", () => {
  console.log("Respuesta de MT4:");
  console.log(response.trim());
});

client.on("error", (err) => {
  console.error("Error al conectar con el pipe:");
  console.error(err.message);
  console.log("");
  console.log("Revisa que:");
  console.log("- MetaTrader esté abierto.");
  console.log("- El EA StreamDockPipeBridgeMT4 esté cargado en una gráfica.");
  console.log("- El pipe usado sea \\\\.\\pipe\\mt4-streamdock.");
});
