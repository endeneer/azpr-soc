/*
 -- ============================================================================
 -- FILE NAME	: decoder.v
 -- DESCRIPTION : ����ǥ��`��
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
module decoder (
	/********** IF/ID�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus]	 if_pc,			 // �ץ���५����
	input  wire [`WordDataBus]	 if_insn,		 // ����
	input  wire					 if_en,			 // �ѥ��ץ饤��ǩ`�����Є�
	/********** GPR���󥿥ե��`�� **********/
	input  wire [`WordDataBus]	 gpr_rd_data_0, // �i�߳����ǩ`�� 0
	input  wire [`WordDataBus]	 gpr_rd_data_1, // �i�߳����ǩ`�� 1
	output wire [`RegAddrBus]	 gpr_rd_addr_0, // �i�߳������ɥ쥹 0
	output wire [`RegAddrBus]	 gpr_rd_addr_1, // �i�߳������ɥ쥹 1
	/********** �ե���`�ǥ��� **********/
	// ID���Ʃ`������Υե���`�ǥ���
	input  wire					 id_en,			// �ѥ��ץ饤��ǩ`�����Є�
	input  wire [`RegAddrBus]	 id_dst_addr,	// �����z�ߥ��ɥ쥹
	input  wire					 id_gpr_we_,	// �����z���Є�
	input  wire [`MemOpBus]		 id_mem_op,		// ���ꥪ�ڥ�`�����
	// EX���Ʃ`������Υե���`�ǥ���
	input  wire					 ex_en,			// �ѥ��ץ饤��ǩ`�����Є�
	input  wire [`RegAddrBus]	 ex_dst_addr,	// �����z�ߥ��ɥ쥹
	input  wire					 ex_gpr_we_,	// �����z���Є�
	input  wire [`WordDataBus]	 ex_fwd_data,	// �ե���`�ǥ��󥰥ǩ`��
	// MEM���Ʃ`������Υե���`�ǥ���
	input  wire [`WordDataBus]	 mem_fwd_data,	// �ե���`�ǥ��󥰥ǩ`��
	/********** �����쥸�������󥿥ե��`�� **********/
	input  wire [`CpuExeModeBus] exe_mode,		// �g�Х�`��
	input  wire [`WordDataBus]	 creg_rd_data,	// �i�߳����ǩ`��
	output wire [`RegAddrBus]	 creg_rd_addr,	// �i�߳������ɥ쥹
	/********** �ǥ��`�ɽY�� **********/
	output reg	[`AluOpBus]		 alu_op,		// ALU���ڥ�`�����
	output reg	[`WordDataBus]	 alu_in_0,		// ALU���� 0
	output reg	[`WordDataBus]	 alu_in_1,		// ALU���� 1
	output reg	[`WordAddrBus]	 br_addr,		// ��᪥��ɥ쥹
	output reg					 br_taken,		// ��᪤γ���
	output reg					 br_flag,		// ��᪥ե饰
	output reg	[`MemOpBus]		 mem_op,		// ���ꥪ�ڥ�`�����
	output wire [`WordDataBus]	 mem_wr_data,	// ��������z�ߥǩ`��
	output reg	[`CtrlOpBus]	 ctrl_op,		// �������ڥ�`�����
	output reg	[`RegAddrBus]	 dst_addr,		// ���å쥸���������z�ߥ��ɥ쥹
	output reg					 gpr_we_,		// ���å쥸���������z���Є�
	output reg	[`IsaExpBus]	 exp_code,		// ���⥳�`��
	output reg					 ld_hazard		// ��`�ɥϥ��`��
);

	/********** ����ե��`��� **********/
	wire [`IsaOpBus]	op		= if_insn[`IsaOpLoc];	  // ���ڥ��`��
	wire [`RegAddrBus]	ra_addr = if_insn[`IsaRaAddrLoc]; // Ra���ɥ쥹
	wire [`RegAddrBus]	rb_addr = if_insn[`IsaRbAddrLoc]; // Rb���ɥ쥹
	wire [`RegAddrBus]	rc_addr = if_insn[`IsaRcAddrLoc]; // Rc���ɥ쥹
	wire [`IsaImmBus]	imm		= if_insn[`IsaImmLoc];	  // ����
	/********** ���� **********/
	// ���Œ���
	wire [`WordDataBus] imm_s = {{`ISA_EXT_W{imm[`ISA_IMM_MSB]}}, imm};
	// ���품��
	wire [`WordDataBus] imm_u = {{`ISA_EXT_W{1'b0}}, imm};
	/********** �쥸�������i�߳������ɥ쥹 **********/
	assign gpr_rd_addr_0 = ra_addr; // ���å쥸�����i�߳������ɥ쥹 0
	assign gpr_rd_addr_1 = rb_addr; // ���å쥸�����i�߳������ɥ쥹 1
	assign creg_rd_addr	 = ra_addr; // �����쥸�����i�߳������ɥ쥹
	/********** ���å쥸�������i�߳����ǩ`�� **********/
	reg			[`WordDataBus]	ra_data;						  // ���Ťʤ�Ra
	wire signed [`WordDataBus]	s_ra_data = $signed(ra_data);	  // ���Ÿ���Ra
	reg			[`WordDataBus]	rb_data;						  // ���Ťʤ�Rb
	wire signed [`WordDataBus]	s_rb_data = $signed(rb_data);	  // ���Ÿ���Rb
	assign mem_wr_data = rb_data; // ��������z�ߥǩ`��
	/********** ���ɥ쥹 **********/
	wire [`WordAddrBus] ret_addr  = if_pc + 1'b1;					 // ���귬��
	wire [`WordAddrBus] br_target = if_pc + imm_s[`WORD_ADDR_MSB:0]; // �����
	wire [`WordAddrBus] jr_target = ra_data[`WordAddrLoc];		   // ��������

	/********** �ե���`�ǥ��� **********/
	always @(*) begin
		/* Ra�쥸���� */
		if ((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_) && 
			(id_dst_addr == ra_addr)) begin
			ra_data = ex_fwd_data;	 // EX���Ʃ`������Υե���`�ǥ���
		end else if ((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_) && 
					 (ex_dst_addr == ra_addr)) begin
			ra_data = mem_fwd_data;	 // MEM���Ʃ`������Υե���`�ǥ���
		end else begin
			ra_data = gpr_rd_data_0; // �쥸�����ե����뤫����i�߳���
		end
		/* Rb�쥸���� */
		if ((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_) && 
			(id_dst_addr == rb_addr)) begin
			rb_data = ex_fwd_data;	 // EX���Ʃ`������Υե���`�ǥ���
		end else if ((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_) && 
					 (ex_dst_addr == rb_addr)) begin
			rb_data = mem_fwd_data;	 // MEM���Ʃ`������Υե���`�ǥ���
		end else begin
			rb_data = gpr_rd_data_1; // �쥸�����ե����뤫����i�߳���
		end
	end

	/********** ��`�ɥϥ��`�ɤΗʳ� **********/
	always @(*) begin
		if ((id_en == `ENABLE) && (id_mem_op == `MEM_OP_LDW) &&
			((id_dst_addr == ra_addr) || (id_dst_addr == rb_addr))) begin
			ld_hazard = `ENABLE;  // ��`�ɥϥ��`��
		end else begin
			ld_hazard = `DISABLE; // �ϥ��`�ɤʤ�
		end
	end

	/********** ����Υǥ��`�� **********/
	always @(*) begin
		/* �ǥե���Ȃ� */
		alu_op	 = `ALU_OP_NOP;
		alu_in_0 = ra_data;
		alu_in_1 = rb_data;
		br_taken = `DISABLE;
		br_flag	 = `DISABLE;
		br_addr	 = {`WORD_ADDR_W{1'b0}};
		mem_op	 = `MEM_OP_NOP;
		ctrl_op	 = `CTRL_OP_NOP;
		dst_addr = rb_addr;
		gpr_we_	 = `DISABLE_;
		exp_code = `ISA_EXP_NO_EXP;
		/* ���ڥ��`�ɤ��ж� */
		if (if_en == `ENABLE) begin
			case (op)
				/* Փ���������� */
				`ISA_OP_ANDR  : begin // �쥸����ͬʿ��Փ��e
					alu_op	 = `ALU_OP_AND;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ANDI  : begin // �쥸�����ȼ�����Փ��e
					alu_op	 = `ALU_OP_AND;
					alu_in_1 = imm_u;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ORR	  : begin // �쥸����ͬʿ��Փ���
					alu_op	 = `ALU_OP_OR;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ORI	  : begin // �쥸�����ȼ�����Փ���
					alu_op	 = `ALU_OP_OR;
					alu_in_1 = imm_u;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_XORR  : begin // �쥸����ͬʿ��������Փ���
					alu_op	 = `ALU_OP_XOR;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_XORI  : begin // �쥸�����ȼ�����������Փ���
					alu_op	 = `ALU_OP_XOR;
					alu_in_1 = imm_u;
					gpr_we_	 = `ENABLE_;
				end
				/* ���g�������� */
				`ISA_OP_ADDSR : begin // �쥸����ͬʿ�η��Ÿ�������
					alu_op	 = `ALU_OP_ADDS;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ADDSI : begin // �쥸�����ȼ����η��Ÿ�������
					alu_op	 = `ALU_OP_ADDS;
					alu_in_1 = imm_s;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ADDUR : begin // �쥸����ͬʿ�η��Ťʤ�����
					alu_op	 = `ALU_OP_ADDU;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_ADDUI : begin // �쥸�����ȼ����η��Ťʤ�����
					alu_op	 = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_SUBSR : begin // �쥸����ͬʿ�η��Ÿ����p��
					alu_op	 = `ALU_OP_SUBS;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_SUBUR : begin // �쥸����ͬʿ�η��Ťʤ��p��
					alu_op	 = `ALU_OP_SUBU;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				/* ���ե����� */
				`ISA_OP_SHRLR : begin // �쥸����ͬʿ��Փ���ҥ��ե�
					alu_op	 = `ALU_OP_SHRL;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_SHRLI : begin // �쥸�����ȼ�����Փ���ҥ��ե�
					alu_op	 = `ALU_OP_SHRL;
					alu_in_1 = imm_u;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_SHLLR : begin // �쥸����ͬʿ��Փ���󥷥ե�
					alu_op	 = `ALU_OP_SHLL;
					dst_addr = rc_addr;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_SHLLI : begin // �쥸�����ȼ�����Փ���󥷥ե�
					alu_op	 = `ALU_OP_SHLL;
					alu_in_1 = imm_u;
					gpr_we_	 = `ENABLE_;
				end
				/* ������� */
				`ISA_OP_BE	  : begin // �쥸����ͬʿ�η��Ÿ������^��Ra == Rb��
					br_addr	 = br_target;
					br_taken = (ra_data == rb_data) ? `ENABLE : `DISABLE;
					br_flag	 = `ENABLE;
				end
				`ISA_OP_BNE	  : begin // �쥸����ͬʿ�η��Ÿ������^��Ra != Rb��
					br_addr	 = br_target;
					br_taken = (ra_data != rb_data) ? `ENABLE : `DISABLE;
					br_flag	 = `ENABLE;
				end
				`ISA_OP_BSGT  : begin // �쥸����ͬʿ�η��Ÿ������^��Ra < Rb��
					br_addr	 = br_target;
					br_taken = (s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
					br_flag	 = `ENABLE;
				end
				`ISA_OP_BUGT  : begin // �쥸����ͬʿ�η��Ťʤ����^��Ra < Rb��
					br_addr	 = br_target;
					br_taken = (ra_data < rb_data) ? `ENABLE : `DISABLE;
					br_flag	 = `ENABLE;
				end
				`ISA_OP_JMP	  : begin // �o�������
					br_addr	 = jr_target;
					br_taken = `ENABLE;
					br_flag	 = `ENABLE;
				end
				`ISA_OP_CALL  : begin // ���`��
					alu_in_0 = {ret_addr, {`BYTE_OFFSET_W{1'b0}}};
					br_addr	 = jr_target;
					br_taken = `ENABLE;
					br_flag	 = `ENABLE;
					dst_addr = `REG_ADDR_W'd31;
					gpr_we_	 = `ENABLE_;
				end
				/* ���ꥢ���������� */
				`ISA_OP_LDW	  : begin // ��`���i�߳���
					alu_op	 = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					mem_op	 = `MEM_OP_LDW;
					gpr_we_	 = `ENABLE_;
				end
				`ISA_OP_STW	  : begin // ��`�ɕ����z��
					alu_op	 = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					mem_op	 = `MEM_OP_STW;
				end
				/* �����ƥॳ�`������ */
				`ISA_OP_TRAP  : begin // �ȥ�å�
					exp_code = `ISA_EXP_TRAP;
				end
				/* �ؘ����� */
				`ISA_OP_RDCR  : begin // �����쥸�������i�߳���
					if (exe_mode == `CPU_KERNEL_MODE) begin
						alu_in_0 = creg_rd_data;
						gpr_we_	 = `ENABLE_;
					end else begin
						exp_code = `ISA_EXP_PRV_VIO;
					end
				end
				`ISA_OP_WRCR  : begin // �����쥸�����ؤΕ����z��
					if (exe_mode == `CPU_KERNEL_MODE) begin
						ctrl_op	 = `CTRL_OP_WRCR;
					end else begin
						exp_code = `ISA_EXP_PRV_VIO;
					end
				end
				`ISA_OP_EXRT  : begin // ���⤫��Ώ͎�
					if (exe_mode == `CPU_KERNEL_MODE) begin
						ctrl_op	 = `CTRL_OP_EXRT;
					end else begin
						exp_code = `ISA_EXP_PRV_VIO;
					end
				end
				/* ������������ */
				default		  : begin // δ���x����
					exp_code = `ISA_EXP_UNDEF_INSN;
				end
			endcase
		end
	end

endmodule
