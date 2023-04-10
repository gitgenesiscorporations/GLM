/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gVEsp065 ³ Autor ³ George AC Gonçalves  ³ Data ³ 04/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gVEsp065 ³ Autor ³ George AC Gonçalves  ³ Data ³ 04/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Valida código de usuário x responsavel pelo CC             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Gatilho do campo código de usuário - Rotina gEspI002       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gVEsp065()  // Valida código de usuário x responsavel pelo CC

lRet := .F.  // flag de retorno falso

If AllTrim(Upper(FunName())) <> "GESPM001"  // se rotina não for de novo usuário

	If AllTrim(Upper(FunName())) == "GESPM008" .Or. AllTrim(Upper(FunName())) == "GESPM009" .Or. AllTrim(Upper(FunName())) == "GESPM013"  // se rotina de operações do DP
		lRet := .T.  // flag de retorno verdadeiro				
		
	Else
		PSWORDER(1)  // muda ordem de índice
		If PswSeek(M->ZZE_CDUSU) == .T.  // se encontrar usuário no arquivo
			aArray := PSWRET()
			cIDSuper := aArray[1][11]  // Retorna ID do usuário superior
		
			If PswSeek(cIDSuper) == .T.  // se encontrar usuário no arquivo
				aArray := PSWRET()
				cCDSuper := aArray[1][2]  // Retorna Código do usuário superior
			                             
///				DbSelectArea("CTT")  // seleciona arquivo de centro de custo
///				CTT->(DbSetOrder(1))  // muda ordem do índice
///				If CTT->(DbSeek(xFilial("CTT")+M->ZZE_CDDEPU))  // posiciona registro
///					If AllTrim(Upper(CTT->CTT_IDRESP)) <> AllTrim(Upper(cCDSuper))  // se o solicitante responsavel pelo CC
					If Empty(M->ZZE_MATUSU) .Or. M->ZZE_MATUSU == "******"
						lRet := .T.  // flag de retorno verdadeiro								
					ElseIf AllTrim(Upper(SubStr(cUsuario,7,15))) <> AllTrim(Upper(cCDSuper))  // se o solicitante responsavel pelo CC
						MsgStop("Usuário selecionado não pertence ao centro de custo do solicitante","Atenção")	
					Else	                                      
						lRet := .T.  // flag de retorno verdadeiro			
					EndIf
///				EndIf

			EndIf
		
		EndIf
		
    EndIf
    
EndIf

Return lRet   // retorno da função