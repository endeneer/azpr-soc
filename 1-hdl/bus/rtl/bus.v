/*
 -- ============================================================================
 -- FILE NAME	: bus.v
 -- DESCRIPTION : ����
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ����ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ģ��ͷ�ļ� **********/
`include "bus.h"

/********** �⥸��`�� **********/
module bus (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,		   // ����å�
	input  wire				   reset,	   // ��ͬ�ڥꥻ�å�
	/********** �Х��ޥ����ź� **********/
	// �Х��ޥ�����ͨ�ź�
	output wire [`WordDataBus] m_rd_data,  // �i�߳����ǩ`��
	output wire				   m_rdy_,	   // ��ǥ�
	// �Х��ޥ���0��
	input  wire				   m0_req_,	   // �Х��ꥯ������
	input  wire [`WordAddrBus] m0_addr,	   // ���ɥ쥹
	input  wire				   m0_as_,	   // ���ɥ쥹���ȥ�`��
	input  wire				   m0_rw,	   // �i�ߣ�����
	input  wire [`WordDataBus] m0_wr_data, // �����z�ߥǩ`��
	output wire				   m0_grnt_,   // �Х�������
	// �Х��ޥ���1��
	input  wire				   m1_req_,	   // �Х��ꥯ������
	input  wire [`WordAddrBus] m1_addr,	   // ���ɥ쥹
	input  wire				   m1_as_,	   // ���ɥ쥹���ȥ�`��
	input  wire				   m1_rw,	   // �i�ߣ�����
	input  wire [`WordDataBus] m1_wr_data, // �����z�ߥǩ`��
	output wire				   m1_grnt_,   // �Х�������
	// �Х��ޥ���2��
	input  wire				   m2_req_,	   // �Х��ꥯ������
	input  wire [`WordAddrBus] m2_addr,	   // ���ɥ쥹
	input  wire				   m2_as_,	   // ���ɥ쥹���ȥ�`��
	input  wire				   m2_rw,	   // �i�ߣ�����
	input  wire [`WordDataBus] m2_wr_data, // �����z�ߥǩ`��
	output wire				   m2_grnt_,   // �Х�������
	// �Х��ޥ���3��
	input  wire				   m3_req_,	   // �Х��ꥯ������
	input  wire [`WordAddrBus] m3_addr,	   // ���ɥ쥹
	input  wire				   m3_as_,	   // ���ɥ쥹���ȥ�`��
	input  wire				   m3_rw,	   // �i�ߣ�����
	input  wire [`WordDataBus] m3_wr_data, // �����z�ߥǩ`��
	output wire				   m3_grnt_,   // �Х�������
	/********** �Х�����`���ź� **********/
	// �Х�����`�ֹ�ͨ�ź�
	output wire [`WordAddrBus] s_addr,	   // ���ɥ쥹
	output wire				   s_as_,	   // ���ɥ쥹���ȥ�`��
	output wire				   s_rw,	   // �i�ߣ�����
	output wire [`WordDataBus] s_wr_data,  // �����z�ߥǩ`��
	// �Х�����`��0��
	input  wire [`WordDataBus] s0_rd_data, // �i�߳����ǩ`��
	input  wire				   s0_rdy_,	   // ��ǥ�
	output wire				   s0_cs_,	   // ���åץ��쥯��
	// �Х�����`��1��
	input  wire [`WordDataBus] s1_rd_data, // �i�߳����ǩ`��
	input  wire				   s1_rdy_,	   // ��ǥ�
	output wire				   s1_cs_,	   // ���åץ��쥯��
	// �Х�����`��2��
	input  wire [`WordDataBus] s2_rd_data, // �i�߳����ǩ`��
	input  wire				   s2_rdy_,	   // ��ǥ�
	output wire				   s2_cs_,	   // ���åץ��쥯��
	// �Х�����`��3��
	input  wire [`WordDataBus] s3_rd_data, // �i�߳����ǩ`��
	input  wire				   s3_rdy_,	   // ��ǥ�
	output wire				   s3_cs_,	   // ���åץ��쥯��
	// �Х�����`��4��
	input  wire [`WordDataBus] s4_rd_data, // �i�߳����ǩ`��
	input  wire				   s4_rdy_,	   // ��ǥ�
	output wire				   s4_cs_,	   // ���åץ��쥯��
	// �Х�����`��5��
	input  wire [`WordDataBus] s5_rd_data, // �i�߳����ǩ`��
	input  wire				   s5_rdy_,	   // ��ǥ�
	output wire				   s5_cs_,	   // ���åץ��쥯��
	// �Х�����`��6��
	input  wire [`WordDataBus] s6_rd_data, // �i�߳����ǩ`��
	input  wire				   s6_rdy_,	   // ��ǥ�
	output wire				   s6_cs_,	   // ���åץ��쥯��
	// �Х�����`��7��
	input  wire [`WordDataBus] s7_rd_data, // �i�߳����ǩ`��
	input  wire				   s7_rdy_,	   // ��ǥ�
	output wire				   s7_cs_	   // ���åץ��쥯��
);

	/********** �Х����`�ӥ� **********/
	bus_arbiter bus_arbiter (
		/********** ����å� & �ꥻ�å� **********/
		.clk		(clk),		  // ����å�
		.reset		(reset),	  // ��ͬ�ڥꥻ�å�
		/********** ���`�ӥȥ�`������ź� **********/
		// �Х��ޥ���0��
		.m0_req_	(m0_req_),	  // �Х��ꥯ������
		.m0_grnt_	(m0_grnt_),	  // �Х�������
		// �Х��ޥ���1��
		.m1_req_	(m1_req_),	  // �Х��ꥯ������
		.m1_grnt_	(m1_grnt_),	  // �Х�������
		// �Х��ޥ���2��
		.m2_req_	(m2_req_),	  // �Х��ꥯ������
		.m2_grnt_	(m2_grnt_),	  // �Х�������
		// �Х��ޥ���3��
		.m3_req_	(m3_req_),	  // �Х��ꥯ������
		.m3_grnt_	(m3_grnt_)	  // �Х�������
	);

	/********** �Х��ޥ����ޥ���ץ쥯�� **********/
	bus_master_mux bus_master_mux (
		/********** �Х��ޥ����ź� **********/
		// �Х��ޥ���0��
		.m0_addr	(m0_addr),	  // ���ɥ쥹
		.m0_as_		(m0_as_),	  // ���ɥ쥹���ȥ�`��
		.m0_rw		(m0_rw),	  // �i�ߣ�����
		.m0_wr_data (m0_wr_data), // �����z�ߥǩ`��
		.m0_grnt_	(m0_grnt_),	  // �Х�������
		// �Х��ޥ���1��
		.m1_addr	(m1_addr),	  // ���ɥ쥹
		.m1_as_		(m1_as_),	  // ���ɥ쥹���ȥ�`��
		.m1_rw		(m1_rw),	  // �i�ߣ�����
		.m1_wr_data (m1_wr_data), // �����z�ߥǩ`��
		.m1_grnt_	(m1_grnt_),	  // �Х�������
		// �Х��ޥ���2��
		.m2_addr	(m2_addr),	  // ���ɥ쥹
		.m2_as_		(m2_as_),	  // ���ɥ쥹���ȥ�`��
		.m2_rw		(m2_rw),	  // �i�ߣ�����
		.m2_wr_data (m2_wr_data), // �����z�ߥǩ`��
		.m2_grnt_	(m2_grnt_),	  // �Х�������
		// �Х��ޥ���3��
		.m3_addr	(m3_addr),	  // ���ɥ쥹
		.m3_as_		(m3_as_),	  // ���ɥ쥹���ȥ�`��
		.m3_rw		(m3_rw),	  // �i�ߣ�����
		.m3_wr_data (m3_wr_data), // �����z�ߥǩ`��
		.m3_grnt_	(m3_grnt_),	  // �Х�������
		/********** �Х�����`�ֹ�ͨ�ź� **********/
		.s_addr		(s_addr),	  // ���ɥ쥹
		.s_as_		(s_as_),	  // ���ɥ쥹���ȥ�`��
		.s_rw		(s_rw),		  // �i�ߣ�����
		.s_wr_data	(s_wr_data)	  // �����z�ߥǩ`��
	);

	/********** ���ɥ쥹�ǥ��`�� **********/
	bus_addr_dec bus_addr_dec (
		/********** ���ɥ쥹 **********/
		.s_addr		(s_addr),	  // ���ɥ쥹
		/********** ���åץ��쥯�� **********/
		.s0_cs_		(s0_cs_),	  // �Х�����`��0��
		.s1_cs_		(s1_cs_),	  // �Х�����`��1��
		.s2_cs_		(s2_cs_),	  // �Х�����`��2��
		.s3_cs_		(s3_cs_),	  // �Х�����`��3��
		.s4_cs_		(s4_cs_),	  // �Х�����`��4��
		.s5_cs_		(s5_cs_),	  // �Х�����`��5��
		.s6_cs_		(s6_cs_),	  // �Х�����`��6��
		.s7_cs_		(s7_cs_)	  // �Х�����`��7��
	);

	/********** �Х�����`�֥ޥ���ץ쥯�� **********/
	bus_slave_mux bus_slave_mux (
		/********** ���åץ��쥯�� **********/
		.s0_cs_		(s0_cs_),	  // �Х�����`��0��
		.s1_cs_		(s1_cs_),	  // �Х�����`��1��
		.s2_cs_		(s2_cs_),	  // �Х�����`��2��
		.s3_cs_		(s3_cs_),	  // �Х�����`��3��
		.s4_cs_		(s4_cs_),	  // �Х�����`��4��
		.s5_cs_		(s5_cs_),	  // �Х�����`��5��
		.s6_cs_		(s6_cs_),	  // �Х�����`��6��
		.s7_cs_		(s7_cs_),	  // �Х�����`��7��
		/********** �Х�����`���ź� **********/
		// �Х�����`��0��
		.s0_rd_data (s0_rd_data), // �i�߳����ǩ`��
		.s0_rdy_	(s0_rdy_),	  // ��ǥ�
		// �Х�����`��1��
		.s1_rd_data (s1_rd_data), // �i�߳����ǩ`��
		.s1_rdy_	(s1_rdy_),	  // ��ǥ�
		// �Х�����`��2��
		.s2_rd_data (s2_rd_data), // �i�߳����ǩ`��
		.s2_rdy_	(s2_rdy_),	  // ��ǥ�
		// �Х�����`��3��
		.s3_rd_data (s3_rd_data), // �i�߳����ǩ`��
		.s3_rdy_	(s3_rdy_),	  // ��ǥ�
		// �Х�����`��4��
		.s4_rd_data (s4_rd_data), // �i�߳����ǩ`��
		.s4_rdy_	(s4_rdy_),	  // ��ǥ�
		// �Х�����`��5��
		.s5_rd_data (s5_rd_data), // �i�߳����ǩ`��
		.s5_rdy_	(s5_rdy_),	  // ��ǥ�
		// �Х�����`��6��
		.s6_rd_data (s6_rd_data), // �i�߳����ǩ`��
		.s6_rdy_	(s6_rdy_),	  // ��ǥ�
		// �Х�����`��7��
		.s7_rd_data (s7_rd_data), // �i�߳����ǩ`��
		.s7_rdy_	(s7_rdy_),	  // ��ǥ�
		/********** �Х��ޥ�����ͨ�ź� **********/
		.m_rd_data	(m_rd_data),  // �i�߳����ǩ`��
		.m_rdy_		(m_rdy_)	  // ��ǥ�
	);

endmodule
