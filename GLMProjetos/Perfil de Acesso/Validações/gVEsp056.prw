/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp056 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp056 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe se o usu�rio pode avan�ar e/ou retroceder dias       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo per. avan�o/retrocesso - Rotina gEspI013���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp056()  // Exibe se o usu�rio pode avan�ar/retroceder dias

gcPermAvRet := "N"  // Retorna se o usu�rio pode avan�ar/retroceder dias

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gcPermAvRet := If(aArray[1][23][1]==.T.,"S","N") // Retorna se o usu�rio pode avan�ar/retroceder dias
EndIf

Return gcPermAvRet  // retorno da fun��o