/*
 -- ============================================================================
 -- FILE NAME	: mem_ctrl.v
 -- DESCRIPTION : ���ꥢ������������˥å�
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
`include "bus.h"

/********** �⥸��`�� **********/
module mem_ctrl (
	/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
	input  wire				   ex_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	input  wire [`MemOpBus]	   ex_mem_op,	   // ���ꥪ�ڥ�`�����
	input  wire [`WordDataBus] ex_mem_wr_data, // ��������z�ߥǩ`��
	input  wire [`WordDataBus] ex_out,		   // �I��Y��
	/********** ���ꥢ���������󥿥ե��`�� **********/
	input  wire [`WordDataBus] rd_data,		   // �i�߳����ǩ`��
	output wire [`WordAddrBus] addr,		   // ���ɥ쥹
	output reg				   as_,			   // ���ɥ쥹�Є�
	output reg				   rw,			   // �i�ߣ�����
	output wire [`WordDataBus] wr_data,		   // �����z�ߥǩ`��
	/********** ���ꥢ�������Y�� **********/
	output reg [`WordDataBus]  out	 ,		   // ���ꥢ�������Y��
	output reg				   miss_align	   // �ߥ����饤��
);

	/********** �ڲ��ź� **********/
	wire [`ByteOffsetBus]	 offset;		   // ���ե��å�

	/********** �����Υ������� **********/
	assign wr_data = ex_mem_wr_data;		   // �����z�ߥǩ`��
	assign addr	   = ex_out[`WordAddrLoc];	   // ���ɥ쥹
	assign offset  = ex_out[`ByteOffsetLoc];   // ���ե��å�

	/********** ���ꥢ������������ **********/
	always @(*) begin
		/* �ǥե���Ȃ� */
		miss_align = `DISABLE;
		out		   = `WORD_DATA_W'h0;
		as_		   = `DISABLE_;
		rw		   = `READ;
		/* ���ꥢ������ */
		if (ex_en == `ENABLE) begin
			case (ex_mem_op)
				`MEM_OP_LDW : begin // ��`���i�߳���
					/* �Х��ȥ��ե��åȤΥ����å� */
					if (offset == `BYTE_OFFSET_WORD) begin // ���饤��
						out			= rd_data;
						as_		   = `ENABLE_;
					end else begin						   // �ߥ����饤��
						miss_align	= `ENABLE;
					end
				end
				`MEM_OP_STW : begin // ��`�ɕ����z��
					/* �Х��ȥ��ե��åȤΥ����å� */
					if (offset == `BYTE_OFFSET_WORD) begin // ���饤��
						rw			= `WRITE;
						as_		   = `ENABLE_;
					end else begin						   // �ߥ����饤��
						miss_align	= `ENABLE;
					end
				end
				default		: begin // ���ꥢ�������ʤ�
					out			= ex_out;
				end
			endcase
		end
	end

endmodule
