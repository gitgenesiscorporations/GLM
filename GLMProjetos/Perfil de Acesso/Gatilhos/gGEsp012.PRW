/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp012 � Autor � George AC Gon�alves  � Data � 25/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp012 � Autor � George AC Gon�alves  � Data � 25/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida digita��o de c�digo departamento X c�digo m�dulo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do departamento - Rotina gEspI001      ���
���                                                - Rotina gEspI002      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp012()  // Valida digita��o de c�digo departamento X c�digo m�dulo

cArea    := GetArea()
cAreaZZJ := ZZJ->(GetArea())

lRet := .T.  // retorno da fun��o    

cCdDept := ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDDEPT"})]
cCdMod  := ACols[N][Ascan(aHeader,{|x|x[2]="ZZF_CDMOD" })]

If !Empty(cCdMod)  // se c�digo do m�dulo preenchido
	DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
	ZZJ->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZJ->(!DbSeek(xFilial("ZZJ")+cCdDept+cCdMod))  // se n�o existir o departamento/m�dulo
		MsgStop("N�o existe o departamento/m�dulo cadastrado.","Aten��o")	
		lRet := .F.  // retorno da fun��o	
	EndIf
EndIf	

ZZJ->(RestArea(cAreaZZJ))
RestArea(cArea)

Return lRet  // retorno da fun��o