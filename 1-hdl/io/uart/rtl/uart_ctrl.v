/*
 -- ============================================================================
 -- FILE NAME	: uart_ctrl.v
 -- DESCRIPTION : UART�����⥸��`��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ��Ҏ����
 -- ============================================================================
*/

/********** ��ͨ�إå��ե����� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ���e�إå��ե����� **********/
`include "uart.h"

/********** �⥸��`�� **********/
module uart_ctrl (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,		 // ����å�
	input  wire				   reset,	 // ��ͬ�ڥꥻ�å�
	/********** �Х����󥿥ե��`�� **********/
	input  wire				   cs_,		 // ���åץ��쥯��
	input  wire				   as_,		 // ���ɥ쥹���ȥ�`��
	input  wire				   rw,		 // Read / Write
	input  wire [`UartAddrBus] addr,	 // ���ɥ쥹
	input  wire [`WordDataBus] wr_data,	 // �����z�ߥǩ`��
	output reg	[`WordDataBus] rd_data,	 // �i�߳����ǩ`��
	output reg				   rdy_,	 // ��ǥ�
	/********** ����z�� **********/
	output reg				   irq_rx,	 // �������˸���z�ߣ������쥸���� 0��
	output reg				   irq_tx,	 // �������˸���z�ߣ������쥸���� 0��
	/********** �����ź� **********/
	// ��������
	input  wire				   rx_busy,	 // �����Хե饰�������쥸���� 0��
	input  wire				   rx_end,	 // ���������ź�
	input  wire [`ByteDataBus] rx_data,	 // ���ťǩ`��
	// ��������
	input  wire				   tx_busy,	 // �����Хե饰�������쥸���� 0��
	input  wire				   tx_end,	 // ���������ź�
	output reg				   tx_start, // �����_ʼ�ź�
	output reg	[`ByteDataBus] tx_data	 // ���ťǩ`��
);

	/********** �����쥸�ĥ� **********/
	// �����쥸���� 1 : �����ťǩ`��
	reg [`ByteDataBus]		   rx_buf;	 // ���ťХåե�

	/********** UART����Փ�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			rd_data	 <= #1 `WORD_DATA_W'h0;
			rdy_	 <= #1 `DISABLE_;
			irq_rx	 <= #1 `DISABLE;
			irq_tx	 <= #1 `DISABLE;
			rx_buf	 <= #1 `BYTE_DATA_W'h0;
			tx_start <= #1 `DISABLE;
			tx_data	 <= #1 `BYTE_DATA_W'h0;
	   end else begin
			/* ��ǥ������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <= #1 `ENABLE_;
			end else begin
				rdy_	 <= #1 `DISABLE_;
			end
			/* �i�߳����������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
					`UART_ADDR_STATUS	 : begin // �����쥸���� 0
						rd_data	 <= #1 {{`WORD_DATA_W-4{1'b0}}, 
										tx_busy, rx_busy, irq_tx, irq_rx};
					end
					`UART_ADDR_DATA		 : begin // �����쥸���� 1
						rd_data	 <= #1 {{`BYTE_DATA_W*2{1'b0}}, rx_buf};
					end
				endcase
			end else begin
				rd_data	 <= #1 `WORD_DATA_W'h0;
			end
			/* �����z�ߥ������� */
			// �����쥸���� 0 : �������˸���z��
			if (tx_end == `ENABLE) begin
				irq_tx<= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr == `UART_ADDR_STATUS)) begin
				irq_tx<= #1 wr_data[`UartCtrlIrqTx];
			end
			// �����쥸���� 0 : �������˸���z��
			if (rx_end == `ENABLE) begin
				irq_rx<= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr == `UART_ADDR_STATUS)) begin
				irq_rx<= #1 wr_data[`UartCtrlIrqRx];
			end
			// �����쥸���� 1
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `UART_ADDR_DATA)) begin // �����_ʼ
				tx_start <= #1 `ENABLE;
				tx_data	 <= #1 wr_data[`BYTE_MSB:`LSB];
			end else begin
				tx_start <= #1 `DISABLE;
				tx_data	 <= #1 `BYTE_DATA_W'h0;
			end
			/* ���ťǩ`����ȡ���z�� */
			if (rx_end == `ENABLE) begin
				rx_buf	 <= #1 rx_data;
			end
		end
	end

endmodule
