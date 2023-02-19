/*
 -- ============================================================================
 -- FILE NAME	: global_config.h
 -- DESCRIPTION : ȫ������
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- 1.0.1	  2014/07/27  zhangly 
 -- ============================================================================
*/

`ifndef __GLOBAL_CONFIG_HEADER__
	`define __GLOBAL_CONFIG_HEADER__	//  

//------------------------------------------------------------------------------
// �O���Ŀ
//------------------------------------------------------------------------------
	/********** Ŀ�꿪�������� **********/
//	`define TARGET_DEV_MFPGA_SPAR3E		// MFPGA��
	`define TARGET_DEV_AZPR_EV_BOARD	// AZPRԭ����

/********** ��λ�źż���ѡ��**********/
//	`define POSITIVE_RESET				// Active High
	`define NEGATIVE_RESET				// Active Low

	/********** �ڴ�����źż���ѡ�� **********/
	`define POSITIVE_MEMORY				// Active High
//	`define NEGATIVE_MEMORY				// Active Low

	/********** I/O �豸ѡ��**********/
	`define IMPLEMENT_TIMER				// ��ʱ��
	`define IMPLEMENT_UART				// UART
	`define IMPLEMENT_GPIO				// General Purpose I/O

//------------------------------------------------------------------------------
// ���ɵĲ���ȡ��������
//------------------------------------------------------------------------------
/********** ��λ���� *********/
	// Active Low
	`ifdef POSITIVE_RESET
		`define RESET_EDGE	  posedge	// ������
		`define RESET_ENABLE  1'b1		// ��λ��Ч
		`define RESET_DISABLE 1'b0		// ��λ��Ч
	`endif
	// Active High
	`ifdef NEGATIVE_RESET
		`define RESET_EDGE	  negedge	// �½���
		`define RESET_ENABLE  1'b0		// ��λ��Ч
		`define RESET_DISABLE 1'b1		// ��λ��Ч
	`endif

	/********** �ڴ�����źż��� *********/
	// Actoive High
	`ifdef POSITIVE_MEMORY
		`define MEM_ENABLE	  1'b1		// �ڴ���Ч
		`define MEM_DISABLE	  1'b0		// �ڴ���Ч
	`endif
	// Active Low
	`ifdef NEGATIVE_MEMORY
		`define MEM_ENABLE	  1'b0		// �ڴ���Ч
		`define MEM_DISABLE	  1'b1		// �ڴ���Ч
	`endif

`endif
