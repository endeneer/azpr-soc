/*
 -- ============================================================================
 -- FILE NAME	: mem_reg.v
 -- DESCRIPTION : MEM���Ʃ`���ѥ��ץ饤��쥸����
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ��ͨ�إå��ե����� **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** ���e�إå��ե����� **********/
`include "isa.h"
`include "cpu.h"

/********** �⥸��`�� **********/
module mem_reg (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,			 // �����å�
	input  wire				   reset,		 // ��ͬ�ڥꥻ�å�
	/********** ���ꥢ�������Y�� **********/
	input  wire [`WordDataBus] out,			 // ���ꥢ�������Y��
	input  wire				   miss_align,	 // �ߥ����饤��
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		 // ���ȩ`��
	input  wire				   flush,		 // �ե�å���
	/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus] ex_pc,		 // �ץ�����󥫥���
	input  wire				   ex_en,		 // �ѥ��ץ饤��ǩ`�����Є�
	input  wire				   ex_br_flag,	 // ��᪥ե饰
	input  wire [`CtrlOpBus]   ex_ctrl_op,	 // �����쥸�������ڥ�`�����
	input  wire [`RegAddrBus]  ex_dst_addr,	 // ���å쥸���������z�ߥ��ɥ쥹
	input  wire				   ex_gpr_we_,	 // ���å쥸���������z���Є�
	input  wire [`IsaExpBus]   ex_exp_code,	 // ���⥳�`��
	/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
	output reg	[`WordAddrBus] mem_pc,		 // �ץ�����󥫥���
	output reg				   mem_en,		 // �ѥ��ץ饤��ǩ`�����Є�
	output reg				   mem_br_flag,	 // ��᪥ե饰
	output reg	[`CtrlOpBus]   mem_ctrl_op,	 // �����쥸�������ڥ�`�����
	output reg	[`RegAddrBus]  mem_dst_addr, // ���å쥸���������z�ߥ��ɥ쥹
	output reg				   mem_gpr_we_,	 // ���å쥸���������z���Є�
	output reg	[`IsaExpBus]   mem_exp_code, // ���⥳�`��
	output reg	[`WordDataBus] mem_out		 // �I���Y��
);

	/********** �ѥ��ץ饤��쥸���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin	 
			/* ��ͬ�ڥꥻ�å� */
			mem_pc		 <=  `WORD_ADDR_W'h0;
			mem_en		 <=  `DISABLE;
			mem_br_flag	 <=  `DISABLE;
			mem_ctrl_op	 <=  `CTRL_OP_NOP;
			mem_dst_addr <=  `REG_ADDR_W'h0;
			mem_gpr_we_	 <=  `DISABLE_;
			mem_exp_code <=  `ISA_EXP_NO_EXP;
			mem_out		 <=  `WORD_DATA_W'h0;
		end else begin
			if (stall == `DISABLE) begin 
				/* �ѥ��ץ饤��쥸�����θ��� */
				if (flush == `ENABLE) begin				  // �ե�å���
					mem_pc		 <=  `WORD_ADDR_W'h0;
					mem_en		 <=  `DISABLE;
					mem_br_flag	 <=  `DISABLE;
					mem_ctrl_op	 <=  `CTRL_OP_NOP;
					mem_dst_addr <=  `REG_ADDR_W'h0;
					mem_gpr_we_	 <=  `DISABLE_;
					mem_exp_code <=  `ISA_EXP_NO_EXP;
					mem_out		 <=  `WORD_DATA_W'h0;
				end else if (miss_align == `ENABLE) begin // �ߥ����饤������
					mem_pc		 <=  ex_pc;
					mem_en		 <=  ex_en;
					mem_br_flag	 <=  ex_br_flag;
					mem_ctrl_op	 <=  `CTRL_OP_NOP;
					mem_dst_addr <=  `REG_ADDR_W'h0;
					mem_gpr_we_	 <=  `DISABLE_;
					mem_exp_code <=  `ISA_EXP_MISS_ALIGN;
					mem_out		 <=  `WORD_DATA_W'h0;
				end else begin							  // �ΤΥǩ`��
					mem_pc		 <=  ex_pc;
					mem_en		 <=  ex_en;
					mem_br_flag	 <=  ex_br_flag;
					mem_ctrl_op	 <=  ex_ctrl_op;
					mem_dst_addr <=  ex_dst_addr;
					mem_gpr_we_	 <=  ex_gpr_we_;
					mem_exp_code <=  ex_exp_code;
					mem_out		 <=  out;
				end
			end
		end
	end

endmodule
