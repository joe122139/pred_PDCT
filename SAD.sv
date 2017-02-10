module SAD #(
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
	input	logic		signed 	[MEA_WID:0] 			y_1[0:MEA_N-1],		//residue 1
	input	logic		signed 	[MEA_WID:0] 			y_2[0:MEA_N-1],		//residue 2
	);




endmodule // SAD