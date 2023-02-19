/*
 -- ============================================================================
 -- FILE NAME	: id_stage.v
 -- DESCRIPTION : ID���Ʃ`��
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
module id_stage (
	/********** ����å� & �ꥻ�å� **********/
	input  wire					 clk,			 // ����å�
	input  wire					 reset,			 // ��ͬ�ڥꥻ�å�
	/********** GPR���󥿥ե��`�� **********/
	input  wire [`WordDataBus]	 gpr_rd_data_0,	 // �i�߳����ǩ`�� 0
	input  wire [`WordDataBus]	 gpr_rd_data_1,	 // �i�߳����ǩ`�� 1
	output wire [`RegAddrBus]	 gpr_rd_addr_0,	 // �i�߳������ɥ쥹 0
	output wire [`RegAddrBus]	 gpr_rd_addr_1,	 // �i�߳������ɥ쥹 1
	/********** �ե���`�ǥ��� **********/
	// EX���Ʃ`������Υե���`�ǥ���
	input  wire					 ex_en,			// �ѥ��ץ饤��ǩ`�����Є�
	input  wire [`WordDataBus]	 ex_fwd_data,	 // �ե���`�ǥ��󥰥ǩ`��
	input  wire [`RegAddrBus]	 ex_dst_addr,	 // �����z�ߥ��ɥ쥹
	input  wire					 ex_gpr_we_,	 // �����z���Є�
	// MEM���Ʃ`������Υե���`�ǥ���
	input  wire [`WordDataBus]	 mem_fwd_data,	 // �ե���`�ǥ��󥰥ǩ`��
	/********** �����쥸�������󥿥ե��`�� **********/
	input  wire [`CpuExeModeBus] exe_mode,		 // �g�Х�`��
	input  wire [`WordDataBus]	 creg_rd_data,	 // �i�߳����ǩ`��
	output wire [`RegAddrBus]	 creg_rd_addr,	 // �i�߳������ɥ쥹
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire					 stall,			 // ���ȩ`��
	input  wire					 flush,			 // �ե�å���
	output wire [`WordAddrBus]	 br_addr,		 // ��᪥��ɥ쥹
	output wire					 br_taken,		 // ��᪤γ���
	output wire					 ld_hazard,		 // ��`�ɥϥ��`��
	/********** IF/ID�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus]	 if_pc,			 // �ץ���५����
	input  wire [`WordDataBus]	 if_insn,		 // ����
	input  wire					 if_en,			 // �ѥ��ץ饤��ǩ`�����Є�
	/********** ID/EX�ѥ��ץ饤��쥸���� **********/
	output wire [`WordAddrBus]	 id_pc,			 // �ץ���५����
	output wire					 id_en,			 // �ѥ��ץ饤��ǩ`�����Є�
	output wire [`AluOpBus]		 id_alu_op,		 // ALU���ڥ�`�����
	output wire [`WordDataBus]	 id_alu_in_0,	 // ALU���� 0
	output wire [`WordDataBus]	 id_alu_in_1,	 // ALU���� 1
	output wire					 id_br_flag,	 // ��᪥ե饰
	output wire [`MemOpBus]		 id_mem_op,		 // ���ꥪ�ڥ�`�����
	output wire [`WordDataBus]	 id_mem_wr_data, // ��������z�ߥǩ`��
	output wire [`CtrlOpBus]	 id_ctrl_op,	 // �������ڥ�`�����
	output wire [`RegAddrBus]	 id_dst_addr,	 // GPR�����z�ߥ��ɥ쥹
	output wire					 id_gpr_we_,	 // GPR�����z���Є�
	output wire [`IsaExpBus]	 id_exp_code	 // ���⥳�`��
);

	/********** �ǥ��`���ź� **********/
	wire  [`AluOpBus]			 alu_op;		 // ALU���ڥ�`�����
	wire  [`WordDataBus]		 alu_in_0;		 // ALU���� 0
	wire  [`WordDataBus]		 alu_in_1;		 // ALU���� 1
	wire						 br_flag;		 // ��᪥ե饰
	wire  [`MemOpBus]			 mem_op;		 // ���ꥪ�ڥ�`�����
	wire  [`WordDataBus]		 mem_wr_data;	 // ��������z�ߥǩ`��
	wire  [`CtrlOpBus]			 ctrl_op;		 // �������ڥ�`�����
	wire  [`RegAddrBus]			 dst_addr;		 // GPR�����z�ߥ��ɥ쥹
	wire						 gpr_we_;		 // GPR�����z���Є�
	wire  [`IsaExpBus]			 exp_code;		 // ���⥳�`��

	/********** �ǥ��`�� **********/
	decoder decoder (
		/********** IF/ID�ѥ��ץ饤��쥸���� **********/
		.if_pc			(if_pc),		  // �ץ���५����
		.if_insn		(if_insn),		  // ����
		.if_en			(if_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		/********** GPR���󥿥ե��`�� **********/
		.gpr_rd_data_0	(gpr_rd_data_0),  // �i�߳����ǩ`�� 0
		.gpr_rd_data_1	(gpr_rd_data_1),  // �i�߳����ǩ`�� 1
		.gpr_rd_addr_0	(gpr_rd_addr_0),  // �i�߳������ɥ쥹 0
		.gpr_rd_addr_1	(gpr_rd_addr_1),  // �i�߳������ɥ쥹 1
		/********** �ե���`�ǥ��� **********/
		// ID���Ʃ`������Υե���`�ǥ���
		.id_en			(id_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		.id_dst_addr	(id_dst_addr),	  // �����z�ߥ��ɥ쥹
		.id_gpr_we_		(id_gpr_we_),	  // �����z���Є�
		.id_mem_op		(id_mem_op),	  // ���ꥪ�ڥ�`�����
		// EX���Ʃ`������Υե���`�ǥ���
		.ex_en			(ex_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		.ex_fwd_data	(ex_fwd_data),	  // �ե���`�ǥ��󥰥ǩ`��
		.ex_dst_addr	(ex_dst_addr),	  // �����z�ߥ��ɥ쥹
		.ex_gpr_we_		(ex_gpr_we_),	  // �����z���Є�
		// MEM���Ʃ`������Υե���`�ǥ���
		.mem_fwd_data	(mem_fwd_data),	  // �ե���`�ǥ��󥰥ǩ`��
		/********** �����쥸�������󥿥ե��`�� **********/
		.exe_mode		(exe_mode),		  // �g�Х�`��
		.creg_rd_data	(creg_rd_data),	  // �i�߳����ǩ`��
		.creg_rd_addr	(creg_rd_addr),	  // �i�߳������ɥ쥹
		/********** �ǥ��`���ź� **********/
		.alu_op			(alu_op),		  // ALU���ڥ�`�����
		.alu_in_0		(alu_in_0),		  // ALU���� 0
		.alu_in_1		(alu_in_1),		  // ALU���� 1
		.br_addr		(br_addr),		  // ��᪥��ɥ쥹
		.br_taken		(br_taken),		  // ��᪤γ���
		.br_flag		(br_flag),		  // ��᪥ե饰
		.mem_op			(mem_op),		  // ���ꥪ�ڥ�`�����
		.mem_wr_data	(mem_wr_data),	  // ��������z�ߥǩ`��
		.ctrl_op		(ctrl_op),		  // �������ڥ�`�����
		.dst_addr		(dst_addr),		  // ���å쥸���������z�ߥ��ɥ쥹
		.gpr_we_		(gpr_we_),		  // ���å쥸���������z���Є�
		.exp_code		(exp_code),		  // ���⥳�`��
		.ld_hazard		(ld_hazard)		  // ��`�ɥϥ��`��
	);

	/********** �ѥ��ץ饤��쥸���� **********/
	id_reg id_reg (
		/********** ����å� & �ꥻ�å� **********/
		.clk			(clk),			  // ����å�
		.reset			(reset),		  // ��ͬ�ڥꥻ�å�
		/********** �ǥ��`�ɽY�� **********/
		.alu_op			(alu_op),		  // ALU���ڥ�`�����
		.alu_in_0		(alu_in_0),		  // ALU���� 0
		.alu_in_1		(alu_in_1),		  // ALU���� 1
		.br_flag		(br_flag),		  // ��᪥ե饰
		.mem_op			(mem_op),		  // ���ꥪ�ڥ�`�����
		.mem_wr_data	(mem_wr_data),	  // ��������z�ߥǩ`��
		.ctrl_op		(ctrl_op),		  // �������ڥ�`�����
		.dst_addr		(dst_addr),		  // ���å쥸���������z�ߥ��ɥ쥹
		.gpr_we_		(gpr_we_),		  // ���å쥸���������z���Є�
		.exp_code		(exp_code),		  // ���⥳�`��
		/********** �ѥ��ץ饤�������ź� **********/
		.stall			(stall),		  // ���ȩ`��
		.flush			(flush),		  // �ե�å���
		/********** IF/ID�ѥ��ץ饤��쥸���� **********/
		.if_pc			(if_pc),		  // �ץ���५����
		.if_en			(if_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		/********** ID/EX�ѥ��ץ饤��쥸���� **********/
		.id_pc			(id_pc),		  // �ץ���५����
		.id_en			(id_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		.id_alu_op		(id_alu_op),	  // ALU���ڥ�`�����
		.id_alu_in_0	(id_alu_in_0),	  // ALU���� 0
		.id_alu_in_1	(id_alu_in_1),	  // ALU���� 1
		.id_br_flag		(id_br_flag),	  // ��᪥ե饰
		.id_mem_op		(id_mem_op),	  // ���ꥪ�ڥ�`�����
		.id_mem_wr_data (id_mem_wr_data), // ��������z�ߥǩ`��
		.id_ctrl_op		(id_ctrl_op),	  // �������ڥ�`�����
		.id_dst_addr	(id_dst_addr),	  // ���å쥸���������z�ߥ��ɥ쥹
		.id_gpr_we_		(id_gpr_we_),	  // ���å쥸���������z���Є�
		.id_exp_code	(id_exp_code)	  // ���⥳�`��
	);

endmodule
