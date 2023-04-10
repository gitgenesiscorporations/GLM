/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gVEsp020 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gVEsp020 � Autor � George AC Gon�alves  � Data � 27/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Descri��o do Cargo/Fun��o do Usu�rio Solicitante     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Inic. padr�o campo desc. cargo usu�rio sol.-Rotina gEspI002���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp020()  // Exibe Descri��o do Cargo/Fun��o do Usu�rio Solicitante

gcDsCargSol := ""  // Retorna a Descri��o do Cargo/Fun��o do usu�rio solicitante

/*
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
	gcDsCargSol := Replicate("*",30)  // Retorna a Descri��o do Cargo/Fun��o do usu�rio solicitante

	DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
	SRJ->(DbSetOrder(1))  // muda ordem do �ndice
	If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
		gcDsCargSol := SRJ->RJ_DESC  // descri��o do cargo/fun��o
	EndIf
///EndIf
*/

If AllTrim(Upper(FunName())) <> "GESPM001"  // se n�o for rotina de solicita��o de perfil de acesso
///	gcDsCargSol := Replicate("*",30)  // Retorna a descri��o do cargo/fun��o do usu�rio solicitante

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de sele��o de ambiente

		PSWORDER(2)  // muda ordem de �ndice
		If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usu�rio no arquivo
			aArray := PSWRET()
		
			cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
			cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "						
			cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
			cQuery += "             ZZE.ZZE_CDUSU  = '" + aArray[1][1]   + "' And "    
			cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

			TCQUERY cQuery Alias TMP NEW                                      

			DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
			ZZE->(DbSetOrder(1))  // muda ordem do �ndice
			If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
				gcDsCargSol := ZZE->ZZE_DSFUNU  // descri��o do cargo/fun��o solicitante
			EndIf

			TMP->(DbCloseArea())	
			
			If Empty(gcDsCargSol)  // se descri��o do cargo/fun��o vazio
				DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
				SRJ->(DbSetOrder(1))  // muda ordem do �ndice
				If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
					gcDsCargSol := SRJ->RJ_DESC  // descri��o do cargo/fun��o
				EndIf			
			EndIf
						
		EndIf	
		
    Else
		cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
		cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "					
		cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
		cQuery += "             ZZE.ZZE_CDSOL  = '" + M->ZZE_CDSOL   + "' And "    
		cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

		TCQUERY cQuery Alias TMP NEW                                      

		DbSelectArea("ZZE")  // seleciona arquivo de solicita��o de acesso - usu�rio
		ZZE->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gcDsCargSol := ZZE->ZZE_DSFUNU  // descri��o do cargo/fun��o do usu�rio solicitante
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcDsCargSol)  // se descri��o do cargo/fun��o vazio
			DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
			SRJ->(DbSetOrder(1))  // muda ordem do �ndice
			If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
				gcDsCargSol := SRJ->RJ_DESC  // descri��o do cargo/fun��o
			EndIf			
		EndIf
					
  EndIf	

Else

	DbSelectArea("SRJ")  // seleciona arquivo de cargo/fun��o
	SRJ->(DbSetOrder(1))  // muda ordem do �ndice
	If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
		gcDsCargSol := SRJ->RJ_DESC  // descri��o do cargo/fun��o
	EndIf
		
EndIf

If Empty(gcDsCargSol)  // se descri��o do cargo/fun��o vazio
	gcDsCargSol := Replicate("*",30)  // Retorna a descri��o do cargo/fun��o do usu�rio solicitante
EndIf

Return gcDsCargSol  // retorno da fun��o