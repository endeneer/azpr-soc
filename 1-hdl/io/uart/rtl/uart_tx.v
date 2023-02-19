/*
 -- ============================================================================
 -- FILE NAME	: uart_tx.v
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
module uart_tx (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,		 // �����å�
	input  wire				   reset,	 // ��ͬ�ڥꥻ�å�
	/********** �����ź� **********/
	input  wire				   tx_start, // �����_ʼ�ź�
	input  wire [`ByteDataBus] tx_data,	 // ���ťǩ`��
	output wire				   tx_busy,	 // �����Хե饰
	output reg				   tx_end,	 // ���������ź�
	/********** UART�����ź� **********/
	output reg				   tx		 // UART�����ź�
);

	/********** �ڲ��ź� **********/
	reg [`UartStateBus]		   state;	 // ���Ʃ`��
	reg [`UartDivCntBus]	   div_cnt;	 // ���ܥ�����
	reg [`UartBitCntBus]	   bit_cnt;	 // �ӥåȥ�����
	reg [`ByteDataBus]		   sh_reg;	 // �����å��եȥ쥸����

	/********** �����Хե饰������ **********/
	assign tx_busy = (state == `UART_STATE_TX) ? `ENABLE : `DISABLE;

	/********** ����Փ�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			state	<=  `UART_STATE_IDLE;
			div_cnt <=  `UART_DIV_RATE;
			bit_cnt <=  `UART_BIT_CNT_START;
			sh_reg	<=  `BYTE_DATA_W'h0;
			tx_end	<=  `DISABLE;
			tx		<=  `UART_STOP_BIT;
		end else begin
			/* ���ť��Ʃ`�� */
			case (state)
				`UART_STATE_IDLE : begin // �����ɥ�״�B
					if (tx_start == `ENABLE) begin // �����_ʼ
						state	<=  `UART_STATE_TX;
						sh_reg	<=  tx_data;
						tx		<=  `UART_START_BIT;
					end
					tx_end	<=  `DISABLE;
				end
				`UART_STATE_TX	 : begin // ������
					/* �����å����ܤˤ��ܩ`��`���{�� */
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // ����
						/* �Υǩ`�������� */
						case (bit_cnt)
							`UART_BIT_CNT_MSB  : begin // ���ȥåץӥåȤ�����
								bit_cnt <=  `UART_BIT_CNT_STOP;
								tx		<=  `UART_STOP_BIT;
							end
							`UART_BIT_CNT_STOP : begin // ��������
								state	<=  `UART_STATE_IDLE;
								bit_cnt <=  `UART_BIT_CNT_START;
								tx_end	<=  `ENABLE;
							end
							default			   : begin // �ǩ`��������
								bit_cnt <=  bit_cnt + 1'b1;
								sh_reg	<=  sh_reg >> 1'b1;
								tx		<=  sh_reg[`LSB];
							end
						endcase
						div_cnt <=  `UART_DIV_RATE;
					end else begin // ������ȥ�����
						div_cnt <=  div_cnt - 1'b1 ;
					end
				end
			endcase
		end
	end

endmodule
