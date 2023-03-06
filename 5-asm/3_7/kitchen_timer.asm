;;; ���P�[�V�����A�h���X�̐ݒ�
	LOCATE	0x20000000

;;; �V���{���̒�`
TIMER_BASE_ADDR_H	EQU	0x4000			;Timer Base Address High
TIMER_CTRL_OFFSET	EQU	0x0				;Timer Control Register Offset
TIMER_INTR_OFFSET	EQU	0x4				;Timer Interrupt Register Offset
TIMER_EXPIRE_OFFSET	EQU	0x8				;Timer Expiration Register Offset
GPIO_BASE_ADDR_H	EQU	0x8000			;GPIO Base Address High
GPIO_IN_OFFSET		EQU	0x0				;GPIO Input Port Register Offset
GPIO_OUT_OFFSET		EQU	0x4				;GPIO Data Register Offset

;;;; Extra
UART_BASE_ADDR_H	EQU 0x6000
UART_STATUS_OFFSET	EQU 0x0
UART_DATA_OFFSET	EQU 0x4
UART_RX_INTR_MASK	EQU 0x1
UART_TX_INTR_MASK	EQU 0x2

;;; Common-anode
;;; 7SEG_DATA_0			EQU	0xC0
;;; 7SEG_DATA_1			EQU	0xF9
;;; 7SEG_DATA_2			EQU	0xA4
;;; 7SEG_DATA_3			EQU	0xB0
;;; 7SEG_DATA_4			EQU	0x99
;;; 7SEG_DATA_5			EQU	0x92
;;; 7SEG_DATA_6			EQU	0x82
;;; 7SEG_DATA_7			EQU	0xF8
;;; 7SEG_DATA_8			EQU	0x80
;;; 7SEG_DATA_9			EQU	0x90

;;; Common-cathode
7SEG_DATA_0			EQU	0x3F
7SEG_DATA_1			EQU	0x06
7SEG_DATA_2			EQU	0x5B
7SEG_DATA_3			EQU	0x4F
7SEG_DATA_4			EQU	0x66
7SEG_DATA_5			EQU	0x6D
7SEG_DATA_6			EQU	0x7D
7SEG_DATA_7			EQU	0x07
7SEG_DATA_8			EQU	0x7F
7SEG_DATA_9			EQU	0x6F

PUSH_SW_DATA_1		EQU	0x1
PUSH_SW_DATA_2		EQU	0x2
PUSH_SW_DATA_3		EQU	0x4
PUSH_SW_DATA_4		EQU	0x8


	XORR	r0,r0,r0

;;; �T�u���[�`���R�[���̃R�[��������W�X�^�ɃZ�b�g
	ORI		r0,r1,high(CONV_NUM_TO_7SEG_DATA)	;���x��CONV_NUM_TO_7SEG_DATA�̏��16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16
	ORI		r1,r1,low(CONV_NUM_TO_7SEG_DATA)	;���x��CONV_NUM_TO_7SEG_DATA�̉���16�r�b�g��r1�ɃZ�b�g

	ORI		r0,r2,high(SET_GPIO_OUT)			;���x��SET_GPIO_OUT�̏��16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16
	ORI		r2,r2,low(SET_GPIO_OUT)				;���x��SET_GPIO_OUT�̉���16�r�b�g��r2�ɃZ�b�g

	ORI		r0,r3,high(DETECT_PUSH_SW_NUM)		;���x��DETECT_PUSH_SW_NUM�̏��16�r�b�g��r3�ɃZ�b�g
	SHLLI	r3,r3,16
	ORI		r3,r3,low(DETECT_PUSH_SW_NUM)		;���x��DETECT_PUSH_SW_NUM�̉���16�r�b�g��r3�ɃZ�b�g

	ORI		r0,r4,high(GET_GPIO_OUT)			;���x��GET_GPIO_OUT�̏��16�r�b�g��r4�ɃZ�b�g
	SHLLI	r4,r4,16
	ORI		r4,r4,low(GET_GPIO_OUT)				;���x��GET_GPIO_OUT�̉���16�r�b�g��r4�ɃZ�b�g

	ORI		r0,r26,high(SEND_CHAR)
	SHLLI	r26,r26,16
	ORI		r26,r26,low(SEND_CHAR)

	ORI		r0,r29,high(CLEAR_BUFFER)
	SHLLI	r29,r29,16
	ORI		r29,r29,low(CLEAR_BUFFER)

	CALL	r29
	ANDR	r0,r0,r0

;;; ��O�x�N�^�̐ݒ�
	ORI		r0,r7,high(EXCEPT_HANDLER)
	SHLLI	r7,r7,16
	ORI		r7,r7,low(EXCEPT_HANDLER)
	WRCR	r7,c4

;;; ���荞�݂̏����ݒ�
	;; Mask
	ORI		r0,r7,0xFE						;Interrupt Mask�ɃZ�b�g����l��r7�ɓ����
	WRCR	r7,c6
	;; Status
	ORI		r0,r7,0x2						;Status�ɃZ�b�g����l��r1�ɓ����(IE:1,EM0)
	WRCR	r7,c0

_RESET_TIMER:
	;; ���ƕb��0�ɐݒ�
	ORI		r0,r5,0							;r5(��)���N���A
	ORI		r0,r6,0							;r6(�b)���N���A
	;; ����\��(7�Z�O�_��)
	ORR		r0,r5,r16						;r16�ɕ\������l���Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,2							;LED1
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	XORR	r13,r13,r13						;��or�b���N���A(0:��, 1:�b)

;;; �v�b�V���{�^�������o
_TIMER_SETTING_LOOP:
	CALL	r3
	ANDR	r0,r0,r0
	ORR		r0,r16,r7
	ORI		r0,r8,PUSH_SW_DATA_1
	BE		r7,r8,_HANDLE_PUSH_SW_1
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r8,PUSH_SW_DATA_2
	BE		r7,r8,_HANDLE_PUSH_SW_2
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r8,PUSH_SW_DATA_3
	BE		r7,r8,_HANDLE_PUSH_SW_3
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r8,PUSH_SW_DATA_4
	BE		r7,r8,_HANDLE_PUSH_SW_4
	ANDR	r0,r0,r0						;NOP

;;; �{�^��1
;;; ���ƕb�̕\���̐؂�ւ�
_HANDLE_PUSH_SW_1:
	BNE		r0,r13,_SECOND_TO_MINUTE		;��or�b�H(0:��, 1:�b)
	ANDR	r0,r0,r0						;NOP

_MINUTE_TO_SECOND:
	ORR		r0,r6,r16						;�b���Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,1							;LED2
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	XORI	r13,r13,1						;��or�b��؂�ւ�
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

_SECOND_TO_MINUTE:
	ORR		r0,r5,r16						;�����Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,2							;LED1
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	XORI	r13,r13,1						;��or�b��؂�ւ�
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

;;; �{�^��2
;;; �\������Ă���l��1���₷
_HANDLE_PUSH_SW_2:
	BNE		r0,r13,_INC_SECOND				;��or�b�H(0:��, 1:�b)
	ANDR	r0,r0,r0						;NOP

_INC_MINUTE:
	ADDUI	r5,r5,1							;����1���₷
	ORI		r0,r7,100						;100�ɂȂ����番���N���A����
	BNE		r7,r5,_DISPLAY_MINUTE_1
	ANDR	r0,r0,r0
	ORI		r0,r5,0

_DISPLAY_MINUTE_1:
	ORR		r0,r5,r16						;�����Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,2							;LED1
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

_INC_SECOND:
	ADDUI	r6,r6,1							;�b��1���₷
	ORI		r0,r7,60						;60�ɂȂ�����b���N���A����
	BNE		r7,r6,_DISPLAY_SECOND_1
	ANDR	r0,r0,r0
	ORI		r0,r6,0

_DISPLAY_SECOND_1:
	ORR		r0,r6,r16						;�b���Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,1							;LED2
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

;;; �{�^��3
;;; �\������Ă���l��1���炷
_HANDLE_PUSH_SW_3:
	BNE		r0,r13,_DEC_SECOND				;��or�b�H(0:��, 1:�b)
	ANDR	r0,r0,r0						;NOP

_DEC_MINUTE:
	ADDUI	r5,r5,-1						;����1���炷
	ADDUI	r0,r7,-1
	BNE		r5,r7,_DISPLAY_MINUTE_2
	ANDR	r0,r0,r0
	ORI		r0,r5,99

_DISPLAY_MINUTE_2:
	ORR		r0,r5,r16						;�����Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,2							;LED1
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

_DEC_SECOND:
	ADDUI	r6,r6,-1						;�b��1���炷
	ADDUI	r0,r7,-1
	BNE		r6,r7,_DISPLAY_SECOND_2
	ANDR	r0,r0,r0
	ORI		r0,r6,59

_DISPLAY_SECOND_2:
	ORR		r0,r6,r16						;�b���Z�b�g
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,1							;LED2
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP
	BE		r0,r0,_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0						;NOP

;;; �{�^��4
;;; �^�C�}�J�n
_HANDLE_PUSH_SW_4:
	;; ���ƕb�̒l��0�Ȃ��_RESET_TIMER�ɖ߂�
	ADDUR	r5,r6,r12
	BE		r0,r12,_RESET_TIMER
	ANDR	r0,r0,r0
	;; �b�̒l�𖞗��l�ɕϊ�
	ORI		r0,r9,0							;�����l
	ORR		r0,r6,r11						;�b���R�s�[
	ORI		r0,r7,0x98
	SHLLI	r7,r7,16
	ORI		r7,r7,0x9680
	ORI		r0,r8,0x23C3
	SHLLI	r8,r8,16
	ORI		r8,r8,0x4600
	BE		r0,r11,_ONE_MINUTE
	ANDR	r0,r0,r0

_SECONDS:
	ADDUR	r9,r7,r9
	ADDUI	r11,r11,-1						;�b��1���炷
	BE		r0,r11,_SET_TIMER
	ANDR	r0,r0,r0
	BE		r0,r0,_SECONDS
	ANDR	r0,r0,r0

	;; 1���̒l�Ń^�C�}��ݒ�
_ONE_MINUTE:
	ADDUR	r9,r8,r9
	ADDUI	r5,r5,-1						;����1���炷

_SET_TIMER:
;;; ����\��
	ORR		r0,r5,r16
	CALL	r1								;�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r7,0
	SHLLI	r7,r7,16
	ORR		r7,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP

	;; �^�C�}�̐ݒ�
	;; Expiration Register
	ORI		r0,r7,TIMER_BASE_ADDR_H			;Timer Base Address���16�r�b�g��r7�ɃZ�b�g
	SHLLI	r7,r7,16
	STW		r7,r9,TIMER_EXPIRE_OFFSET		;�����l��ݒ�

	;; Control Register
	;; �^�C�}���X�^�[�g
	ORI		r0,r8,0x1						;Periodic:0, Start:1
	STW		r7,r8,TIMER_CTRL_OFFSET			;Timer Control Register��ݒ�

;;; .��_��
	ORI		r0,r7,0x10
	SHLLI	r7,r7,16
	ORI		r7,r7,0x0000
_TIMER_LOOP:
	ADDUI	r7,r7,-1

	ADDUI	r0,r8,-1
	BE		r8,r5,_SET_LED
	ANDR	r0,r0,r0

	BNE		r0,r7,_TIMER_LOOP
	ANDR	r0,r0,r0

	;7�Z�O�̒l��ǂ�
	CALL	r4
	ANDR	r0,r0,r0

	XORI	r16,r16,0x8000

	CALL	r2
	ANDR	r0,r0,r0						;NOP

	ORI		r0,r7,0x10
	SHLLI	r7,r7,16
	ORI		r7,r7,0x0000
	BE		r0,r0,_TIMER_LOOP
	ANDR	r0,r0,r0

;;; 2��LED�_��
_SET_LED:
	ORI		r0,r7,TIMER_BASE_ADDR_H			;Timer Base Address���16�r�b�g��r7�ɃZ�b�g
	SHLLI	r7,r7,16
	STW		r7,r0,TIMER_CTRL_OFFSET			;Timer Control Register��ݒ�

	ORI		r0,r7,1
	SHLLI	r7,r7,16

_SET_LED2:
	ORI		r0,r10,0xFFFF

	;7�Z�O�̒l��ǂ�
	CALL	r4
	ANDR	r0,r0,r0

	XORR	r16,r7,r16

	CALL	r2
	ANDR	r0,r0,r0						;NOP

;;;; Send Bel to terminal as alert
;	ORI 	r0,r15,0x07
;	CALL 	r26
;	ANDR	r0,r0,r0						;NOP
;
;	ORI 	r0,r15,'D'						;Debug print
;	CALL 	r26
;	ANDR	r0,r0,r0						;NOP

;;; �v�b�V���{�^���������ꂽ

	;�{�^��1��bit16�Ƃ���
	ORI		r0,r7,GPIO_BASE_ADDR_H			;GPIO Base Address���16�r�b�g��r7�ɃZ�b�g
	SHLLI	r7,r7,16
_DETECT_PUSH_BUTTON_2:
	LDW		r7,r8,GPIO_IN_OFFSET			;GPIO Input Port Register�̒l���擾
	BNE		r0,r8,_GOTO_TIMER_SETTING_LOOP

	ANDR	r0,r0,r0						;NOP

	ADDUI	r10,r10,-1

	BNE		r0,r10,_DETECT_PUSH_BUTTON_2
	ANDR	r0,r0,r0

	ORI		r0,r7,3
	SHLLI	r7,r7,16

	BE		r0,r0,_SET_LED2
	ANDR	r0,r0,r0

_GOTO_TIMER_SETTING_LOOP:
	LDW		r7,r8,GPIO_IN_OFFSET			;GPIO Input Port Register�̒l���擾
	BNE		r0,r8,_GOTO_TIMER_SETTING_LOOP
	ANDR	r0,r0,r0
	BE		r0,r0,_RESET_TIMER
	ANDR	r0,r0,r0


;;; 7�Z�O�_�����[�`��
CONV_NUM_TO_7SEG_DATA:
	;; ���ʂ̌����琔���𒊏o
	ORR		r0,r16,r18						;r16��r18�ɃR�s�[
	XORR	r17,r17,r17						;Return Value�̃N���A
	XORR	r19,r19,r19						;0:1����(7SEG2), 1:2����(7SEG1)
	XORR	r20,r20,r20						;2���ڂ̒l
	;; 10�̈ʂ̒l�����߂�
	ORI		r0,r21,10						;r21��10�������
_SUB10:
	BUGT	r18,r21,_CHECK_0				;r18<r21(r18<10)�Ȃ��_CHECK_0�ɂƂ�
	ANDR	r0,r0,r0						;NOP
	ADDUI	r18,r18,-10
	ADDUI	r20,r20,1
	BE		r0,r0,_SUB10					;r21<r18�Ȃ��SUB10�ɂƂ�
	ANDR	r0,r0,r0						;NOP

_CHECK_0:
	ORI		r0,r21,0
	BNE		r18,r21,_CHECK_1
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_0
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_1:
	ORI		r0,r21,1
	BNE		r18,r21,_CHECK_2
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_1
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_2:
	ORI		r0,r21,2
	BNE		r18,r21,_CHECK_3
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_2
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_3:
	ORI		r0,r21,3
	BNE		r18,r21,_CHECK_4
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_3
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_4:
	ORI		r0,r21,4
	BNE		r18,r21,_CHECK_5
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_4
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_5:
	ORI		r0,r21,5
	BNE		r18,r21,_CHECK_6
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_5
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_6:
	ORI		r0,r21,6
	BNE		r18,r21,_CHECK_7
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_6
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_7:
	ORI		r0,r21,7
	BNE		r18,r21,_CHECK_8
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_7
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_8:
	ORI		r0,r21,8
	BNE		r18,r21,_CHECK_9
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r22,7SEG_DATA_8
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP

_CHECK_9:
	ORI		r0,r22,7SEG_DATA_9
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0						;NOP
	SHLLI	r22,r22,8						;7SEG2�p��8�r�b�g�V�t�g

_SET_RETURN_VALUE:
	ORR		r17,r22,r17
	BNE		r0,r19,_CONV_NUM_TO_7SEG_DATA_RETURN
	ANDR	r0,r0,r0						;NOP
_NEXT_DIGIT:
	ORR		r0,r20,r18
	ORI		r19,r19,1						;0:1����(7SEG2), 1:2����(7SEG1)
	BE		r0,r0,_CHECK_0
	ANDR	r0,r0,r0						;NOP
_CONV_NUM_TO_7SEG_DATA_RETURN:
	JMP		r31
	ANDR	r0,r0,r0						;NOP


SET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	STW		r17,r16,GPIO_OUT_OFFSET
_SET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0						;NOP


GET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	LDW		r17,r16,GPIO_OUT_OFFSET
_GET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0						;NOP


DETECT_PUSH_SW_NUM:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
_WAIT_PUSH_SW_ON:
	LDW		r17,r18,GPIO_IN_OFFSET
	BE		r0,r18,_WAIT_PUSH_SW_ON
	ANDR	r0,r0,r0						;NOP
_WAIT_PUSH_SW_OFF:
	LDW		r17,r19,GPIO_IN_OFFSET
	BNE		r0,r19,_WAIT_PUSH_SW_OFF
	ANDR	r0,r0,r0						;NOP
_CHECK_PUSH_SW_1:
	ANDI	r18,r19,PUSH_SW_DATA_1
	BNE		r0,r19,_SET_RETURN_VALUE_PUSH_SW
	ANDR	r0,r0,r0						;NOP
_CHECK_PUSH_SW_2:
	ANDI	r18,r19,PUSH_SW_DATA_2
	BNE		r0,r19,_SET_RETURN_VALUE_PUSH_SW
	ANDR	r0,r0,r0						;NOP
_CHECK_PUSH_SW_3:
	ANDI	r18,r19,PUSH_SW_DATA_3
	BNE		r0,r19,_SET_RETURN_VALUE_PUSH_SW
	ANDR	r0,r0,r0						;NOP
_CHECK_PUSH_SW_4:
	ANDI	r18,r19,PUSH_SW_DATA_4
	BNE		r0,r19,_SET_RETURN_VALUE_PUSH_SW
	ANDR	r0,r0,r0						;NOP
_SET_RETURN_VALUE_PUSH_SW:
	ORR		r0,r19,r16
_SOFTWARE_DEBOUNCE_SETUP:
	ORI		r0,r14,0x9
	SHLLI	r14,r14,16
	ORI		r14,r14,0x27C0					;0.12s delay, R14=dec2hex(10M*0.12/2)=0x927C0, divide 2 because, decrement and BNE check below takes two cycles.
_SOFTWARE_DEBOUNCE_DELAY:
	ADDUI	r14,r14,-1
	BNE		r0,r14,_SOFTWARE_DEBOUNCE_DELAY	;while( (--R14) != 0);
	ANDR	r0,r0,r0						;NOP
_DETECT_PUSH_SW_NUM_RETURN:
	JMP		r31
	ANDR	r0,r0,r0						;NOP

;;; ���荞�݃n���h��
EXCEPT_HANDLER:
	;; ���荞�݃X�e�[�^�X�N���A
	ORI		r0,r24,TIMER_BASE_ADDR_H		;Timer Base Address���16�r�b�g��r24�ɃZ�b�g
	SHLLI	r24,r24,16
	STW		r24,r0,TIMER_INTR_OFFSET		;Interrupt���N���A
	STW		r24,r0,TIMER_CTRL_OFFSET		;�^�C�}���~

	;; ���̒l��1���炷
	ADDUI	r5,r5,-1
	ADDUI	r0,r25,-1
	BE		r5,r25,_END_OF_INTR_HANDLER
	ANDR	r0,r0,r0

	;; �^�C�}��1���ɐݒ�
	ORI		r0,r25,0x23C3
	SHLLI	r25,r25,16
	ADDUI	r25,r25,0x4600
	STW		r24,r25,TIMER_EXPIRE_OFFSET		;�����l��ݒ�
	ORI		r0,r8,0x3						;Periodic:1, Start:1
	STW		r24,r8,TIMER_CTRL_OFFSET		;Timer Control Register��ݒ�

	;; ����\��
	ORR		r0,r5,r16
	CALL	r1								;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0						;NOP
	ORI		r0,r24,3
	SHLLI	r24,r24,16
	ORR		r24,r17,r16
	CALL	r2
	ANDR	r0,r0,r0						;NOP

_END_OF_INTR_HANDLER:
	;; �x���X���b�g�m�F
	RDCR	c5,r24
	ANDI	r24,r24,0x8
	BE		r0,r24,_GOTO_EXRT
	ANDR	r0,r0,r0						;NOP
	RDCR	c3,r24
	ADDUI	r24,r24,-4
	WRCR	r24,c3

_GOTO_EXRT:
	;; ���荞�݂����������A�h���X�ɖ߂�
	EXRT
	ANDR	r0,r0,r0						;NOP

;;;; Extra: UART
CLEAR_BUFFER:
	ORI		r0,r27,UART_BASE_ADDR_H
	SHLLI 	r27,r27,16
_CHECK_UART_STATUS:
	LDW		r27,r28,UART_STATUS_OFFSET
	ANDI	r28,r28,UART_RX_INTR_MASK
	BE		r0,r28,_CLEAR_BUFFER_RETURN
	ANDR	r0,r0,r0
_RECEIVE_DATA:
	LDW		r27,r28,UART_DATA_OFFSET
	LDW		r27,r28,UART_STATUS_OFFSET
	XORI	r28,r28,UART_RX_INTR_MASK
	STW		r27,r28,UART_STATUS_OFFSET
	BNE		r0,r0,_CHECK_UART_STATUS
_CLEAR_BUFFER_RETURN:
	JMP		r31
	ANDR	r0,r0,r0

SEND_CHAR:
	ORI		r0,r27,UART_BASE_ADDR_H
	SHLLI 	r27,r27,16
	STW		r27,r15,UART_DATA_OFFSET
_WAIT_SEND_DONE:
	LDW		r27,r23,UART_STATUS_OFFSET
	ANDI	r23,r23,UART_TX_INTR_MASK
	BE		r0,r23,_WAIT_SEND_DONE
	ANDR	r0,r0,r0

	LDW		r27,r23,UART_STATUS_OFFSET
	XORI	r23,r23,UART_TX_INTR_MASK
	STW		r27,r23,UART_STATUS_OFFSET

	JMP		r31
	ANDR	r0,r0,r0