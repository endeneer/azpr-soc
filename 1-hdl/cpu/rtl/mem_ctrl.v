/*
 -- ============================================================================
 -- FILE NAME	: mem_ctrl.v
 -- DESCRIPTION : メモリアクセス崙囮ユニット
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 仟?ﾗ?撹
 -- ============================================================================
*/

/********** 慌宥ヘッダファイル **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** ???eヘッダファイル **********/
`include "isa.h"
`include "cpu.h"
`include "bus.h"

/********** モジュ?`ル **********/
module mem_ctrl (
	/********** EX/MEMパイプラインレジスタ **********/
	input  wire				   ex_en,		   // パイプラインデ?`タの嗤??
	input  wire [`MemOpBus]	   ex_mem_op,	   // メモリオペレ?`ション
	input  wire [`WordDataBus] ex_mem_wr_data, // メモリ??き?zみデ?`タ
	input  wire [`WordDataBus] ex_out,		   // ?I尖?Y惚
	/********** メモリアクセスインタフェ?`ス **********/
	input  wire [`WordDataBus] rd_data,		   // ?iみ竃しデ?`タ
	output wire [`WordAddrBus] addr,		   // アドレス
	output reg				   as_,			   // アドレス嗤??
	output reg				   rw,			   // ?iみ????き
	output wire [`WordDataBus] wr_data,		   // ??き?zみデ?`タ
	/********** メモリアクセス?Y惚 **********/
	output reg [`WordDataBus]  out	 ,		   // メモリアクセス?Y惚
	output reg				   miss_align	   // ミスアライン
);

	/********** 坪何佚催 **********/
	wire [`ByteOffsetBus]	 offset;		   // オフセット

	/********** 竃薦のアサイン **********/
	assign wr_data = ex_mem_wr_data;		   // ??き?zみデ?`タ
	assign addr	   = ex_out[`WordAddrLoc];	   // アドレス
	assign offset  = ex_out[`ByteOffsetLoc];   // オフセット

	/********** メモリアクセスの崙囮 **********/
	always @(*) begin
		/* デフォルト?? */
		miss_align = `DISABLE;
		out		   = `WORD_DATA_W'h0;
		as_		   = `DISABLE_;
		rw		   = `READ;
		/* メモリアクセス */
		if (ex_en == `ENABLE) begin
			case (ex_mem_op)
				`MEM_OP_LDW : begin // ワ?`ド?iみ竃し
					/* バイトオフセットのチェック */
					if (offset == `BYTE_OFFSET_WORD) begin // アライン
						out			= rd_data;
						as_		   = `ENABLE_;
					end else begin						   // ミスアライン
						miss_align	= `ENABLE;
					end
				end
				`MEM_OP_STW : begin // ワ?`ド??き?zみ
					/* バイトオフセットのチェック */
					if (offset == `BYTE_OFFSET_WORD) begin // アライン
						rw			= `WRITE;
						as_		   = `ENABLE_;
					end else begin						   // ミスアライン
						miss_align	= `ENABLE;
					end
				end
				default		: begin // メモリアクセスなし
					out			= ex_out;
				end
			endcase
		end
	end

endmodule
