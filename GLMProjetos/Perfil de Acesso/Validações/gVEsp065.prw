/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp065 � Autor � George AC Gon�alves  � Data � 04/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp065 � Autor � George AC Gon�alves  � Data � 04/12/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida c�digo de usu�rio x responsavel pelo CC             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Gatilho do campo c�digo de usu�rio - Rotina gEspI002       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp065()  // Valida c�digo de usu�rio x responsavel pelo CC

lRet := .F.  // flag de retorno falso

If AllTrim(Upper(FunName())) <> "GESPM001"  // se rotina n�o for de novo usu�rio

	If AllTrim(Upper(FunName())) == "GESPM008" .Or. AllTrim(Upper(FunName())) == "GESPM009" .Or. AllTrim(Upper(FunName())) == "GESPM013"  // se rotina de opera��es do DP
		lRet := .T.  // flag de retorno verdadeiro				
		
	Else
		PSWORDER(1)  // muda ordem de �ndice
		If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usu�rio no arquivo
			aArray := PSWRET()
			cIDSuper := aArray[1][11]  // Retorna ID do usu�rio superior
		
			If PswSeek(cIDSuper) == .T.  // se encontrar usu�rio no arquivo
				aArray := PSWRET()
				cCDSuper := aArray[1][2]  // Retorna C�digo do usu�rio superior
			                             
///				DbSelectArea("CTT")  // seleciona arquivo de centro de custo
///				CTT->(DbSetOrder(1))  // muda ordem do �ndice
///				If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
///					If AllTrim(Upper(CTT->CTT_IDRESP)) <> AllTrim(Upper(cCDSuper))  // se o solicitante responsavel pelo CC
					If Empty(M->ZZE_MATUSU) .Or. M->ZZE_MATUSU == "******"
						lRet := .T.  // flag de retorno verdadeiro								
					ElseIf AllTrim(Upper(SubStr(cUsuario,7,15))) <> AllTrim(Upper(cCDSuper))  // se o solicitante responsavel pelo CC
						MsgStop("Usu�rio selecionado n�o pertence ao centro de custo do solicitante","Aten��o")	
					Else	                                      
						lRet := .T.  // flag de retorno verdadeiro			
					EndIf
///				EndIf

			EndIf
		
		EndIf
		
    EndIf
    
EndIf

Return lRet   // retorno da fun��o