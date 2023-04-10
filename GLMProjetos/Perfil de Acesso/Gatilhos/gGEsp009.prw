/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gGEsp009 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gGEsp009 � Autor � George AC Gon�alves  � Data � 07/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recupera ID do usu�rio aprovador                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do departamento - Rotina gEspI001      ���    
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp009()  // Recupera ID do usu�rio aprovador
                                                  
gcUserId := ""  // Retorna o ID do usu�rio

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(aCols[N][AScan(aHeader,{|x|Alltrim(x[2])=='ZZF_GESTOR'})]) == .T.  // se encontrar usu�rio no arquivo
	aArray := PSWRET()
	gcUserId := aArray[1][2] // Retorna o ID do usu�rio
EndIf

Return gcUserId  // retorno da fun��o