// Stream Dock MT4 Bridge Server
// Servidor local para comunicar Stream Dock con MetaTrader 4 mediante Named Pipes

const http = require("http");
const net = require("net");

const PORT = 8080;
const PIPE_NAME = "\\\\.\\pipe\\mt4-streamdock";

function sendPipeCommand(command) {
  return new Promise((resolve, reject) => {
    const client = net.createConnection(PIPE_NAME, () => {
      client.write(command);
    });

    let response = "";

    client.on("data", (data) => {
      response += data.toString();
      client.end();
    });

    client.on("end", () => {
      resolve(response.trim());
    });

    client.on("error", (err) => {
      reject(err);
    });
  });
}

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type"
  });

  res.end(JSON.stringify(data, null, 2));
}

const server = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    sendJson(res, 200, { ok: true });
    return;
  }

  if (req.method === "GET" && req.url === "/health") {
    sendJson(res, 200, {
      ok: true,
      service: "StreamDock MT4 Pipe Bridge",
      pipe: PIPE_NAME,
      port: PORT
    });
    return;
  }

  if (req.method === "GET" && req.url === "/mt4/status") {
    try {
      const response = await sendPipeCommand("STATUS");
      sendJson(res, 200, {
        ok: true,
        command: "STATUS",
        response
      });
    } catch (error) {
      sendJson(res, 500, {
        ok: false,
        error: error.message
      });
    }
    return;
  }

  if (req.method === "POST" && req.url === "/mt4/buy") {
    let body = "";

    req.on("data", chunk => {
      body += chunk.toString();
    });

    req.on("end", async () => {
      try {
        const data = JSON.parse(body || "{}");
        const symbol = data.symbol || "XAUUSD";
        const lots = data.lots || 0.01;

        const command = `BUY|${symbol}|${lots}`;
        const response = await sendPipeCommand(command);

        sendJson(res, 200, {
          ok: true,
          command,
          response
        });
      } catch (error) {
        sendJson(res, 500, {
          ok: false,
          error: error.message
        });
      }
    });

    return;
  }

  if (req.method === "POST" && req.url === "/mt4/sell") {
    let body = "";

    req.on("data", chunk => {
      body += chunk.toString();
    });

    req.on("end", async () => {
      try {
        const data = JSON.parse(body || "{}");
        const symbol = data.symbol || "XAUUSD";
        const lots = data.lots || 0.01;

        const command = `SELL|${symbol}|${lots}`;
        const response = await sendPipeCommand(command);

        sendJson(res, 200, {
          ok: true,
          command,
          response
        });
      } catch (error) {
        sendJson(res, 500, {
          ok: false,
          error: error.message
        });
      }
    });

    return;
  }

  if (req.method === "POST" && req.url === "/mt4/close-all") {
    try {
      const response = await sendPipeCommand("CLOSE_ALL");
      sendJson(res, 200, {
        ok: true,
        command: "CLOSE_ALL",
        response
      });
    } catch (error) {
      sendJson(res, 500, {
        ok: false,
        error: error.message
      });
    }
    return;
  }

  sendJson(res, 404, {
    ok: false,
    error: "Endpoint not found"
  });
});

server.listen(PORT, () => {
  console.log(`StreamDock MT4 Pipe Bridge running on http://localhost:${PORT}`);
  console.log(`Using pipe: ${PIPE_NAME}`);
});
