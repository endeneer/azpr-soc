/*
 -- ============================================================================
 -- FILE NAME	: chip_top.v
 -- DESCRIPTION : ����ģ��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ����
 -- 1.0.1	  2014/06/27  zhangly    
 -- ============================================================================
*/
  
/********** ͨ��ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ��Ŀͷ�ļ� **********/
`include "gpio.h"

/********** ģ�� **********/
module chip_top (
	/********** ʱ���븴λ **********/
	input wire				   clk_ref,		  // ����ʱ��
	input wire				   reset_sw		  // ȫ�ָ�λ��ȱʡ����Ϊ���߼�,��global_config.h
	/********** UART **********/
`ifdef IMPLEMENT_UART // UARTʵ��
	, input wire			   uart_rx		  // UART�����ź�
	, output wire			   uart_tx		  // UART�����ź�
`endif
	/********** ͨ��I/ O�˿� **********/
`ifdef IMPLEMENT_GPIO // GPIOʵ��
`ifdef GPIO_IN_CH	 //����ӿ�ʵ��
	, input wire [`GPIO_IN_CH-1:0]	 gpio_in  // ����ӿ�
`endif
`ifdef GPIO_OUT_CH	 // ����ӿ�ʵ��
	, output wire [`GPIO_OUT_CH-1:0] gpio_out // ����ӿ�
`endif
`ifdef GPIO_IO_CH	 // ��������ӿ�ʵ��
	, inout wire [`GPIO_IO_CH-1:0]	 gpio_io  // ��������ӿ�
`endif
`endif
);

	/********** ʱ���븴λ **********/
	wire					   clk;			  	// ʱ��
	wire					   clk_;		  		// ����ʱ��
	wire					   chip_reset;	  	// ��λ
   
	/********** ʱ��ģ�� **********/
	clk_gen clk_gen (
		/**********  ʱ���븴λ **********/
		.clk_ref	  (clk_ref),			  	// ����ʱ��
		.reset_sw	  (reset_sw),			// ȫ�ָ�λ
		/********** ����ʱ�� **********/
		.clk		  (clk),				  		// ʱ��
		.clk_		  (clk_),				  	// ����ʱ��
		/********** ��λ **********/
		.chip_reset	  (chip_reset)			// ��λ
	);

	/********** оƬ **********/
	chip chip (
		/********** ʱ���븴λ **********/
		.clk	  (clk),					  // ʱ��
		.clk_	  (clk_),					  // ����ʱ��
		.reset	  (chip_reset)				  // ��λ
		/********** UART **********/
`ifdef IMPLEMENT_UART
		, .uart_rx	(uart_rx)				  // UART�����ź�
		, .uart_tx	(uart_tx)				  // UART�����ź�
`endif
		/********** GPIO **********/
`ifdef IMPLEMENT_GPIO
`ifdef GPIO_IN_CH  // ����ӿ�ʵ��
		, .gpio_in (gpio_in)				  // ����ӿ�
`endif
`ifdef GPIO_OUT_CH // ����ӿ�ʵ��
		, .gpio_out (gpio_out)				  // ����ӿ�
`endif
`ifdef GPIO_IO_CH  // ��������ӿ�ʵ��
		, .gpio_io	(gpio_io)				  // ��������ӿ�
`endif
`endif
	);

endmodule
