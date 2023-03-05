/*
 -- ============================================================================
 -- FILE NAME	: chip.v
 -- DESCRIPTION : chipģ����װCPU�����ߡ����ߴ����豸��ROM��UART��GPIO��TIMER��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ����
 -- 1.0.1	  2014/07/27  zhangly    ����������ŷ���ʱ gpio_in Լ�����ĸ�key��Ϊ���߼�
 -- ============================================================================
*/

/********** ͨ��ͷ�ļ� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ��Ŀͷ�ļ� **********/
`include "cpu.h"
`include "bus.h"
`include "rom.h"
`include "timer.h"
`include "uart.h"
`include "gpio.h"

/********** ģ�� **********/
module chip (
	/********** ʱ���븴λ **********/
	input  wire						 clk,		  // ʱ��
	input  wire						 clk_,		  // ����ʱ��
	input  wire						 reset		  // ��λ
	/********** UART  **********/
`ifdef IMPLEMENT_UART //  UARTʵ��
	, input	 wire					 uart_rx	  // UART�����ź�
	, output wire					 uart_tx	  // UART�����ź�
`endif
	/********** ͨ��I/ O�˿� **********/
`ifdef IMPLEMENT_GPIO //GPIOʵ��
`ifdef GPIO_IN_CH	 // ����ӿ�ʵ��
	, input wire [`GPIO_IN_CH-1:0]	 gpio_in	  // ����ӿ�
`endif
`ifdef GPIO_OUT_CH	 //  ����ӿ�ʵ��
	, output wire [`GPIO_OUT_CH-1:0] gpio_out	  // ����ӿ�
`endif
`ifdef GPIO_IO_CH	 // ��������ӿ�ʵ��
	, inout wire [`GPIO_IO_CH-1:0]	 gpio_io	  // ��������ӿ�
`endif
`endif
);

	/********** �����ź� **********/
	// ���������ź�
	wire [`WordDataBus] m_rd_data;				  // ��ȡ����
	wire				m_rdy_;					  // ��ǥ�
	// ��������0
	wire				m0_req_;				  // ��������
	wire [`WordAddrBus] m0_addr;				  // ��ַ
	wire				m0_as_;					  // ��ַѡͨ
	wire				m0_rw;					  // ��/д
	wire [`WordDataBus] m0_wr_data;				  // ����
	wire				m0_grnt_;				  // ������Ȩ
	// ��������1
	wire				m1_req_;				  // ��������
	wire [`WordAddrBus] m1_addr;				  // ��ַ
	wire				m1_as_;					  // ��ַѡͨ
	wire				m1_rw;					  // ��/д
	wire [`WordDataBus] m1_wr_data;				  // ����
	wire				m1_grnt_;				  // ������Ȩ
	// ��������2
	wire				m2_req_;				  // ��������
	wire [`WordAddrBus] m2_addr;				  // ��ַ
	wire				m2_as_;					  // ��ַѡͨ
	wire				m2_rw;					  // ��/д
	wire [`WordDataBus] m2_wr_data;				  // ����
	wire				m2_grnt_;				  // ������Ȩ
	// ��������3
	wire				m3_req_;				  // ��������
	wire [`WordAddrBus] m3_addr;				  // ��ַ
	wire				m3_as_;					  // ��ַѡͨ
	wire				m3_rw;					  // ��/д
	wire [`WordDataBus] m3_wr_data;				  // ����
	wire				m3_grnt_;				  // ������Ȩ
	/********** ���ߴ��豸�ź�**********/
	//���д��豸�����ź�
	wire [`WordAddrBus] s_addr;					  // ��ַ
	wire				s_as_;					  // ��ַѡͨ
	wire				s_rw;					  // ��/д
	wire [`WordDataBus] s_wr_data;				  // д������
	// 0�����ߴ��豸
	wire [`WordDataBus] s0_rd_data;				  // ��ȡ����
	wire				s0_rdy_;				  // ����
	wire				s0_cs_;					  // Ƭѡ
	// 1�����ߴ��豸
	wire [`WordDataBus] s1_rd_data;				  // ��ȡ����
	wire				s1_rdy_;				  // ����
	wire				s1_cs_;					  // Ƭѡ
	// 2�����ߴ��豸
	wire [`WordDataBus] s2_rd_data;				  // ��ȡ����
	wire				s2_rdy_;				  // ����
	wire				s2_cs_;					  // Ƭѡ
	// 3�����ߴ��豸
	wire [`WordDataBus] s3_rd_data;				  // ��ȡ����
	wire				s3_rdy_;				  // ����
	wire				s3_cs_;					  // Ƭѡ
	// 4�����ߴ��豸
	wire [`WordDataBus] s4_rd_data;				  // ��ȡ����
	wire				s4_rdy_;				  // ����
	wire				s4_cs_;					  // Ƭѡ
	// 5�����ߴ��豸
	wire [`WordDataBus] s5_rd_data;				  // ��ȡ����
	wire				s5_rdy_;				  // ����
	wire				s5_cs_;					  // Ƭѡ
	// 6�����ߴ��豸
	wire [`WordDataBus] s6_rd_data;				  // ��ȡ����
	wire				s6_rdy_;				  // ����
	wire				s6_cs_;					  // Ƭѡ
	// 7�����ߴ��豸
	wire [`WordDataBus] s7_rd_data;				  // ��ȡ����
	wire				s7_rdy_;				  // ����
	wire				s7_cs_;					  // Ƭѡ
	/**********�ж������ź� **********/
	wire				   irq_timer;			  // ��ʱ���ж�
	wire				   irq_uart_rx;			  // UART IRQ����ȡ��
	wire				   irq_uart_tx;			  // UART IRQ�����ͣ�
	wire [`CPU_IRQ_CH-1:0] cpu_irq;				  // CPU IRQ

	assign cpu_irq = {{`CPU_IRQ_CH-3{`LOW}}, 
					  irq_uart_rx, irq_uart_tx, irq_timer};

	/********** CPU **********/
	cpu cpu (
		/********** ʱ���븴λ **********/
		.clk			 (clk),					  // ʱ��
		.clk_			 (clk_),				  // ����ʱ��
		.reset			 (reset),				  // ��λ
		/********** ���߽ӿ� **********/
		// IF Stage ָ���ȡ--��������0
		.if_bus_rd_data	 (m_rd_data),			  // ����������
		.if_bus_rdy_	 (m_rdy_),				  // ����
		.if_bus_grnt_	 (m0_grnt_),			  // ������Ȩ
		.if_bus_req_	 (m0_req_),				  // ��������
		.if_bus_addr	 (m0_addr),				  // ��ַ
		.if_bus_as_		 (m0_as_),				  // ��ַѡͨ
		.if_bus_rw		 (m0_rw),				  // ��/д
		.if_bus_wr_data	 (m0_wr_data),			  // д�������
		// MEM Stage �ڴ����--��������1
		.mem_bus_rd_data (m_rd_data),			  // ����������
		.mem_bus_rdy_	 (m_rdy_),				  // ����
		.mem_bus_grnt_	 (m1_grnt_),			  // ������Ȩ
		.mem_bus_req_	 (m1_req_),				  // ��������
		.mem_bus_addr	 (m1_addr),				  // ��ַ
		.mem_bus_as_	 (m1_as_),				  // ��ַѡͨ
		.mem_bus_rw		 (m1_rw),				  // ��/д
		.mem_bus_wr_data (m1_wr_data),			  // д�������
		/********** �ж� **********/
		.cpu_irq		 (cpu_irq)				  // �ж�����
	);

	/********** ��������2 : δ�gװ **********/
	assign m2_addr	  = `WORD_ADDR_W'h0;
	assign m2_as_	  = `DISABLE_;
	assign m2_rw	  = `READ;
	assign m2_wr_data = `WORD_DATA_W'h0;
	assign m2_req_	  = `DISABLE_;

	/********** �������� 3 : δ�gװ **********/
	assign m3_addr	  = `WORD_ADDR_W'h0;
	assign m3_as_	  = `DISABLE_;
	assign m3_rw	  = `READ;
	assign m3_wr_data = `WORD_DATA_W'h0;
	assign m3_req_	  = `DISABLE_;
   
	/********** ���ߴ��豸 0 : ROM **********/
	rom rom (
		/********** Clock & Reset **********/
		.clk			 (clk),					  // ʱ��
		.reset			 (reset),				  // �첽��λ
		/**********���߽ӿ� **********/
		.cs_			 (s0_cs_),				  // Ƭѡ
		.as_			 (s_as_),				  // ��ַѡͨ
		.addr			 (s_addr[`RomAddrLoc]),	  // ��ַ
		.rd_data		 (s0_rd_data),			  // ����������
		.rdy_			 (s0_rdy_)				  // ����
	);

	/********** ���ߴ��豸 1 : Scratch Pad Memory����������RAM��ͨ������ֱ�ӷ��� **********/
	assign s1_rd_data = `WORD_DATA_W'h0;
	assign s1_rdy_	  = `DISABLE_;

	/********** ���ߴ��豸 2 : ��ʱ�� **********/
