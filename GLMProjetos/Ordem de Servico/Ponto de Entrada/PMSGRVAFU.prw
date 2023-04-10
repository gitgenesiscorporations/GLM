/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informática Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (PMS) - Módulo de Gestão de Projetos                       ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PMSGRVAFU ³ Autor ³ George AC Gonçalves ³ Data ³ 15/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ PMSGRVAFU ³ Autor ³ George AC Gonçalves ³ Data ³ 15/04/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Complemento à gravação dos apontamentos modelo II          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específico: Projeto de ordem de serviço                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Ponto de entrada na rotina PMSA321                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch"       
#include "Topconn.ch"      

User Function PMSGRVAFU()  // Complemento à gravação dos apontamentos modelo II

cArea    := GetArea()          
cAreaAFU := AFU->(GetArea())
cAreaSZ0 := SZ0->(GetArea())
cAreaAF8 := AF8->(GetArea())
cAreaSA1 := SA1->(GetArea())

If ALTERA == .T.
	Private _cNumOS := AFU->AFU_DOCUME
EndIf

_cCliente  := ""  // código do cliente
_cLoja     := ""  // loja do cliente
_cTransl   := ""  // se cobra translado do cliente
_cHrTransl := ""  // hora de translado
_cDescAlm  := ""  // se desconta intervalo de almoço do cliente
_cRespProj := ""  // responsável pelo projeto no cliente

DbSelectArea("AF8")  // Seleciona arquivo de projetos
AF8->(DbSetOrder(1))  // muda ordem do índice
If AF8->(DbSeek(xFilial("AF8")+AFU->AFU_PROJET))  // posiciona registro
	_cCliente  := AF8->AF8_CLIENT      // código do cliente
	_cLoja     := AF8->AF8_LOJA        // loja do cliente
	_cRespProj := AF8->AF8_RESPPR      // responsável pelo projeto no cliente
	
	DbSelectArea("SA1")  // Seleciona arquivo de clientes
	SA1->(DbSetOrder(1))  // muda ordem do índice
	If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))  // posiciona registro
		_cTransl   := SA1->A1_TRANS    // se cobra translado do cliente
		_cHrTransl := SA1->A1_HRTRANS  // hora de translado
		_cDescAlm  := SA1->A1_DESCALM  // se desconta intervalo de almoço do cliente
	EndIf                             

EndIf                             

DbSelectArea("AFU")  // Seleciona arquivo de apontamentos
AFU->(DbSetOrder(7))  // muda ordem do índice
If AFU->(DbSeek(xFilial("AFU")+AFU->AFU_CTRRVS+_cNumOS))  // posiciona registro
	_cHoraAlm := AFU->AFU_HRALM  // hora de intervalo de almoço
EndIf
                                                     
// ***********************************************************************************        
// Recupera hora inicial do atendimento        
cQuery := "Select Min (AFU.AFU_HORAI) As HORAI "
cQuery += "  From " + RetSqlname("AFU") + " AFU "
cQuery += " Where AFU.AFU_FILIAL = '" + xFilial("AFU") + "' And " 
cQuery += "       AFU.AFU_DOCUME = '" + _cNumOS        + "' And " 
cQuery += "       AFU.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())
If TMP->(!Eof())
	_cHoraIni := TMP->HORAI  // hora inicio do atendimento
EndIf                                  
TMP->(DbCloseArea())	

// ***********************************************************************************
// Recupera hora do término do atendimento        
cQuery := "Select Max (AFU.AFU_HORAF) As HORAF "
cQuery += "  From " + RetSqlname("AFU") + " AFU "
cQuery += " Where AFU.AFU_FILIAL = '" + xFilial("AFU") + "' And " 
cQuery += "       AFU.AFU_DOCUME = '" + _cNumOS        + "' And " 
cQuery += "       AFU.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())
If TMP->(!Eof())
	_cHoraFim := TMP->HORAF  // hora do término do atendimento
EndIf                                  
TMP->(DbCloseArea())	

// ***********************************************************************************
// Calcula total das horas do atendimento
_cTtHoras := SubHoras(_cHoraFim,_cHoraIni)  // total das horas do atendimento

// Verifica hora de translado
If _cTransl == "S"  // Se cobra translado do cliente                 
	_cTtHoras := SomaHoras(_cTtHoras,_cHrTransl)  // adiciona hora de translado ao total das horas do atendimento
EndIf

// Verifica hora de intervalo de almoço
If _cDescAlm == "S"  // Se desconta intervalo de almoço do cliente                 
	_cTtHoras := SubHoras(_cTtHoras,_cHoraAlm)  // subtrai hora de intervalo de almoço ao total das horas do atendimento
EndIf                                                                                                                  
                                                                                       
_cTtHoras := AllTrim(StrTran(StrZero(_cTtHoras,5,2),".",":"))  // total das horas do atendimento
                               
