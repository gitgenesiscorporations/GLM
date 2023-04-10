/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp046 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp046 � Autor � George AC Gon�alves  � Data � 16/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Nome do Usu�rio Superior                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo nome usu�rio superior- Rotina gEspI013  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp046()  // Exibe o nome do usu�rio superior

gcNmUsuSup := M->ZZE_NMSOL  // Retorna o c�digo do usu�rio superior

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambientes/empresas
		PSWORDER(1)  // muda ordem de �ndice
		If PswSeek(M->ZZE_USUSUP) == .T.  // se encontrar usu�rio no arquivo
			aArray := PSWRET()
			gcNmUsuSup := aArray[1][4] // Retorna o nome do usu�rio superior
		EndIf
	Else
		gcNmUsuSup := M->ZZE_NMSOL
	EndIf
		
EndIf

Return gcNmUsuSup  // retorno da fun��o