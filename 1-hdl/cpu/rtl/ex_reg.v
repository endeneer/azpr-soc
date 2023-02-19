/*
 -- ============================================================================
 -- FILE NAME	: ex_reg.v
 -- DESCRIPTION : EX���Ʃ`���ѥ��ץ饤��쥸����
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
module ex_reg (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,			   // ����å�
	input  wire				   reset,		   // ��ͬ�ڥꥻ�å�
	/********** ALU�γ��� **********/
	input  wire [`WordDataBus] alu_out,		   // ����Y��
	input  wire				   alu_of,		   // ���`�Хե�`
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		   // ���ȩ`��
	input  wire				   flush,		   // �ե�å���
	input  wire				   int_detect,	   // ����z�ߗʳ�
	/********** ID/EX�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus] id_pc,		   // �ץ���५����
	input  wire				   id_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	input  wire				   id_br_flag,	   // ��᪥ե饰
	input  wire [`MemOpBus]	   id_mem_op,	   // ���ꥪ�ڥ�`�����
	input  wire [`WordDataBus] id_mem_wr_data, // ��������z�ߥǩ`��
	input  wire [`CtrlOpBus]   id_ctrl_op,	   // �����쥸�������ڥ�`�����
	input  wire [`RegAddrBus]  id_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	input  wire				   id_gpr_we_,	   // ���å쥸���������z���Є�
	input  wire [`IsaExpBus]   id_exp_code,	   // ���⥳�`��
	/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
	output reg	[`WordAddrBus] ex_pc,		   // �ץ���५����
	output reg				   ex_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	output reg				   ex_br_flag,	   // ��᪥ե饰
	output reg	[`MemOpBus]	   ex_mem_op,	   // ���ꥪ�ڥ�`�����
	output reg	[`WordDataBus] ex_mem_wr_data, // ��������z�ߥǩ`��
	output reg	[`CtrlOpBus]   ex_ctrl_op,	   // �����쥸�������ڥ�`�����
	output reg	[`RegAddrBus]  ex_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	output reg				   ex_gpr_we_,	   // ���å쥸���������z���Є�
	output reg	[`IsaExpBus]   ex_exp_code,	   // ���⥳�`��
	output reg	[`WordDataBus] ex_out		   // �I��Y��
);

	/********** �ѥ��ץ饤��쥸���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		/* ��ͬ�ڥꥻ�å� */
		if (reset == `RESET_ENABLE) begin 
			ex_pc		   <= #1 `WORD_ADDR_W'h0;
			ex_en		   <= #1 `DISABLE;
			ex_br_flag	   <= #1 `DISABLE;
			ex_mem_op	   <= #1 `MEM_OP_NOP;
			ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
			ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
			ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
			ex_gpr_we_	   <= #1 `DISABLE_;
			ex_exp_code	   <= #1 `ISA_EXP_NO_EXP;
			ex_out		   <= #1 `WORD_DATA_W'h0;
		end else begin
			/* �ѥ��ץ饤��쥸�����θ��� */
			if (stall == `DISABLE) begin 
				if (flush == `ENABLE) begin				  // �ե�å���
					ex_pc		   <= #1 `WORD_ADDR_W'h0;
					ex_en		   <= #1 `DISABLE;
					ex_br_flag	   <= #1 `DISABLE;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_NO_EXP;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else if (int_detect == `ENABLE) begin // ����z�ߤΗʳ�
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_EXT_INT;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else if (alu_of == `ENABLE) begin	  // ���g���`�Хե�`
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_OVERFLOW;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else begin							  // �ΤΥǩ`��
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 id_mem_op;
					ex_mem_wr_data <= #1 id_mem_wr_data;
					ex_ctrl_op	   <= #1 id_ctrl_op;
					ex_dst_addr	   <= #1 id_dst_addr;
					ex_gpr_we_	   <= #1 id_gpr_we_;
					ex_exp_code	   <= #1 id_exp_code;
					ex_out		   <= #1 alu_out;
				end
			end
		end
	end

endmodule
