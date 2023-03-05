;;; ���P�[�V�����A�h���X�̐ݒ�
	LOCATE	0x20000000

;;; �V���{���̒�`
GPIO_BASE_ADDR_H	EQU	0x8000			;GPIO Base Address High
GPIO_IN_OFFSET		EQU	0x0				;GPIO Input Port Register Offset
GPIO_OUT_OFFSET		EQU	0x4				;GPIO Output Port Register Offset

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


	XORR	r0,r0,r0

;;; �T�u���[�`���R�[���̃R�[��������W�X�^�ɃZ�b�g
	ORI		r0,r1,high(CONV_NUM_TO_7SEG_DATA)	;���x��CONV_NUM_TO_7SEG_DATA�̏��16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16
	ORI		r1,r1,low(CONV_NUM_TO_7SEG_DATA)	;���x��CONV_NUM_TO_7SEG_DATA�̉���16�r�b�g��r1�ɃZ�b�g

	ORI		r0,r2,high(SET_GPIO_OUT)			;���x��SET_GPIO_OUT�̏��16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16
	ORI		r2,r2,low(SET_GPIO_OUT)				;���x��SET_GPIO_OUT�̏��16�r�b�g��r2�ɃZ�b�g

	ORI		r0,r3,high(WAIT_PUSH_SW)			;���x��WAIT_PUSH_SW�̏��16�r�b�g��r3�ɃZ�b�g
	SHLLI	r3,r3,16
	ORI		r3,r3,low(WAIT_PUSH_SW)				;���x��WAIT_PUSH_SW�̏��16�r�b�g��r3�ɃZ�b�g

;;; �J�E���^�[�̒l��������
_COUNTER_RESET:
	ORI		r0,r4,0

_7SEG_COUNTER_LOOP:
;;; 7�Z�O�_��
	ORR		r0,r4,r16					;�J�E���^�[�̒l�������ɃZ�b�g
	CALL	r1							;CONV_NUM_TO_7SEG_DATA�Ăяo��
	ANDR	r0,r0,r0					;NOP

	ORR		r0,r17,r16					;�o�̓f�[�^�������ɃZ�b�g
	CALL	r2							;SET_GPIO_OUT�Ăяo��
	ANDR	r0,r0,r0					;NOP

	CALL	r3							;WAIT_PUSH_SW�Ăяo��
	ANDR	r0,r0,r0					;NOP

_COUNT_UP:
	ADDUI	r4,r4,1
	ORI		r0,r5,100
	BE		r5,r4,_COUNTER_RESET
	ANDR	r0,r0,r0					;NOP
	BE		r0,r0,_7SEG_COUNTER_LOOP
	ANDR	r0,r0,r0					;NOP


CONV_NUM_TO_7SEG_DATA:
	;; ���ʂ̌����琔���𒊏o
	ORR		r0,r16,r18					;r16��r18�ɃR�s�[
	XORR	r17,r17,r17					;Return Value�̃N���A
	XORR	r19,r19,r19					;0:1����(7SEG2), 1:2����(7SEG1)
	XORR	r20,r20,r20					;2���ڂ̒l
	;; 10�̈ʂ̒l�����߂�
	ORI		r0,r21,10					;r21��10�������
_SUB10:
	BUGT	r18,r21,_CHECK_0			;r18<r21(r18<10)�Ȃ��_CHECK_0�ɂƂ�
	ANDR	r0,r0,r0					;NOP
	ADDUI	r18,r18,-10
	ADDUI	r20,r20,1
	BE		r0,r0,_SUB10				;r21<r18�Ȃ��SUB10�ɂƂ�
	ANDR	r0,r0,r0					;NOP

_CHECK_0:
	ORI		r0,r21,0
	BNE		r18,r21,_CHECK_1
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_0
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_1:
	ORI		r0,r21,1
	BNE		r18,r21,_CHECK_2
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_1
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_2:
	ORI		r0,r21,2
	BNE		r18,r21,_CHECK_3
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_2
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_3:
	ORI		r0,r21,3
	BNE		r18,r21,_CHECK_4
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_3
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_4:
	ORI		r0,r21,4
	BNE		r18,r21,_CHECK_5
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_4
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_5:
	ORI		r0,r21,5
	BNE		r18,r21,_CHECK_6
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_5
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_6:
	ORI		r0,r21,6
	BNE		r18,r21,_CHECK_7
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_6
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_7:
	ORI		r0,r21,7
	BNE		r18,r21,_CHECK_8
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_7
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_8:
	ORI		r0,r21,8
	BNE		r18,r21,_CHECK_9
	ANDR	r0,r0,r0					;NOP
	ORI		r0,r22,7SEG_DATA_8
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g
	BE		r0,r0,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP

_CHECK_9:
	ORI		r0,r22,7SEG_DATA_9
	BNE		r0,r19,_SET_RETURN_VALUE
	ANDR	r0,r0,r0					;NOP
	SHLLI	r22,r22,8					;7SEG2�p��8�r�b�g�V�t�g

_SET_RETURN_VALUE:
	ORR		r17,r22,r17
	BNE		r0,r19,_CONV_NUM_TO_7SEG_DATA_RETURN
	ANDR	r0,r0,r0					;NOP
_NEXT_DIGIT:
	ORR		r0,r20,r18
	ORI		r19,r19,1					;0:1����(7SEG2), 1:2����(7SEG1)
	BE		r0,r0,_CHECK_0
	ANDR	r0,r0,r0					;NOP
_CONV_NUM_TO_7SEG_DATA_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP


SET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	STW		r17,r16,GPIO_OUT_OFFSET
_SET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP


WAIT_PUSH_SW:
	ORI		r0,r16,GPIO_BASE_ADDR_H
	SHLLI	r16,r16,16
_WAIT_PUSH_SW_ON:
	LDW		r16,r17,GPIO_IN_OFFSET
	BE		r0,r17,_WAIT_PUSH_SW_ON
	ANDR	r0,r0,r0					;NOP
_WAIT_PUSH_SW_OFF:
	LDW		r16,r17,GPIO_IN_OFFSET
	BNE		r0,r17,_WAIT_PUSH_SW_OFF
	ANDR	r0,r0,r0					;NOP
_WAIT_PUSH_SW_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP
