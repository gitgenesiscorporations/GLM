/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp032 � Autor � George AC Gon�alves  � Data � 26/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp032 � Autor � George AC Gon�alves  � Data � 26/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida habilita��o do campo motivo do bloqueio/desligamento���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Valida��o do campo motivo bloqueio/deslig - Rotina gEspI007���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp032()  // Valida habilita��o do campo de motivo do bloqueio/desligamento

lRet := .T.  // campo desabilitado

If AllTrim(Upper(FunName()))== "GESPM008" .Or. AllTrim(Upper(FunName()))== "GESPM009" .Or. AllTrim(Upper(FunName()))== "GESPM014" .Or. AllTrim(Upper(FunName()))== "GESPM013" .Or. AllTrim(Upper(FunName()))== "GESPM015"
	lRet := .F.  // campo desabilitado
ElseIf AllTrim(Upper(FunName()))=="GESPM001" .And. M->ZZE_VFUNC == "1"
	lRet := .F.  // campo desabilitado
EndIf	

Return lRet   // retorno da fun��o