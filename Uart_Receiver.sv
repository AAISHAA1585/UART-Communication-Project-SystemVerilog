module Uart_Receiver (uart_if uart);

  parameter int clk_freq   = 50_000_000;
  parameter int baud_rate  = 115200;
  parameter int oversample = 16;

  // clock divider for oversampling
  localparam int sample_div = clk_freq / (baud_rate * oversample);

  logic [$clog2(sample_div)-1:0] sample_cnt;
  logic [$clog2(oversample)-1:0] os_cnt;
  logic [3:0] bit_cnt;
  logic [9:0] rx_shift;
  logic receiving;

  always_ff @(posedge uart.clk or posedge uart.reset) begin
    if (uart.reset) begin
      sample_cnt <= 0;
      os_cnt     <= 0;
      bit_cnt    <= 0;
      rx_shift   <= 0;
      receiving  <= 0;
      uart.valid_rx <= 0;
    end
    else begin
      uart.valid_rx <= 0;

      // generate oversampling tick
      if (sample_cnt == sample_div - 1) begin
        sample_cnt <= 0;

        // ----------------------------
        // IDLE: wait for start bit
        // ----------------------------
        if (!receiving) begin
          if (uart.RxD == 0) begin
            receiving <= 1;
            os_cnt   <= 0;
            bit_cnt  <= 0;
          end
        end
        // ----------------------------
        // RECEIVING
        // ----------------------------
        else begin
          os_cnt <= os_cnt + 1;

          // sample at middle of bit (8th sample)
          if (os_cnt == (oversample/2 - 1)) begin
            rx_shift <= {uart.RxD, rx_shift[9:1]};
          end

          // one full bit done
          if (os_cnt == oversample - 1) begin
            os_cnt <= 0;
            bit_cnt <= bit_cnt + 1;

            // received full frame (start + data + stop)
            if (bit_cnt == 9) begin
              receiving <= 0;
              bit_cnt   <= 0;
              uart.valid_rx <= 1;
            end
          end
        end
      end
      else begin
        sample_cnt <= sample_cnt + 1;
      end
    end
  end

  // extract 8-bit data (ignore start & stop)
  assign uart.RxData = rx_shift[8:1];

endmodule
