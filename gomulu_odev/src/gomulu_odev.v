module main (
    input wire btn1,   // İlk tuş girişi
    input wire btn2,   // İkinci tuş girişi
    input wire clk,    // Saat sinyali
    output reg led_r,  // Kırmızı LED çıkışı
    output reg led_g,  // Yeşil LED çıkışı
    output reg led_b   // Mavi LED çıkışı
);

reg [31:0] counter1;
reg [31:0] counter2;
reg [2:0] state;

parameter IDLE = 2'b00;
parameter BLUE_ON = 2'b01;
parameter RED_ON = 2'b10;
parameter YELLOW_ON = 2'b11;

always @(posedge clk) begin
    if (btn1 && !btn2) begin
        state <= BLUE_ON;   // İlk tuşa basıldığında BLUE_ON durumuna geç
        counter1 <= 24'b0;  // İlk sayacı sıfırla
        counter2 <= 24'b0;  // İkinci sayacı sıfırla
    end
    else if (!btn1 && btn2) begin
        state <= RED_ON;    // İkinci tuşa basıldığında RED_ON durumuna geç
        counter1 <= 24'b0;  // İlk sayacı sıfırla
        counter2 <= 24'b0;  // İkinci sayacı sıfırla
    end

    case (state)
        IDLE: begin
            led_r <= 1'b0;
            led_g <= 1'b0;
            led_b <= 1'b1;
        end
        BLUE_ON: begin
            led_r <= 1'b0;
            led_g <= 1'b1;
            led_b <= 1'b1;
            counter1 <= counter1 + 1;  // İlk sayacı bir artır
            if (counter1 == 32'b00000011111111111111111111111111) begin // 3sn tl;dr her 0 ı 1 e çevirmek += 1 sn (binary decimal conversion)
                state <= IDLE;  // Belirli bir süre sonra IDLE durumuna geç
            end
        end
        RED_ON: begin
            led_r <= 1'b1;
            led_g <= 1'b1;
            led_b <= 1'b0;
            counter2 <= counter2 + 1;  // İkinci sayacı bir artır
            if (counter2 == 32'b00000011111111111111111111111111) begin // 3sn tl;dr her 0 ı 1 e çevirmek += 1 sn (binary decimal conversion)
                state <= IDLE;  // Belirli bir süre sonra IDLE durumuna geç
            end
        end
    endcase
end

endmodule