// ***********************************************************************************
// Calcula total das horas abonadas do atendimento
cQuery := "Select Sum(AFU.AFU_HQUANT) As TTHORAS "
cQuery += "  From " + RetSqlname("AFU") + " AFU, "
cQuery +=             RetSqlname("SB1") + " SB1  "
cQuery += " Where AFU.AFU_FILIAL = '" + xFilial("AFU") + "' And " 
cQuery += "       AFU.AFU_DOCUME = '" + _cNumOS        + "' And " 
cQuery += "       AFU.D_E_L_E_T_ = ' '                      And "
cQuery += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' And " 
cQuery += "       SB1.B1_COD     = AFU.AFU_COD              And "
cQuery += "       SB1.B1_PRV1    = 0                        And "
cQuery += "       SB1.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())
If TMP->(!Eof())                                   
                                                    
	If At(".",AllTrim(Str(TMP->TTHORAS))) > 0 
		_cTtHrA := Val(AllTrim(Str((Val(SubStr(AllTrim(Str(TMP->TTHORAS)),1,At(".",AllTrim(Str(TMP->TTHORAS)))-1)))))+"."+AllTrim(Str(((Val(SubStr(AllTrim(Str(TMP->TTHORAS)),At(".",AllTrim(Str(TMP->TTHORAS)))+1,99))*60)/100))))  // somatório dos valores faturados
	Else
		_cTtHrA := TMP->TTHORAS  // total das horas abonadas do atendimento	
	EndIf
	_cTtHrA := AllTrim(StrTran(StrZero(_cTtHrA,5,2),".",":"))  // total das horas abonadas do atendimento
	
	// Verifica hora de translado
	If _cTransl == "S"  // Se cobra translado do cliente                 
		_cTtHrA := SomaHoras(_cTtHrA,_cHrTransl)  // adiciona hora de translado ao total das horas do atendimento
	EndIf

	// Verifica hora de intervalo de almoço
	If _cDescAlm == "S"  // Se desconta intervalo de almoço do cliente                 
		_cTtHrA := SubHoras(_cTtHrA,_cHoraAlm)  // subtrai hora de intervalo de almoço ao total das horas do atendimento
	EndIf                                                                                                                  

	_cTtHrA := AllTrim(StrTran(StrZero(_cTtHrA,5,2),".",":"))  // total das horas do atendimento

	_cTtHrAbon := AllTrim(StrTran(StrZero(TMP->TTHORAS,5,2),".",":"))  // total das horas abonadas do atendimento
	
	If _cTtHrA == _cTtHoras                                                                                      
		_cTtHrAbon := _cTtHrA
	EndIf
	
EndIf                                  
TMP->(DbCloseArea())	

// ***********************************************************************************
// Calcula total das horas faturadas do atendimento
cQuery := "Select Sum(AFU.AFU_HQUANT) As TTHORAS "
cQuery += "  From " + RetSqlname("AFU") + " AFU, "
cQuery +=             RetSqlname("SB1") + " SB1  "
cQuery += " Where AFU.AFU_FILIAL = '" + xFilial("AFU") + "' And " 
cQuery += "       AFU.AFU_DOCUME = '" + _cNumOS        + "' And " 
cQuery += "       AFU.D_E_L_E_T_ = ' '                      And "
cQuery += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' And " 
cQuery += "       SB1.B1_COD     = AFU.AFU_COD              And "
cQuery += "       SB1.B1_PRV1    > 0                        And "
cQuery += "       SB1.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())
If TMP->(!Eof())

	If At(".",AllTrim(Str(TMP->TTHORAS))) > 0 
		_cTtHrF := Val(AllTrim(Str((Val(SubStr(AllTrim(Str(TMP->TTHORAS)),1,At(".",AllTrim(Str(TMP->TTHORAS)))-1)))))+"."+AllTrim(Str(((Val(SubStr(AllTrim(Str(TMP->TTHORAS)),At(".",AllTrim(Str(TMP->TTHORAS)))+1,99))*60)/100))))  // somatório dos valores faturados
	Else
		_cTtHrF := TMP->TTHORAS  // total das horas faturadas do atendimento	
	EndIf
	_cTtHrF := AllTrim(StrTran(StrZero(_cTtHrF,5,2),".",":"))  // total das horas abonadas do atendimento
	
	// Verifica hora de translado
	If _cTransl == "S"  // Se cobra translado do cliente                 
		_cTtHrF := SomaHoras(_cTtHrF,_cHrTransl)  // adiciona hora de translado ao total das horas do atendimento
	EndIf

	// Verifica hora de intervalo de almoço
	If _cDescAlm == "S"  // Se desconta intervalo de almoço do cliente                 
		_cTtHrF := SubHoras(_cTtHrF,_cHoraAlm)  // subtrai hora de intervalo de almoço ao total das horas do atendimento
	EndIf                                                                                                                  

	_cTtHrF := AllTrim(StrTran(StrZero(_cTtHrF,5,2),".",":"))  // total das horas do atendimento

	_cTtHrFat := AllTrim(StrTran(StrZero(TMP->TTHORAS,5,2),".",":"))  // total das horas faturadas do atendimento
	
	If _cTtHrF == _cTtHoras
		_cTtHrFat := _cTtHrF
	EndIf

