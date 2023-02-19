/* 
 -- ============================================================================
 -- FILE NAME	: id_reg.v
 -- DESCRIPTION : ID���Ʃ`���ѥ��ץ饤��쥸����
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
module id_reg (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,			   // �����å�
	input  wire				   reset,		   // ��ͬ�ڥꥻ�å�
	/********** �ǥ��`�ɽY�� **********/
	input  wire [`AluOpBus]	   alu_op,		   // ALU���ڥ�`�����
	input  wire [`WordDataBus] alu_in_0,	   // ALU���� 0
	input  wire [`WordDataBus] alu_in_1,	   // ALU���� 1
	input  wire				   br_flag,		   // ��᪥ե饰
	input  wire [`MemOpBus]	   mem_op,		   // ���ꥪ�ڥ�`�����
	input  wire [`WordDataBus] mem_wr_data,	   // ��������z�ߥǩ`��
	input  wire [`CtrlOpBus]   ctrl_op,		   // �������ڥ�`�����
	input  wire [`RegAddrBus]  dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	input  wire				   gpr_we_,		   // ���å쥸���������z���Є�
	input  wire [`IsaExpBus]   exp_code,	   // ���⥳�`��
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		   // ���ȩ`��
	input  wire				   flush,		   // �ե�å���
	/********** IF/ID�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus] if_pc,		   // �ץ�����५����
	input  wire				   if_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	/********** ID/EX�ѥ��ץ饤��쥸���� **********/
	output reg	[`WordAddrBus] id_pc,		   // �ץ�����५����
	output reg				   id_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	output reg	[`AluOpBus]	   id_alu_op,	   // ALU���ڥ�`�����
	output reg	[`WordDataBus] id_alu_in_0,	   // ALU���� 0
	output reg	[`WordDataBus] id_alu_in_1,	   // ALU���� 1
	output reg				   id_br_flag,	   // ��᪥ե饰
	output reg	[`MemOpBus]	   id_mem_op,	   // ���ꥪ�ڥ�`�����
	output reg	[`WordDataBus] id_mem_wr_data, // ��������z�ߥǩ`��
	output reg	[`CtrlOpBus]   id_ctrl_op,	   // �������ڥ�`�����
	output reg	[`RegAddrBus]  id_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	output reg				   id_gpr_we_,	   // ���å쥸���������z���Є�
	output reg [`IsaExpBus]	   id_exp_code	   // ���⥳�`��
);

	/********** �ѥ��ץ饤��쥸���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin 
			/* ��ͬ�ڥꥻ�å� */
			id_pc		   <=  `WORD_ADDR_W'h0;
			id_en		   <=  `DISABLE;
			id_alu_op	   <=  `ALU_OP_NOP;
			id_alu_in_0	   <=  `WORD_DATA_W'h0;
			id_alu_in_1	   <=  `WORD_DATA_W'h0;
			id_br_flag	   <=  `DISABLE;
			id_mem_op	   <=  `MEM_OP_NOP;
			id_mem_wr_data <=  `WORD_DATA_W'h0;
			id_ctrl_op	   <=  `CTRL_OP_NOP;
			id_dst_addr	   <=  `REG_ADDR_W'd0;
			id_gpr_we_	   <=  `DISABLE_;
			id_exp_code	   <=  `ISA_EXP_NO_EXP;
		end else begin
			/* �ѥ��ץ饤��쥸�����θ��� */
			if (stall == `DISABLE) begin 
				if (flush == `ENABLE) begin // �ե�å���
				   id_pc		  <=  `WORD_ADDR_W'h0;
				   id_en		  <=  `DISABLE;
				   id_alu_op	  <=  `ALU_OP_NOP;
				   id_alu_in_0	  <=  `WORD_DATA_W'h0;
				   id_alu_in_1	  <=  `WORD_DATA_W'h0;
				   id_br_flag	  <=  `DISABLE;
				   id_mem_op	  <=  `MEM_OP_NOP;
				   id_mem_wr_data <=  `WORD_DATA_W'h0;
				   id_ctrl_op	  <=  `CTRL_OP_NOP;
				   id_dst_addr	  <=  `REG_ADDR_W'd0;
				   id_gpr_we_	  <=  `DISABLE_;
				   id_exp_code	  <=  `ISA_EXP_NO_EXP;
				end else begin				// �ΤΥǩ`��
				   id_pc		  <=  if_pc;
				   id_en		  <=  if_en;
				   id_alu_op	  <=  alu_op;
				   id_alu_in_0	  <=  alu_in_0;
				   id_alu_in_1	  <=  alu_in_1;
				   id_br_flag	  <=  br_flag;
				   id_mem_op	  <=  mem_op;
				   id_mem_wr_data <=  mem_wr_data;
				   id_ctrl_op	  <=  ctrl_op;
				   id_dst_addr	  <=  dst_addr;
				   id_gpr_we_	  <=  gpr_we_;
				   id_exp_code	  <=  exp_code;
				end
			end
		end
	end

endmodule
