/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp002 � Autor � George AC Gon�alves  � Data � 18/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp002 � Autor � George AC Gon�alves  � Data � 18/12/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida usu�rio bloqueado                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do usu�rio - Rotina gCADZZI            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp002()  // Valida usu�rio bloqueado

lRet := .T.  // departamento/m�dulo n�o cadastrado

aUsers := AllUsers(.T.)  // array com dados do usu�rio
      
PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->ZZI_CDUSU) == .T.  // se encontrar usu�rio no arquivo
	If aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZI_CDUSU})][1][17] == .T.  // verifica se usu�rio esta bloqueado
		lRet := .F.  // departamento/m�dulo j� cadastrado
		MsgStop("Usu�rio bloqueado no Protheus n�o pode ser cadastrado como aprovador.","Aten��o")	
	EndIf
Else	
	lRet := .F.  // departamento/m�dulo j� cadastrado
	MsgStop("Usu�rio n�o cadastrado no Protheus n�o pode ser cadastrado como aprovador.","Aten��o")	
EndIf

Return lRet   // retorno da fun��o