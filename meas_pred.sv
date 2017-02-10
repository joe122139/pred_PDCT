`timescale 1ns/1ps
module meas_pred #(
	BLK_N = 4,
	PIX_N = BLK_N*BLK_N,
	MEA_N  = PIX_N/2,
	PIX_WID = 8,
	MEA_WID = $clog2(PIX_N)+PIX_WID,
	QSTEP_WID = 3,
	PREDICTOR_N = 2,
	PIC_WID = 13，
	PIC_HT = 13
	)
(
	input	logic									clk,rst_n,arst_n,en_o,
	input 	logic 	signed 	[MEA_WID:0] 			y[0:MEA_N-1],
	input	logic			[QSTEP_WID-1:0]			qStep,
	input 	logic	[PIC_WID-$clog2(BLK_N)-1:0]		cor_X,
	input 	logic	[PIC_HT-$clog2(BLK_N)-1:0]		cor_Y,
	output	reg		signed 	[MEA_WID-1:0] 			y_r[0:MEA_N-1],

);



logic 	signed 	[MEA_WID:0]				y_p[0:PREDICTOR_N-1];
logic 	signed 	[MEA_WID:0]				y_r[0:PREDICTOR_N-1];
logic 	signed 	[MEA_WID:0]				y_ave;
always_comb begin : proc_Y_predictor
//use following matrix A as example 
/*A = 
   1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
     1     0     0    -1     1     0     0    -1     1     0     0    -1     1     0     0    -1
     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1
     0    -1     1     0     0    -1     1     0     0    -1     1     0     0    -1     1     0
     1     1     1     1     0     0     0     0     0     0     0     0    -1    -1    -1    -1
     1     0     0    -1     0     0     0     0     0     0     0     0    -1     0     0     1
*/
	y_r[0] = 0;
	y_r[1] = 0;
	y_ave = 0;

	//pred. bottom row
	y_p[0] = (((y[0]+y[3])>>1)-y[2])>>1;

	//pred. right column
	y_p[1] = (((y[0]+y[5])>>1)-y[1])>>1;

	y_ave = 128*16; 

	if(cor_X == 0 && cor_Y==0) begin
		y_r[0] = y[0]-y_ave;
	end
	else　if(cor_X != 0 && cor_Y==0) begin		//Top line in an image
		y_r[1] = y[1]-y_ave;
	end
	else　if(cor_X == 0 && cor_Y!=0)	begin		//Left column in an image
		y_r[0] = y[0]-y_ave;
	end
	else　//other blocks
		y_r[0] = y[0]-y_p[0];
		y_r[1] = y[1]-y_p[1];
	end

end





	endmodule // meas_pred