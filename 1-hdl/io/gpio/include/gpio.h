/*
 -- ============================================================================
 -- FILE NAME	: gpio.h
 -- DESCRIPTION : General Purpose I/O�إå�
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __GPIO_HEADER__
   `define __GPIO_HEADER__			// ���󥯥�`�ɥ��`��

	/********** �ݩ`�����ζ��x **********/
	`define GPIO_IN_CH		   4	// �����ݩ`����
	`define GPIO_OUT_CH		   18	// �����ݩ`����
	`define GPIO_IO_CH		   16	// ������ݩ`����
  
	/********** �Х� **********/
	`define GpioAddrBus		   1:0	// ���ɥ쥹�Х�
	`define GPIO_ADDR_W		   2	// ���ɥ쥹��
	`define GpioAddrLoc		   1:0	// ���ɥ쥹��λ��
	/********** ���ɥ쥹�ޥå� **********/
	`define GPIO_ADDR_IN_DATA  2'h0 // �����쥸���� 0 : �����ݩ`��
	`define GPIO_ADDR_OUT_DATA 2'h1 // �����쥸���� 1 : �����ݩ`��
	`define GPIO_ADDR_IO_DATA  2'h2 // �����쥸���� 2 : ������ݩ`��
	`define GPIO_ADDR_IO_DIR   2'h3 // �����쥸���� 3 : ���������
	/********** ��������� **********/
	`define GPIO_DIR_IN		   1'b0 // ����
	`define GPIO_DIR_OUT	   1'b1 // ����

`endif
