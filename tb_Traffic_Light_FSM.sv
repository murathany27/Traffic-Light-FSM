`timescale 1ns/1ps

module tb_Traffic_Light_FSM();
    logic clk;
    logic reset;
    logic TAORB;
    logic [2:0] LA, LB;

    Traffic_Light_FSM dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize and Reset the system
        reset = 1; 
        TAORB = 1; // Assume traffic is on Street A
        #20 reset = 0; 
        
        // Scenario 1: Traffic on Street A ends (~TAORB)
        #50 TAORB = 0;
        
        // Scenario 2: Green for B
        #150; 
        
        // Scenario 3: Traffic returns to Street A (TAORB = 1)
        TAORB = 1;
        
        // Scenario 4: Watch the 5-cycle delay in S3, then return to S0
        #200;
        
        $stop;
    end

endmodule