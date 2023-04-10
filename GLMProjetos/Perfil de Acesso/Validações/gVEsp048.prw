/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gVEsp048 ³ Autor ³ George AC Gonçalves  ³ Data ³ 16/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gVEsp048 ³ Autor ³ George AC Gonçalves  ³ Data ³ 16/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Exibe Descrição do Departamento do Usuário                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Inic. padrão campo desc. depto. do usuário -Rotina gEspI002³±±
±±³                                                       -Rotina gEspI013³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp048()  // Exibe Descrição do Departamento do Usuário

gcDsDepUsu := ""  // Retorna a Descrição do departamento do usuário

/*
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se não for rotina de solicitação de perfil de acesso
	gcDsDepSol := Replicate("*",30)  // Retorna a Descrição do departamento do usuário

	If AllTrim(Upper(FunName())) == "GESPM015"  // se for rotina de seleção de ambiente
		DbSelectArea("SQB")  // seleciona arquivo de departamentos
		SQB->(DbSetOrder(1))  // muda ordem do índice
		If SQB->(DbSeek(xFilial("SQB")+M->ZZE_CDDEPU))  // posiciona registro
			gcDsDepSol := SQB->QB_DESCRIC  // descrição do departamento
		EndIf                         
	Else
		gcDsDepSol := M->ZZE_DSDEPT
	EndIf
		
///EndIf
*/

/*    
///If AllTrim(Upper(FunName())) <> "GESPM001"  // se não for rotina de solicitação de perfil de acesso
	gcDsDepUsu := Replicate("*",30)  // Retorna a Descrição do departamento do usuário

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do índice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
		gcDsDepUsu := CTT->CTT_DESC01  // descrição do departamento
	EndIf
///EndIf
*/

If AllTrim(Upper(FunName())) <> "GESPM001"  // se não for rotina de solicitação de perfil de acesso
///	gcDsDepUsu := Replicate("*",30)  // Retorna a descrição do cargo/função do usuário solicitante

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
				gcDsDepUsu := ZZE->ZZE_NMDEPU  // descrição do cargo/função solicitante
			EndIf

			TMP->(DbCloseArea())	
			
			If Empty(gcDsDepUsu)  // se descrição do departamento vazio			
				DbSelectArea("CTT")  // seleciona arquivo de departamentos
				CTT->(DbSetOrder(1))  // muda ordem do índice
				If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
					gcDsDepUsu := CTT->CTT_DESC01  // descrição do departamento
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
			gcDsDepUsu := ZZE->ZZE_NMDEPU  // descrição do cargo/função do usuário solicitante
		EndIf

		TMP->(DbCloseArea())	
		
		If Empty(gcDsDepUsu)  // se descrição do departamento vazio			
			DbSelectArea("CTT")  // seleciona arquivo de departamentos
			CTT->(DbSetOrder(1))  // muda ordem do índice
			If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
				gcDsDepUsu := CTT->CTT_DESC01  // descrição do departamento
			EndIf
		EndIf
					
	EndIf	

Else

	DbSelectArea("CTT")  // seleciona arquivo de departamentos
	CTT->(DbSetOrder(1))  // muda ordem do índice
	If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
		gcDsDepUsu := CTT->CTT_DESC01  // descrição do departamento
	EndIf

EndIf

If Empty(gcDsDepUsu)  // se descrição do departamento vazio
	gcDsDepUsu := Replicate("*",30)  // Retorna a descrição do departamento do usuário
EndIf

Return gcDsDepUsu  // retorno da função