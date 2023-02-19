/*
 -- ============================================================================
 -- FILE NAME	: uart.h
 -- DESCRIPTION : UARTģ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __UART_HEADER__
	`define __UART_HEADER__			// ���󥯥�`�ɥ��`��

/*
 * �����ܤˤĤ��ơ�
 * ?UART�ϥ��å�ȫ��λ����ܲ������Ȥ˥ܩ`��`�Ȥ����ɤ��Ƥ��ޤ���
 *	 �����ܲ�����ܩ`��`�Ȥ���������Ϥϡ�
 *	 UART_DIV_RATE��UART_DIV_CNT_W��UartDivCntBus���������¤�����
 * ?UART_DIV_RATE�Ϸ��ܥ�`�Ȥ��x���Ƥ��ޤ���
 *	 UART_DIV_RATE�ϻ����ܲ�����ܩ`��`�ȤǸ�ä����ˤʤ�ޤ���
 * ?UART_DIV_CNT_W�Ϸ��ܥ����󥿤η����x���Ƥ��ޤ���
 *	 UART_DIV_CNT_W��UART_DIV_RATE��log2�������ˤʤ�ޤ���
 * ?UartDivCntBus��UART_DIV_CNT_W�ΥХ��Ǥ���
 *	 UART_DIV_CNT_W-1:0�Ȥ����¤�����
 *
 * �����ܤ�����
 * ?UART�Υܩ`��`�Ȥ�38,400baud�ǡ����å�ȫ��λ����ܲ�����10MHz�Έ��ϡ�
 *	 UART_DIV_RATE��10,000,000��38,400��260�Ȥʤ�ޤ���
 *	 UART_DIV_CNT_W��log2(260)��9�Ȥʤ�ޤ���
 */

	/********** ���ܥ����� *********/
	`define UART_DIV_RATE	   9'd260  // ���ܥ�`��
	`define UART_DIV_CNT_W	   9	   // ���ܥ����󥿷�
	`define UartDivCntBus	   8:0	   // ���ܥ����󥿥Х�
	/********** ���ɥ쥹�Х� **********/
	`define UartAddrBus		   0:0	// ���ɥ쥹�Х�
	`define UART_ADDR_W		   1	// ���ɥ쥹��
	`define UartAddrLoc		   0:0	// ���ɥ쥹��λ��
	/********** ���ɥ쥹�ޥå� **********/
	`define UART_ADDR_STATUS   1'h0 // �����쥸���� 0 : ���Ʃ`����
	`define UART_ADDR_DATA	   1'h1 // �����쥸���� 1 : �����ťǩ`��
	/********** �ӥåȥޥå� **********/
	`define UartCtrlIrqRx	   0	// �������˸���z��
	`define UartCtrlIrqTx	   1	// �������˸���z��
	`define UartCtrlBusyRx	   2	// �����Хե饰
	`define UartCtrlBusyTx	   3	// �����Хե饰
	/********** �����ť��Ʃ`���� **********/
	`define UartStateBus	   0:0	// ���Ʃ`�����Х�
	`define UART_STATE_IDLE	   1'b0 // ���Ʃ`���� : �����ɥ�״�B
	`define UART_STATE_TX	   1'b1 // ���Ʃ`���� : ������
	`define UART_STATE_RX	   1'b1 // ���Ʃ`���� : ������
	/********** �ӥåȥ����� **********/
	`define UartBitCntBus	   3:0	// �ӥåȥ����󥿥Х�
	`define UART_BIT_CNT_W	   4	// �ӥåȥ����󥿷�
	`define UART_BIT_CNT_START 4'h0 // ������Ȃ� : �����`�ȥӥå�
	`define UART_BIT_CNT_MSB   4'h8 // ������Ȃ� : �ǩ`����MSB
	`define UART_BIT_CNT_STOP  4'h9 // ������Ȃ� : ���ȥåץӥå�
	/********** �ӥåȥ�٥� **********/
	`define UART_START_BIT	   1'b0 // �����`�ȥӥå�
	`define UART_STOP_BIT	   1'b1 // ���ȥåץӥå�

`endif
