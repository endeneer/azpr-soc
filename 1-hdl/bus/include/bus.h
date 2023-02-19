/*
 -- ============================================================================
 -- FILE NAME	: bus.h
 -- DESCRIPTION : ���ߺ궨��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
  -- 1.0.0	  2014/08/2  zhangly	  
 -- ============================================================================
*/

`ifndef __BUS_HEADER__
	`define __BUS_HEADER__			 

	/********** �������� *********/
	`define BUS_MASTER_CH	   4	 // ��������
	`define BUS_MASTER_INDEX_W 2	 // ��������λ��

	/********** ����������*********/
	`define BusOwnerBus		   1:0	 //����������λ���
	`define BUS_OWNER_MASTER_0 2'h0	 // ���������� �� 0����������
	`define BUS_OWNER_MASTER_1 2'h1	 // ���������� �� 1����������
	`define BUS_OWNER_MASTER_2 2'h2	 // ���������� �� 2����������
	`define BUS_OWNER_MASTER_3 2'h3	 // ���������� �� 3����������

	/********** ���ߴ��� *********/
	`define BUS_SLAVE_CH	   8	 // ���ߴ����豸����
	`define BUS_SLAVE_INDEX_W  3	 // ��������λ��
	`define BusSlaveIndexBus   2:0	 // ���ߴ�������λ����
	`define BusSlaveIndexLoc   29:27 // ���ߴ�������λ��

	`define BUS_SLAVE_0		   0	 // 0�����ߴ���
	`define BUS_SLAVE_1		   1	 // 1�����ߴ���
	`define BUS_SLAVE_2		   2	 // 2�����ߴ���
	`define BUS_SLAVE_3		   3	 // 3�����ߴ���
	`define BUS_SLAVE_4		   4	 // 4�����ߴ���
	`define BUS_SLAVE_5		   5	 // 5�����ߴ���
	`define BUS_SLAVE_6		   6	 // 6�����ߴ���
	`define BUS_SLAVE_7		   7	 // 7�����ߴ���

`endif
