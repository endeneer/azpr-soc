;;; �V���{���̒�`
GPIO_BASE_ADDR_H	EQU	0x8000		;GPIO Base Address High
GPIO_OUT_OFFSET		EQU	0x4			;GPIO Output Port Register Offset

;;; LED�_��
	XORR	r0,r0,r0
	ORI		r0,r1,GPIO_BASE_ADDR_H	;GPIO Base Address���16�r�b�g��r1�ɃZ�b�g
	SHLLI	r1,r1,16				;16�r�b�g���V�t�g
	ORI		r0,r2,0x1				;�o�̓f�[�^�����16�r�b�g��r2�ɃZ�b�g
	SHLLI	r2,r2,16				;16�r�b�g���V�t�g
	ORI		r2,r2,0x0000			;�o�̓f�[�^������16�r�b�g��r2�ɃZ�b�g
	STW		r1,r2,GPIO_OUT_OFFSET	;GPIO Output Port�ɏo�̓f�[�^����������

;;; �������[�v
LOOP:
	BE		r0,r0,LOOP				;LOOP�ɖ߂�
	ANDR	r0,r0,r0				;NOP
