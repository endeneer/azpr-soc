/*
 -- ============================================================================
 -- FILE NAME	: alu.v
 -- DESCRIPTION : ���gՓ�������˥å�
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
`include "cpu.h"

/********** �⥸��`�� **********/
module alu (
	input  wire [`WordDataBus] in_0,  // ���� 0
	input  wire [`WordDataBus] in_1,  // ���� 1
	input  wire [`AluOpBus]	   op,	  // ���ڥ�`�����
	output reg	[`WordDataBus] out,	  // ����
	output reg				   of	  // ���`�Хե�`
);

	/********** ���Ÿ���������ź� **********/
	wire signed [`WordDataBus] s_in_0 = $signed(in_0); // ���Ÿ������� 0
	wire signed [`WordDataBus] s_in_1 = $signed(in_1); // ���Ÿ������� 1
	wire signed [`WordDataBus] s_out  = $signed(out);  // ���Ÿ�������

	/********** ���gՓ������ **********/
	always @(*) begin
		case (op)
			`ALU_OP_AND	 : begin // Փ��e��AND��
				out	  = in_0 & in_1;
			end
			`ALU_OP_OR	 : begin // Փ��ͣ�OR��
				out	  = in_0 | in_1;
			end
			`ALU_OP_XOR	 : begin // ������Փ��ͣ�XOR��
				out	  = in_0 ^ in_1;
			end
			`ALU_OP_ADDS : begin // ���Ÿ�������
				out	  = in_0 + in_1;
			end
			`ALU_OP_ADDU : begin // ���Ťʤ�����
				out	  = in_0 + in_1;
			end
			`ALU_OP_SUBS : begin // ���Ÿ����p��
				out	  = in_0 - in_1;
			end
			`ALU_OP_SUBU : begin // ���Ťʤ��p��
				out	  = in_0 - in_1;
			end
			`ALU_OP_SHRL : begin // Փ���ҥ��ե�
				out	  = in_0 >> in_1[`ShAmountLoc];
			end
			`ALU_OP_SHLL : begin // Փ���󥷥ե�
				out	  = in_0 << in_1[`ShAmountLoc];
			end
			default		 : begin // �ǥե���Ȃ� (No Operation)
				out	  = in_0;
			end
		endcase
	end

	/********** ���`�Хե�`�����å� **********/
	always @(*) begin
		case (op)
			`ALU_OP_ADDS : begin // ���㥪�`�Хե�`�Υ����å�
				if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) ||
					((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
					of = `ENABLE;
				end else begin
					of = `DISABLE;
				end
			end
			`ALU_OP_SUBS : begin // �p�㥪�`�Хե�`�Υ����å�
				if (((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) ||
					((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0))) begin
					of = `ENABLE;
				end else begin
					of = `DISABLE;
				end
			end
			default		: begin // �ǥե���Ȃ�
				of = `DISABLE;
			end
		endcase
	end

endmodule
