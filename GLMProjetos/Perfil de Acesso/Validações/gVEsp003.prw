/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp003 � Autor � George AC Gon�alves  � Data � 10/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp003 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia do m�dulo                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do m�dulo - Rotina gCADZZC             ���
���          � Digita��o do c�digo do perfil - Rotina gCADZZC             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp003()  // Valida exist�ncia do m�dulo

lRet := .T.  // m�dulo n�o cadastrado

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

If Ascan(aDescModulos,{|X| X[1] = Val(M->ZZC_CDMOD)}) == 0  // recupera descri��o do m�dulo
	lRet := .F.  // m�dulo n�o cadastrado
	MsgStop("N�o existe este M�dulo no Protheus","Aten��o")	
EndIf

If lRet == .T. .And. !Empty(M->ZZC_CDMOD)  // se existir m�dulo
	DbSelectArea("ZZC")  // seleciona arquivo de departamento/m�dulo
	ZZC->(DbSetOrder(1))  // muda ordem do �ndice
	If ZZC->(DbSeek(xFilial("ZZC")+M->ZZC_CDMOD+M->ZZC_CDPERF))  // posiciona registro
		lRet := .F.  // departamento/m�dulo j� cadastrado
		MsgStop("M�dulo/Perfil de acesso j� cadastrado","Aten��o")	
	EndIf
EndIf	

Return lRet   // retorno da fun��o