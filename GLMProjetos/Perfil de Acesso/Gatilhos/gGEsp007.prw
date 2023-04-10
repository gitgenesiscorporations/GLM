/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gGEsp007 ³ Autor ³ George AC Gonçalves  ³ Data ³ 05/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gGEsp007 ³ Autor ³ George AC Gonçalves  ³ Data ³ 05/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Valida existência de usuário                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Digitação do nome do usuário - Rotina gEspI001             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gGEsp007(cFlag)  // Valida existência de usuário
//cFlag = identificação do processo:
//	      1 = executa îdentificação de usuário homônimo
//		  2 = não executa îdentificação de usuário homônimo

Local lRet := .T.  // retorno da função       
                                                                 
Private mv_par01 := ""                      // Código de Usuário Inicial	    
Private mv_par02 := "999999"                // Código de Usuário Final
Private mv_par03 := ""                      // Departamento Inicial
Private mv_par04 := "ZZZZZZZZZZZZZZZZZZZZ"  // Departamento Final
Private mv_par05 := ""                      // Cargo/Função Inicial
Private mv_par06 := "ZZZZZZZZZZZZZZZZZZZZ"  // Cargo/Função Final
Private mv_par07 := ""                      // Superior Inicial
Private mv_par08 := "ZZZZZZZZZZZZZZZZZZZZ"  // Superior Final
Private mv_par09 := ""                      // Perfil de Acesso Inicial
Private mv_par10 := "ZZZZZZZZZZZZZZZZZZZZ"  // Perfil de Acesso Final
Private mv_par11 := "3"                     // Status Usuário

Public gFlagParam := .F.  // determina seleção de parâmetros: .T. = seleciona, .F. = não seleciona

aUsers := AllUsers(.T.)  // array com dados do usuário

If cFlag == "1"  // se executa îdentificação de usuário homônimo
	For lN := 1 To Len(aUsers)  // percorre arquivo de usuários
		If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(M->ZZE_NMUSU))  // verifica existência do usuário
			nOp := Aviso("Atenção","Já existe um usuário cadastrado com este nome. O que deseja fazer ?",{"Verificar","Confirmar","Cancelar"})
			If nOp == 1  // Verificar perfil do usuário
				mv_par01 := aUsers[lN][1][1]  // Código de Usuário Inicial	    
				mv_par02 := aUsers[lN][1][1]  // Código de Usuário Final	    
				U_gEspR001()  // Relatório de Perfil de Acesso por Usuário			
				If Aviso("Atenção","Mantém o nome do usuário como homônimo ?",{"Sim","Não"}) == 2  // se não aceitar o nome do usuário
					lRet := .F.  // retorno da função
					Exit  // aborta operação			
				EndIf
			ElseIf nOp == 2  // Confirma nome do usuário
				Exit  // aborta operação		
			Else  // Não aceita o nome do usuário
				lRet := .F.  // retorno da função
				Exit  // aborta operação
			EndIf
		EndIf
	Next
ElseIf cFlag == "2"  // se não executa îdentificação de usuário homônimo	
	lRet := .F.  // retorno da função
	For lN := 1 To Len(aUsers)  // percorre arquivo de usuários
		If Upper(AllTrim(aUsers[lN][1][4])) == Upper(AllTrim(M->ZZE_NMUSU))  // verifica existência do usuário
			lRet := .T.  // retorno da função	
		EndIf	
	Next	
EndIf

Return lRet   // retorno da função