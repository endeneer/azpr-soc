/*
 -- ============================================================================
 -- FILE NAME	: bus_if.v
 -- DESCRIPTION : �Х����󥿥ե��`��
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
`include "bus.h"

/********** �⥸��`�� **********/
module bus_if (
	/********** �����å� & �ꥻ�å� **********/
	input  wire				   clk,			   // �����å�
	input  wire				   reset,		   // ��ͬ�ڥꥻ�å�
	/********** �ѥ��ץ饤�������ź� **********/
	input  wire				   stall,		   // ���ȩ`��
	input  wire				   flush,		   // �ե�å����ź�
	output reg				   busy,		   // �ӥ��`�ź�
	/********** CPU���󥿥ե��`�� **********/
	input  wire [`WordAddrBus] addr,		   // ���ɥ쥹
	input  wire				   as_,			   // ���ɥ쥹�Є�
	input  wire				   rw,			   // �i�ߣ�����
	input  wire [`WordDataBus] wr_data,		   // �����z�ߥǩ`��
	output reg	[`WordDataBus] rd_data,		   // �i�߳����ǩ`��
	/********** SPM���󥿥ե��`�� **********/
	input  wire [`WordDataBus] spm_rd_data,	   // �i�߳����ǩ`��
	output wire [`WordAddrBus] spm_addr,	   // ���ɥ쥹
	output reg				   spm_as_,		   // ���ɥ쥹���ȥ��`��
	output wire				   spm_rw,		   // �i�ߣ�����
	output wire [`WordDataBus] spm_wr_data,	   // �����z�ߥǩ`��
	/********** �Х����󥿥ե��`�� **********/
	input  wire [`WordDataBus] bus_rd_data,	   // �i�߳����ǩ`��
	input  wire				   bus_rdy_,	   // ��ǥ�
	input  wire				   bus_grnt_,	   // �Х�������
	output reg				   bus_req_,	   // �Х��ꥯ������
	output reg	[`WordAddrBus] bus_addr,	   // ���ɥ쥹
	output reg				   bus_as_,		   // ���ɥ쥹���ȥ��`��
	output reg				   bus_rw,		   // �i�ߣ�����
	output reg	[`WordDataBus] bus_wr_data	   // �����z�ߥǩ`��
);

	/********** �ڲ��ź� **********/
	reg	 [`BusIfStateBus]	   state;		   // �Х����󥿥ե��`����״�B
	reg	 [`WordDataBus]		   rd_buf;		   // �i�߳����Хåե�
	wire [`BusSlaveIndexBus]   s_index;		   // �Х�����`�֥���ǥå���

	/********** �Х�����`�֤Υ���ǥå��� **********/
	assign s_index	   = addr[`BusSlaveIndexLoc];

	/********** �����Υ������� **********/
	assign spm_addr	   = addr;
	assign spm_rw	   = rw;
	assign spm_wr_data = wr_data;
						 
	/********** ���ꥢ������������ **********/
	always @(*) begin
		/* �ǥե���Ȃ� */
		rd_data	 = `WORD_DATA_W'h0;
		spm_as_	 = `DISABLE_;
		busy	 = `DISABLE;
		/* �Х����󥿥ե��`����״�B */
		case (state)
			`BUS_IF_STATE_IDLE	 : begin // �����ɥ�
				/* ���ꥢ������ */
				if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin
					/* ���������Ȥ��x�k */
					if (s_index == `BUS_SLAVE_1) begin // SPM�إ�������
						if (stall == `DISABLE) begin // ���ȩ`��k���Υ����å�
							spm_as_	 = `ENABLE_;
							if (rw == `READ) begin // �i�߳�����������
								rd_data	 = spm_rd_data;
							end
						end
					end else begin					   // �Х��إ�������
						busy	 = `ENABLE;
					end
				end
			end
			`BUS_IF_STATE_REQ	 : begin // �Х��ꥯ������
				busy	 = `ENABLE;
			end
			`BUS_IF_STATE_ACCESS : begin // �Х���������
				/* ��ǥ����� */
				if (bus_rdy_ == `ENABLE_) begin // ��ǥ�����
					if (rw == `READ) begin // �i�߳�����������
						rd_data	 = bus_rd_data;
					end
				end else begin					// ��ǥ�δ����
					busy	 = `ENABLE;
				end
			end
			`BUS_IF_STATE_STALL	 : begin // ���ȩ`��
				if (rw == `READ) begin // �i�߳�����������
					rd_data	 = rd_buf;
				end
			end
		endcase
	end

   /********** �Х����󥿥ե��`����״�B���� **********/ 
   always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* ��ͬ�ڥꥻ�å� */
			state		<=  `BUS_IF_STATE_IDLE;
			bus_req_	<=  `DISABLE_;
			bus_addr	<=  `WORD_ADDR_W'h0;
			bus_as_		<=  `DISABLE_;
			bus_rw		<=  `READ;
			bus_wr_data <=  `WORD_DATA_W'h0;
			rd_buf		<=  `WORD_DATA_W'h0;
		end else begin
			/* �Х����󥿥ե��`����״�B */
			case (state)
				`BUS_IF_STATE_IDLE	 : begin // �����ɥ�
					/* ���ꥢ������ */
					if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin 
						/* ���������Ȥ��x�k */
						if (s_index != `BUS_SLAVE_1) begin // �Х��إ�������
							state		<=  `BUS_IF_STATE_REQ;
							bus_req_	<=  `ENABLE_;
							bus_addr	<=  addr;
							bus_rw		<=  rw;
							bus_wr_data <=  wr_data;
						end
					end
				end
				`BUS_IF_STATE_REQ	 : begin // �Х��ꥯ������
					/* �Х������ȴ��� */
					if (bus_grnt_ == `ENABLE_) begin // �Х��ث@��
						state		<=  `BUS_IF_STATE_ACCESS;
						bus_as_		<=  `ENABLE_;
					end
				end
				`BUS_IF_STATE_ACCESS : begin // �Х���������
					/* ���ɥ쥹���ȥ��`�֤Υͥ��`�� */
					bus_as_		<=  `DISABLE_;
					/* ��ǥ����� */
					if (bus_rdy_ == `ENABLE_) begin // ��ǥ�����
						bus_req_	<=  `DISABLE_;
						bus_addr	<=  `WORD_ADDR_W'h0;
						bus_rw		<=  `READ;
						bus_wr_data <=  `WORD_DATA_W'h0;
						/* �i�߳����ǩ`���α��� */
						if (bus_rw == `READ) begin // �i�߳�����������
							rd_buf		<=  bus_rd_data;
						end
						/* ���ȩ`��k���Υ����å� */
						if (stall == `ENABLE) begin // ���ȩ`��k��
							state		<=  `BUS_IF_STATE_STALL;
						end else begin				// ���ȩ`��δ�k��
							state		<=  `BUS_IF_STATE_IDLE;
						end
					end
				end
				`BUS_IF_STATE_STALL	 : begin // ���ȩ`��
					/* ���ȩ`��k���Υ����å� */
					if (stall == `DISABLE) begin // ���ȩ`����
						state		<=  `BUS_IF_STATE_IDLE;
					end
				end
			endcase
		end
	end

endmodule
