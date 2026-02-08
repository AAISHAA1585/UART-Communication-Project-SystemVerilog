module Uart_Interface (uart_if uart);

  // Loopback connection for simulation (TX -> RX)
  assign uart.RxD = uart.TxD;

  Uart_Transmitter tx_inst (uart);
  Uart_Receiver    rx_inst (uart);

endmodule
