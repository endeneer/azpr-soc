/*
 -- ============================================================================
 -- FILE NAME	: uart_rx.v
 -- DESCRIPTION : UART���ť⥸��`��
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
module uart_rx (
	/********** ����å� & �ꥻ�å� **********/
	input  wire				   clk,		// ����å�
	input  wire				   reset,	// ��ͬ�ڥꥻ�å�
	/********** �����ź� **********/
	output wire				   rx_busy, // �����Хե饰
	output reg				   rx_end,	// ���������ź�
	output reg	[`ByteDataBus] rx_data, // ���ťǩ`��
	/********** UART�����ź� **********/
	input  wire				   rx		// UART�����ź�
);

	/********** �ڲ��쥸���� **********/
	reg [`UartStateBus]		   state;	 // ���Ʃ`��
	reg [`UartDivCntBus]	   div_cnt;	 // ���ܥ�����
	reg [`UartBitCntBus]	   bit_cnt;	 // �ӥåȥ�����

	/********** �����Хե饰������ **********/
	assign rx_busy = (state != `UART_STATE_IDLE) ? `ENABLE : `DISABLE;

	/********** ����Փ�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			rx_end	<= #1 `DISABLE;
			rx_data <= #1 `BYTE_DATA_W'h0;
			state	<= #1 `UART_STATE_IDLE;
			div_cnt <= #1 `UART_DIV_RATE / 2;
			bit_cnt <= #1 `UART_BIT_CNT_W'h0;
		end else begin
			/* ���ť��Ʃ`�� */
			case (state)
				`UART_STATE_IDLE : begin // �����ɥ�״�B
					if (rx == `UART_START_BIT) begin // �����_ʼ
						state	<= #1 `UART_STATE_RX;
					end
					rx_end	<= #1 `DISABLE;
				end
				`UART_STATE_RX	 : begin // ������
					/* ����å����ܤˤ��ܩ`��`���{�� */
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // ����
						/* �Υǩ`�������� */
						case (bit_cnt)
							`UART_BIT_CNT_STOP	: begin // ���ȥåץӥåȤ�����
								state	<= #1 `UART_STATE_IDLE;
								bit_cnt <= #1 `UART_BIT_CNT_START;
								div_cnt <= #1 `UART_DIV_RATE / 2;
								/* �ե�`�ߥ󥰥���`�Υ����å� */
								if (rx == `UART_STOP_BIT) begin
									rx_end	<= #1 `ENABLE;
								end
							end
							default				: begin // �ǩ`��������
								rx_data <= #1 {rx, rx_data[`BYTE_MSB:`LSB+1]};
								bit_cnt <= #1 bit_cnt + 1'b1;
								div_cnt <= #1 `UART_DIV_RATE;
							end
						endcase
					end else begin // ������ȥ�����
						div_cnt <= #1 div_cnt - 1'b1;
					end
				end
			endcase
		end
	end

endmodule
