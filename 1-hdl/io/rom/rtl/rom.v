/*
 -- ============================================================================
 -- FILE NAME	: rom.v
 -- DESCRIPTION : Read Only Memory
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ��ͨ�إå��ե����� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ���e�إå��ե����� **********/
`include "rom.h"

/********** �⥸��`�� **********/
module rom (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,		// �����å�
	input  wire				   reset,	// ��ͬ�ڥꥻ�å�
	/********** �Х����󥿥ե��`�� **********/
	input  wire				   cs_,		// ���åץ��쥯��
	input  wire				   as_,		// ���ɥ쥹���ȥ��`��
	input  wire [`RomAddrBus]  addr,	// ���ɥ쥹
	output wire [`WordDataBus] rd_data, // �i�߳����ǩ`��
	output reg				   rdy_		// ��ǥ�
);

	/********** Xilinx FPGA Block RAM : -> altera sprom **********/
	altera_sprom x_s3e_sprom (
		.clock  (clk),					// �����å�
		.address (addr),					// ���ɥ쥹
		.q (rd_data)				// �i�߳����ǩ`��
	);

	/********** ��ǥ������� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			rdy_ <=  `DISABLE_;
		end else begin
			/* ��ǥ������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_ <=  `ENABLE_;
			end else begin
				rdy_ <=  `DISABLE_;
			end
		end
	end

endmodule
