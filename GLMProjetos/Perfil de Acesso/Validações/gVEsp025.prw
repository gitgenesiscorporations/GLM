/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp025 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp025 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Descri��o do Cargo/Fun��o do Usu�rio                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo descri��o cargo usu�rio-Rotina gEspI002 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp025()  // Exibe Descri��o do Cargo/Fun��o do Usu�rio

gcDsCargUsu := ""  // Retorna a Descri��o do Cargo/Fun��o do usu�rio solicitante

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
	SRJ->(DbSetOrder(1))  // muda ordem do �ndice
	If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNU))  // posiciona registro
		gcDsCargUsu := SRJ->RJ_DESC  // descri��o do cargo/fun��o
	EndIf
EndIf

Return gcDsCargUsu  // retorno da fun��o