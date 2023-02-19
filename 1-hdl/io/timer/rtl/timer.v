/*
 -- ============================================================================
 -- FILE NAME	: timer.v
 -- DESCRIPTION : ��ʱ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- 1.0.1	  2014/06/27  zhangly
 -- ============================================================================
*/

/********** ͨ��ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ģ��ͷ�ļ� **********/
`include "timer.h"

/********** ģ�� **********/
module timer (
	/********** ʱ���븴λ **********/
	input  wire					clk,	   // ʱ��
	input  wire					reset,	   // �첽��λ
	/********** ���߽ӿ� **********/
	input  wire					cs_,	   // Ƭ��
	input  wire					as_,	   // ��ַѡͨ
	input  wire					rw,		   // Read / Write
	input  wire [`TimerAddrBus] addr,	   // ��ַ
	input  wire [`WordDataBus]	wr_data,   // д����
	output reg	[`WordDataBus]	rd_data,   // ��ȡ����
	output reg					rdy_,	   // ��ǥ�
	/********** �ж���� **********/
	output reg					irq		   // �ж����󣨿��ƼĴ��� 1��
);

	/********** ���ƼĴ��� **********/
	// ���ƼĴ��� 0 : ����
	reg							mode;	   //ģʽ
	reg							start;	   // ��ʼλ
	// ���ƼĴ��� 2 : ����ֵ
	reg [`WordDataBus]			expr_val;  // ����ֵ
	// ���ƼĴ��� 3 : ������
	reg [`WordDataBus]			counter;   // ������

	/********** ���ڱ�־ **********/
	wire expr_flag = ((start == `ENABLE) && (counter == expr_val)) ?
					 `ENABLE : `DISABLE;

	/********** ��ʱ������ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �첽��λ */
			rd_data	 <=  `WORD_DATA_W'h0;
			rdy_	 <=  `DISABLE_;
			start	 <=  `DISABLE;
			mode	 <=  `TIMER_MODE_ONE_SHOT;
			irq		 <=  `DISABLE;
			expr_val <=  `WORD_DATA_W'h0;
			counter	 <=  `WORD_DATA_W'h0;
		end else begin
			/* ׼�������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <=  `ENABLE_;
			end else begin
				rdy_	 <=  `DISABLE_;
			end
			/* ������ */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
					`TIMER_ADDR_CTRL	: begin // ���ƼĴ��� 0
						rd_data	 <=  {{`WORD_DATA_W-2{1'b0}}, mode, start};
					end
					`TIMER_ADDR_INTR	: begin // ���ƼĴ��� 1
						rd_data	 <=  {{`WORD_DATA_W-1{1'b0}}, irq};
					end
					`TIMER_ADDR_EXPR	: begin // ���ƼĴ��� 2
						rd_data	 <=  expr_val;
					end
					`TIMER_ADDR_COUNTER : begin // ���ƼĴ��� 3
						rd_data	 <=  counter;
					end
				endcase
			end else begin
				rd_data	 <=  `WORD_DATA_W'h0;
			end
			/* д���� */
			// ���ƼĴ��� 0
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_CTRL)) begin
				start	 <=  wr_data[`TimerStartLoc];
				mode	 <=  wr_data[`TimerModeLoc];
			end else if ((expr_flag == `ENABLE)	 &&
						 (mode == `TIMER_MODE_ONE_SHOT)) begin
				start	 <=  `DISABLE;
			end
			// ���ƼĴ��� 1
			if (expr_flag == `ENABLE) begin
				irq		 <=  `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr ==	 `TIMER_ADDR_INTR)) begin
				irq		 <=  wr_data[`TimerIrqLoc];
			end
			// ���ƼĴ��� 2
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_EXPR)) begin
				expr_val <=  wr_data;
			end
			// ���ƼĴ��� 3
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_COUNTER)) begin
				counter	 <=  wr_data;
			end else if (expr_flag == `ENABLE) begin
				counter	 <=  `WORD_DATA_W'h0;
			end else if (start == `ENABLE) begin
				counter	 <=  counter + 1'd1;
			end
		end
	end

endmodule
