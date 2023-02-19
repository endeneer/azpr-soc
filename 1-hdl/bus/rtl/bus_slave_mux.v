/*
 -- ============================================================================
 -- FILE NAME	: bus_slave_mux.v
 -- DESCRIPTION :���ߴ�����·������ʵ��
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

/********** ģ�� **********/
module bus_slave_mux (
	/********** �����ź� **********/
	input  wire				   s0_cs_,	   // 0�����ߴ���Ƭѡ
	input  wire				   s1_cs_,	   // 1�����ߴ���Ƭѡ
	input  wire				   s2_cs_,	   // 2�����ߴ���Ƭѡ
	input  wire				   s3_cs_,	   // 3�����ߴ���Ƭѡ
	input  wire				   s4_cs_,	   // 4�����ߴ���Ƭѡ
	input  wire				   s5_cs_,	   // 5�����ߴ���Ƭѡ
	input  wire				   s6_cs_,	   // 6�����ߴ���Ƭѡ
	input  wire				   s7_cs_,	   // 7�����ߴ���Ƭѡ
	/********** �Х�����`���ź� **********/
	// 0�����ߴ���
	input  wire [`WordDataBus] s0_rd_data, // ����������
	input  wire				   s0_rdy_,	   // ����
	// 1�����ߴ���
	input  wire [`WordDataBus] s1_rd_data, // ����������
	input  wire				   s1_rdy_,	   // ����
	// 2�����ߴ���
	input  wire [`WordDataBus] s2_rd_data, // ����������
	input  wire				   s2_rdy_,	   // ����
	// 3�����ߴ���
	input  wire [`WordDataBus] s3_rd_data, // ����������
	input  wire				   s3_rdy_,	   // ����
	// 4�����ߴ���
	input  wire [`WordDataBus] s4_rd_data, // ����������
	input  wire				   s4_rdy_,	   // ����
	// 5�����ߴ���
	input  wire [`WordDataBus] s5_rd_data, // ����������
	input  wire				   s5_rdy_,	   // ����
	// 6�����ߴ���
	input  wire [`WordDataBus] s6_rd_data, // ����������
	input  wire				   s6_rdy_,	   // ����
	// 7�����ߴ���
	input  wire [`WordDataBus] s7_rd_data, // ����������
	input  wire				   s7_rdy_,	   // ����
	/********** �������ع����ź� **********/
	output reg	[`WordDataBus] m_rd_data,  // ����������
	output reg				   m_rdy_	   // ����
);

	/********** ���ߴ�����·������ **********/
	always @(*) begin
		/* ѡ��Ƭѡ�źŶ�Ӧ�Ĵ��� */
		if (s0_cs_ == `ENABLE_) begin		   // ����0�����ߴ���
			m_rd_data = s0_rd_data;
			m_rdy_	  = s0_rdy_;
		end else if (s1_cs_ == `ENABLE_) begin // ����1�����ߴ���
			m_rd_data = s1_rd_data;
			m_rdy_	  = s1_rdy_;
		end else if (s2_cs_ == `ENABLE_) begin // ����2�����ߴ���
			m_rd_data = s2_rd_data;
			m_rdy_	  = s2_rdy_;
		end else if (s3_cs_ == `ENABLE_) begin // ����3�����ߴ���
			m_rd_data = s3_rd_data;
			m_rdy_	  = s3_rdy_;
		end else if (s4_cs_ == `ENABLE_) begin // ����4�����ߴ���
			m_rd_data = s4_rd_data;
			m_rdy_	  = s4_rdy_;
		end else if (s5_cs_ == `ENABLE_) begin // ����5�����ߴ���
			m_rd_data = s5_rd_data;
			m_rdy_	  = s5_rdy_;
		end else if (s6_cs_ == `ENABLE_) begin // ����6�����ߴ���
			m_rd_data = s6_rd_data;
			m_rdy_	  = s6_rdy_;
		end else if (s7_cs_ == `ENABLE_) begin // ����7�����ߴ���
			m_rd_data = s7_rd_data;
			m_rdy_	  = s7_rdy_;
		end else begin						   // Ĭ��ֵ
			m_rd_data = `WORD_DATA_W'h0;
			m_rdy_	  = `DISABLE_;
		end
	end

endmodule
