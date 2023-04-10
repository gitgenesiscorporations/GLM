/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gCADZZI ³ Autor ³ George A.C. Gonçalves ³ Data ³ 30/12/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gCADZZI ³ Autor ³ George A.C. Gonçalves ³ Data ³ 30/12/08  ³±±
±±³          ³ gVALZZI ³ Autor ³ George A.C. Gonçalves ³ Data ³ 30/12/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Manutenção no cadastro de aprovadores (Gestor/Controller)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada via menu                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gCADZZI()  // Manutenção no cadastro de aprovadores (Gestor/Controller)                                            

AxCadastro("ZZI","Manutenção no cadastro de aprovadores (Gestor/Controller)",".T.","U_gVALZZI()")  // chamada a função de Manutenção no cadastro de aprovadores (Gestor/Controller)

Return  // retorno da função                                                                   
***************************************************************************************************************************************************

User Function gVALZZI()  // validação gravação de aprovadores

lRet := .T.  // retorno da função

If M->ZZI_TIPO <> "1"  // verifica se já informado controller para a empresa                
	cQuery := "    SELECT COUNT(*) AS QTD_TIPO "
	cQuery += "      FROM " + RetSqlname("ZZI") + " ZZI "
	cQuery += "     WHERE ZZI.ZZI_FILIAL = '" + xFilial("ZZI") + "' And " 
	cQuery += "           ZZI.ZZI_TIPO  <> '1'                      And "    
	cQuery += "           ZZI.D_E_L_E_T_ = ' '                          "
                                
	TCQUERY cQuery Alias TMP NEW                                      

	If INCLUI == .T. .And. TMP->QTD_TIPO > 0  // se existir tipo controller
		lRet := .F.  // retorno da função
		MsgStop("Já existe Controller registrado.","Atenção")			
	EndIf
	
	If ALTERA == .T. .And. ZZI->ZZI_TIPO <> M->ZZI_TIPO  // se empresa modificada
		If TMP->QTD_TIPO > 0  // se existir tipo controller
			lRet := .F.  // retorno da função
			MsgStop("Já existe Controller registrado.","Atenção")			
		EndIf
	EndIf

	TMP->(DbCloseArea())	
	
EndIf

Return lRet  // retorno da função