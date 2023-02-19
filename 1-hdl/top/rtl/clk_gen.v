/*
 -- ============================================================================
 -- FILE NAME	: clk_gen.v
 -- DESCRIPTION : ʱ������ģ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ����
 -- 1.0.1	  2014/06/27  zhangly
 -- ============================================================================
*/
 
/********** ͨ��ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ģ�� **********/
module clk_gen (
	/********** ʱ���븴λ **********/
	input wire	clk_ref,   // ����ʱ��
	input wire	reset_sw,  // ȫ�ָ�λ
	/********** ����ʱ�� **********/
	output wire clk,	   // ʱ��
	output wire clk_,	   // ����ʱ��
	/********** оƬ��λ **********/
	output wire chip_reset // оƬ��λ
);

	/********** �ڲ��ź� **********/
	wire		locked;	   // �����ź�
	wire		dcm_reset; // dcm ��λ

	/********** ������λ **********/
	// DCM��λ
	assign dcm_reset  = (reset_sw == `RESET_SW_ENABLE) ? `ENABLE : `DISABLE;
	// оƬ��λ
	assign chip_reset = ((reset_sw == `RESET_SW_ENABLE) || (locked == `DISABLE)) ?
							`RESET_ENABLE : `RESET_DISABLE;

	/********** Xilinx DCM (Digitl Clock Manager) -> altera pll**********/
	/* x_s3e_dcm x_s3e_dcm (
		.CLKIN_IN		 (clk_ref),	  // ����ʱ��
		.RST_IN			 (dcm_reset), // DCM��λ
		.CLK0_OUT		 (clk),		  // ʱ��
		.CLK180_OUT		 (clk_),	  // ����ʱ��
		.LOCKED_OUT		 (locked)	  // ����
   );
	*/
	
	altera_dcm x_s3e_dcm (
		.inclk0		 (clk_ref),	  // ����ʱ��
		.areset			 (dcm_reset), // DCM��λ
		.c0		 (clk),		  // ʱ��
		.c1		 (clk_),	  // ����ʱ��
		.locked		 (locked)	  // ����
   );
	

endmodule
