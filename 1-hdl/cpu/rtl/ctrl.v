/*
 -- ============================================================================
 -- FILE NAME	: ctrl.v
 -- DESCRIPTION : ������˥å�
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
`include "rom.h"
`include "spm.h"

/********** �⥸��`�� **********/
module ctrl (
	/********** �����å� & �ꥻ�å� **********/
	input  wire					  clk,			// �����å�
	input  wire					  reset,		// ��ͬ�ڥꥻ�å�
	/********** �����쥸�������󥿥ե��`�� **********/
	input  wire [`RegAddrBus]	  creg_rd_addr, // �i�߳������ɥ쥹
	output reg	[`WordDataBus]	  creg_rd_data, // �i�߳����ǩ`��
	output reg	[`CpuExeModeBus]  exe_mode,		// �g�Х�`��
	/********** ����z�� **********/
	input  wire [`CPU_IRQ_CH-1:0] irq,			// ����z��Ҫ��
	output reg					  int_detect,	// ����z�ߗʳ�
	/********** ID/EX�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus]	  id_pc,		// �ץ�����५����
	/********** MEM/WB�ѥ��ץ饤��쥸���� **********/
	input  wire [`WordAddrBus]	  mem_pc,		// �ץ�����󥫥���
	input  wire					  mem_en,		// �ѥ��ץ饤��ǩ`�����Є�
	input  wire					  mem_br_flag,	// ��᪥ե饰
	input  wire [`CtrlOpBus]	  mem_ctrl_op,	// �����쥸�������ڥ�`�����
	input  wire [`RegAddrBus]	  mem_dst_addr, // �����z�ߥ��ɥ쥹
	input  wire [`IsaExpBus]	  mem_exp_code, // ���⥳�`��
	input  wire [`WordDataBus]	  mem_out,		// �I���Y��
	/********** �ѥ��ץ饤�������ź� **********/
	// �ѥ��ץ饤���״�B
	input  wire					  if_busy,		// IF���Ʃ`���ӥ��`
	input  wire					  ld_hazard,	// ���`�ɥϥ��`��
	input  wire					  mem_busy,		// MEM���Ʃ`���ӥ��`
	// ���ȩ`���ź�
	output wire					  if_stall,		// IF���Ʃ`�����ȩ`��
	output wire					  id_stall,		// ID���Ʃ`�����ȩ`��
	output wire					  ex_stall,		// EX���Ʃ`�����ȩ`��
	output wire					  mem_stall,	// MEM���Ʃ`�����ȩ`��
	// �ե�å����ź�
	output wire					  if_flush,		// IF���Ʃ`���ե�å���
	output wire					  id_flush,		// ID���Ʃ`���ե�å���
	output wire					  ex_flush,		// EX���Ʃ`���ե�å���
	output wire					  mem_flush,	// MEM���Ʃ`���ե�å���
	output reg	[`WordAddrBus]	  new_pc		// �¤����ץ�����५����
);

	/********** �����쥸���� **********/
	reg							 int_en;		// 0�� : ����z���Є�
	reg	 [`CpuExeModeBus]		 pre_exe_mode;	// 1�� : �g�Х�`��
	reg							 pre_int_en;	// 1�� : ����z���Є�
	reg	 [`WordAddrBus]			 epc;			// 3�� : ����ץ�����५����
	reg	 [`WordAddrBus]			 exp_vector;	// 4�� : ����٥���
	reg	 [`IsaExpBus]			 exp_code;		// 5�� : ���⥳�`��
	reg							 dly_flag;		// 6�� : �ǥ��쥤�����åȥե饰
	reg	 [`CPU_IRQ_CH-1:0]		 mask;			// 7�� : ����z�ߥޥ���

	/********** �ڲ��ź� **********/
	reg [`WordAddrBus]		  pre_pc;			// ǰ�Υץ�����५����
	reg						  br_flag;			// ��᪥ե饰

	/********** �ѥ��ץ饤�������ź� **********/
	// ���ȩ`���ź�
	wire   stall	 = if_busy | mem_busy;
	assign if_stall	 = stall | ld_hazard;
	assign id_stall	 = stall;
	assign ex_stall	 = stall;
	assign mem_stall = stall;
	// �ե�å����ź�
	reg	   flush;
	assign if_flush	 = flush;
	assign id_flush	 = flush | ld_hazard;
	assign ex_flush	 = flush;
	assign mem_flush = flush;

	/********** �ѥ��ץ饤��ե�å������� **********/
	always @(*) begin
		/* �ǥե���Ȃ� */
		new_pc = `WORD_ADDR_W'h0;
		flush  = `DISABLE;
		/* �ѥ��ץ饤��ե�å��� */
		if (mem_en == `ENABLE) begin // �ѥ��ץ饤��Υǩ`�����Є�
			if (mem_exp_code != `ISA_EXP_NO_EXP) begin		 // ����k��
				new_pc = exp_vector;
				flush  = `ENABLE;
			end else if (mem_ctrl_op == `CTRL_OP_EXRT) begin // EXRT����
				new_pc = epc;
				flush  = `ENABLE;
			end else if (mem_ctrl_op == `CTRL_OP_WRCR) begin // WRCR����
				new_pc = mem_pc;
				flush  = `ENABLE;
			end
		end
	end

	/********** ����z�ߤΗʳ� **********/
	always @(*) begin
		if ((int_en == `ENABLE) && ((|((~mask) & irq)) == `ENABLE)) begin
			int_detect = `ENABLE;
		end else begin
			int_detect = `DISABLE;
		end
	end
   
	/********** �i�߳����������� **********/
	always @(*) begin
		case (creg_rd_addr)
		   `CREG_ADDR_STATUS	 : begin // 0��:���Ʃ`����
			   creg_rd_data = {{`WORD_DATA_W-2{1'b0}}, int_en, exe_mode};
		   end
		   `CREG_ADDR_PRE_STATUS : begin // 1��:����k��ǰ�Υ��Ʃ`����
			   creg_rd_data = {{`WORD_DATA_W-2{1'b0}}, 
							   pre_int_en, pre_exe_mode};
		   end
		   `CREG_ADDR_PC		 : begin // 2��:�ץ�����५����
			   creg_rd_data = {id_pc, `BYTE_OFFSET_W'h0};
		   end
		   `CREG_ADDR_EPC		 : begin // 3��:����ץ�����५����
			   creg_rd_data = {epc, `BYTE_OFFSET_W'h0};
		   end
		   `CREG_ADDR_EXP_VECTOR : begin // 4��:����٥���
			   creg_rd_data = {exp_vector, `BYTE_OFFSET_W'h0};
		   end
		   `CREG_ADDR_CAUSE		 : begin // 5��:����ԭ��
			   creg_rd_data = {{`WORD_DATA_W-1-`ISA_EXP_W{1'b0}}, 
							   dly_flag, exp_code};
		   end
		   `CREG_ADDR_INT_MASK	 : begin // 6��:����z�ߥޥ���
			   creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}}, mask};
		   end
		   `CREG_ADDR_IRQ		 : begin // 6��:����z��ԭ��
			   creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}}, irq};
		   end
		   `CREG_ADDR_ROM_SIZE	 : begin // 7��:ROM�Υ�����
			   creg_rd_data = $unsigned(`ROM_SIZE);
		   end
		   `CREG_ADDR_SPM_SIZE	 : begin // 8��:SPM�Υ�����
			   creg_rd_data = $unsigned(`SPM_SIZE);
		   end
		   `CREG_ADDR_CPU_INFO	 : begin // 9��:CPU�����
			   creg_rd_data = {`RELEASE_YEAR, `RELEASE_MONTH, 
							   `RELEASE_VERSION, `RELEASE_REVISION};
		   end
		   default				 : begin // �ǥե���Ȃ�
			   creg_rd_data = `WORD_DATA_W'h0;
		   end
		endcase
	end

	/********** CPU������ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			exe_mode	 <=  `CPU_KERNEL_MODE;
			int_en		 <=  `DISABLE;
			pre_exe_mode <=  `CPU_KERNEL_MODE;
			pre_int_en	 <=  `DISABLE;
			exp_code	 <=  `ISA_EXP_NO_EXP;
			mask		 <=  {`CPU_IRQ_CH{`ENABLE}};
			dly_flag	 <=  `DISABLE;
			epc			 <=  `WORD_ADDR_W'h0;
			exp_vector	 <=  `WORD_ADDR_W'h0;
			pre_pc		 <=  `WORD_ADDR_W'h0;
			br_flag		 <=  `DISABLE;
		end else begin
			/* CPU��״�B����� */
			if ((mem_en == `ENABLE) && (stall == `DISABLE)) begin
				/* PC�ȷ�᪥ե饰�α��� */
				pre_pc		 <=  mem_pc;
				br_flag		 <=  mem_br_flag;
				/* CPU�Υ��Ʃ`�������� */
				if (mem_exp_code != `ISA_EXP_NO_EXP) begin		 // ����k��
					exe_mode	 <=  `CPU_KERNEL_MODE;
					int_en		 <=  `DISABLE;
					pre_exe_mode <=  exe_mode;
					pre_int_en	 <=  int_en;
					exp_code	 <=  mem_exp_code;
					dly_flag	 <=  br_flag;
					epc			 <=  pre_pc;
				end else if (mem_ctrl_op == `CTRL_OP_EXRT) begin // EXRT����
					exe_mode	 <=  pre_exe_mode;
					int_en		 <=  pre_int_en;
				end else if (mem_ctrl_op == `CTRL_OP_WRCR) begin // WRCR����
				   /* �����쥸�����ؤΕ����z�� */
					case (mem_dst_addr)
						`CREG_ADDR_STATUS	  : begin // ���Ʃ`����
							exe_mode	 <=  mem_out[`CregExeModeLoc];
							int_en		 <=  mem_out[`CregIntEnableLoc];
						end
						`CREG_ADDR_PRE_STATUS : begin // ����k��ǰ�Υ��Ʃ`����
							pre_exe_mode <=  mem_out[`CregExeModeLoc];
							pre_int_en	 <=  mem_out[`CregIntEnableLoc];
						end
						`CREG_ADDR_EPC		  : begin // ����ץ�����५����
							epc			 <=  mem_out[`WordAddrLoc];
						end
						`CREG_ADDR_EXP_VECTOR : begin // ����٥���
							exp_vector	 <=  mem_out[`WordAddrLoc];
						end
						`CREG_ADDR_CAUSE	  : begin // ����ԭ��
							dly_flag	 <=  mem_out[`CregDlyFlagLoc];
							exp_code	 <=  mem_out[`CregExpCodeLoc];
						end
						`CREG_ADDR_INT_MASK	  : begin // ����z�ߥޥ���
							mask		 <=  mem_out[`CPU_IRQ_CH-1:0];
						end
					endcase
				end
			end
		end
	end

endmodule
