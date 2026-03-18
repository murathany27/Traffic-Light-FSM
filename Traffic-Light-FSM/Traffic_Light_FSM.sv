module Traffic_Light_FSM (
    input  logic clk,
    input  logic reset,
    input  logic TAORB,
    output logic [2:0] LA, LB // [2]=Green, [1]=Yellow, [0]=Red
);

    typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
    state_t current_state, next_state;

    logic [2:0] timer;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            timer         <= 3'd0;
        end else begin
            current_state <= next_state;
            
            // increment timer if state stays the same, otherwise reset
            if (current_state == next_state) 
                timer <= timer + 1'b1;
            else 
                timer <= 3'd0;
        end
    end

    always_comb begin
        case (current_state)
            S0: next_state = (TAORB) ? S0 : S1;        // stay in S0 if TAORB is high
            S1: next_state = (timer < 3'd5) ? S1 : S2; // wait for 5 clock cycles
            S2: next_state = (~TAORB) ? S2 : S3;       // stay in S2 if TAORB is low
            S3: next_state = (timer < 3'd5) ? S3 : S0; // wait for 5 clock cycles
            default: next_state = S0;
        endcase
    end

    always_comb begin
        // default values to prevent latches
        LA = 3'b001; 
        LB = 3'b001;
        
        case (current_state)
            S0: LA = 3'b100; // A: Green
            S1: LA = 3'b010; // A: Yellow
            S2: LB = 3'b100; // B: Green
            S3: LB = 3'b010; // B: Yellow
        endcase
    end

endmodule