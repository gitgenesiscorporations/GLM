/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp051 � Autor � George AC Gon�alves  � Data � 22/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp051 � Autor � George AC Gon�alves  � Data � 22/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida habilita��o do campo c�digo do departamento         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Valida��o do campo c�digo do cargo/fun��o - Rotina gEspI003���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp051()  // Valida habilita��o do campo c�digo do departamento

lRet := .F.  // campo desabilitado

If AllTrim(Upper(FunName()))=="GESPM005" .Or.;  // transfer�ncia departamental
   AllTrim(Upper(FunName()))=="GESPM006"        // transfer�ncia entre empresas/filiais
	lRet := .T.  // campo habilitado                                         
EndIf	

Return lRet   // retorno da fun��o