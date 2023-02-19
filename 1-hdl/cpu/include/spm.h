/*
 -- ============================================================================
 -- FILE NAME	: spm.h
 -- DESCRIPTION : ������å��ѥåɥ���إå�
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

`ifndef __SPM_HEADER__
	`define __SPM_HEADER__			  // ���󥯥�`�ɥ��`��

/*
 * ��SPM�Υ������ˤĤ��ơ�
 * ?SPM�Υ�������������ˤϡ�
 *	 SPM_SIZE��SPM_DEPTH��SPM_ADDR_W��SpmAddrBus��SpmAddrLoc���������¤�����
 * ?SPM_SIZE��SPM�Υ��������x���Ƥ��ޤ���
 * ?SPM_DEPTH��SPM������x���Ƥ��ޤ���
 *	 SPM�η��ϻ����Ĥ�32bit��4Byte���̶��ʤΤǡ�
 *	 SPM_DEPTH��SPM_SIZE��4�Ǹ�ä����ˤʤ�ޤ���
 * ?SPM_ADDR_W��SPM�Υ��ɥ쥹�����x���Ƥ��ꡢ
 *	 SPM_DEPTH��log2�������ˤʤ�ޤ���
 * ?SpmAddrBus��SpmAddrLoc��SPM_ADDR_W�ΥХ��Ǥ���
 *	 SPM_ADDR_W-1:0�Ȥ����¤�����
 *
 * ��SPM�Υ�����������
 * ?SPM�Υ�������16384Byte��16KB���Έ��ϡ�
 *	 SPM_DEPTH��16384��4��4096
 *	 SPM_ADDR_W��log2(4096)��12�Ȥʤ�ޤ���
 */

	`define SPM_SIZE   4096 // SPM�Υ�����
	`define SPM_DEPTH  1024 // SPM���
	`define SPM_ADDR_W 10	 // ���ɥ쥹��
	`define SpmAddrBus 9:0	 // ���ɥ쥹�Х�
	`define SpmAddrLoc 9:0	 // ���ɥ쥹��λ��

`endif

