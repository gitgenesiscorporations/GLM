/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp016 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp016 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Nome do Usu�rio Solicitante                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo nome usu�rio solicitante-Rotina gEspI002���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp016()  // Exibe Nome do Usu�rio Solicitante

gcNmUsuSol := ""  // Retorna o Nome do usu�rio solicitante

///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	PSWORDER(1)  // muda ordem de �ndice
	If PswSeek(M->ZZE_CDSOL) == .T.  // se encontrar usu�rio no arquivo
		aArray := PSWRET()
		gcNmUsuSol := aArray[1][4] // Retorna o Nome do usu�rio solicitante
	EndIf
///EndIf	

Return gcNmUsuSol  // retorno da fun��o