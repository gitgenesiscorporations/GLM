/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp013 � Autor � George AC Gon�alves  � Data � 01/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp013 � Autor � George AC Gon�alves  � Data � 01/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Nome do Usu�rio                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo Nome do usu�rio - Rotina gEspI001       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp013()  // Exibe Nome do usu�rio
                                                       
///aUsers  := AllUsers(.T.)  // array com dados do usu�rio

///gcNmUsu := aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZE_CDUSU})][1][4]  // recupera nome do usu�rio                           

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gcNmUsu := aArray[1][4] // Retorna o Nome do usu�rio solicitante
EndIf

Return gcNmUsu  // retorno da fun��o