/*
 -- ============================================================================
 -- FILE NAME	: cpu.v
 -- DESCRIPTION : CPU�ȥåץ⥸��`��
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
`include "spm.h"

/********** �⥸��`�� **********/
module cpu (
	/********** �����å� & �ꥻ�å� **********/
	input  wire					  clk,			   // �����å�
	input  wire					  clk_,			   // ��ܞ�����å�
	input  wire					  reset,		   // ��ͬ�ڥꥻ�å�
	/********** �Х����󥿥ե��`�� **********/
	// IF Stage
	input  wire [`WordDataBus]	  if_bus_rd_data,  // �i�߳����ǩ`��
	input  wire					  if_bus_rdy_,	   // ��ǥ�
	input  wire					  if_bus_grnt_,	   // �Х�������
	output wire					  if_bus_req_,	   // �Х��ꥯ������
	output wire [`WordAddrBus]	  if_bus_addr,	   // ���ɥ쥹
	output wire					  if_bus_as_,	   // ���ɥ쥹���ȥ��`��
	output wire					  if_bus_rw,	   // �i�ߣ�����
	output wire [`WordDataBus]	  if_bus_wr_data,  // �����z�ߥǩ`��
	// MEM Stage
	input  wire [`WordDataBus]	  mem_bus_rd_data, // �i�߳����ǩ`��
	input  wire					  mem_bus_rdy_,	   // ��ǥ�
	input  wire					  mem_bus_grnt_,   // �Х�������
	output wire					  mem_bus_req_,	   // �Х��ꥯ������
	output wire [`WordAddrBus]	  mem_bus_addr,	   // ���ɥ쥹
	output wire					  mem_bus_as_,	   // ���ɥ쥹���ȥ��`��
	output wire					  mem_bus_rw,	   // �i�ߣ�����
	output wire [`WordDataBus]	  mem_bus_wr_data, // �����z�ߥǩ`��
	/********** ����z�� **********/
	input  wire [`CPU_IRQ_CH-1:0] cpu_irq		   // ����z��Ҫ��
);

	/********** �ѥ��ץ饤��쥸���� **********/
	// IF/ID
	wire [`WordAddrBus]			 if_pc;			 // �ץ�����५����
	wire [`WordDataBus]			 if_insn;		 // ����
	wire						 if_en;			 // �ѥ��ץ饤��ǩ`�����Є�
	// ID/EX�ѥ��ץ饤��쥸����
	wire [`WordAddrBus]			 id_pc;			 // �ץ�����५����
	wire						 id_en;			 // �ѥ��ץ饤��ǩ`�����Є�
	wire [`AluOpBus]			 id_alu_op;		 // ALU���ڥ�`�����
	wire [`WordDataBus]			 id_alu_in_0;	 // ALU���� 0
	wire [`WordDataBus]			 id_alu_in_1;	 // ALU���� 1
	wire						 id_br_flag;	 // ��᪥ե饰
	wire [`MemOpBus]			 id_mem_op;		 // ���ꥪ�ڥ�`�����
	wire [`WordDataBus]			 id_mem_wr_data; // ��������z�ߥǩ`��
	wire [`CtrlOpBus]			 id_ctrl_op;	 // �������ڥ�`�����
	wire [`RegAddrBus]			 id_dst_addr;	 // GPR�����z�ߥ��ɥ쥹
	wire						 id_gpr_we_;	 // GPR�����z���Є�
	wire [`IsaExpBus]			 id_exp_code;	 // ���⥳�`��
	// EX/MEM�ѥ��ץ饤��쥸����
	wire [`WordAddrBus]			 ex_pc;			 // �ץ�����५����
	wire						 ex_en;			 // �ѥ��ץ饤��ǩ`�����Є�
	wire						 ex_br_flag;	 // ��᪥ե饰
	wire [`MemOpBus]			 ex_mem_op;		 // ���ꥪ�ڥ�`�����
	wire [`WordDataBus]			 ex_mem_wr_data; // ��������z�ߥǩ`��
	wire [`CtrlOpBus]			 ex_ctrl_op;	 // �����쥸�������ڥ�`�����
	wire [`RegAddrBus]			 ex_dst_addr;	 // ���å쥸���������z�ߥ��ɥ쥹
	wire						 ex_gpr_we_;	 // ���å쥸���������z���Є�
	wire [`IsaExpBus]			 ex_exp_code;	 // ���⥳�`��
	wire [`WordDataBus]			 ex_out;		 // �I���Y��
	// MEM/WB�ѥ��ץ饤��쥸����
	wire [`WordAddrBus]			 mem_pc;		 // �ץ�����󥫥���
	wire						 mem_en;		 // �ѥ��ץ饤��ǩ`�����Є�
	wire						 mem_br_flag;	 // ��᪥ե饰
	wire [`CtrlOpBus]			 mem_ctrl_op;	 // �����쥸�������ڥ�`�����
	wire [`RegAddrBus]			 mem_dst_addr;	 // ���å쥸���������z�ߥ��ɥ쥹
	wire						 mem_gpr_we_;	 // ���å쥸���������z���Є�
	wire [`IsaExpBus]			 mem_exp_code;	 // ���⥳�`��
	wire [`WordDataBus]			 mem_out;		 // �I���Y��
	/********** �ѥ��ץ饤�������ź� **********/
	// ���ȩ`���ź�
	wire						 if_stall;		 // IF���Ʃ`��
	wire						 id_stall;		 // ID���Ʃ`
	wire						 ex_stall;		 // EX���Ʃ`��
	wire						 mem_stall;		 // MEM���Ʃ`��
	// �ե�å����ź�
	wire						 if_flush;		 // IF���Ʃ`��
	wire						 id_flush;		 // ID���Ʃ`��
	wire						 ex_flush;		 // EX���Ʃ`��
	wire						 mem_flush;		 // MEM���Ʃ`��
	// �ӥ��`�ź�
	wire						 if_busy;		 // IF���Ʃ`��
	wire						 mem_busy;		 // MEM���Ʃ`��
	// �������������ź�
	wire [`WordAddrBus]			 new_pc;		 // �¤���PC
	wire [`WordAddrBus]			 br_addr;		 // ��᪥��ɥ쥹
	wire						 br_taken;		 // ��᪤γ���
	wire						 ld_hazard;		 // ���`�ɥϥ��`��
	/********** ���å쥸�����ź� **********/
	wire [`WordDataBus]			 gpr_rd_data_0;	 // �i�߳����ǩ`�� 0
	wire [`WordDataBus]			 gpr_rd_data_1;	 // �i�߳����ǩ`�� 1
	wire [`RegAddrBus]			 gpr_rd_addr_0;	 // �i�߳������ɥ쥹 0
	wire [`RegAddrBus]			 gpr_rd_addr_1;	 // �i�߳������ɥ쥹 1
	/********** �����쥸�����ź� **********/
	wire [`CpuExeModeBus]		 exe_mode;		 // �g�Х�`��
	wire [`WordDataBus]			 creg_rd_data;	 // �i�߳����ǩ`��
	wire [`RegAddrBus]			 creg_rd_addr;	 // �i�߳������ɥ쥹
	/********** Interrupt Request **********/
	wire						 int_detect;	  // ����z�ߗʳ�
	/********** ������å��ѥåɥ����ź� **********/
	// IF���Ʃ`��
	wire [`WordDataBus]			 if_spm_rd_data;  // �i�߳����ǩ`��
	wire [`WordAddrBus]			 if_spm_addr;	  // ���ɥ쥹
	wire						 if_spm_as_;	  // ���ɥ쥹���ȥ��`��
	wire						 if_spm_rw;		  // �i�ߣ�����
	wire [`WordDataBus]			 if_spm_wr_data;  // �����z�ߥǩ`��
	// MEM���Ʃ`��
	wire [`WordDataBus]			 mem_spm_rd_data; // �i�߳����ǩ`��
	wire [`WordAddrBus]			 mem_spm_addr;	  // ���ɥ쥹
	wire						 mem_spm_as_;	  // ���ɥ쥹���ȥ��`��
	wire						 mem_spm_rw;	  // �i�ߣ�����
	wire [`WordDataBus]			 mem_spm_wr_data; // �����z�ߥǩ`��
	/********** �ե���`�ǥ����ź� **********/
	wire [`WordDataBus]			 ex_fwd_data;	  // EX���Ʃ`��
	wire [`WordDataBus]			 mem_fwd_data;	  // MEM���Ʃ`��

	/********** IF���Ʃ`�� **********/
	if_stage if_stage (
		/********** �����å� & �ꥻ�å� **********/
		.clk			(clk),				// �����å�
		.reset			(reset),			// ��ͬ�ڥꥻ�å�
		/********** SPM���󥿥ե��`�� **********/
		.spm_rd_data	(if_spm_rd_data),	// �i�߳����ǩ`��
		.spm_addr		(if_spm_addr),		// ���ɥ쥹
		.spm_as_		(if_spm_as_),		// ���ɥ쥹���ȥ��`��
		.spm_rw			(if_spm_rw),		// �i�ߣ�����
		.spm_wr_data	(if_spm_wr_data),	// �����z�ߥǩ`��
		/********** �Х����󥿥ե��`�� **********/
		.bus_rd_data	(if_bus_rd_data),	// �i�߳����ǩ`��
		.bus_rdy_		(if_bus_rdy_),		// ��ǥ�
		.bus_grnt_		(if_bus_grnt_),		// �Х�������
		.bus_req_		(if_bus_req_),		// �Х��ꥯ������
		.bus_addr		(if_bus_addr),		// ���ɥ쥹
		.bus_as_		(if_bus_as_),		// ���ɥ쥹���ȥ��`��
		.bus_rw			(if_bus_rw),		// �i�ߣ�����
		.bus_wr_data	(if_bus_wr_data),	// �����z�ߥǩ`��
		/********** �ѥ��ץ饤�������ź� **********/
		.stall			(if_stall),			// ���ȩ`��
		.flush			(if_flush),			// �ե�å���
		.new_pc			(new_pc),			// �¤���PC
		.br_taken		(br_taken),			// ��᪤γ���
		.br_addr		(br_addr),			// ����ȥ��ɥ쥹
		.busy			(if_busy),			// �ӥ��`�ź�
		/********** IF/ID�ѥ��ץ饤��쥸���� **********/
		.if_pc			(if_pc),			// �ץ�����५����
		.if_insn		(if_insn),			// ����
		.if_en			(if_en)				// �ѥ��ץ饤��ǩ`�����Є�
	);

	/********** ID���Ʃ`�� **********/
	id_stage id_stage (
		/********** �����å� & �ꥻ�å� **********/
		.clk			(clk),				// �����å�
		.reset			(reset),			// ��ͬ�ڥꥻ�å�
		/********** GPR���󥿥ե��`�� **********/
		.gpr_rd_data_0	(gpr_rd_data_0),	// �i�߳����ǩ`�� 0
		.gpr_rd_data_1	(gpr_rd_data_1),	// �i�߳����ǩ`�� 1
		.gpr_rd_addr_0	(gpr_rd_addr_0),	// �i�߳������ɥ쥹 0
		.gpr_rd_addr_1	(gpr_rd_addr_1),	// �i�߳������ɥ쥹 1
		/********** �ե���`�ǥ��� **********/
		// EX���Ʃ`������Υե���`�ǥ���
		.ex_en			(ex_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.ex_fwd_data	(ex_fwd_data),		// �ե���`�ǥ��󥰥ǩ`��
		.ex_dst_addr	(ex_dst_addr),		// �����z�ߥ��ɥ쥹
		.ex_gpr_we_		(ex_gpr_we_),		// �����z���Є�
		// MEM���Ʃ`������Υե���`�ǥ���
		.mem_fwd_data	(mem_fwd_data),		// �ե���`�ǥ��󥰥ǩ`��
		/********** �����쥸�������󥿥ե��`�� **********/
		.exe_mode		(exe_mode),			// �g�Х�`��
		.creg_rd_data	(creg_rd_data),		// �i�߳����ǩ`��
		.creg_rd_addr	(creg_rd_addr),		// �i�߳������ɥ쥹
		/********** �ѥ��ץ饤�������ź� **********/
	   .stall		   (id_stall),		   // ���ȩ`��
		.flush			(id_flush),			// �ե�å���
		.br_addr		(br_addr),			// ��᪥��ɥ쥹
		.br_taken		(br_taken),			// ��᪤γ���
		.ld_hazard		(ld_hazard),		// ���`�ɥϥ��`��
		/********** IF/ID�ѥ��ץ饤��쥸���� **********/
		.if_pc			(if_pc),			// �ץ�����५����
		.if_insn		(if_insn),			// ����
		.if_en			(if_en),			// �ѥ��ץ饤��ǩ`�����Є�
		/********** ID/EX�ѥ��ץ饤��쥸���� **********/
		.id_pc			(id_pc),			// �ץ�����५����
		.id_en			(id_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.id_alu_op		(id_alu_op),		// ALU���ڥ�`�����
		.id_alu_in_0	(id_alu_in_0),		// ALU���� 0
		.id_alu_in_1	(id_alu_in_1),		// ALU���� 1
		.id_br_flag		(id_br_flag),		// ��᪥ե饰
		.id_mem_op		(id_mem_op),		// ���ꥪ�ڥ�`�����
		.id_mem_wr_data (id_mem_wr_data),	// ��������z�ߥǩ`��
		.id_ctrl_op		(id_ctrl_op),		// �������ڥ�`�����
		.id_dst_addr	(id_dst_addr),		// GPR�����z�ߥ��ɥ쥹
		.id_gpr_we_		(id_gpr_we_),		// GPR�����z���Є�
		.id_exp_code	(id_exp_code)		// ���⥳�`��
	);

	/********** EX���Ʃ`�� **********/
	ex_stage ex_stage (
		/********** �����å� & �ꥻ�å� **********/
		.clk			(clk),				// �����å�
		.reset			(reset),			// ��ͬ�ڥꥻ�å�
		/********** �ѥ��ץ饤�������ź� **********/
		.stall			(ex_stall),			// ���ȩ`��
		.flush			(ex_flush),			// �ե�å���
		.int_detect		(int_detect),		// ����z�ߗʳ�
		/********** �ե���`�ǥ��� **********/
		.fwd_data		(ex_fwd_data),		// �ե���`�ǥ��󥰥ǩ`��
		/********** ID/EX�ѥ��ץ饤��쥸���� **********/
		.id_pc			(id_pc),			// �ץ�����५����
		.id_en			(id_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.id_alu_op		(id_alu_op),		// ALU���ڥ�`�����
		.id_alu_in_0	(id_alu_in_0),		// ALU���� 0
		.id_alu_in_1	(id_alu_in_1),		// ALU���� 1
		.id_br_flag		(id_br_flag),		// ��᪥ե饰
		.id_mem_op		(id_mem_op),		// ���ꥪ�ڥ�`�����
		.id_mem_wr_data (id_mem_wr_data),	// ��������z�ߥǩ`��
		.id_ctrl_op		(id_ctrl_op),		// �����쥸�������ڥ�`�����
		.id_dst_addr	(id_dst_addr),		// ���å쥸���������z�ߥ��ɥ쥹
		.id_gpr_we_		(id_gpr_we_),		// ���å쥸���������z���Є�
		.id_exp_code	(id_exp_code),		// ���⥳�`��
		/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
		.ex_pc			(ex_pc),			// �ץ�����५����
		.ex_en			(ex_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.ex_br_flag		(ex_br_flag),		// ��᪥ե饰
		.ex_mem_op		(ex_mem_op),		// ���ꥪ�ڥ�`�����
		.ex_mem_wr_data (ex_mem_wr_data),	// ��������z�ߥǩ`��
		.ex_ctrl_op		(ex_ctrl_op),		// �����쥸�������ڥ�`�����
		.ex_dst_addr	(ex_dst_addr),		// ���å쥸���������z�ߥ��ɥ쥹
		.ex_gpr_we_		(ex_gpr_we_),		// ���å쥸���������z���Є�
		.ex_exp_code	(ex_exp_code),		// ���⥳�`��
		.ex_out			(ex_out)			// �I���Y��
	);

	/********** MEM���Ʃ`�� **********/
	mem_stage mem_stage (
		/********** �����å� & �ꥻ�å� **********/
		.clk			(clk),				// �����å�
		.reset			(reset),			// ��ͬ�ڥꥻ�å�
		/********** �ѥ��ץ饤�������ź� **********/
		.stall			(mem_stall),		// ���ȩ`��
		.flush			(mem_flush),		// �ե�å���
		.busy			(mem_busy),			// �ӥ��`�ź�
		/********** �ե���`�ǥ��� **********/
		.fwd_data		(mem_fwd_data),		// �ե���`�ǥ��󥰥ǩ`��
		/********** SPM���󥿥ե��`�� **********/
		.spm_rd_data	(mem_spm_rd_data),	// �i�߳����ǩ`��
		.spm_addr		(mem_spm_addr),		// ���ɥ쥹
		.spm_as_		(mem_spm_as_),		// ���ɥ쥹���ȥ��`��
		.spm_rw			(mem_spm_rw),		// �i�ߣ�����
		.spm_wr_data	(mem_spm_wr_data),	// �����z�ߥǩ`��
		/********** �Х����󥿥ե��`�� **********/
		.bus_rd_data	(mem_bus_rd_data),	// �i�߳����ǩ`��
		.bus_rdy_		(mem_bus_rdy_),		// ��ǥ�
		.bus_grnt_		(mem_bus_grnt_),	// �Х�������
		.bus_req_		(mem_bus_req_),		// �Х��ꥯ������
		.bus_addr		(mem_bus_addr),		// ���ɥ쥹
		.bus_as_		(mem_bus_as_),		// ���ɥ쥹���ȥ��`��
		.bus_rw			(mem_bus_rw),		// �i�ߣ�����
		.bus_wr_data	(mem_bus_wr_data),	// �����z�ߥǩ`��
		/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
		.ex_pc			(ex_pc),			// �ץ�����५����
		.ex_en			(ex_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.ex_br_flag		(ex_br_flag),		// ��᪥ե饰
		.ex_mem_op		(ex_mem_op),		// ���ꥪ�ڥ�`�����
		.ex_mem_wr_data (ex_mem_wr_data),	// ��������z�ߥǩ`��
		.ex_ctrl_op		(ex_ctrl_op),		// �����쥸�������ڥ�`�����
		.ex_dst_addr	(ex_dst_addr),		// ���å쥸���������z�ߥ��ɥ쥹
		.ex_gpr_we_		(ex_gpr_we_),		// ���å쥸���������z���Є�
		.ex_exp_code	(ex_exp_code),		// ���⥳�`��
		.ex_out			(ex_out),			// �I���Y��
		/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
		.mem_pc			(mem_pc),			// �ץ�����󥫥���
		.mem_en			(mem_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.mem_br_flag	(mem_br_flag),		// ��᪥ե饰
		.mem_ctrl_op	(mem_ctrl_op),		// �����쥸�������ڥ�`�����
		.mem_dst_addr	(mem_dst_addr),		// ���å쥸���������z�ߥ��ɥ쥹
		.mem_gpr_we_	(mem_gpr_we_),		// ���å쥸���������z���Є�
		.mem_exp_code	(mem_exp_code),		// ���⥳�`��
		.mem_out		(mem_out)			// �I���Y��
	);

	/********** ������˥å� **********/
	ctrl ctrl (
		/********** �����å� & �ꥻ�å� **********/
		.clk			(clk),				// �����å�
		.reset			(reset),			// ��ͬ�ڥꥻ�å�
		/********** �����쥸�������󥿥ե��`�� **********/
		.creg_rd_addr	(creg_rd_addr),		// �i�߳������ɥ쥹
		.creg_rd_data	(creg_rd_data),		// �i�߳����ǩ`��
		.exe_mode		(exe_mode),			// �g�Х�`��
		/********** ����z�� **********/
		.irq			(cpu_irq),			// ����z��Ҫ��
		.int_detect		(int_detect),		// ����z�ߗʳ�
		/********** ID/EX�ѥ��ץ饤��쥸���� **********/
		.id_pc			(id_pc),			// �ץ�����५����
		/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
		.mem_pc			(mem_pc),			// �ץ�����󥫥���
		.mem_en			(mem_en),			// �ѥ��ץ饤��ǩ`�����Є�
		.mem_br_flag	(mem_br_flag),		// ��᪥ե饰
		.mem_ctrl_op	(mem_ctrl_op),		// �����쥸�������ڥ�`�����
		.mem_dst_addr	(mem_dst_addr),		// ���å쥸���������z�ߥ��ɥ쥹
		.mem_exp_code	(mem_exp_code),		// ���⥳�`��
		.mem_out		(mem_out),			// �I���Y��
		/********** �ѥ��ץ饤�������ź� **********/
		// �ѥ��ץ饤���״�B
		.if_busy		(if_busy),			// IF���Ʃ`���ӥ��`
		.ld_hazard		(ld_hazard),		// Load�ϥ��`��
		.mem_busy		(mem_busy),			// MEM���Ʃ`���ӥ��`
		// ���ȩ`���ź�
		.if_stall		(if_stall),			// IF���Ʃ`�����ȩ`��
		.id_stall		(id_stall),			// ID���Ʃ`�����ȩ`��
		.ex_stall		(ex_stall),			// EX���Ʃ`�����ȩ`��
		.mem_stall		(mem_stall),		// MEM���Ʃ`�����ȩ`��
		// �ե�å����ź�
		.if_flush		(if_flush),			// IF���Ʃ`���ե�å���
		.id_flush		(id_flush),			// ID���Ʃ`���ե�å���
		.ex_flush		(ex_flush),			// EX���Ʃ`���ե�å���
		.mem_flush		(mem_flush),		// MEM���Ʃ`���ե�å���
		// �¤����ץ�����५����
		.new_pc			(new_pc)			// �¤����ץ�����५����
	);

	/********** ���å쥸���� **********/
	gpr gpr (
		/********** �����å� & �ꥻ�å� **********/
		.clk	   (clk),					// �����å�
		.reset	   (reset),					// ��ͬ�ڥꥻ�å�
		/********** �i�߳����ݩ`�� 0 **********/
		.rd_addr_0 (gpr_rd_addr_0),			// �i�߳������ɥ쥹
		.rd_data_0 (gpr_rd_data_0),			// �i�߳����ǩ`��
		/********** �i�߳����ݩ`�� 1 **********/
		.rd_addr_1 (gpr_rd_addr_1),			// �i�߳������ɥ쥹
		.rd_data_1 (gpr_rd_data_1),			// �i�߳����ǩ`��
		/********** �����z�ߥݩ`�� **********/
		.we_	   (mem_gpr_we_),			// �����z���Є�
		.wr_addr   (mem_dst_addr),			// �����z�ߥ��ɥ쥹
		.wr_data   (mem_out)				// �����z�ߥǩ`��
	);

	/********** ������å��ѥåɥ��� **********/
	spm spm (
		/********** �����å� **********/
		.clk			 (clk_),					  // �����å�
		/********** �ݩ`��A : IF���Ʃ`�� **********/
		.if_spm_addr	 (if_spm_addr[`SpmAddrLoc]),  // ���ɥ쥹
		.if_spm_as_		 (if_spm_as_),				  // ���ɥ쥹���ȥ��`��
		.if_spm_rw		 (if_spm_rw),				  // �i�ߣ�����
		.if_spm_wr_data	 (if_spm_wr_data),			  // �����z�ߥǩ`��
		.if_spm_rd_data	 (if_spm_rd_data),			  // �i�߳����ǩ`��
		/********** �ݩ`��B : MEM���Ʃ`�� **********/
		.mem_spm_addr	 (mem_spm_addr[`SpmAddrLoc]), // ���ɥ쥹
		.mem_spm_as_	 (mem_spm_as_),				  // ���ɥ쥹���ȥ��`��
		.mem_spm_rw		 (mem_spm_rw),				  // �i�ߣ�����
		.mem_spm_wr_data (mem_spm_wr_data),			  // �����z�ߥǩ`��
		.mem_spm_rd_data (mem_spm_rd_data)			  // �i�߳����ǩ`��
	);

endmodule
