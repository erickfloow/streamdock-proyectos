//+------------------------------------------------------------------+
//| StreamDockPipeBridgeMT4.mq4                                      |
//| Bridge por Named Pipe para controlar MetaTrader 4 desde Node.js   |
//+------------------------------------------------------------------+
#property strict

input string PipeName = "mt4-streamdock";
input bool AllowLiveTrading = false;
input double DefaultLots = 0.01;
input int Slippage = 5;
input int MagicNumber = 18018;

#define GENERIC_READ_WRITE 0xC0000000
#define OPEN_EXISTING 3
#define PIPE_ACCESS_DUPLEX 0x00000003
#define PIPE_TYPE_MESSAGE 0x00000004
#define PIPE_READMODE_MESSAGE 0x00000002
#define PIPE_WAIT 0x00000000
#define INVALID_HANDLE_VALUE -1

#import "kernel32.dll"
int CreateNamedPipeW(
   string lpName,
   int dwOpenMode,
   int dwPipeMode,
   int nMaxInstances,
   int nOutBufferSize,
   int nInBufferSize,
   int nDefaultTimeOut,
   int lpSecurityAttributes
);

bool ConnectNamedPipe(int hNamedPipe, int lpOverlapped);
bool DisconnectNamedPipe(int hNamedPipe);
bool ReadFile(int hFile, uchar &lpBuffer[], int nNumberOfBytesToRead, int &lpNumberOfBytesRead, int lpOverlapped);
bool WriteFile(int hFile, uchar &lpBuffer[], int nNumberOfBytesToWrite, int &lpNumberOfBytesWritten, int lpOverlapped);
bool CloseHandle(int hObject);
int GetLastError();
#import

int pipeHandle = INVALID_HANDLE_VALUE;
string fullPipeName;

//+------------------------------------------------------------------+
//| Inicialización                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   fullPipeName = "\\\\.\\pipe\\" + PipeName;

   Print("StreamDock Named Pipe Bridge iniciado...");
   Print("Pipe: ", fullPipeName);

   CreatePipe();

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Cierre                                                           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(pipeHandle != INVALID_HANDLE_VALUE)
   {
      DisconnectNamedPipe(pipeHandle);
      CloseHandle(pipeHandle);
      pipeHandle = INVALID_HANDLE_VALUE;
   }

   Print("StreamDock Named Pipe Bridge detenido.");
}

//+------------------------------------------------------------------+
//| Loop principal                                                   |
//+------------------------------------------------------------------+
void OnTick()
{
   if(pipeHandle == INVALID_HANDLE_VALUE)
      CreatePipe();

   if(pipeHandle == INVALID_HANDLE_VALUE)
      return;

   bool connected = ConnectNamedPipe(pipeHandle, 0);

   int error = GetLastError();

   if(!connected && error != 535)
      return;

   uchar buffer[1024];
   ArrayInitialize(buffer, 0);

   int bytesRead = 0;
   bool readOk = ReadFile(pipeHandle, buffer, 1023, bytesRead, 0);

   if(readOk && bytesRead > 0)
   {
      string message = CharArrayToString(buffer, 0, bytesRead);
      Print("Mensaje recibido por pipe: ", message);

      string response = ProcessCommand(message);

      uchar outBuffer[];
      StringToCharArray(response, outBuffer, 0, WHOLE_ARRAY, CP_UTF8);

      int bytesWritten = 0;
      WriteFile(pipeHandle, outBuffer, ArraySize(outBuffer) - 1, bytesWritten, 0);

      Print("Respuesta enviada: ", response);
   }

   DisconnectNamedPipe(pipeHandle);
}

//+------------------------------------------------------------------+
//| Crear pipe                                                       |
//+------------------------------------------------------------------+
void CreatePipe()
{
   pipeHandle = CreateNamedPipeW(
      fullPipeName,
      PIPE_ACCESS_DUPLEX,
      PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
      1,
      1024,
      1024,
      0,
      0
   );

   if(pipeHandle == INVALID_HANDLE_VALUE)
   {
      Print("Error al crear pipe. Código: ", GetLastError());
   }
   else
   {
      Print("Pipe creado correctamente: ", fullPipeName);
   }
}

//+------------------------------------------------------------------+
//| Procesar comandos                                                |
//+------------------------------------------------------------------+
string ProcessCommand(string command)
{
   command = StringTrimLeft(StringTrimRight(command));

   if(command == "PING")
      return "PONG";

   if(command == "STATUS")
   {
      return "OK|MT4_CONNECTED|symbol=" + Symbol() +
             "|bid=" + DoubleToString(Bid, Digits) +
             "|ask=" + DoubleToString(Ask, Digits) +
             "|account=" + AccountName() +
             "|balance=" + DoubleToString(AccountBalance(), 2) +
             "|equity=" + DoubleToString(AccountEquity(), 2);
   }

   string parts[];
   int count = StringSplit(command, '|', parts);

   if(count <= 0)
      return "ERROR|EMPTY_COMMAND";

   string action = parts[0];

   if(action == "BUY" || action == "SELL")
   {
      string symbol = Symbol();
      double lots = DefaultLots;

      if(count >= 2 && parts[1] != "")
         symbol = parts[1];

      if(count >= 3 && parts[2] != "")
         lots = StrToDouble(parts[2]);

      if(!AllowLiveTrading)
         return "SAFE_MODE|" + action + "|" + symbol + "|" + DoubleToString(lots, 2);

      return ExecuteTrade(action, symbol, lots);
   }

   if(action == "CLOSE_ALL")
   {
      if(!AllowLiveTrading)
         return "SAFE_MODE|CLOSE_ALL";

      return CloseAllOrders();
   }

   return "ERROR|UNKNOWN_COMMAND|" + command;
}

//+------------------------------------------------------------------+
//| Ejecutar compra o venta                                          |
//+------------------------------------------------------------------+
string ExecuteTrade(string action, string symbol, double lots)
{
   RefreshRates();

   int type;
   double price;

   if(action == "BUY")
   {
      type = OP_BUY;
      price = MarketInfo(symbol, MODE_ASK);
   }
   else
   {
      type = OP_SELL;
      price = MarketInfo(symbol, MODE_BID);
   }

   int ticket = OrderSend(
      symbol,
      type,
      lots,
      price,
      Slippage,
      0,
      0,
      "StreamDock",
      MagicNumber,
      0,
      clrNONE
   );

   if(ticket < 0)
      return "ERROR|ORDER_SEND|" + IntegerToString(GetLastError());

   return "OK|" + action + "|ticket=" + IntegerToString(ticket);
}

//+------------------------------------------------------------------+
//| Cerrar todas las operaciones                                     |
//+------------------------------------------------------------------+
string CloseAllOrders()
{
   int closed = 0;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         RefreshRates();

         bool result = false;

         if(OrderType() == OP_BUY)
         {
            result = OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, clrNONE);
         }
         else if(OrderType() == OP_SELL)
         {
            result = OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, clrNONE);
         }

         if(result)
            closed++;
      }
   }

   return "OK|CLOSE_ALL|closed=" + IntegerToString(closed);
}
