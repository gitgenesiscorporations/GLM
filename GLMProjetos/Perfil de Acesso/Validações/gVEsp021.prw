/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp021 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp021 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe e-Mail do Usu�rio Solicitante                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo e-Mail usu�rio solic. - Rotina gEspI002 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp021()  // Exibe e-Mail do Usu�rio Solicitante

gceMailSol := ""  // Retorna o e-Mail do usu�rio solicitante

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	PSWORDER(1)  // muda ordem de �ndice
	If PswSeek(M->ZZE_CDSOL) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		gceMailSol := aArray[1][14] // Retorna o e-mail do usu�rio solicitante
	EndIf
///EndIf

Return gceMailSol  // retorno da fun��o