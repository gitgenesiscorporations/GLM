/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp026 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp026 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe e-Mail do Usu�rio                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo e-Mail usu�rio - Rotina gEspI002        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp026()  // Exibe e-Mail do Usu�rio

gceMailUsu := ""  // Retorna o e-Mail do usu�rio

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	PSWORDER(1)  // muda ordem de �ndice
	If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		gceMailUsu := aArray[1][14] // Retorna o e-mail do usu�rio
	EndIf
EndIf

Return gceMailUsu  // retorno da fun��o