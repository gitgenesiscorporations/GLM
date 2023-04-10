/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp006 � Autor � George AC Gon�alves  � Data � 03/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp006 � Autor � George AC Gon�alves  � Data � 03/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida exist�ncia de usu�rio                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o da matr�culo do usu�rio - Rotina gEspI001        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp006()  // Valida exist�ncia de usu�rio

lRet := .T.  // retorno da fun��o

aUsers := AllUsers(.T.)  // array com dados do usu�rio

For lN := 1 To Len(aUsers)  // percorre arquivo de usu�rios
	If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(M->ZZE_NMUSU))  // verifica exist�ncia do usu�rio
		lRet := .F.  // retorno da fun��o
		MsgStop("Usu�rio j� cadastrado n�o pode ter nova solicita��o de inclus�o. Para modificar o perfil selecione outra op��o.","Aten��o")	
		Exit  // aborta opera��o
	EndIf
Next

Return lRet   // retorno da fun��o