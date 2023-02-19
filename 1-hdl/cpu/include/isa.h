/* 
 -- ============================================================================
 -- FILE NAME	: isa.h
 -- DESCRIPTION : ����åȥ��`���ƥ�����
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __ISA_HEADER__
	`define __ISA_HEADER__			 // Include Guard

//------------------------------------------------------------------------------
// ����
//------------------------------------------------------------------------------
	/********** ���� **********/
	`define ISA_NOP			   32'h0 // No Operation
	/********** ���ڥ��`�� **********/
	// �Х�
	`define ISA_OP_W		   6	 // ���ڥ��`�ɷ�
	`define IsaOpBus		   5:0	 // ���ڥ��`�ɥХ�
	`define IsaOpLoc		   31:26 // ���ڥ��`�ɤ�λ��
	// ���ڥ��`��
	`define ISA_OP_ANDR		   6'h00 // �쥸����ͬʿ��Փ��e
	`define ISA_OP_ANDI		   6'h01 // �쥸�����ȶ�����Փ��e
	`define ISA_OP_ORR		   6'h02 // �쥸����ͬʿ��Փ���
	`define ISA_OP_ORI		   6'h03 // �쥸�����ȶ�����Փ���
	`define ISA_OP_XORR		   6'h04 // �쥸����ͬʿ��������Փ���
	`define ISA_OP_XORI		   6'h05 // �쥸�����ȶ�����������Փ���
	`define ISA_OP_ADDSR	   6'h06 // �쥸����ͬʿ�η��Ÿ�������
	`define ISA_OP_ADDSI	   6'h07 // �쥸�����ȶ����η��Ÿ�������
	`define ISA_OP_ADDUR	   6'h08 // �쥸����ͬʿ�η��Ťʤ�����
	`define ISA_OP_ADDUI	   6'h09 // �쥸�����ȶ����η��Ťʤ�����
	`define ISA_OP_SUBSR	   6'h0a // �쥸����ͬʿ�η��Ÿ����p��
	`define ISA_OP_SUBUR	   6'h0b // �쥸����ͬʿ�η��Ťʤ��p��
	`define ISA_OP_SHRLR	   6'h0c // �쥸����ͬʿ��Փ���ҥ��ե�
	`define ISA_OP_SHRLI	   6'h0d // �쥸�����ȶ�����Փ���ҥ��ե�
	`define ISA_OP_SHLLR	   6'h0e // �쥸����ͬʿ��Փ���󥷥ե�
	`define ISA_OP_SHLLI	   6'h0f // �쥸�����ȶ�����Փ���󥷥ե�
	`define ISA_OP_BE		   6'h10 // �쥸����ͬʿ�η��Ÿ������^(==)
	`define ISA_OP_BNE		   6'h11 // �쥸����ͬʿ�η��Ÿ������^(!=)
	`define ISA_OP_BSGT		   6'h12 // �쥸����ͬʿ�η��Ÿ������^(<)
	`define ISA_OP_BUGT		   6'h13 // �쥸����ͬʿ�η��Ťʤ����^(<)
	`define ISA_OP_JMP		   6'h14 // �쥸����ָ���ν~�����
	`define ISA_OP_CALL		   6'h15 // �쥸����ָ���Υ��֥�`���󥳩`��
	`define ISA_OP_LDW		   6'h16 // ��`���i�߳���
	`define ISA_OP_STW		   6'h17 // ��`�ɕ����z��
	`define ISA_OP_TRAP		   6'h18 // �ȥ�å�
	`define ISA_OP_RDCR		   6'h19 // �����쥸�������i�߳���
	`define ISA_OP_WRCR		   6'h1a // �����쥸�����ؤΕ����z��
	`define ISA_OP_EXRT		   6'h1b // ���⤫��Ώ͎�
	/********** �쥸�������ɥ쥹 **********/
	// �Х�
	`define ISA_REG_ADDR_W	   5	 // �쥸�������ɥ쥹��
	`define IsaRegAddrBus	   4:0	 // �쥸�������ɥ쥹�Х�
	`define IsaRaAddrLoc	   25:21 // �쥸����Ra��λ��
	`define IsaRbAddrLoc	   20:16 // �쥸����Rb��λ��
	`define IsaRcAddrLoc	   15:11 // �쥸����Rc��λ��
	/********** ���� **********/
	// �Х�
	`define ISA_IMM_W		   16	 // �����η�
	`define ISA_EXT_W		   16	 // �����η��Œ�����
	`define ISA_IMM_MSB		   15	 // ����������λ�ӥå�
	`define IsaImmBus		   15:0	 // �����ΥХ�
	`define IsaImmLoc		   15:0	 // ������λ��

//------------------------------------------------------------------------------
// ����
//------------------------------------------------------------------------------
	/********** ���⥳�`�� **********/
	// �Х�
	`define ISA_EXP_W		   3	 // ���⥳�`�ɷ�
	`define IsaExpBus		   2:0	 // ���⥳�`�ɥХ�
	// ����
	`define ISA_EXP_NO_EXP	   3'h0	 // ����ʤ�
	`define ISA_EXP_EXT_INT	   3'h1	 // �ⲿ����z��
	`define ISA_EXP_UNDEF_INSN 3'h2	 // δ���x����
	`define ISA_EXP_OVERFLOW   3'h3	 // ���g���`�Хե�`
	`define ISA_EXP_MISS_ALIGN 3'h4	 // ���ɥ쥹�ߥ����饤��
	`define ISA_EXP_TRAP	   3'h5	 // �ȥ�å�
	`define ISA_EXP_PRV_VIO	   3'h6	 // �ؘ��`��

`endif
