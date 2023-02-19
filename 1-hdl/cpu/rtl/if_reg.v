/*
 -- ============================================================================
 -- FILE NAME	: if_reg.v
 -- DESCRIPTION : IF���Ʃ`���ѥ��ץ饤��쥸����
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
module if_reg (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,		   // �����å�
	input  wire				   reset,	   // ��ͬ�ڥꥻ�å�
	/********** �ե��å��ǩ`�� **********/
	input  wire [`WordDataBus] insn,	   // �ե��å���������
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,	   // ���ȩ`��
	input  wire				   flush,	   // �ե�å���
	input  wire [`WordAddrBus] new_pc,	   // �¤����ץ�����५����
	input  wire				   br_taken,   // ��᪤γ���
	input  wire [`WordAddrBus] br_addr,	   // ����ȥ��ɥ쥹
	/********** IF/ID�ѥ��ץ饤��쥸���� **********/
	output reg	[`WordAddrBus] if_pc,	   // �ץ�����५����
	output reg	[`WordDataBus] if_insn,	   // ����
	output reg				   if_en	   // �ѥ��ץ饤��ǩ`�����Є�
);

	/********** �ѥ��ץ饤��쥸���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin 
			/* ��ͬ�ڥꥻ�å� */
			if_pc	<=  `RESET_VECTOR;
			if_insn <=  `ISA_NOP;
			if_en	<=  `DISABLE;
		end else begin
			/* �ѥ��ץ饤��쥸�����θ��� */
			if (stall == `DISABLE) begin 
				if (flush == `ENABLE) begin				// �ե�å���
					if_pc	<=  new_pc;
					if_insn <=  `ISA_NOP;
					if_en	<=  `DISABLE;
				end else if (br_taken == `ENABLE) begin // ��᪤γ���
					if_pc	<=  br_addr;
					if_insn <=  insn;
					if_en	<=  `ENABLE;
				end else begin							// �ΤΥ��ɥ쥹
					if_pc	<=  if_pc + 1'd1;
					if_insn <=  insn;
					if_en	<=  `ENABLE;
				end
			end
		end
	end

endmodule
