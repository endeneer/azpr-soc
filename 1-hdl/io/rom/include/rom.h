/*
 -- ============================================================================
 -- FILE NAME	: rom.h
 -- DESCRIPTION : ROM �إå�
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __ROM_HEADER__
	`define __ROM_HEADER__			  // ���󥯥�`�ɥ��`��

/*
 * ��ROM�Υ������ˤĤ��ơ�
 * ?ROM�Υ�������������ˤϡ�
 *	 ROM_SIZE��ROM_DEPTH��ROM_ADDR_W��RomAddrBus��RomAddrLoc���������¤�����
 * ?ROM_SIZE��ROM�Υ��������x���Ƥ��ޤ���
 * ?ROM_DEPTH��ROM������x���Ƥ��ޤ���
 *	 ROM�η��ϻ����Ĥ�32bit��4Byte���̶��ʤΤǡ�
 *	 ROM_DEPTH��ROM_SIZE��4�Ǹ�ä����ˤʤ�ޤ���
 * ?ROM_ADDR_W��ROM�Υ��ɥ쥹�����x���Ƥ��ꡢ
 *	 ROM_DEPTH��log2�������ˤʤ�ޤ���
 * ?RomAddrBus��RomAddrLoc��ROM_ADDR_W�ΥХ��Ǥ���
 *	 ROM_ADDR_W-1:0�Ȥ����¤�����
 *
 * ��ROM�Υ�����������
 * ?ROM�Υ�������8192Byte��4KB���Έ��ϡ�
 *	 ROM_DEPTH��8192��4��2048
 *	 ROM_ADDR_W��log2(2048)��11�Ȥʤ�ޤ���
 */

	`define ROM_SIZE   4096 // ROM�Υ�����
	`define ROM_DEPTH  1024 // ROM���
	`define ROM_ADDR_W 10	// ���ɥ쥹��
	`define RomAddrBus 9:0 // ���ɥ쥹�Х�
	`define RomAddrLoc 9:0 // ���ɥ쥹��λ��

`endif

