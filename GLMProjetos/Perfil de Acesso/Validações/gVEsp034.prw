/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp034 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp034 � Autor � George AC Gon�alves  � Data � 15/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe c�digo do Usu�rio                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�digo usu�rio - Rotina gEspI013        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp034()  // Exibe c�digo do usu�rio

gcCdUsu := ""  // Retorna o c�digo do usu�rio

If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambientes/empresas
	PSWORDER(2)  // muda ordem de �ndice
	If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		gcCdUsu := aArray[1][1] // Retorna o e-mail do usu�rio solicitante
	EndIf
EndIf

Return gcCdUsu  // retorno da fun��o