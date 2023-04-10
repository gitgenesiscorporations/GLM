/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (PMS) - M�dulo de Gest�o de Projetos                       ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVPms001 � Autor � George AC Gon�alves  � Data � 09/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVPms001 � Autor � George AC Gon�alves  � Data � 09/04/14  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida usu�rio bloqueado/n�o existente                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de ordem de servi�o                    ���
��������������������������������������������������������������������������ٱ�
���Partida   � Digita��o do c�digo do usu�rio - Rotina MATA020            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVPms001()  // Valida usu�rio bloqueado/n�o existente

cArea    := GetArea()          
cAreaSA2 := SA2->(GetArea())

lRet := .T.  // retorno da fun��o

aUsers := AllUsers(.T.)  // array com dados do usu�rio       

PSWORDER(1)  // muda ordem de �ndice
If PswSeek(M->A2_CDUSR) == .T.  // se encontrar usu�rio no arquivo
	If aUsers[Ascan(aUsers,{|X| X[1][1] == M->A2_CDUSR})][1][17] == .T.  // verifica se usu�rio esta bloqueado
		lRet := .F.  // retorno da fun��o
		MsgStop("Usu�rio encontra-se bloqueado no Protheus","Aten��o")	
	EndIf
Else
	lRet := .F.  // retorno da fun��o
	MsgStop("Usu�rio n�o cadastrado no Protheus","Aten��o")	
EndIf                                                              

If M->A2_CDUSR == "000000"  // C�digo de Usu�rio Administrador
	lRet := .F.  // retorno da fun��o
	MsgStop("Fornecedor n�o pode ser associado ao usu�rio Administrador","Aten��o")	
EndIf

DbSelectArea("SA2")  // Seleciona arquivo de fornecedores
SA2->(DbSetOrder(10))  // muda ordem do �ndice
If SA2->(DbSeek(xFilial("SA2")+M->A2_CDUSR))  // posiciona registro
	lRet := .F.  // retorno da fun��o
	MsgStop("Usu�rio ja associado a outro c�digo de fornecedor ["+SA2->A2_COD+"/"+SA2->A2_LOJA+"-"+SA2->A2_NOME+"]","Aten��o")	
EndIf
               
SA2->(RestArea(cAreaSA2))
RestArea(cArea)

Return lRet   // retorno da fun��o