/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp002 � Autor � George AC Gon�alves  � Data � 08/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp002 � Autor � George AC Gon�alves  � Data � 08/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recupera e-mail do usu�rio                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do usu�rio - Rotina gCADZZI            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp002()  // Recupea nome do usu�rio

aUsers  := AllUsers(.T.)  // array com dados do usu�rio

gcEMail := aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZI_CDUSU})][1][14]  // recupera descri��o do m�dulo

Return gcEMail   // retorno da fun��o