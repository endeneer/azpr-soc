/*
 -- ============================================================================
 -- FILE NAME	: bus_addr_dec.v
 -- DESCRIPTION : ���ߵ�ַ������ģ�飬���������ܿ�����ĵ�ַ�źţ��ж�Ҫ�����ĸ������豸����ַ�ĸ�3λ��ʾ��ͬ�Ĵ���
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

/********** ��ַ������ģ�� **********/
module bus_addr_dec (
	/********** ��ַ **********/
	input  wire [`WordAddrBus] s_addr, // �����ܿ��ṩ�ĵ�ַ�ź�
	/********** ���Ƭѡ�ź� **********/
	output reg				   s0_cs_, // 0�����ߴ���Ƭѡ�ź�
	output reg				   s1_cs_, // 1�����ߴ���Ƭѡ�ź�
	output reg				   s2_cs_, // 2�����ߴ���Ƭѡ�ź�
	output reg				   s3_cs_, // 3�����ߴ���Ƭѡ�ź�
	output reg				   s4_cs_, // 4�����ߴ���Ƭѡ�ź�
	output reg				   s5_cs_, // 5�����ߴ���Ƭѡ�ź�
	output reg				   s6_cs_, // 6�����ߴ���Ƭѡ�ź�
	output reg				   s7_cs_  // 7�����ߴ���Ƭѡ�ź�
);

	/********** ���ߴ������� **********/
	wire [`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc]; // ȡ��ַ�и�3λ��ʾ�Ĵ�����

	/********** ���ߴ�����·������**********/
	always @(*) begin
		/* ��ʼ��Ƭѡ�ź� */
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;
		/* ѡ���ַ��Ӧ�Ĵ��� */
		case (s_index)
			`BUS_SLAVE_0 : begin // 0�����ߴ���
				s0_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_1 : begin // 1�����ߴ���
				s1_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_2 : begin // 2�����ߴ���
				s2_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_3 : begin // 0�����ߴ���
				s3_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_4 : begin // 4�����ߴ���
				s4_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_5 : begin // 5�����ߴ���
				s5_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_6 : begin // 6�����ߴ���
				s6_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_7 : begin // 7�����ߴ���
				s7_cs_	= `ENABLE_;
			end
		endcase
	end

endmodule
