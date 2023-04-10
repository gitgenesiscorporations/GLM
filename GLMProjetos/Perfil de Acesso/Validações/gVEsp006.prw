/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp006 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp006 � Autor � George AC Gon�alves  � Data � 19/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida usu�rio bloqueado/n�o existente                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do usu�rio - Rotina gEspI001           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp006()  // Valida usu�rio bloqueado/n�o existente

lRet := .T.  // retorno da fun��o

aUsers := AllUsers(.T.)  // array com dados do usu�rio       

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZE_CDSOL) == .T.  // se encontrar usu�rio no arquivo
	If aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZE_CDSOL})][1][17] == .T.  // verifica se usu�rio esta bloqueado
		lRet := .F.  // retorno da fun��o
		MsgStop("Usu�rio bloqueado no Protheus n�o pode solicitar acesso.","Aten��o")	
	EndIf
Else
	lRet := .F.  // retorno da fun��o
	MsgStop("Usu�rio n�o cadastrado no Protheus n�o pode solicitar acesso.","Aten��o")	
EndIf

Return lRet   // retorno da fun��o