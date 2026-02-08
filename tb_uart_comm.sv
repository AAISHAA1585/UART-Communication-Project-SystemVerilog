`timescale 1ns/1ps

module tb_uart_comm;

  // UART interface
  uart_if uart();

  // DUT
  Uart_Interface dut (
    .uart(uart)
  );

  // Clock generation: 50 MHz
  initial uart.clk = 0;
  always #10 uart.clk = ~uart.clk;

  // Monitor RX continuously (DEBUG)
  always @(posedge uart.valid_rx) begin
    $display("[RX-MON] Time=%0t  RxData=%c (0x%0h)  Raw=%b",
              $time, uart.RxData, uart.RxData, uart.RxData);
  end

  // Test sequence
  initial begin
    uart.reset    = 1;
    uart.transmit = 0;
    uart.TxData   = 8'h00;

    #200;
    uart.reset = 0;

    send_byte("A");
    send_byte("I");
    send_byte("S");
    send_byte("H");
    send_byte("W");
    send_byte("A");
	 send_byte("R");
    send_byte("Y");
    send_byte("A");

    #300000;
    $display("=== TEST COMPLETED ===");
    $finish;
  end

  // Enhanced send task with debug
  task send_byte(input byte data);
    begin
      @(negedge uart.clk);
      while (uart.busy)
        @(negedge uart.clk);

      $display("[TX] Time=%0t  Sending=%c (0x%0h)",
                $time, data, data);

      uart.TxData   = data;
      uart.transmit = 1;
      @(negedge uart.clk);
      uart.transmit = 0;

      // wait for reception
      wait (uart.valid_rx == 1);

      $display("[TB] Time=%0t  Sent=%c  Received=%c (0x%0h)",
                $time, data, uart.RxData, uart.RxData);
    end
  endtask

endmodule
