/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp015 � Autor � George AC Gon�alves  � Data � 02/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp015 � Autor � George AC Gon�alves  � Data � 02/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recupera ID do usu�rio solicitante                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inicializador padr�o campo usu�rio solicit.-Rotina gEspI001���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp015()  // Recupera ID do usu�rio solicitante
                                                  
gcUserId := ""  // Retorna o ID do usu�rio

PSWORDER(2)  // muda ordem de �ndice
If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
	gcUserId := PSWID() // Retorna o ID do usu�rio
EndIf

Return gcUserId  // retorno da fun��o