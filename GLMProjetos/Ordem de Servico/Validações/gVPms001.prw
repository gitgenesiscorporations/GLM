/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informática Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (PMS) - Módulo de Gestão de Projetos                       ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gVPms001 ³ Autor ³ George AC Gonçalves  ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gVPms001 ³ Autor ³ George AC Gonçalves  ³ Data ³ 09/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Valida usuário bloqueado/não existente                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específico: Projeto de ordem de serviço                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Digitação do código do usuário - Rotina MATA020            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"

User Function gVPms001()  // Valida usuário bloqueado/não existente

cArea    := GetArea()          
cAreaSA2 := SA2->(GetArea())

lRet := .T.  // retorno da função

aUsers := AllUsers(.T.)  // array com dados do usuário       

PSWORDER(1)  // muda ordem de índice
If PswSeek(M->A2_CDUSR) == .T.  // se encontrar usuário no arquivo
	If aUsers[Ascan(aUsers,{|X| X[1][1] == M->A2_CDUSR})][1][17] == .T.  // verifica se usuário esta bloqueado
		lRet := .F.  // retorno da função
		MsgStop("Usuário encontra-se bloqueado no Protheus","Atenção")	
	EndIf
Else
	lRet := .F.  // retorno da função
	MsgStop("Usuário não cadastrado no Protheus","Atenção")	
EndIf                                                              

If M->A2_CDUSR == "000000"  // Código de Usuário Administrador
	lRet := .F.  // retorno da função
	MsgStop("Fornecedor não pode ser associado ao usuário Administrador","Atenção")	
EndIf

DbSelectArea("SA2")  // Seleciona arquivo de fornecedores
SA2->(DbSetOrder(10))  // muda ordem do índice
If SA2->(DbSeek(xFilial("SA2")+M->A2_CDUSR))  // posiciona registro
	lRet := .F.  // retorno da função
	MsgStop("Usuário ja associado a outro código de fornecedor ["+SA2->A2_COD+"/"+SA2->A2_LOJA+"-"+SA2->A2_NOME+"]","Atenção")	
EndIf
               
SA2->(RestArea(cAreaSA2))
RestArea(cArea)

Return lRet   // retorno da função