/*
 -- ============================================================================
 -- FILE NAME	: bus_master_mux.v
 -- DESCRIPTION : �������ض�·������ʵ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ͨ��ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ģ��ͷ�ļ� **********/
`include "bus.h"

/********** ģ�� **********/
module bus_master_mux (
	/********** ��������ź� **********/
	// 0����������
	input  wire [`WordAddrBus] m0_addr,	   // ��ַ
	input  wire				   m0_as_,	   // ��ַѡͨ
	input  wire				   m0_rw,	   // ��/д
	input  wire [`WordDataBus] m0_wr_data, // д�������
	input  wire				   m0_grnt_,   // ��������
	// 1����������
	input  wire [`WordAddrBus] m1_addr,	   // ��ַ
	input  wire				   m1_as_,	   // ��ַѡͨ
	input  wire				   m1_rw,	   // ��/д
	input  wire [`WordDataBus] m1_wr_data, // д�������
	input  wire				   m1_grnt_,   // ��������
	// 3����������
	input  wire [`WordAddrBus] m2_addr,	   // ��ַ
	input  wire				   m2_as_,	   // ��ַѡͨ
	input  wire				   m2_rw,	   // ��/д
	input  wire [`WordDataBus] m2_wr_data, // д�������
	input  wire				   m2_grnt_,   // ��������
	// 3����������
	input  wire [`WordAddrBus] m3_addr,	   // ��ַ
	input  wire				   m3_as_,	   // ��ַѡͨ
	input  wire				   m3_rw,	   // ��/д
	input  wire [`WordDataBus] m3_wr_data, // д�������
	input  wire				   m3_grnt_,   // ��������
	/********** �����ź����ߴ��� **********/
	output reg	[`WordAddrBus] s_addr,	   // ��ַ
	output reg				   s_as_,	   // ��ַѡͨ
	output reg				   s_rw,	   // ��/д
	output reg	[`WordDataBus] s_wr_data   // д�������
);

	/********** �������ض�·������ **********/
	always @(*) begin
		/* ѡ���������ʹ��Ȩ������ */
		if (m0_grnt_ == `ENABLE_) begin			 // 0�������ܿ�
			s_addr	  = m0_addr;
			s_as_	  = m0_as_;
			s_rw	  = m0_rw;
			s_wr_data = m0_wr_data;
		end else if (m1_grnt_ == `ENABLE_) begin // 1�������ܿ�
			s_addr	  = m1_addr;
			s_as_	  = m1_as_;
			s_rw	  = m1_rw;
			s_wr_data = m1_wr_data;
		end else if (m2_grnt_ == `ENABLE_) begin // 2�������ܿ�
			s_addr	  = m2_addr;
			s_as_	  = m2_as_;
			s_rw	  = m2_rw;
			s_wr_data = m2_wr_data;
		end else if (m3_grnt_ == `ENABLE_) begin // 3�������ܿ�
			s_addr	  = m3_addr;
			s_as_	  = m3_as_;
			s_rw	  = m3_rw;
			s_wr_data = m3_wr_data;
		end else begin							 // Ĭ��ֵ
			s_addr	  = `WORD_ADDR_W'h0;
			s_as_	  = `DISABLE_;
			s_rw	  = `READ;
			s_wr_data = `WORD_DATA_W'h0;
		end
	end

endmodule
