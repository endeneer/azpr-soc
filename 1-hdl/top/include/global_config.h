/*
 -- ============================================================================
 -- FILE NAME	: global_config.h
 -- DESCRIPTION : È«¾ÖÉèÖÃ
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 ÐÂÒŽ×÷³É
 -- 1.0.1	  2014/07/27  zhangly 
 -- ============================================================================
*/

`ifndef __GLOBAL_CONFIG_HEADER__
	`define __GLOBAL_CONFIG_HEADER__	//  

//------------------------------------------------------------------------------
// ÔO¶¨í—Ä¿
//------------------------------------------------------------------------------
	/********** Ä¿±ê¿ª·¢°åÉèÖÃ **********/
//	`define TARGET_DEV_MFPGA_SPAR3E		// MFPGA°å
	`define TARGET_DEV_AZPR_EV_BOARD	// AZPRÔ­Éú°å

/********** ¸´Î»ÐÅºÅ¼«ÐÔÑ¡Ôñ**********/
//	`define POSITIVE_RESET				// Active High
	`define NEGATIVE_RESET				// Active Low

	/********** ï¿½Ú´ï¿½ï¿½ï¿½ï¿½ï¿½ÅºÅ¼ï¿½ï¿½ï¿½Ñ¡ï¿½ï¿½ **********/
//  `define POSITIVE_MEMORY				// Active High
	`define NEGATIVE_MEMORY				// Active Low

	/********** I/O Éè±¸Ñ¡Ôñ**********/
	`define IMPLEMENT_TIMER				// ¶¨Ê±Æ÷
	`define IMPLEMENT_UART				// UART
	`define IMPLEMENT_GPIO				// General Purpose I/O

//------------------------------------------------------------------------------
// Éú³ÉµÄ²ÎÊýÈ¡¾öÓÚÅäÖÃ
//------------------------------------------------------------------------------
/********** ¸´Î»¼«ÐÔ *********/
	// Active Low
	`ifdef POSITIVE_RESET
		`define RESET_EDGE	  posedge	// ÉÏÉýÑØ
		`define RESET_ENABLE  1'b1		// ¸´Î»ÓÐÐ§
		`define RESET_DISABLE 1'b0		// ¸´Î»ÎÞÐ§
	`endif
	// Active High
	`ifdef NEGATIVE_RESET
		`define RESET_EDGE	  negedge	// ÏÂ½µÑØ
		`define RESET_ENABLE  1'b0		// ¸´Î»ÓÐÐ§
		`define RESET_DISABLE 1'b1		// ¸´Î»ÎÞÐ§
	`endif

	/********** ÄÚ´æ¿ØÖÆÐÅºÅ¼«ÐÔ *********/
	// Actoive High
	`ifdef POSITIVE_MEMORY
		`define MEM_ENABLE	  1'b1		// ÄÚ´æÓÐÐ§
		`define MEM_DISABLE	  1'b0		// ÄÚ´æÎÞÐ§
	`endif
	// Active Low
	`ifdef NEGATIVE_MEMORY
		`define MEM_ENABLE	  1'b0		// ÄÚ´æÓÐÐ§
		`define MEM_DISABLE	  1'b1		// ÄÚ´æÎÞÐ§
	`endif

`endif
