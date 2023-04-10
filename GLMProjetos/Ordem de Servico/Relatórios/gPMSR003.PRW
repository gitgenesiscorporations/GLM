/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informática Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (PMS) - Módulo de Gestão de Projetos                       ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gPMSR003  ³ Autor ³ George AC. Gonçalves ³ Data ³ 29/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gPMSR003     ³ Autor ³ George Gonçalves ³ Data ³ 29/04/14 ³±±
±±³          ³ gResumo      ³ Autor ³ George Gonçalves ³ Data ³ 29/04/14 ³±±
±±³          ³ gImpCabecalho³ Autor ³ George Gonçalves ³ Data ³ 28/04/14 ³±±
±±³          ³ gImpRodape   ³ Autor ³ George Gonçalves ³ Data ³ 28/04/14 ³±±
±±³          ³ ValidPerg    ³ Autor ³ George Gonçalves ³ Data ³ 29/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Emissão do Fechamento Mensal - Colaborador/Técnico         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específico: Projeto de ordem de serviço                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada via menu - Rotina gPMSR003                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "Topconn.ch"      
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "AP5MAIL.CH"
#include "PROTHEUS.CH"
#include "FONT.CH"

User Function gPMSR003()  // Emissão do Fechamento Mensal - Colaborador/Técnico

cPerg := Padr("GLM002",10)

//+---------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                  ¦
//+---------------------------------------------------------------------+
ValidPerg()  // chamada a função de validação de grupo de perguntas

//+---------------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                                ¦
//¦ mv_par01  // Código do Recurso                                      ¦
//¦ mv_par02  // Mês/Ano Fechamento                                     ¦
//+---------------------------------------------------------------------+ 
If !Pergunte(cPerg,.T.)
	Return  // Retorno da função
EndIf

RptStatus({|| gResumo()},,"Imprimindo fechamento mensal... " + Time())

Return  // retorno da função      
****************************************************************************************************************************************************

Static Function gResumo()  // Função de impressão do fechamento mensal

Private li   := 9999
Private nPag := 1 

Private oFont01N 
Private oFont02N 
Private oFont02N 

Define FONT oFont1 NAME "Times New Roman" BOLD

