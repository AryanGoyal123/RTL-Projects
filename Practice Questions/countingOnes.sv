module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

  logic [$clog2(DATA_WIDTH+1)-1:0] count;
  
  always_comb begin
    count = '0;
    for (int i = 0; i < DATA_WIDTH; i++) begin
      if (din[i])
        count = count + 1;
    end
    dout = count;
  end

endmodule
