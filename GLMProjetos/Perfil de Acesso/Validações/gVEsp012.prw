/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp012 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp012 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe ID do Usu�rio Solicitante                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Habilita��o do campo ID Solicitante - Rotina gEspI001      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp012()  // Exibe ID do Usu�rio Solicitante

gcUserId := ""  // Retorna o ID do usu�rio

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDSOL) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gcUserId := aArray[1][2] // Retorna o ID do usu�rio
EndIf

Return gcUserId  // retorno da fun��o