/* 
 -- ============================================================================
 -- FILE NAME	: cpu.h
 -- DESCRIPTION : CPU�إå�
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __CPU_HEADER__
	`define __CPU_HEADER__	// ���󥯥�`�ɥ��`��

//------------------------------------------------------------------------------
// Operation
//------------------------------------------------------------------------------
	/********** �쥸���� **********/
	`define REG_NUM				 32	  // �쥸������
	`define REG_ADDR_W			 5	  // �쥸�������ɥ쥹��
	`define RegAddrBus			 4:0  // �쥸�������ɥ쥹�Х�
	/********** ����z��Ҫ���ź� **********/
	`define CPU_IRQ_CH			 8	  // IRQ��
	/********** ALU���ڥ��`�� **********/
	// �Х�
	`define ALU_OP_W			 4	  // ALU���ڥ��`�ɷ�
	`define AluOpBus			 3:0  // ALU���ڥ��`�ɥХ�
	// ���ڥ��`��
	`define ALU_OP_NOP			 4'h0 // No Operation
	`define ALU_OP_AND			 4'h1 // AND
	`define ALU_OP_OR			 4'h2 // OR
	`define ALU_OP_XOR			 4'h3 // XOR
	`define ALU_OP_ADDS			 4'h4 // ���Ÿ�������
	`define ALU_OP_ADDU			 4'h5 // ���Ťʤ�����
	`define ALU_OP_SUBS			 4'h6 // ���Ÿ����p��
	`define ALU_OP_SUBU			 4'h7 // ���Ťʤ��p��
	`define ALU_OP_SHRL			 4'h8 // Փ���ҥ��ե�
	`define ALU_OP_SHLL			 4'h9 // Փ���󥷥ե�
	/********** ���ꥪ�ڥ��`�� **********/
	// �Х�
	`define MEM_OP_W			 2	  // ���ꥪ�ڥ��`�ɷ�
	`define MemOpBus			 1:0  // ���ꥪ�ڥ��`�ɥХ�
	// ���ڥ��`��
	`define MEM_OP_NOP			 2'h0 // No Operation
	`define MEM_OP_LDW			 2'h1 // ��`���i�߳���
	`define MEM_OP_STW			 2'h2 // ��`�ɕ����z��
	/********** �������ڥ��`�� **********/
	// �Х�
	`define CTRL_OP_W			 2	  // �������ڥ��`�ɷ�
	`define CtrlOpBus			 1:0  // �������ڥ��`�ɥХ�
	// ���ڥ��`��
	`define CTRL_OP_NOP			 2'h0 // No Operation
	`define CTRL_OP_WRCR		 2'h1 // �����쥸�����ؤΕ����z��
	`define CTRL_OP_EXRT		 2'h2 // ���⤫��Ώ͎�

	/********** �g�Х�`�� **********/
	// �Х�
	`define CPU_EXE_MODE_W		 1	  // �g�Х�`�ɷ�
	`define CpuExeModeBus		 0:0  // �g�Х�`�ɥХ�
	// �g�Х�`��
	`define CPU_KERNEL_MODE		 1'b0 // ���`�ͥ��`��
	`define CPU_USER_MODE		 1'b1 // ��`����`��

//------------------------------------------------------------------------------
// �����쥸����
//------------------------------------------------------------------------------
	/********** ���ɥ쥹�ޥå� **********/
	`define CREG_ADDR_STATUS	 5'h0  // ���Ʃ`����
	`define CREG_ADDR_PRE_STATUS 5'h1  // ǰ�Υ��Ʃ`����
	`define CREG_ADDR_PC		 5'h2  // �ץ���५����
	`define CREG_ADDR_EPC		 5'h3  // ����ץ���५����
	`define CREG_ADDR_EXP_VECTOR 5'h4  // ����٥���
	`define CREG_ADDR_CAUSE		 5'h5  // ����ԭ��쥸����
	`define CREG_ADDR_INT_MASK	 5'h6  // ����z�ߥޥ���
	`define CREG_ADDR_IRQ		 5'h7  // ����z��Ҫ��
	// �i�߳��������I��
	`define CREG_ADDR_ROM_SIZE	 5'h1d // ROM������
	`define CREG_ADDR_SPM_SIZE	 5'h1e // SPM������
	`define CREG_ADDR_CPU_INFO	 5'h1f // CPU���
	/********** �ӥåȥޥå� **********/
	`define CregExeModeLoc		 0	   // �g�Х�`�ɤ�λ��
	`define CregIntEnableLoc	 1	   // ����z���Є���λ��
	`define CregExpCodeLoc		 2:0   // ���⥳�`�ɤ�λ��
	`define CregDlyFlagLoc		 3	   // �ǥ��쥤����åȥե饰��λ��

//------------------------------------------------------------------------------
// �Х����󥿥ե��`��
//------------------------------------------------------------------------------
	/********** �Х����󥿥ե��`����״�B **********/
	// �Х�
	`define BusIfStateBus		 1:0   // ״�B�Х�
	// ״�B
	`define BUS_IF_STATE_IDLE	 2'h0  // �����ɥ�
	`define BUS_IF_STATE_REQ	 2'h1  // �Х��ꥯ������
	`define BUS_IF_STATE_ACCESS	 2'h2  // �Х���������
	`define BUS_IF_STATE_STALL	 2'h3  // ���ȩ`��

//------------------------------------------------------------------------------
// MISC
//------------------------------------------------------------------------------
	/********** �٥��� **********/
	`define RESET_VECTOR		 30'h0 // �ꥻ�åȥ٥���
	/********** ���ե��� **********/
	`define ShAmountBus			 4:0   // ���ե����Х�
	`define ShAmountLoc			 4:0   // ���ե�����λ��

	/********** CPU��� *********/
	`define RELEASE_YEAR		 8'd41 // ������ (YYYY - 1970)
	`define RELEASE_MONTH		 8'd7  // ������
	`define RELEASE_VERSION		 8'd1  // �Щ`�����
	`define RELEASE_REVISION	 8'd0  // ��ӥ����


`endif
