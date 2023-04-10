/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp045 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp045 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe C�digo do Usu�rio Superior                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo c�digo usu�rio superior- Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp045()  // Exibe o c�digo do usu�rio superior

gcCdUsuSup := M->ZZE_CDSOL  // Retorna o c�digo do usu�rio superior

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambientes/empresas
		PSWORDER(2)  // muda ordem de �ndice
		If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
			aArray := PSWRET()
			gcCdUsuSup := aArray[1][11] // Retorna o c�digo do usu�rio superior
		EndIf
	Else
		gcCdUsuSup := M->ZZE_CDSOL
	EndIf
		
EndIf

Return gcCdUsuSup  // retorno da fun��o