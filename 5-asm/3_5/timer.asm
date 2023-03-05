;;; ���P�[�V�����A�h���X�̐ݒ�
	LOCATE	0x20000000

;;; �V���{���̒�`
TIMER_BASE_ADDR_H			EQU	0x4000	;Timer Base Address High
TIMER_CTRL_OFFSET			EQU	0x0		;Timer Control Register Offset
TIMER_INTR_OFFSET			EQU	0x4		;Timer Interrupt Register Offset
TIMER_EXPIRE_OFFSET			EQU	0x8		;Timer Expiration Register Offset
GPIO_BASE_ADDR_H			EQU	0x8000	;GPIO Base Address High
GPIO_OUT_OFFSET				EQU	0x4		;GPIO Data Register Offset


	XORR	r0,r0,r0					;r0���N���A

	ORI		r0,r1,high(SET_GPIO_OUT)	;SET_GPIO_OUT�̏��16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16
	ORI		r1,r1,low(SET_GPIO_OUT)		;SET_GPIO_OUT�̉���16�r�b�g��r1�ɃZ�b�g

	ORI		r0,r2,high(GET_GPIO_OUT)	;GET_GPIO_OUT�̏��16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16
	ORI		r2,r2,low(GET_GPIO_OUT)		;GET_GPIO_OUT�̉���16�r�b�g��r2�ɃZ�b�g

;;; LED����
	ORI		r0,r16,0x1
	SHLLI	r16,r16,16
	ORI		r16,r16,0x0
	CALL	r1
	ANDR	r0,r0,r0

;;; ��O�x�N�^�̐ݒ�
	ORI		r0,r3,high(EXCEPT_HANDLER)
	SHLLI	r3,r3,16
	ORI		r3,r3,low(EXCEPT_HANDLER)
	WRCR	r3,c4

;;; ���荞�݂̏����ݒ�
	;; Mask
	ORI		r0,r3,0xFE					;Interrupt Mask�ɃZ�b�g����l��r3�ɓ����
	WRCR	r3,c6

	;; Status
	ORI		r0,r3,0x2					;Status�ɃZ�b�g����l��r3�ɓ����(IE:1,EM:0)
	WRCR	r3,c0

;;; �^�C�}�̏����ݒ�
	;; Expiration Register
	ORI		r0,r3,TIMER_BASE_ADDR_H		;Timer Base Address���16�r�b�g��r3�ɃZ�b�g
	SHLLI	r3,r3,16
	ORI		r0,r4,0x4C					;�����l�̒l
	SHLLI	r4,r4,16
	ORI		r4,r4,0x4B40				;�����l�̒l
	STW		r3,r4,TIMER_EXPIRE_OFFSET	;�����l��ݒ�
	;; Control Register
	ORI		r0,r4,0x3					;Periodic:1, Start:1
	STW		r3,r4,TIMER_CTRL_OFFSET		;Timer Control Register��ݒ�

;; �����҂�
LOOP:
	BE		r0,r0,LOOP					;�������[�v
	ANDR	r0,r0,r0					;NOP


SET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	STW		r17,r16,GPIO_OUT_OFFSET
_SET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP

GET_GPIO_OUT:
	ORI		r0,r17,GPIO_BASE_ADDR_H
	SHLLI	r17,r17,16
	LDW		r17,r16,GPIO_OUT_OFFSET
_GET_GPIO_OUT_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP


;; ���荞�݃n���h��
EXCEPT_HANDLER:
	;; ���荞�݃X�e�[�^�X�N���A
	ORI		r0,r24,TIMER_BASE_ADDR_H	;Timer Base Address���16�r�b�g��r24�ɃZ�b�g
	SHLLI	r24,r24,16
	STW		r24,r0,TIMER_INTR_OFFSET	;Interrupt���N���A

	;;  LED�o�̓f�[�^�𔽓]
	CALL	r2
	ANDR	r0,r0,r0
	ORI		r0,r24,1
	SHLLI	r24,r24,16
	XORR	r16,r24,r16
	CALL	r1
	ANDR	r0,r0,r0

	;; �x���X���b�g�m�F
	RDCR	c5,r24
	ANDI	r24,r24,0x8
	BE		r0,r24,GOTO_EXRT
	ANDR	r0,r0,r0					;NOP
	RDCR	c3,r24
	ADDUI	r24,r24,-4
	WRCR	r24,c3
GOTO_EXRT:
	;; ���荞�݂����������A�h���X�ɖ߂�
	EXRT
	ANDR	r0,r0,r0					;NOP
