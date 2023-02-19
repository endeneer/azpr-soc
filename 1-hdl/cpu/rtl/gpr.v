/* 
 -- ============================================================================
 -- FILE NAME	: gpr.v
 -- DESCRIPTION : ���å쥸����
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ��ͨ�إå��ե����� **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** ���e�إå��ե����� **********/
`include "cpu.h"

/********** �⥸��`�� **********/
module gpr (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,				   // �����å�
	input  wire				   reset,			   // ��ͬ�ڥꥻ�å�
	/********** �i�߳����ݩ`�� 0 **********/
	input  wire [`RegAddrBus]  rd_addr_0,		   // �i�߳������ɥ쥹
	output wire [`WordDataBus] rd_data_0,		   // �i�߳����ǩ`��
	/********** �i�߳����ݩ`�� 1 **********/
	input  wire [`RegAddrBus]  rd_addr_1,		   // �i�߳������ɥ쥹
	output wire [`WordDataBus] rd_data_1,		   // �i�߳����ǩ`��
	/********** �����z�ߥݩ`�� **********/
	input  wire				   we_,				   // �����z���Є�
	input  wire [`RegAddrBus]  wr_addr,			   // �����z�ߥ��ɥ쥹
	input  wire [`WordDataBus] wr_data			   // �����z�ߥǩ`��
);

	/********** �ڲ��ź� **********/
	reg [`WordDataBus]		   gpr [`REG_NUM-1:0]; // �쥸��������
	integer					   i;				   // ���ƥ�`��

	/********** �i�߳����������� (Write After Read) **********/
	// �i�߳����ݩ`�� 0
	assign rd_data_0 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_0)) ? 
					   wr_data : gpr[rd_addr_0];
	// �i�߳����ݩ`�� 1
	assign rd_data_1 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_1)) ? 
					   wr_data : gpr[rd_addr_1];
   
	/********** �����z�ߥ������� **********/
	always @ (posedge clk or `RESET_EDGE reset) begin
		i = 0;
		if (reset == `RESET_ENABLE) begin 
			/* ��ͬ�ڥꥻ�å� */
			for (i = 0; i < `REG_NUM; i = i + 1) begin
				gpr[i]		 <=  `WORD_DATA_W'h0;
			end
		end else begin
			/* �����z�ߥ������� */
			if (we_ == `ENABLE_) begin 
				gpr[wr_addr] <=  wr_data;
			end
		end
	end

endmodule 
