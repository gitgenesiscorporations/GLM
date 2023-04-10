/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp033 � Autor � George AC Gon�alves  � Data � 10/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp033 � Autor � George AC Gon�alves  � Data � 10/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida habilita��o do campo c�digo do cargo/fun��o         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Valida��o do campo c�digo do cargo/fun��o - Rotina gEspI001���
���                                                      - Rotina gEspI002���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp033()  // Valida habilita��o do campo c�digo do cargo/fun��o

lRet := .F.  // campo desabilitado

If AllTrim(Upper(FunName()))=="GESPM001" .Or. ;  // solicita��o de acesso
   AllTrim(Upper(FunName()))=="GESPM004" .Or. ;  // altera��o de cargo/fun��o
   AllTrim(Upper(FunName()))=="GESPM005" .Or. ;  // transfer�ncia departamental
   AllTrim(Upper(FunName()))=="GESPM006"         // transfer�ncia entre empresas/filiais
	lRet := .T.  // campo habilitado
EndIf	

Return lRet   // retorno da fun��o