EndIf                                  
TMP->(DbCloseArea())	
                                                                                                   
// ***********************************************************************************        
_cHoraIni  := AllTrim(StrTran(StrZero(Val(_cHoraIni),5,2),".",":"))   // hora inicio do atendimento
_cHoraAlm  := AllTrim(StrTran(StrZero(Val(_cHoraAlm),5,2),".",":"))   // hora de intervalo de almoço
_cHrTransl := AllTrim(StrTran(StrZero(Val(_cHrTransl),5,2),".",":"))  // hora de translado
_cHoraFim  := AllTrim(StrTran(StrZero(Val(_cHoraFim),5,2),".",":"))   // hora do término do atendimento

// Grava cabeçalho da ordem de serviço          
DbSelectArea("SZ0")  // Seleciona arquivo de cabeçalho de ordem de serviço
SZ0->(DbSetOrder(1))  // muda ordem do índice
If SZ0->(!DbSeek(xFilial("SZ0")+_cNumOS))  // posiciona registro
	RecLock("SZ0",.T.)  // se bloquear registro
	SZ0->Z0_FILIAL  := xFilial("SZ0")   // código da filial
	SZ0->Z0_NUMOS   := _cNumOS          // número da ordem de serviço
	SZ0->Z0_CDREC   := AFU->AFU_RECURS  // código do recurso
	SZ0->Z0_DTEMIS  := AFU->AFU_DATA    // data de emissão/apontamento
	SZ0->Z0_PROJETO := AFU->AFU_PROJET  // código do projeto
	SZ0->Z0_REVISAO := AFU->AFU_REVISA  // número da sequencia de revisão
	SZ0->Z0_CTRRVS  := AFU->AFU_CTRRVS  // controle de revisão
	SZ0->Z0_CLIENTE := _cCliente        // código do cliente
	SZ0->Z0_LOJA    := _cLoja           // loja do cliente
	SZ0->Z0_TRANS   := _cTransl         // se cobra translado do cliente
	SZ0->Z0_DESCALM := _cDescAlm        // se desconta intervalo de almoço do cliente
	SZ0->Z0_RESPPR  := _cRespProj       // responsável pelo projeto no cliente
	SZ0->Z0_HRINI   := _cHoraIni        // hora inicio do atendimento
	SZ0->Z0_HRALM   := _cHoraAlm        // hora de intervalo de almoço
	SZ0->Z0_HRTRANS := _cHrTransl       // hora de translado
	SZ0->Z0_HRFIM   := _cHoraFim        // hora do término do atendimento
	SZ0->Z0_HRTOT   := _cTtHoras        // total das horas do atendimento
	SZ0->Z0_HRFAT   := _cTtHrFat        // total das horas faturadas do atendimento
	SZ0->Z0_HRABO   := _cTtHrAbon       // total das horas abonadas do atendimento
	MsUnLock()  // libera registro bloqueado                                                 
Else	
	RecLock("SZ0",.F.)  // se bloquear registro
	SZ0->Z0_DTEMIS  := AFU->AFU_DATA    // data de emissão/apontamento		
	SZ0->Z0_PROJETO := AFU->AFU_PROJET  // código do projeto
	SZ0->Z0_REVISAO := AFU->AFU_REVISA  // número da sequencia de revisão
	SZ0->Z0_CTRRVS  := AFU->AFU_CTRRVS  // controle de revisão
	SZ0->Z0_CLIENTE := _cCliente        // código do cliente
	SZ0->Z0_LOJA    := _cLoja           // loja do cliente
	SZ0->Z0_TRANS   := _cTransl         // se cobra translado do cliente
	SZ0->Z0_DESCALM := _cDescAlm        // se desconta intervalo de almoço do cliente
	SZ0->Z0_RESPPR  := _cRespProj       // responsável pelo projeto no cliente	
	SZ0->Z0_HRINI   := _cHoraIni        // hora inicio do atendimento
	SZ0->Z0_HRALM   := _cHoraAlm        // hora de intervalo de almoço
	SZ0->Z0_HRTRANS := _cHrTransl       // hora de translado
	SZ0->Z0_HRFIM   := _cHoraFim        // hora do término do atendimento
	SZ0->Z0_HRTOT   := _cTtHoras        // total das horas do atendimento
	SZ0->Z0_HRFAT   := _cTtHrFat        // total das horas faturadas do atendimento
	SZ0->Z0_HRABO   := _cTtHrAbon       // total das horas abonadas do atendimento
	MsUnLock()  // libera registro bloqueado                                                 
EndIf
                                              
SA1->(RestArea(cAreaSA1))
AF8->(RestArea(cAreaAF8))
SZ0->(RestArea(cAreaSZ0))
AFU->(RestArea(cAreaAFU))
RestArea(cArea)

Return  // retorno da função