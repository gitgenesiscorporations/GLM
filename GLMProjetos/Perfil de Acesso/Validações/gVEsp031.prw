/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp031 � Autor � George AC Gon�alves  � Data � 25/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp031 � Autor � George AC Gon�alves  � Data � 25/05/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida c�digo de usu�rio bloqueado                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Gatilho do campo c�digo de usu�rio - Rotina gEspI006       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp031()  // Valida c�digo de usu�rio bloqueado

lRet := .T.  // departamento/m�dulo n�o cadastrado

If AllTrim(Upper(FunName()))<>"GESPM001"                       

	aUsers := AllUsers(.T.)  // array com dados do usu�rio

	If AllTrim(Upper(FunName()))=="GESPM013"                       
		PSWORDER(1)  // muda ordem de �ndice
		If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
			If aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZE_CDUSU})][1][17] == .F.  // verifica se usu�rio esta bloqueado
				MsgStop("Usu�rio n�o encontra-se bloqueado no Protheus.","Aten��o")	
				lRet := .F.  // departamento/m�dulo n�o cadastrado		
			EndIf
		EndIf
	Else
		PSWORDER(1)  // muda ordem de �ndice
		If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
			If aUsers[Ascan(aUsers,{|X| X[1][1] = M->ZZE_CDUSU})][1][17] == .T.  // verifica se usu�rio esta bloqueado
				MsgStop("Usu�rio encontra-se bloqueado no Protheus.","Aten��o")	
				lRet := .F.  // departamento/m�dulo n�o cadastrado		
			EndIf
		EndIf
	EndIf
		
EndIf	

Return lRet   // retorno da fun��o