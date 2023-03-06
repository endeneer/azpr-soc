	LOCATE	0x20000000
;;; �V���{���̒�`
UART_BASE_ADDR_H	EQU	0x6000			;UART Base Address High
UART_STATUS_OFFSET	EQU	0x0				;UART Status Register Offset
UART_DATA_OFFSET	EQU	0x4				;UART Data Register Offset
UART_RX_INTR_MASK	EQU	0x1				;UART Receive Interrupt Mask
UART_TX_INTR_MASK	EQU	0x2				;UART Transmit Interrupt Mask


	XORR	r0,r0,r0

	ORI		r0,r1,high(CLEAR_BUFFER)	;CLEAR_BUFFER�̏��16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16
	ORI		r1,r1,low(CLEAR_BUFFER)		;CLEAR_BUFFER�̉���16�r�b�g��r1�ɃZ�b�g

	ORI		r0,r2,high(SEND_CHAR)		;SEND_CHAR�̏��16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16
	ORI		r2,r2,low(SEND_CHAR)		;SEND_CHAR�̉���16�r�b�g��r2�ɃZ�b�g

;;; UART�o�b�t�@�N���A
	CALL	r1							;CLEAR_BUFFER�Ăяo��
	ANDR	r0,r0,r0					;NOP

;;; �����\��

;;;; Bel
	ORI 	r0,r16,0x07
	CALL	r2
	ANDR 	r0,r0,r0

;;;; ANSI: foreground: bright red 
	ORI 	r0,r16,0x1b
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'['
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'9'
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'1'
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'m'
	CALL	r2
	ANDR 	r0,r0,r0

;;;; Text: "Aloha,"
	ORI		r0,r16,'A'					;r16��'H'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'l'					;r16��'e'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'o'					;r16��'l'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'h'					;r16��'l'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'a'					;r16��'o'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,','					;r16��','���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

;;;; ANSI: foreground: black 
	ORI 	r0,r16,0x1b
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'['
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'3'
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'0'
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'m'
	CALL	r2
	ANDR 	r0,r0,r0


;;;; ANSI: background: bright yellow
	ORI 	r0,r16,0x1b
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'['
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'1'
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'0'
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'3'
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'m'
	CALL	r2
	ANDR 	r0,r0,r0

;;;; Text: "En De"
	ORI		r0,r16,'E'					;r16��'w'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'n'					;r16��'o'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,' '					;r16��'r'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'D'					;r16��'l'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'e'					;r16��'d'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r16,'!'					;r16��'.'���Z�b�g
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

;;;; ANSI: reset
	ORI 	r0,r16,0x1b
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'['
	CALL	r2
	ANDR 	r0,r0,r0
	
	ORI 	r0,r16,'0'
	CALL	r2
	ANDR 	r0,r0,r0

	ORI 	r0,r16,'m'
	CALL	r2
	ANDR 	r0,r0,r0

;;; �������[�v
LOOP:
	BE		r0,r0,LOOP					;�������[�v
	ANDR	r0,r0,r0					;NOP

CLEAR_BUFFER:
	ORI		r0,r16,UART_BASE_ADDR_H		;UART Base Address���16�r�b�g��r16�ɃZ�b�g
	SHLLI	r16,r16,16

_CHECK_UART_STATUS:
	LDW		r16,r17,UART_STATUS_OFFSET	;STATUS���擾

	ANDI	r17,r17,UART_RX_INTR_MASK
	BE		r0,r17,_CLEAR_BUFFER_RETURN	;Receive Interrupt bit�������Ă��Ȃ����_CLEAR_BUFFER_RETURN�����s
	ANDR	r0,r0,r0					;NOP

_RECEIVE_DATA:
	LDW		r16,r17,UART_DATA_OFFSET	;��M�f�[�^��ǂ�Ńo�b�t�@���N���A����

	LDW		r16,r17,UART_STATUS_OFFSET	;STATUS���擾
	XORI	r17,r17,UART_RX_INTR_MASK
	STW		r16,r17,UART_STATUS_OFFSET	;Receive Interrupt bit���N���A

	BNE		r0,r0,_CHECK_UART_STATUS	;_CHECK_UART_STATUS�ɖ߂�
	ANDR	r0,r0,r0					;NOP
_CLEAR_BUFFER_RETURN:
	JMP		r31							;�Ăяo�����ɖ߂�
	ANDR	r0,r0,r0					;NOP


SEND_CHAR:
	ORI		r0,r17,UART_BASE_ADDR_H		;UART Base Address���16�r�b�g��r17�ɃZ�b�g
	SHLLI	r17,r17,16
	STW		r17,r16,UART_DATA_OFFSET	;r16�𑗐M����

_WAIT_SEND_DONE:
	LDW		r17,r18,UART_STATUS_OFFSET	;STATUS���擾
	ANDI	r18,r18,UART_TX_INTR_MASK
	BE		r0,r18,_WAIT_SEND_DONE
	ANDR	r0,r0,r0

	LDW		r17,r18,UART_STATUS_OFFSET
	XORI	r18,r18,UART_TX_INTR_MASK
	STW		r17,r18,UART_STATUS_OFFSET	;Transmit Interrupt bit���N���A

	JMP		r31							;�Ăяo�����ɖ߂�
	ANDR	r0,r0,r0					;NOP