`ifdef IMPLEMENT_TIMER // ��ʱ��ѡװ
	timer timer (
		/********** ʱ���븴λ **********/
		.clk			 (clk),					  // ʱ��
		.reset			 (reset),				  // �첽��λ
		/********** ���߽ӿ� **********/
		.cs_			 (s2_cs_),				  // Ƭѡ
		.as_			 (s_as_),				  // ��ַѡͨ
		.addr			 (s_addr[`TimerAddrLoc]), // ��ַ
		.rw				 (s_rw),				  // ��/д
		.wr_data		 (s_wr_data),			  // д�������
		.rd_data		 (s2_rd_data),			  // ����������
		.rdy_			 (s2_rdy_),				  // ����
		/********** �ж� **********/
		.irq			 (irq_timer)			  // ��ʱ���ж�����
	 );
`else				   // ��ʱ��δѡװ
	assign s2_rd_data = `WORD_DATA_W'h0;
	assign s2_rdy_	  = `DISABLE_;
	assign irq_timer  = `DISABLE;
`endif

	/********** ���ߴ��豸 3 : UART **********/
`ifdef IMPLEMENT_UART // UARTѡװ
	uart uart (
		/********** ʱ���븴λ **********/
		.clk			 (clk),					  // ʱ��
		.reset			 (reset),				  // �첽��λ
		/********** ���߽ӿ� **********/
		.cs_			 (s3_cs_),				  // Ƭѡ
		.as_			 (s_as_),				  // ��ַѡͨ
		.rw				 (s_rw),				  // ��/д
		.addr			 (s_addr[`UartAddrLoc]),  //  ��ַ
		.wr_data		 (s_wr_data),			  // д�������
		.rd_data		 (s3_rd_data),			  // ����������
		.rdy_			 (s3_rdy_),				  // ����
		/********** �ж� **********/
		.irq_rx			 (irq_uart_rx),			  // ��������ж�����
		.irq_tx			 (irq_uart_tx),			  // ��������ж�����
		/********** UART�շ��źţ�ͨ��FPGA����ΪTTL��ƽ�����ͨ�����ڽ���ΪRS232��ƽ	**********/
		.rx				 (uart_rx),				  // UART�����źţ�����Լ��ʱע��
		.tx				 (uart_tx)				  // UART�����źţ�����Լ��ʱע��
	);
`else				  // UARTδѡװ
	assign s3_rd_data  = `WORD_DATA_W'h0;
	assign s3_rdy_	   = `DISABLE_;
	assign irq_uart_rx = `DISABLE;
	assign irq_uart_tx = `DISABLE;
`endif

	/********** ���ߴ��豸 4 : GPIO **********/
`ifdef IMPLEMENT_GPIO // GPIOѡװ
	gpio gpio (
		/********** ʱ���븴λ **********/
		.clk			 (clk),					 // ʱ��
		.reset			 (reset),				 // �첽��λ
		/********** ���߽ӿ� **********/
		.cs_			 (s4_cs_),				 // Ƭѡ
		.as_			 (s_as_),				 // ��ַѡͨ
		.rw				 (s_rw),				 // ��/д
		.addr			 (s_addr[`GpioAddrLoc]), // ��ַ
		.wr_data		 (s_wr_data),			 // д�������
		.rd_data		 (s4_rd_data),			 // ����������
		.rdy_			 (s4_rdy_)				 // ����
		/********** GPIO �˿� **********/
`ifdef GPIO_IN_CH	 // ѡװ�����
		, .gpio_in		 (gpio_in)				 // �����,zhanglyע�������������Լ�����ĸ����߼��İ�ť����ȡ��
`endif
`ifdef GPIO_OUT_CH	 // ѡװ�����
		, .gpio_out		 (gpio_out)				 // �����
`endif
`ifdef GPIO_IO_CH	 // ѡװ���������
		, .gpio_io		 (gpio_io)				 // ���������
`endif
	);
`else				  // GPIOûѡװ
	assign s4_rd_data = `WORD_DATA_W'h0;
	assign s4_rdy_	  = `DISABLE_;
`endif

	/********** ���ߴ��豸 5 : ûѡװ **********/
	assign s5_rd_data = `WORD_DATA_W'h0;
	assign s5_rdy_	  = `DISABLE_;
  
	/********** ���ߴ��豸 6 :  ûѡװ **********/
	assign s6_rd_data = `WORD_DATA_W'h0;
	assign s6_rdy_	  = `DISABLE_;
  
	/********** ���ߴ��豸 7 :  ûѡװ **********/
	assign s7_rd_data = `WORD_DATA_W'h0;
	assign s7_rdy_	  = `DISABLE_;

	/********** ���� **********/
	bus bus (
		/********** ʱ���븴λ **********/
		.clk			 (clk),					 // ʱ��
		.reset			 (reset),				 // �첽��λ
		/********** ���������ź� **********/
		// �����������ع����ź�
		.m_rd_data		 (m_rd_data),			 // ����������
		.m_rdy_			 (m_rdy_),				 // ����
		// 0����������
		.m0_req_		 (m0_req_),				 // ��������
		.m0_addr		 (m0_addr),				 // ��ַ
		.m0_as_			 (m0_as_),				 // ��ַѡͨ
		.m0_rw			 (m0_rw),				 // ��/д
		.m0_wr_data		 (m0_wr_data),			 // д�������
		.m0_grnt_		 (m0_grnt_),			 // ������Ȩ
		// 1����������
		.m1_req_		 (m1_req_),				 // �Х��ꥯ������
		.m1_addr		 (m1_addr),				 // ���ɥ쥹
		.m1_as_			 (m1_as_),				 // ���ɥ쥹���ȥ��`��
		.m1_rw			 (m1_rw),				 // �i�ߣ�����
		.m1_wr_data		 (m1_wr_data),			 // �����z�ߥǩ`��
		.m1_grnt_		 (m1_grnt_),			 // �Х�������
		// 2����������
		.m2_req_		 (m2_req_),				 // �Х��ꥯ������
		.m2_addr		 (m2_addr),				 // ���ɥ쥹
		.m2_as_			 (m2_as_),				 // ���ɥ쥹���ȥ��`��
		.m2_rw			 (m2_rw),				 // �i�ߣ�����
		.m2_wr_data		 (m2_wr_data),			 // �����z�ߥǩ`��
		.m2_grnt_		 (m2_grnt_),			 // �Х�������
		// 3����������
		.m3_req_		 (m3_req_),				 // �Х��ꥯ������
		.m3_addr		 (m3_addr),				 // ���ɥ쥹
		.m3_as_			 (m3_as_),				 // ���ɥ쥹���ȥ��`��
		.m3_rw			 (m3_rw),				 // �i�ߣ�����
		.m3_wr_data		 (m3_wr_data),			 // �����z�ߥǩ`��
		.m3_grnt_		 (m3_grnt_),			 // �Х�������
		/********** ���ߴ��豸�ź� **********/
		// �������ߴ����豸�����ź�
		.s_addr			 (s_addr),				 // ��ַ
		.s_as_			 (s_as_),				 // ��ַѡͨ
		.s_rw			 (s_rw),				 // ��/д
		.s_wr_data		 (s_wr_data),			 // д�������
		// 0�����ߴ���
		.s0_rd_data		 (s0_rd_data),			 // ����������
		.s0_rdy_		 (s0_rdy_),				 // ����
		.s0_cs_			 (s0_cs_),				 // Ƭѡ
		// 1�����ߴ���
		.s1_rd_data		 (s1_rd_data),			 // �i�߳����ǩ`��
		.s1_rdy_		 (s1_rdy_),				 // ��ǥ�
		.s1_cs_			 (s1_cs_),				 // ���åץ��쥯��
		// 2�����ߴ���
		.s2_rd_data		 (s2_rd_data),			 // �i�߳����ǩ`��
		.s2_rdy_		 (s2_rdy_),				 // ��ǥ�
		.s2_cs_			 (s2_cs_),				 // ���åץ��쥯��
		// 3�����ߴ���
		.s3_rd_data		 (s3_rd_data),			 // �i�߳����ǩ`��
		.s3_rdy_		 (s3_rdy_),				 // ��ǥ�
		.s3_cs_			 (s3_cs_),				 // ���åץ��쥯��
		// 4�����ߴ���
		.s4_rd_data		 (s4_rd_data),			 // �i�߳����ǩ`��
		.s4_rdy_		 (s4_rdy_),				 // ��ǥ�
		.s4_cs_			 (s4_cs_),				 // ���åץ��쥯��
		// 5�����ߴ���
		.s5_rd_data		 (s5_rd_data),			 // �i�߳����ǩ`��
		.s5_rdy_		 (s5_rdy_),				 // ��ǥ�
		.s5_cs_			 (s5_cs_),				 // ���åץ��쥯��
		// 6�����ߴ���
		.s6_rd_data		 (s6_rd_data),			 // �i�߳����ǩ`��
		.s6_rdy_		 (s6_rdy_),				 // ��ǥ�
		.s6_cs_			 (s6_cs_),				 // ���åץ��쥯��
		// 7�����ߴ���
		.s7_rd_data		 (s7_rd_data),			 // �i�߳����ǩ`��
		.s7_rdy_		 (s7_rdy_),				 // ��ǥ�
		.s7_cs_			 (s7_cs_)				 // ���åץ��쥯��
	);

endmodule
