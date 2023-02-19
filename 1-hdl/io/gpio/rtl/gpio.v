/*
 -- ============================================================================
 -- FILE NAME	: gpio.v
 -- DESCRIPTION :  General Purpose I/O
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
`include "gpio.h"

/********** �⥸��`�� **********/
module gpio (
	/********** �����å� & �ꥻ�å� **********/
	input  wire						clk,	 // �����å�
	input  wire						reset,	 // �ꥻ�å�
	/********** �Х����󥿥ե��`�� **********/
	input  wire						cs_,	 // ���åץ��쥯��
	input  wire						as_,	 // ���ɥ쥹���ȥ��`��
	input  wire						rw,		 // Read / Write
	input  wire [`GpioAddrBus]		addr,	 // ���ɥ쥹
	input  wire [`WordDataBus]		wr_data, // �����z�ߥǩ`��
	output reg	[`WordDataBus]		rd_data, // �i�߳����ǩ`��
	output reg						rdy_	 // ��ǥ�
	/********** ����������ݩ`�� **********/
`ifdef GPIO_IN_CH	 // �����ݩ`�ȤΌgװ
	, input wire [`GPIO_IN_CH-1:0]	gpio_in	 // �����ݩ`�ȣ������쥸����0��
`endif
`ifdef GPIO_OUT_CH	 // �����ݩ`�ȤΌgװ
	, output reg [`GPIO_OUT_CH-1:0] gpio_out // �����ݩ`�ȣ������쥸����1��
`endif
`ifdef GPIO_IO_CH	 // ������ݩ`�ȤΌgװ
	, inout wire [`GPIO_IO_CH-1:0]	gpio_io	 // ������ݩ`�ȣ������쥸����2��
`endif
);

`ifdef GPIO_IO_CH	 // ������ݩ`�Ȥ�����
	/********** ������ź� **********/
	wire [`GPIO_IO_CH-1:0]			io_in;	 // �����ǩ`��
	reg	 [`GPIO_IO_CH-1:0]			io_out;	 // �����ǩ`��
	reg	 [`GPIO_IO_CH-1:0]			io_dir;	 // ��������������쥸����3��
	reg	 [`GPIO_IO_CH-1:0]			io;		 // �����
	integer							i;		 // ���ƥ�`��
   
	/********** ������źŤξ@�A���� **********/
	assign io_in	   = gpio_io;			 // �����ǩ`��
	assign gpio_io	   = io;				 // �����

	/********** �������������� **********/
	always @(*) begin
		for (i = 0; i < `GPIO_IO_CH; i = i + 1) begin : IO_DIR
			io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];
		end
	end

`endif
   
	/********** GPIO������ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			rd_data	 <=  `WORD_DATA_W'h0;
			rdy_	 <=  `DISABLE_;
`ifdef GPIO_OUT_CH	 // �����ݩ`�ȤΥꥻ�å�
			gpio_out <=  {`GPIO_OUT_CH{`LOW}};
`endif
`ifdef GPIO_IO_CH	 // ������ݩ`�ȤΥꥻ�å�
			io_out	 <=  {`GPIO_IO_CH{`LOW}};
			// io_dir	 <=  {`GPIO_IO_CH{`GPIO_DIR_IN}};
			// changed to GPIO_DIR_OUT (simplify wiring because leaving unused output floating is ok, but not for input)
			io_dir	 <=  {`GPIO_IO_CH{`GPIO_DIR_OUT}};
`endif
		end else begin
			/* ��ǥ������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <=  `ENABLE_;
			end else begin
				rdy_	 <=  `DISABLE_;
			end 
			/* �i�߳����������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
`ifdef GPIO_IN_CH	// �����ݩ`�Ȥ��i�߳���
					`GPIO_ADDR_IN_DATA	: begin // �����쥸���� 0
						rd_data	 <=  {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}}, 
										gpio_in};
					end
`endif
`ifdef GPIO_OUT_CH	// �����ݩ`�Ȥ��i�߳���
					`GPIO_ADDR_OUT_DATA : begin // �����쥸���� 1
						rd_data	 <=  {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}}, 
										gpio_out};
					end
`endif
`ifdef GPIO_IO_CH	// ������ݩ`�Ȥ��i�߳���
					`GPIO_ADDR_IO_DATA	: begin // �����쥸���� 2
						rd_data	 <=  {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
										io_in};
					 end
					`GPIO_ADDR_IO_DIR	: begin // �����쥸���� 3
						rd_data	 <=  {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
										io_dir};
					end
`endif
				endcase
			end else begin
				rd_data	 <=  `WORD_DATA_W'h0;
			end
			/* �����z�ߥ������� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)) begin
				case (addr)
`ifdef GPIO_OUT_CH	// �����ݩ`�ȤؤΕ�������
					`GPIO_ADDR_OUT_DATA : begin // �����쥸���� 1
						gpio_out <=  wr_data[`GPIO_OUT_CH-1:0];
					end
`endif
`ifdef GPIO_IO_CH	// ������ݩ`�ȤؤΕ�������
					`GPIO_ADDR_IO_DATA	: begin // �����쥸���� 2
						io_out	 <=  wr_data[`GPIO_IO_CH-1:0];
					 end
					`GPIO_ADDR_IO_DIR	: begin // �����쥸���� 3
						io_dir	 <=  wr_data[`GPIO_IO_CH-1:0];
					end
`endif
				endcase
			end
		end
	end

endmodule
