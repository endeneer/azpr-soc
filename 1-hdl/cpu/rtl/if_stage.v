/*
 -- ============================================================================
 -- FILE NAME	: if_stage.v
 -- DESCRIPTION : IF���Ʃ`��
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
module if_stage (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,			// ����å�
	input  wire				   reset,		// ��ͬ�ڥꥻ�å�
	/********** SPM���󥿥ե��`�� **********/
	input  wire [`WordDataBus] spm_rd_data, // �i�߳����ǩ`��
	output wire [`WordAddrBus] spm_addr,	// ���ɥ쥹
	output wire				   spm_as_,		// ���ɥ쥹���ȥ�`��
	output wire				   spm_rw,		// �i�ߣ�����
	output wire [`WordDataBus] spm_wr_data, // �����z�ߥǩ`��
	/********** �Х����󥿥ե��`�� **********/
	input  wire [`WordDataBus] bus_rd_data, // �i�߳����ǩ`��
	input  wire				   bus_rdy_,	// ��ǥ�
	input  wire				   bus_grnt_,	// �Х�������
	output wire				   bus_req_,	// �Х��ꥯ������
	output wire [`WordAddrBus] bus_addr,	// ���ɥ쥹
	output wire				   bus_as_,		// ���ɥ쥹���ȥ�`��
	output wire				   bus_rw,		// �i�ߣ�����
	output wire [`WordDataBus] bus_wr_data, // �����z�ߥǩ`��
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		// ���ȩ`��
	input  wire				   flush,		// �ե�å���
	input  wire [`WordAddrBus] new_pc,		// �¤����ץ���५����
	input  wire				   br_taken,	// ��᪤γ���
	input  wire [`WordAddrBus] br_addr,		// ����ȥ��ɥ쥹
	output wire				   busy,		// �ӥ��`�ź�
	/********** IF/ID�ѥ��ץ饤��쥸���� **********/
	output wire [`WordAddrBus] if_pc,		// �ץ���५����
	output wire [`WordDataBus] if_insn,		// ����
	output wire				   if_en		// �ѥ��ץ饤��ǩ`�����Є�
);

	/********** �ڲ��ӾA�ź� **********/
	wire [`WordDataBus]		   insn;		// �ե��å���������

	/********** �Х����󥿥ե��`�� **********/
	bus_if bus_if (
		/********** ����å� & �ꥻ�å� **********/
		.clk		 (clk),					// ����å�
		.reset		 (reset),				// ��ͬ�ڥꥻ�å�
		/********** �ѥ��ץ饤�������ź� **********/
		.stall		 (stall),				// ���ȩ`��
		.flush		 (flush),				// �ե�å����ź�
		.busy		 (busy),				// �ӥ��`�ź�
		/********** CPU���󥿥ե��`�� **********/
		.addr		 (if_pc),				// ���ɥ쥹
		.as_		 (`ENABLE_),			// ���ɥ쥹�Є�
		.rw			 (`READ),				// �i�ߣ�����
		.wr_data	 (`WORD_DATA_W'h0),		// �����z�ߥǩ`��
		.rd_data	 (insn),				// �i�߳����ǩ`��
		/********** ������å��ѥåɥ��ꥤ�󥿥ե��`�� **********/
		.spm_rd_data (spm_rd_data),			// �i�߳����ǩ`��
		.spm_addr	 (spm_addr),			// ���ɥ쥹
		.spm_as_	 (spm_as_),				// ���ɥ쥹���ȥ�`��
		.spm_rw		 (spm_rw),				// �i�ߣ�����
		.spm_wr_data (spm_wr_data),			// �����z�ߥǩ`��
		/********** �Х����󥿥ե��`�� **********/
		.bus_rd_data (bus_rd_data),			// �i�߳����ǩ`��
		.bus_rdy_	 (bus_rdy_),			// ��ǥ�
		.bus_grnt_	 (bus_grnt_),			// �Х�������
		.bus_req_	 (bus_req_),			// �Х��ꥯ������
		.bus_addr	 (bus_addr),			// ���ɥ쥹
		.bus_as_	 (bus_as_),				// ���ɥ쥹���ȥ�`��
		.bus_rw		 (bus_rw),				// �i�ߣ�����
		.bus_wr_data (bus_wr_data)			// �����z�ߥǩ`��
	);
   
	/********** IF���Ʃ`���ѥ��ץ饤��쥸���� **********/
	if_reg if_reg (
		/********** ����å� & �ꥻ�å� **********/
		.clk		 (clk),					// ����å�
		.reset		 (reset),				// ��ͬ�ڥꥻ�å�
		/********** �ե��å��ǩ`�� **********/
		.insn		 (insn),				// �ե��å���������
		/********** �ѥ��ץ饤�������ź� **********/
		.stall		 (stall),				// ���ȩ`��
		.flush		 (flush),				// �ե�å���
		.new_pc		 (new_pc),				// �¤����ץ���५����
		.br_taken	 (br_taken),			// ��᪤γ���
		.br_addr	 (br_addr),				// ����ȥ��ɥ쥹
		/********** IF/ID�ѥ��ץ饤��쥸���� **********/
		.if_pc		 (if_pc),				// �ץ���५����
		.if_insn	 (if_insn),				// ����
		.if_en		 (if_en)				// �ѥ��ץ饤��ǩ`�����Є�
	);

endmodule
