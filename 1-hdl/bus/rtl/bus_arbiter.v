/*
 -- ============================================================================
 -- FILE	 : bus_arbiter.v
 -- SYNOPSIS : �����ٲ���ģ�飬ʹ����ѯ���ư�����˳�����ʹ��Ȩ���䣬��ƽ�ȶԴ�������������
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

/********** �����ٲ��� **********/
module bus_arbiter (
	/********** ʱ���븴λ **********/
	input  wire		   clk,		 // ʱ��
	input  wire		   reset,	 // �첽��λ
	/********** ��������ź� **********/
	//  0����������
	input  wire		   m0_req_,	 // ��������
	output reg		   m0_grnt_, // ��������
	//  1����������
	input  wire		   m1_req_,	 // ��������
	output reg		   m1_grnt_, // ��������
	//  2����������
	input  wire		   m2_req_,	 // ��������
	output reg		   m2_grnt_, // ��������
	//  3����������
	input  wire		   m3_req_,	 // ��������
	output reg		   m3_grnt_	 // ��������
);

	/********** �ڲ��ź� **********/
	reg [`BusOwnerBus] owner;	 // ���ߵ�ǰ������
   
	/********** ��������ʹ��Ȩ**********/
	always @(*) begin
		/* ��������ʹ��Ȩ��ʼ�� */
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;
		/* ��������ʹ��Ȩ */
		case (owner)
			`BUS_OWNER_MASTER_0 : begin // 0����������
				m0_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_1 : begin // 1����������
				m1_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_2 : begin // 2����������
				m2_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_3 : begin // 3����������
				m3_grnt_ = `ENABLE_;
			end
		endcase
	end
   
	/********** ����ʹ��Ȩ�ٲ� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �첽��λ */
			owner <=  `BUS_OWNER_MASTER_0;
		end else begin
			/* �ٲ� */
			case (owner)
				`BUS_OWNER_MASTER_0 : begin // ����ʹ��Ȩ�����ߣ�0����������
					/* ��һ���������ʹ��Ȩ������ */
					if (m0_req_ == `ENABLE_) begin			// 0����������
						owner <=  `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1����������
						owner <=  `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2����������
						owner <=  `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3����������
						owner <=  `BUS_OWNER_MASTER_3;
					end
				end
				`BUS_OWNER_MASTER_1 : begin // ����ʹ��Ȩ�����ߣ�1����������
					/* ��һ���������ʹ��Ȩ������ */
					if (m1_req_ == `ENABLE_) begin			// 1����������
						owner <=  `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2����������
						owner <=  `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3����������
						owner <=  `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0����������
						owner <=  `BUS_OWNER_MASTER_0;
					end
				end
				`BUS_OWNER_MASTER_2 : begin // ����ʹ��Ȩ�����ߣ�2����������
					/* ��һ���������ʹ��Ȩ������ */
					if (m2_req_ == `ENABLE_) begin			// 2����������
						owner <=  `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3����������
						owner <=  `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0����������
						owner <=  `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1����������
						owner <=  `BUS_OWNER_MASTER_1;
					end
				end
				`BUS_OWNER_MASTER_3 : begin // ����ʹ��Ȩ�����ߣ�3����������
					/* ��һ���������ʹ��Ȩ������ */
					if (m3_req_ == `ENABLE_) begin			// 3����������
						owner <=  `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0����������
						owner <=  `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1����������
						owner <=  `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2����������
						owner <=  `BUS_OWNER_MASTER_2;
					end
				end
			endcase
		end
	end

endmodule
