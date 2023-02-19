/*
 -- ============================================================================
 -- FILE NAME	: ex_stage.v
 -- DESCRIPTION : EX���Ʃ`��
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
module ex_stage (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,			   // ����å�
	input  wire				   reset,		   // ��ͬ�ڥꥻ�å�
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		   // ���ȩ`��
	input  wire				   flush,		   // �ե�å���
	input  wire				   int_detect,	   // ����z�ߗʳ�
	/********** �ե���`�ǥ��� **********/
	output wire [`WordDataBus] fwd_data,	   // �ե���`�ǥ��󥰥ǩ`��
	/********** ID/EX�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus] id_pc,		   // �ץ���५����
	input  wire				   id_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	input  wire [`AluOpBus]	   id_alu_op,	   // ALU���ڥ�`�����
	input  wire [`WordDataBus] id_alu_in_0,	   // ALU���� 0
	input  wire [`WordDataBus] id_alu_in_1,	   // ALU���� 1
	input  wire				   id_br_flag,	   // ��᪥ե饰
	input  wire [`MemOpBus]	   id_mem_op,	   // ���ꥪ�ڥ�`�����
	input  wire [`WordDataBus] id_mem_wr_data, // ��������z�ߥǩ`��
	input  wire [`CtrlOpBus]   id_ctrl_op,	   // �����쥸�������ڥ�`�����
	input  wire [`RegAddrBus]  id_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	input  wire				   id_gpr_we_,	   // ���å쥸���������z���Є�
	input  wire [`IsaExpBus]   id_exp_code,	   // ���⥳�`��
	/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
	output wire [`WordAddrBus] ex_pc,		   // �ץ���५����
	output wire				   ex_en,		   // �ѥ��ץ饤��ǩ`�����Є�
	output wire				   ex_br_flag,	   // ��᪥ե饰
	output wire [`MemOpBus]	   ex_mem_op,	   // ���ꥪ�ڥ�`�����
	output wire [`WordDataBus] ex_mem_wr_data, // ��������z�ߥǩ`��
	output wire [`CtrlOpBus]   ex_ctrl_op,	   // �����쥸�������ڥ�`�����
	output wire [`RegAddrBus]  ex_dst_addr,	   // ���å쥸���������z�ߥ��ɥ쥹
	output wire				   ex_gpr_we_,	   // ���å쥸���������z���Є�
	output wire [`IsaExpBus]   ex_exp_code,	   // ���⥳�`��
	output wire [`WordDataBus] ex_out		   // �I��Y��
);

	/********** ALU�γ��� **********/
	wire [`WordDataBus]		   alu_out;		   // ����Y��
	wire					   alu_of;		   // ���`�Хե�`

	/********** ����Y���Υե���`�ǥ��� **********/
	assign fwd_data = alu_out;

	/********** ALU **********/
	alu alu (
		.in_0			(id_alu_in_0),	  // ���� 0
		.in_1			(id_alu_in_1),	  // ���� 1
		.op				(id_alu_op),	  // ���ڥ�`�����
		.out			(alu_out),		  // ����
		.of				(alu_of)		  // ���`�Хե�`
	);

	/********** �ѥ��ץ饤��쥸���� **********/
	ex_reg ex_reg (
		/********** ����å� & �ꥻ�å� **********/
		.clk			(clk),			  // ����å�
		.reset			(reset),		  // ��ͬ�ڥꥻ�å�
		/********** ALU�γ��� **********/
		.alu_out		(alu_out),		  // ����Y��
		.alu_of			(alu_of),		  // ���`�Хե�`
		/********** �ѥ��ץ饤�������ź� **********/
		.stall			(stall),		  // ���ȩ`��
		.flush			(flush),		  // �ե�å���
		.int_detect		(int_detect),	  // ����z�ߗʳ�
		/********** ID/EX�ѥ��ץ饤��쥸���� **********/
		.id_pc			(id_pc),		  // �ץ���५����
		.id_en			(id_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		.id_br_flag		(id_br_flag),	  // ��᪥ե饰
		.id_mem_op		(id_mem_op),	  // ���ꥪ�ڥ�`�����
		.id_mem_wr_data (id_mem_wr_data), // ��������z�ߥǩ`��
		.id_ctrl_op		(id_ctrl_op),	  // �����쥸�������ڥ�`�����
		.id_dst_addr	(id_dst_addr),	  // ���å쥸���������z�ߥ��ɥ쥹
		.id_gpr_we_		(id_gpr_we_),	  // ���å쥸���������z���Є�
		.id_exp_code	(id_exp_code),	  // ���⥳�`��
		/********** EX/MEM�ѥ��ץ饤��쥸���� **********/
		.ex_pc			(ex_pc),		  // �ץ���५����
		.ex_en			(ex_en),		  // �ѥ��ץ饤��ǩ`�����Є�
		.ex_br_flag		(ex_br_flag),	  // ��᪥ե饰
		.ex_mem_op		(ex_mem_op),	  // ���ꥪ�ڥ�`�����
		.ex_mem_wr_data (ex_mem_wr_data), // ��������z�ߥǩ`��
		.ex_ctrl_op		(ex_ctrl_op),	  // �����쥸�������ڥ�`�����
		.ex_dst_addr	(ex_dst_addr),	  // ���å쥸���������z�ߥ��ɥ쥹
		.ex_gpr_we_		(ex_gpr_we_),	  // ���å쥸���������z���Є�
		.ex_exp_code	(ex_exp_code),	  // ���⥳�`��
		.ex_out			(ex_out)		  // �I��Y��
	);

endmodule
