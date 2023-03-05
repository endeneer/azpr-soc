;;; ���P�[�V�����A�h���X�̐ݒ�
	LOCATE	0x20000000

;;; �V���{���̒�`
UART_BASE_ADDR_H		EQU	0x6000		;UART Base Address High
UART_STATUS_OFFSET		EQU	0x0			;UART Status Register Offset
UART_DATA_OFFSET		EQU	0x4			;UART Data Register Offset
UART_RX_INTR_MASK		EQU	0x1			;UART Receive Interrupt Mask
UART_TX_INTR_MASK		EQU	0x2			;UART Transmit Interrupt Mask
GPIO_BASE_ADDR_H		EQU	0x8000		;GPIO Base Address High
GPIO_OUT_OFFSET			EQU	0x4			;GPIO Data Register Offset


	XORR	r0,r0,r0					;r0��0�N���A

	ORI		r0,r1,high(CLEAR_BUFFER)	;CLEAR_BUFFER�̏��16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16
	ORI		r1,r1,low(CLEAR_BUFFER)		;CLEAR_BUFFER�̉���16�r�b�g��r1�ɃZ�b�g

	ORI		r0,r2,high(SEND_CHAR)		;SEND_CHAR�̏��16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16
	ORI		r2,r2,low(SEND_CHAR)		;SEND_CHAR�̉���16�r�b�g��r2�ɃZ�b�g

	ORI		r0,r3,high(SET_GPIO_OUT)	;SET_GPIO_OUT�̏��16�r�b�g��r3�ɃZ�b�g
	SHLLI	r3,r3,16
	ORI		r3,r3,low(SET_GPIO_OUT)		;SET_GPIO_OUT�̉���16�r�b�g��r3�ɃZ�b�g


;;; ��O�x�N�^�̐ݒ�
	ORI		r0,r4,high(EXCEPT_HANDLER)
	SHLLI	r4,r4,16
	ORI		r4,r4,low(EXCEPT_HANDLER)
	WRCR	r4,c4

;;; UART�o�b�t�@�N���A
	CALL	r1							;CLEAR_BUFFER�Ăяo��
	ANDR	r0,r0,r0					;NOP

;;; �Z�p�I�[�o�[�t���[�𔭐�������
	ORI		r0,r4,0x7FFF
	SHLLI	r4,r4,16
	ORI		r4,r4,0xFFFF
	ADDSI	r4,r4,1

;;; LED�_��
	ORI		r0,r16,0x2
	SHLLI	r16,r16,16
	ORI		r16,r16,0xFFFF				;�o�̓f�[�^��r16�ɃZ�b�g
	CALL	r3
	ANDR	r0,r0,r0					;NOP

;; �������[�v
LOOP:
	BE		r0,r0,LOOP					;�������[�v
	ANDR	r0,r0,r0					;NOP


CLEAR_BUFFER:
	ORI		r0,r16,UART_BASE_ADDR_H		;UART Base Address���16�r�b�g��r2�ɃZ�b�g
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

SET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	STW		r17,r16,GPIO_OUT_OFFSET
_SET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP


;;; ��O�n���h��
;; ��O�R�[�h���V���A���ɕ\������
EXCEPT_HANDLER:
	RDCR	c5,r24
	ANDI	r24,r24,0x7

	ADDUI	r24,r24,48

	ORR		r0,r24,r16
	CALL	r2							;SEND_CHAR�Ăяo��
	ANDR	r0,r0,r0					;NOP

;;; LED�_��
	ORI		r0,r16,0x2
	SHLLI	r16,r16,16
	ORI		r16,r16,0x0 				;�o�̓f�[�^��r16�ɃZ�b�g
	CALL	r3
	ANDR	r0,r0,r0					;NOP

;;; �������[�v
EXCEPT_LOOP:
	BE		r0,r0,EXCEPT_LOOP			;�������[�v
	ANDR	r0,r0,r0					;NOP
