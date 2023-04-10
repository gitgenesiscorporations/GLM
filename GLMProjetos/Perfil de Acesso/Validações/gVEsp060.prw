/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gVEsp060 ³ Autor ³ George AC Gonçalves  ³ Data ³ 02/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gVEsp060 ³ Autor ³ George AC Gonçalves  ³ Data ³ 02/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Filtra matrícula pelo responsável do centro de custo       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Inic. padrão campo matrícula do usuário - Rotina gEspI001  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gVEsp060()  // Filtra matrícula pelo responsável do centro de custo

lRet := .T.  // flag de retorno verdadeiro

If M->ZZE_MATSOL == M->ZZE_MATUSU  // se matrícula do solicitante igual ao do usuário
	lRet := .F.  // flag de retorno falso
	MsgStop("Matrícula do usuário não pode ser a mesma que o solicitante","Atenção")	
EndIf
                                                                        
DbSelectArea("SRA")  // seleciona arquivo de funcionários
SRA->(DbSetOrder(1))  // muda ordem do índice
If SRA->(!DbSeek(xFilial("SRA")+M->ZZE_MATUSU))  // posiciona registro
	lRet := .F.  // flag de retorno falso
	MsgStop("Matrícula do usuário não cadastrada no arquivo de funcionário do módulo de folha de pagamento","Atenção")	 
Else
	If !Empty(SRA->RA_SITFOLH)  // se situação não for normal
		lRet := .F.  // flag de retorno falso
		MsgStop("Funcionário não esta com a situação normalizada no módulo de folha de pagamento","Atenção")	 	
	EndIf
EndIf

DbSelectArea("CTT")  // seleciona arquivo de centro de custo
CTT->(DbSetOrder(1))  // muda ordem do índice
If CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))  // posiciona registro
	If AllTrim(Upper(CTT->CTT_IDRESP)) <> AllTrim(Upper(SubStr(cUsuario,7,15)))  // se o solicitante responsavel pelo CC
		lRet := .F.  // flag de retorno falso
		MsgStop("Funcionário não pertence ao centro de custo sob responsabilidade do solicitante","Atenção")		
	EndIf
EndIf
                                       
Return lRet  // retorno da função