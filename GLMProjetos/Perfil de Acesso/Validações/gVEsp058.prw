/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp058 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp058 � Autor � George AC Gon�alves  � Data � 22/07/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe dias a retroceder para lan�amento                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo dias a retroceder - Rotina gEspI013     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp058()  // Exibe n�mero de dias a retroceder para lan�amento

gnRetrocede := 0  // Retorna n�mero de dias a retroceder para lan�amento

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gnRetrocede := aArray[1][23][2] // Retorna n�mero de dias a retroceder para lan�amento
EndIf

Return gnRetrocede  // retorno da fun��o