/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp013 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp013 � Autor � George AC Gon�alves  � Data � 19/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia do m�dulo                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do m�dulo - Rotina gCADZZG             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp013()  // Valida exist�ncia do m�dulo

lRet := .T.  // m�dulo n�o cadastrado

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

If Ascan(aDescModulos,{|X| X[1] = Val(M->ZZG_CDMOD)}) == 0  // recupera descri��o do m�dulo
	lRet := .F.  // departamento/m�dulo j� cadastrado
	MsgStop("N�o existe este M�dulo no Protheus","Aten��o")	
EndIf	

Return lRet   // retorno da fun��o