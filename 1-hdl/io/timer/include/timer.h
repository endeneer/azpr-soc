/*
 -- ============================================================================
 -- FILE NAME	: timer.h
 -- DESCRIPTION : ��ʱ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __TIMER_HEADER__
	`define __TIMER_HEADER__		 //  

	/********** �Х� **********/
	`define TIMER_ADDR_W		2	 // ���ɥ쥹��
	`define TimerAddrBus		1:0	 // ���ɥ쥹�Х�
	`define TimerAddrLoc		1:0	 // ���ɥ쥹��λ��
	/********** ���ɥ쥹�ޥå� **********/
	`define TIMER_ADDR_CTRL		2'h0 // �����쥸���� 0 : ����ȥ�`��
	`define TIMER_ADDR_INTR		2'h1 // �����쥸���� 1 : ����z��
	`define TIMER_ADDR_EXPR		2'h2 // �����쥸���� 2 : ���˂�
	`define TIMER_ADDR_COUNTER	2'h3 // �����쥸���� 3 : ������
	/********** �ӥåȥޥå� **********/
	// �����쥸���� 0 : ����ȥ�`��
	`define TimerStartLoc		0	 // �����`�ȥӥåȤ�λ��
	`define TimerModeLoc		1	 // ��`�ɥӥåȤ�λ��
	`define TIMER_MODE_ONE_SHOT 1'b0 // ��`�� : ��󥷥�åȥ�����
	`define TIMER_MODE_PERIODIC 1'b1 // ��`�� : ���ڥ�����
	// �����쥸���� 1 : ����z��Ҫ��
	`define TimerIrqLoc			0	 // ����z��Ҫ��ӥåȤ�λ��

`endif