oFont01N := TFont():New("Times New Roman",11,11,,.T.,,,,.T.,.F.)
oFont03N := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
oFont02N := TFont():New("Times New Roman",09,09,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New("Emissão do Fechamento Mensal - Colaborador/Técnico")

oPrint:SetPortrait() 

ProcRegua(1)
                                                           
aDsMes     := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
_cTTHoras  := ""
_cTTABO    := ""
_cTTFAT    := ""
_cTTValFat := 0

DbSelectArea("SM0")  // seleciona arquivo de empresas
SM0->(DbSetOrder(1))  // muda ordem do índice
If SM0->(DbSeek(cEmpAnt+cFilAnt))  // posiciona registro
	_cCidade := SM0->M0_CIDCOB  // nome do cliente
EndIf

DbSelectArea("AE8")  // seleciona arquivo de recursos
AE8->(DbSetOrder(1))  // muda ordem do índice
If AE8->(DbSeek(xFilial("AE8")+mv_par01))  // posiciona registro
	_cNmRecurso := AE8->AE8_DESCRI   // nome do recurso
	_ceMailRec  := AE8->AE8_EMAIL    // e-mail do recurso
	
	DbSelectArea("SA2")  // seleciona arquivo de fornecedores
	SA2->(DbSetOrder(10))  // muda ordem do índice
	If SA2->(DbSeek(xFilial("SA2")+AE8->AE8_USER))  // posiciona registro
		_cCidRec  := SA2->A2_MUN       // município do fornecedor/recurso
		_cEstRec  := SA2->A2_EST       // estado do fornecedor/recurso
		_nVlHoras := SA2->A2_VLHORAS   // valor das horas do fornecedor/técnico
		_nVlFixo  := SA2->A2_VLRFIXO   // valor fixo do fornecedor/técnico		
	EndIf
EndIf	
          
// Select da pesquisa do fechamento
cQuery := "Select SZ0.Z0_NUMOS   As NUMOS  , " 
cQuery += "       SZ0.Z0_DTEMIS  As DTEMIS , " 
cQuery += "       SZ0.Z0_HRTOT   As HRTOT  , " 
cQuery += "       SZ0.Z0_HRABO   As HRABO  , " 
cQuery += "       SZ0.Z0_HRFAT   As HRFAT  , " 
cQuery += "       SZ0.Z0_RESPPR  As RESPPR , " 
cQuery += "       SZ0.Z0_CLIENTE As CLIENTE, " 
cQuery += "       SZ0.Z0_LOJA    As LOJA     " 
cQuery += "  From " + RetSqlname("SZ0") + " SZ0 "
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                            + " ' And " 
cQuery += "       SZ0.Z0_CDREC     = '" + mv_par01                                  + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(mv_par02,4,4)+SubStr(mv_par02,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                  And " 
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                      "
cQuery += "Order By SZ0.Z0_DTEMIS, SZ0.Z0_NUMOS "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

Do While TMP->(!Eof())  // percorre o arquivo no intervalo
	_cNumOS     := TMP->NUMOS   // número da OS
	_cDtEmis    := TMP->DTEMIS  // data de emissão/apontamento da OS
	_cHoraTotal := TMP->HRTOT   // total de horas do atendimento             
	_cHoraABO   := TMP->HRABO   // total de horas abonadas
	_cHoraFAT   := TMP->HRFAT   // total de horas faturadas
	_nValFat    := _nVlHoras * (Val(SubStr(_cHoraFAT,1,2))+(Val(SubStr(_cHoraFAT,4,2))/60))  // somatório dos valores faturados

	DbSelectArea("SA1")  // seleciona arquivo de clientes
	SA1->(DbSetOrder(1))  // muda ordem do índice
	If SA1->(DbSeek(xFilial("SA1")+TMP->CLIENTE+TMP->LOJA))  // posiciona registro
		_cNmCliente := SA1->A1_NOME  // nome do cliente
	EndIf

	// valida cancelamento pelo operador
	If LASTKEY() == 286 .Or. LASTKEY() == 27             
		Exit 
	EndIf

	If li > 2800  // se quebra de página
		If nPag > 1  // se não for impressão da 1a página
			gImpRodape()  // chamada a função de impressão do rodapé
		Endif
		
		gImpCabecalho()  // chamada a função de impressão do cabeçalho			
	EndIf   
                 
	oPrint:Say(li,0105,DToC(SToD(_cDtEmis)),oFont02N)
	oPrint:Say(li,0285,"GLM OS " + SubStr(_cNumOS,1,4)+"-"+SubStr(_cNumOS,5,6),oFont02N)
	oPrint:Say(li,0635,SubStr(_cNmCliente,1,28),oFont02N)
	oPrint:Say(li,1235,_cHoraTotal,oFont02N)	
	oPrint:Say(li,1510,_cHoraABO,oFont02N)
	oPrint:Say(li,1785,_cHoraFAT,oFont02N)			                                
	If _nValFat > 0
		oPrint:Say(li,2122,TRANSFORM(_nValFat,"@E 9,999,999,999.99"),oFont02N)				
	Else
		oPrint:Say(li,2140,TRANSFORM(_nValFat,"@E 9,999,999,999.99"),oFont02N)			
	EndIf
                                       
	_cTTHoras  := SomaHoras(_cTTHoras,_cHoraTotal)  // somatório das horas
	_cTTABO    := SomaHoras(_cTTABO  ,_cHoraABO)    // somatório das horas abonadas
	_cTTFAT    := SomaHoras(_cTTFAT  ,_cHoraFAT)    // somatório das horas faturadas
	_cTTValFat := _cTTValFat + _nValFat             // somatório dos valores faturados

	li := li + 50  // incrementa contador de linhas         						                                                                   
				
	TMP->(DbSkip())  // incrementa contador de registros
    	  	
EndDo                                                         

If !Empty(_cTTHoras)
	_cTTHoras := AllTrim(StrTran(StrZero(_cTTHoras,5,2),".",":"))  // total das horas do atendimento
	_cTTABO   := AllTrim(StrTran(StrZero(_cTTABO,5,2),".",":"))    // total das horas abonadas
	_cTTFAT   := AllTrim(StrTran(StrZero(_cTTFAT,5,2),".",":"))    // total das horas faturadas
	
	oPrint:Line(li,0100,li,2325)						

	li := li + 30  // incrementa contador de linhas         						                                                                   
	
	oPrint:Say(li,1233,_cTTHoras,oFont03N)
	oPrint:Say(li,1508,_cTTABO,oFont03N)
	oPrint:Say(li,1783,_cTTFAT,oFont03N)			                                        
	If _cTTValFat > 0
		oPrint:Say(li,2109,TRANSFORM(_cTTValFat,"@E 9,999,999,999.99"),oFont03N)				
	Else
		oPrint:Say(li,2127,TRANSFORM(_cTTValFat,"@E 9,999,999,999.99"),oFont03N)					
	EndIf
EndIf

TMP->(DbCloseArea())	

gImpRodape()  // chamada a função de impressão do rodapé
oPrint:Preview()	
	
Return  // retorno da função
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do ¡ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","Código do Recurso"     ,"Código do Recurso"     ,"Código do Recurso"     ,"mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","AE8","","","","",""})
	Aadd(aRegs,{cPerg,"02","Mês/Ano Fechamento"    ,"Mês/Ano Fechamento"    ,"Mês/Ano Fechamento"    ,"mv_ch2","C",07,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","",""})			

   For i := 1 To Len(aRegs)
      RecLock("SX1",.T.)
      For j := 1 To FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])              
         EndIf
      Next
      MsUnlock()
   Next
	
EndIf

Return  // Retorno da função
***************************************************************************************************************************************************

Static Function gImpCabecalho()  // Impressão do cabeçalho

oPrint:StartPage()

oPrint:SayBitmap(0000,0100,"LogoGLMCabec.Bmp",2235,0600)		

If nPag == 1  // se não for impressão da 1a página

	oPrint:Say(0600,0300,AllTrim(_cCidade) + ", " + SubStr(DToS(dDataBase),7,2) + " de " + aDsMes[Val(SubStr(DToS(dDataBase),5,2))] + " de " + SubStr(DToS(dDataBase),1,4) + ".",oFont01N)

	oPrint:Say(0700,0300,"À",oFont01N)

	oPrint:Say(0750,0300,AllTrim(_cNmRecurso),oFont01N)

	oPrint:Say(0800,0300,AllTrim(_cCidRec) + " / " +  AllTrim(_cEstRec),oFont01N)

	oPrint:Say(0900,0300,"Referência: Resumo do Faturamento - " + aDsMes[Val(SubStr(mv_par02,1,2))] + SubStr(mv_par02,3,5),oFont01N)
	
	oPrint:Say(1000,0300,"Prezado(a) Colaborador(a) " + AllTrim(_cNmRecurso) + ",",oFont01N)

	oPrint:Say(1100,0450,"Segue resumo do faturamento referente aos serviços executados no mês de",oFont01N)

	oPrint:Say(1150,0300,aDsMes[Val(SubStr(mv_par02,1,2))] + SubStr(mv_par02,3,5) + ".",oFont01N)	

	oPrint:Say(1300,0100,"QUADRO DEMONSTRATIVO DE HORAS:",oFont01N)
	
	oPrint:Line(1350,0100,1350,2325)			

	oPrint:Say(1370,0100,"DATA",oFont02N)
	oPrint:Say(1370,0284,"OS´s",oFont02N)	
	oPrint:Say(1370,0630,"CLIENTE",oFont02N)		                                
	oPrint:Say(1370,1230,"TOTAL HORAS",oFont02N)										
	oPrint:Say(1370,1505,"HS ABONADAS",oFont02N)
	oPrint:Say(1370,1780,"HS FATURADA",oFont02N)
	oPrint:Say(1370,2055,"VR FATURADO",oFont02N)									

	oPrint:Line(1430,0100,1430,2325)			

	li := 1460
		
Else	
	oPrint:Say(0600,0100,"QUADRO DEMONSTRATIVO DE HORAS:",oFont01N)

	oPrint:Line(0600,0100,0600,2325)			

	oPrint:Say(0620,0100,"DATA",oFont02N)
	oPrint:Say(0620,0284,"OS´s",oFont02N)	
	oPrint:Say(0620,0630,"CLIENTE",oFont02N)		                                
	oPrint:Say(0620,1230,"TOTAL HORAS",oFont02N)										
	oPrint:Say(0620,1505,"HS ABONADAS",oFont02N)
	oPrint:Say(0620,1780,"HS FATURADA",oFont02N)
	oPrint:Say(0620,2055,"VR FATURADO",oFont02N)									

	oPrint:Line(0780,0100,0780,2325)			

	li := 780
	
EndIf					

nPag++  // incrementa contador de páginas

Return  // Retorno da função
***************************************************************************************************************************************************

Static Function gImpRodape()  // Impressão do rodapé

Do Case
	Case cFilAnt == "01"  // GLM Informática
		oPrint:SayBitmap(2900,0100,"LogoGLMInfoRod.Bmp",2235,0370)			
	Case cFilAnt == "02"  // GLM Empreendimentos
		oPrint:SayBitmap(2900,0100,"LogoGLMEmprRod.Bmp",2235,0370)		
	Case cFilAnt == "03"  // GLM Consulting
EndCase                     

oPrint:EndPage()

Return  // Retorno da função