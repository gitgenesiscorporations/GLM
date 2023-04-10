/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gVEsp020 ³ Autor ³ George AC Gonçalves  ³ Data ³ 27/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gVEsp020 ³ Autor ³ George AC Gonçalves  ³ Data ³ 27/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Exibe Descrição do Cargo/Função do Usuário Solicitante     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Inic. padrão campo desc. cargo usuário sol.-Rotina gEspI002³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp020()  // Exibe Descrição do Cargo/Função do Usuário Solicitante

gcDsCargSol := ""  // Retorna a Descrição do Cargo/Função do usuário solicitante

/*
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se não for rotina de solicitação de perfil de acesso
	gcDsCargSol := Replicate("*",30)  // Retorna a Descrição do Cargo/Função do usuário solicitante

	DbSelectArea("SRJ")  // seleciona arquivo de cargo/função
	SRJ->(DbSetOrder(1))  // muda ordem do índice
	If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
		gcDsCargSol := SRJ->RJ_DESC  // descrição do cargo/função
	EndIf
///EndIf
*/

If AllTrim(Upper(FunName())) <> "GESPM001"  // se não for rotina de solicitação de perfil de acesso
///	gcDsCargSol := Replicate("*",30)  // Retorna a descrição do cargo/função do usuário solicitante

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de seleção de ambiente

		PSWORDER(2)  // muda ordem de índice
		If PswSeek(SubStr(cUsuario,7,15)) == .T.  // se encontrar usuário no arquivo
			aArray := PSWRET()
		
			cQuery := "      Select Max(ZZE.ZZE_NUMSOL) As NUMSOL "
			cQuery += "        FROM " + RetSqlname("ZZE") + " ZZE "						
			cQuery += "       Where ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' And "
			cQuery += "             ZZE.ZZE_CDUSU  = '" + aArray[1][1]   + "' And "    
			cQuery += "			    ZZE.D_E_L_E_T_ = ' '                          "

			TCQUERY cQuery Alias TMP NEW                                      

			DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
			ZZE->(DbSetOrder(1))  // muda ordem do índice
			If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
				gcDsCargSol := ZZE->ZZE_DSFUNU  // descrição do cargo/função solicitante
			EndIf

			TMP->(DbCloseArea())	
			
			If Empty(gcDsCargSol)  // se descrição do cargo/função vazio
				DbSelectArea("SRJ")  // seleciona arquivo de cargo/função
				SRJ->(DbSetOrder(1))  // muda ordem do índice
				If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
					gcDsCargSol := SRJ->RJ_DESC  // descrição do cargo/função
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

		DbSelectArea("ZZE")  // seleciona arquivo de solicitação de acesso - usuário
		ZZE->(DbSetOrder(1))  // muda ordem do índice
		If ZZE->(DbSeek(xFilial("ZZE")+TMP->NUMSOL))  // posiciona registro
			gcDsCargSol := ZZE->ZZE_DSFUNU  // descrição do cargo/função do usuário solicitante
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcDsCargSol)  // se descrição do cargo/função vazio
			DbSelectArea("SRJ")  // seleciona arquivo de cargo/função
			SRJ->(DbSetOrder(1))  // muda ordem do índice
			If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
				gcDsCargSol := SRJ->RJ_DESC  // descrição do cargo/função
			EndIf			
		EndIf
					
  EndIf	

Else

	DbSelectArea("SRJ")  // seleciona arquivo de cargo/função
	SRJ->(DbSetOrder(1))  // muda ordem do índice
	If SRJ->(DbSeek(xFilial("SRJ")+M->ZZE_CDFUNC))  // posiciona registro
		gcDsCargSol := SRJ->RJ_DESC  // descrição do cargo/função
	EndIf
		
EndIf

If Empty(gcDsCargSol)  // se descrição do cargo/função vazio
	gcDsCargSol := Replicate("*",30)  // Retorna a descrição do cargo/função do usuário solicitante
EndIf

Return gcDsCargSol  // retorno da função