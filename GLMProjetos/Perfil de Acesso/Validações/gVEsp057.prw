/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp057 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp057 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe dias a avan�ar para lan�amento                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo dias a avan�ar - Rotina gEspI013        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp057()  // Exibe n�mero de dias a avan�ar para lan�amento

gnAvanco := 0  // Retorna n�mero de dias a avan�ar para lan�amento

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gnAvanco := aArray[1][23][3]  // Retorna n�mero de dias a avan�ar para lan�amento
EndIf

Return gnAvanco  // retorno da fun��o