/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp039 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp039 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe ID do Usu�rio                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo ID do usu�rio - Rotina gEspI013         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp039()  // Exibe ID do usu�rio

gcIDUsu := ""  // Retorna o ID do usu�rio

If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambientes/empresas
	PSWORDER(2)  // muda ordem de �ndice
	If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		gcIDUsu := aArray[1][2] // Retorna o ID do usu�rio
	EndIf
EndIf

Return gcIDUsu  // retorno da fun��o