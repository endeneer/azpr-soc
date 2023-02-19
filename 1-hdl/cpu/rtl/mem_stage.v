/*
 -- ============================================================================
 -- FILE NAME	: mem_stage.v
 -- DESCRIPTION : MEM���Ʃ`��
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
module mem_stage (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,			   // ����å�
	input  wire				   reset,		   // ��ͬ�ڥꥻ�å�
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		   // ���ȩ`��
	input  wire				   flush,		   // �ե�å���
	output wire				   busy,		   // �ӥ��`�ź�
	/********** �ե���`�ǥ��� **********/
	output wire [`WordDataBus] fwd_data,	   // �ե���`�ǥ��󥰥ǩ`��
	/********** SPM���󥿥ե��`�� **********/
	input  wire [`WordDataBus] spm_rd_data,	   // �i�߳����ǩ`��
	output wire [`WordAddrBus] spm_addr,	   // ���ɥ쥹
	output wire				   spm_as_,		   // ���ɥ쥹���ȥ�`��
	output wire				   spm_rw,		   // �i�ߣ�����
	output wire [`WordDataBus] spm_wr_data,	   // �����z�ߥǩ`��
	/********** �Х����󥿥ե��`�� **********/
	input  wire [`WordDataBus] bus_rd_data,	   // �i�߳����ǩ`��
	input  wire				   bus_rdy_,	   // ��ǥ�
	input  wire				   bus_grnt_,	   // �Х�������
	output wire				   bus_req_,	   // �Х��ꥯ������
	output wire [`WordAddrBus] bus_addr,	   // ���ɥ쥹
	output wire				   bus_as_,		   // ���ɥ쥹���ȥ�`��
	output wire				   bus_rw,		   // �i�ߣ�����
	output wire [`WordDataBus] bus_wr_data,	   // �����z�ߥǩ`��
	/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus] ex_pc,		   // �ץ���५����
	input  wire				   ex_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	input  wire				   ex_br_flag,	   // ��᪥ե饰
	input  wire [`MemOpBus]	   ex_mem_op,	   // ���ꥪ�ڥ�`�����
	input  wire [`WordDataBus] ex_mem_wr_data, // ��������z�ߥǩ`��
	input  wire [`CtrlOpBus]   ex_ctrl_op,	   // �����쥸�������ڥ�`�����
	input  wire [`RegAddrBus]  ex_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	input  wire				   ex_gpr_we_,	   // ���å쥸���������z���Є�
	input  wire [`IsaExpBus]   ex_exp_code,	   // ���⥳�`��
	input  wire [`WordDataBus] ex_out,		   // �I��Y��
	/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
	output wire [`WordAddrBus] mem_pc,		   // �ץ���󥫥���
	output wire				   mem_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	output wire				   mem_br_flag,	   // ��᪥ե饰
	output wire [`CtrlOpBus]   mem_ctrl_op,	   // �����쥸�������ڥ�`�����
	output wire [`RegAddrBus]  mem_dst_addr,   // ���å쥸���������z�ߥ��ɥ쥹
	output wire				   mem_gpr_we_,	   // ���å쥸���������z���Є�
	output wire [`IsaExpBus]   mem_exp_code,   // ���⥳�`��
	output wire [`WordDataBus] mem_out		   // �I��Y��
);

	/********** �ڲ��ź� **********/
	wire [`WordDataBus]		   rd_data;		   // �i�߳����ǩ`��
	wire [`WordAddrBus]		   addr;		   // ���ɥ쥹
	wire					   as_;			   // ���ɥ쥹�Є�
	wire					   rw;			   // �i�ߣ�����
	wire [`WordDataBus]		   wr_data;		   // �����z�ߥǩ`��
	wire [`WordDataBus]		   out;			   // ���ꥢ�������Y��
	wire					   miss_align;	   // �ߥ����饤��

	/********** �Y���Υե���`�ǥ��� **********/
	assign fwd_data	 = out;

	/********** ���ꥢ������������˥å� **********/
	mem_ctrl mem_ctrl (
		/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
		.ex_en			(ex_en),			   // �ѥ��ץ饤��ǩ`�����Є�
		.ex_mem_op		(ex_mem_op),		   // ���ꥪ�ڥ�`�����
		.ex_mem_wr_data (ex_mem_wr_data),	   // ��������z�ߥǩ`��
		.ex_out			(ex_out),			   // �I��Y��
		/********** ���ꥢ���������󥿥ե��`�� **********/
		.rd_data		(rd_data),			   // �i�߳����ǩ`��
		.addr			(addr),				   // ���ɥ쥹
		.as_			(as_),				   // ���ɥ쥹�Є�
		.rw				(rw),				   // �i�ߣ�����
		.wr_data		(wr_data),			   // �����z�ߥǩ`��
		/********** ���ꥢ�������Y�� **********/
		.out			(out),				   // ���ꥢ�������Y��
		.miss_align		(miss_align)		   // �ߥ����饤��
	);

	/********** �Х����󥿥ե��`�� **********/
	bus_if bus_if (
		/********** ����å� & �ꥻ�å� **********/
		.clk		 (clk),					   // ����å�
		.reset		 (reset),				   // ��ͬ�ڥꥻ�å�
		/********** �ѥ��ץ饤�������ź� **********/
		.stall		 (stall),				   // ���ȩ`��
		.flush		 (flush),				   // �ե�å����ź�
		.busy		 (busy),				   // �ӥ��`�ź�
		/********** CPU���󥿥ե��`�� **********/
		.addr		 (addr),				   // ���ɥ쥹
		.as_		 (as_),					   // ���ɥ쥹�Є�
		.rw			 (rw),					   // �i�ߣ�����
		.wr_data	 (wr_data),				   // �����z�ߥǩ`��
		.rd_data	 (rd_data),				   // �i�߳����ǩ`��
		/********** ������å��ѥåɥ��ꥤ�󥿥ե��`�� **********/
		.spm_rd_data (spm_rd_data),			   // �i�߳����ǩ`��
		.spm_addr	 (spm_addr),			   // ���ɥ쥹
		.spm_as_	 (spm_as_),				   // ���ɥ쥹���ȥ�`��
		.spm_rw		 (spm_rw),				   // �i�ߣ�����
		.spm_wr_data (spm_wr_data),			   // �����z�ߥǩ`��
		/********** �Х����󥿥ե��`�� **********/
		.bus_rd_data (bus_rd_data),			   // �i�߳����ǩ`��
		.bus_rdy_	 (bus_rdy_),			   // ��ǥ�
		.bus_grnt_	 (bus_grnt_),			   // �Х�������
		.bus_req_	 (bus_req_),			   // �Х��ꥯ������
		.bus_addr	 (bus_addr),			   // ���ɥ쥹
		.bus_as_	 (bus_as_),				   // ���ɥ쥹���ȥ�`��
		.bus_rw		 (bus_rw),				   // �i�ߣ�����
		.bus_wr_data (bus_wr_data)			   // �����z�ߥǩ`��
	);

	/********** MEM���Ʃ`���ѥ��ץ饤��쥸���� **********/
	mem_reg mem_reg (
		/********** ����å� & �ꥻ�å� **********/
		.clk		  (clk),				   // ����å�
		.reset		  (reset),				   // ��ͬ�ڥꥻ�å�
		/********** ���ꥢ�������Y�� **********/
		.out		  (out),				   // �Y��
		.miss_align	  (miss_align),			   // �ߥ����饤��
		/********** �ѥ��ץ饤�������ź� **********/
		.stall		  (stall),				   // ���ȩ`��
		.flush		  (flush),				   // �ե�å���
		/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
		.ex_pc		  (ex_pc),				   // �ץ���󥫥���
		.ex_en		  (ex_en),				   // �ѥ��ץ饤��ǩ`�����Є�
		.ex_br_flag	  (ex_br_flag),			   // ��᪥ե饰
		.ex_ctrl_op	  (ex_ctrl_op),			   // �����쥸�������ڥ�`�����
		.ex_dst_addr  (ex_dst_addr),		   // ���å쥸���������z�ߥ��ɥ쥹
		.ex_gpr_we_	  (ex_gpr_we_),			   // ���å쥸���������z���Є�
		.ex_exp_code  (ex_exp_code),		   // ���⥳�`��
		/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
		.mem_pc		  (mem_pc),				   // �ץ���󥫥���
		.mem_en		  (mem_en),				   // �ѥ��ץ饤��ǩ`�����Є�
		.mem_br_flag  (mem_br_flag),		   // ��᪥ե饰
		.mem_ctrl_op  (mem_ctrl_op),		   // �����쥸�������ڥ�`�����
		.mem_dst_addr (mem_dst_addr),		   // ���å쥸���������z�ߥ��ɥ쥹
		.mem_gpr_we_  (mem_gpr_we_),		   // ���å쥸���������z���Є�
		.mem_exp_code (mem_exp_code),		   // ���⥳�`��
		.mem_out	  (mem_out)				   // �I��Y��
	);

endmodule
