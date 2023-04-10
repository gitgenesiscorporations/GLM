/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp001 � Autor � George AC Gon�alves  � Data � 08/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp001 � Autor � George AC Gon�alves  � Data � 08/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia do departamento/m�dulo                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do departamento - Rotina gCADZZJ       ���
���          � Digita��o do c�digo do m�dulo       - Rotina gCADZZJ       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp001()  // Valida exist�ncia do departamento/m�dulo

lRet := .T.  // departamento/m�dulo n�o cadastrado

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

If !Empty(M->ZZJ_CDMOD) .And. (Ascan(aDescModulos,{|X| X[1] = Val(M->ZZJ_CDMOD)})) == 0  // recupera descri��o do m�dulo
	lRet := .F.  // departamento/m�dulo j� cadastrado
	MsgStop("N�o existe este M�dulo no Protheus","Aten��o")	
EndIf

If lRet == .T. .And. !Empty(M->ZZJ_CDDEP)  // se existir departamento
	DbSelectArea("ZZJ")  // seleciona arquivo de departamento/m�dulo
	ZZJ->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZJ->(DbSeek(xFilial("ZZJ")+M->ZZJ_CDDEP+M->ZZJ_CDMOD))  // posiciona registro
		lRet := .F.  // departamento/m�dulo j� cadastrado
		MsgStop("Departamento/M�dulo j� cadastrado","Aten��o")	
	EndIf
EndIf	

Return lRet   // retorno da fun��o