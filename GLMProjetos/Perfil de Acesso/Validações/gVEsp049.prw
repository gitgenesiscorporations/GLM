/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp049 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp049 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida habilita��o do campo empresa                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Valida��o do campo empresa - Rotina gEspI001               ���
���                                       - Rotina gEspI013               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp049()  // Valida habilita��o do campo de empresa

lRet := .F.  // campo desabilitado

If AllTrim(Upper(FunName()))=="GESPM001" .Or. ;  // solicita��o de acesso
   AllTrim(Upper(FunName()))=="GESPM004" .Or. ;  // altera��o de perfil
   AllTrim(Upper(FunName()))=="GESPM005" .Or. ;  // transfer�ncia departamental
   AllTrim(Upper(FunName()))=="GESPM006" .Or. ;  // transfer�ncia entre empresas/filiais
   AllTrim(Upper(FunName()))=="GESPM015"         // sele��o de ambientes/empresas    
	lRet := .T.  // campo habilitado
EndIf	

Return lRet   // retorno da fun��o