/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informática Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (PMS) - Módulo de Gestão de Projetos                       ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gPMSM002  ³ Autor ³ George AC Gonçalves ³ Data ³ 02/05/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gPMSM002  ³ Autor ³ George AC Gonçalves ³ Data ³ 02/05/14  ³±±
±±³          ³ ValidPerg ³ Autor ³ George AC Gonçalves ³ Data ³ 02/05/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Gerar Fechamento Mensal dos Serviços:                      ³±±
±±³          ³ Pedido de Venda Cliente para faturamento                   ³±±
±±³          ³ Pedido de Compra Colaborador para pagamento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específico: Projeto de ordem de serviço                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Chamada via menu - Rotina gPMSM002                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                               
#Include "rwmake.ch" 
#include "topconn.ch"

User Function gPMSM002()  // Gerar Fechamento Mensal dos Serviços

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros              ³
//³ mv_par01  // Mês/Ano Fechamento                   ³          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := "GLM003"

ValidPerg()  // valida grupo de pergunta   
If Pergunte(cPerg,.T.) == .T.  // se cancelar operação
   RptStatus({||RptDetail()},"Fechamento do período. Aguarde...")  // chamada a função de geração dos direitos autorais 
Else
   Return  // retorno da fun‡Æo                       
EndIf           

Return  // retorno da fun‡Æ
********************************************************************************************************************

Static Function RptDetail()  // função de geração das notas fiscais de entrada

Private aCabSC5      := {}             // define array do cabeçalho do pedido de venda
Private aItemSC6     := {}             // define array dos itens do pedido de venda
Private aLinhaSC6    := {}             // define array dos itens do pedido de venda
Private aCabSC7      := {}             // define array do cabeçalho do pedido de compras
Private aItemSC7     := {}             // define array dos itens do pedido de compras
Private aLinhaSC7    := {}             // define array dos itens do pedido de compras
Private _GLMmv_par01 := mv_par01       // define conteúdo da pergunta


// Processa fechamento para o cliente - Gera arquivos do pedido de venda SC5/SC6
// Select da pesquisa do fechamento
cQuery := "Select SZ0.Z0_CLIENTE AS CLIENTE, "
cQuery += "       SZ0.Z0_LOJA    AS LOJA,    "
cQuery += "       Sum(CONVERT(INT,(SubString(SZ0.Z0_HRTOT,1,PATINDEX('%:%',SZ0.Z0_HRTOT)-1)))+((CONVERT(INT,(Right(SZ0.Z0_HRTOT,2)))/0.6)/100)) AS TOTALHORAS "
cQuery += "  From " + RetSqlname("SZ0") + " SZ0 "
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                              "
cQuery += "Group By SZ0.Z0_CLIENTE,SZ0.Z0_LOJA "
cQuery += "Order By SZ0.Z0_CLIENTE,SZ0.Z0_LOJA "

TcQuery cQuery Alias "TMP" New

TMP->(DbGotop())  // vai para o início do arquivo
Do While TMP->(!Eof())  // percorre todo o arquivo

	aCabSC5  := {}  // define array do cabeçalho do pedido de venda
	aItemSC6 := {}  // define array do itens do pedido de venda

	_cNumPed :=GetSXENum("SC5","C5_NUM")  // Recupera número do pedido de venda        
	_cItem   := 0

	// Recupera dados do cliente		                                    
	DbSelectArea("SA1")  // seleciona arquivo de cliente
	SA1->(DbSetOrder(1))  // muda ordem do índice
	SA1->(DbSeek(xFilial("SA1")+TMP->CLIENTE+TMP->LOJA))  // posiciona registro
	
	// define array do cabeçalho do pedido de venda
	aCabSC5 := {{"C5_FILIAL" , xFilial("SC5")          , NIL},;
                {"C5_NUM"    , _cNumPed                , NIL},;
                {"C5_TIPO"   , "N"		               , NIL},;                    
                {"C5_CLIENTE", TMP->CLIENTE            , NIL},;                    
                {"C5_LOJACLI", TMP->LOJA	           , NIL},;                
                {"C5_CLIENT" , TMP->CLIENTE            , NIL},;                    
                {"C5_LOJAENT", TMP->LOJA	           , NIL},;                    
                {"C5_TIPOCLI", SA1->A1_TIPO            , NIL},;                    
                {"C5_CONDPAG", SA1->A1_COND            , NIL},;                    
                {"C5_TABELA" , SA1->A1_TABELA          , NIL},;
                {"C5_VEND1"  , SA1->A1_VEND            , NIL},;
                {"C5_COMIS1" , SA1->A1_COMIS           , NIL},;
                {"C5_EMISSAO", CToD("01/"+_GLMmv_par01), NIL},;                    
                {"C5_TPFRETE", "S"    		           , NIL},;                    
                {"C5_MOEDA"  , 1             	       , NIL},;                                
                {"C5_LIBEROK", "S"		               , NIL},;                
                {"C5_TIPLIB" , "2"   	               , NIL},;                
                {"C5_TXMOEDA", 1         	           , NIL}}
            
	// Select da pesquisa do fechamento por produto
	cQuery := "Select SZ0.Z0_CLIENTE AS CLIENTE, "
	cQuery += "       SZ0.Z0_LOJA    AS LOJA,    "
	cQuery += "       AFU.AFU_COD    AS PRODUTO, "
	cQuery += "       Sum(CONVERT(INT,(SubString(SZ0.Z0_HRTOT,1,PATINDEX('%:%',SZ0.Z0_HRTOT)-1)))+((CONVERT(INT,(Right(SZ0.Z0_HRTOT,2)))/0.6)/100)) AS TOTALHORAS "
	cQuery += "  From " + RetSqlname("SZ0") + " SZ0, "
	cQuery +=             RetSqlname("AFU") + " AFU, "
	cQuery +=             RetSqlname("SB1") + " SB1  "
	cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
	cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 	
	cQuery += "       SZ0.Z0_CLIENTE   = '" + TMP->CLIENTE                                      + "'  And " 
	cQuery += "       SZ0.Z0_LOJA      = '" + TMP->LOJA                                         + "'  And " 			
	cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
	cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 	
	cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                          And "
	cQuery += "       AFU.AFU_FILIAL   = '" + xFilial("AFU")                                    + " ' And " 
	cQuery += "       AFU.AFU_DOCUME   = SZ0.Z0_NUMOS                                                 And "
	cQuery += "       AFU.D_E_L_E_T_   = ' '                                                          And "
	cQuery += "       SB1.B1_FILIAL    = '" + xFilial("SB1")                                    + " ' And " 
	cQuery += "       SB1.B1_COD       = AFU.AFU_COD                                                  And "
	cQuery += "       SB1.B1_PRV1      > 0                                                            And "
	cQuery += "       SB1.D_E_L_E_T_   = ' '                                                              " 
	cQuery += "Group By SZ0.Z0_CLIENTE,SZ0.Z0_LOJA,AFU.AFU_COD "
	cQuery += "Order By SZ0.Z0_CLIENTE,SZ0.Z0_LOJA,AFU.AFU_COD "

	TcQuery cQuery Alias "TMPC6" New

	TMPC6->(DbGotop())  // vai para o início do arquivo
	Do While TMPC6->(!Eof())  // percorre todo o arquivo

		_cItem := _cItem + 1  // incrementa contador de itens
		
		// Recupera dados do produto
		DbSelectArea("SB1")  // seleciona arquivo de produtos
		SB1->(DbSetOrder(1))  // muda ordem do índice
		SB1->(DbSeek(xFilial("SB1")+TMPC6->PRODUTO))  // posiciona registro

		// Recupera dados da tabela de preço
		DbSelectArea("DA1")  // seleciona arquivo de itens da tabela de preço
		DA1->(DbSetOrder(1))  // muda ordem do índice
		DA1->(DbSeek(xFilial("SB1")+SA1->A1_TABELA+TMPC6->PRODUTO))  // posiciona registro

		// Recupera dados da tabela de preço
		DbSelectArea("DA1")  // seleciona arquivo de itens da tabela de preço
		DA1->(DbSetOrder(1))  // muda ordem do índice
		DA1->(DbSeek(xFilial("SB1")+SA1->A1_TABELA+TMPC6->PRODUTO))  // posiciona registro

		// Recupera dados do TES
		DbSelectArea("SF4")  // seleciona arquivo de TES
		SF4->(DbSetOrder(1))  // muda ordem do índice
		SF4->(DbSeek(xFilial("SF4")+SB1->B1_TS))  // posiciona registro

		// define array dos itens do pedido de venda              
		aLinhaSC6 := {}  // define array dos itens do pedido de venda
		AaDd(aLinhaSC6, {"C6_FILIAL" , xFilial("SC6")                         , NIL})
		AaDd(aLinhaSC6, {"C6_ITEM"   , StrZero(_cItem,2)                      , NIL})
		AaDd(aLinhaSC6, {"C6_PRODUTO", TMPC6->PRODUTO                         , NIL})
		AaDd(aLinhaSC6, {"C6_UM"     , SB1->B1_UM                             , NIL})
		AaDd(aLinhaSC6, {"C6_QTDVEN" , TMPC6->TOTALHORAS                      , NIL})
		AaDd(aLinhaSC6, {"C6_PRCVEN" , DA1->DA1_PRCVEN                        , NIL})
		AaDd(aLinhaSC6, {"C6_VALOR"  , (TMPC6->TOTALHORAS*DA1->DA1_PRCVEN)    , NIL})
		AaDd(aLinhaSC6, {"C6_QTDLIB" , TMPC6->TOTALHORAS                      , NIL})
		AaDd(aLinhaSC6, {"C6_TES"    , SB1->B1_TS                             , NIL})
		AaDd(aLinhaSC6, {"C6_LOCAL"  , SB1->B1_LOCPAD                         , NIL})
		AaDd(aLinhaSC6, {"C6_CF"     , SF4->F4_CF                             , NIL})
		AaDd(aLinhaSC6, {"C6_CLI"    , TMP->CLIENTE                           , NIL})		
		AaDd(aLinhaSC6, {"C6_ENTREG" , CToD("01/"+_GLMmv_par01)               , NIL})
		AaDd(aLinhaSC6, {"C6_LOJA"   , TMP->LOJA                              , NIL})				
		AaDd(aLinhaSC6, {"C6_NUM"    , _cNumPed                               , NIL})						
		AaDd(aLinhaSC6, {"C6_COMIS1" , SA1->A1_COMIS                          , NIL})		
		AaDd(aLinhaSC6, {"C6_DESCRI" , SB1->B1_DESC                           , NIL})				
		AaDd(aLinhaSC6, {"C6_PRUNIT" , DA1->DA1_PRCVEN                        , NIL})

		AaDd(aItemSC6,aLinhaSC6)		
		
		TMPC6->(DbSkip())  // incrementa contador de registros
		
	EndDo
		
	TMPC6->(DbCloseArea())			                                    
    
    If !Empty(aItemSC6)  // se possuir itens a faturar    
		Begin Transaction    
			lMSErroAuto := .F.
			MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabSC5,aItemSC6,3)   //Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}         
			If lMsErroAuto  // se existe erro na transação
				MostraErro() 			
				DisarmTransaction()
	            Break
			EndIf
		End Transaction                         
	EndIf	      	    

	TMP->(DbSkip())  // incrementa contador de registro

EndDo

TMP->(DbCloseArea())  // fecha arquivo temporário                               


// Processa fechamento para o colaborador - Gera arquivo do pedido de compra SC7
// Select da pesquisa do fechamento
cQuery := "Select SZ0.Z0_CDREC AS RECURSO, "
cQuery += "       Sum(CONVERT(INT,(SubString(SZ0.Z0_HRTOT,1,PATINDEX('%:%',SZ0.Z0_HRTOT)-1)))+((CONVERT(INT,(Right(SZ0.Z0_HRTOT,2)))/0.6)/100)) AS TOTALHORAS "
cQuery += "  From " + RetSqlname("SZ0") + " SZ0 "
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 	
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                              "
cQuery += "Group By SZ0.Z0_CDREC "
cQuery += "Order By SZ0.Z0_CDREC "

TcQuery cQuery Alias "TMP" New

TMP->(DbGotop())  // vai para o início do arquivo
Do While TMP->(!Eof())  // percorre todo o arquivo

	aCabSC7  := {}  // define array do cabeçalho do pedido de compra
	aItemSC7 := {}  // define array do itens do pedido de compra

	// Recupera dados do Recurso
	DbSelectArea("AE8")  // seleciona arquivo de recursos
	AE8->(DbSetOrder(1))  // muda ordem do índice
	AE8->(DbSeek(xFilial("AE8")+TMP->RECURSO))  // posiciona registro
	
	// Recupera dados do Fornecedores
	DbSelectArea("SA2")  // seleciona arquivo de fornecedores
	SA2->(DbSetOrder(10))  // muda ordem do índice
	SA2->(DbSeek(xFilial("SA2")+AE8->AE8_USER))  // posiciona registro
    If SA2->A2_VLHORAS == 0 .And. SA2->A2_VLRFIXO == 0  // se fornecedor sem valor de horas ou fixo não gera pedido de compra
    	TMP->(DbSkip())  // incrementa contador de registro
    	Loop  // pega próximo registro
    EndIf

	_cNumPed :=GetSXENum("SC7","C7_NUM")  // Recupera número do pedido de compra
	_cItem   := 0
		
	// define array do cabeçalho do pedido de compra
	aCabSC7 := {{"C7_FILIAL" , xFilial("SC7")          , NIL},;
            	{"C7_NUM"    , _cNumPed                , NIL},;
            	{"C7_TIPO"   , "1"                     , NIL},;            	
                {"C7_EMISSAO", CToD("01/"+_GLMmv_par01), NIL},;
                {"C7_FORNECE", SA2->A2_COD             , NIL},;
                {"C7_LOJA"   , SA2->A2_LOJA            , NIL},;
                {"C7_COND"   , SA2->A2_COND            , NIL},;   
                {"C7_CONTATO", SA2->A2_NREDUZ          , NIL},;   
                {"C7_FILENT" , xFilial("SC7")          , NIL},;
                {"C7_MOEDA"  , 1                       , NIL},;
                {"C7_TXMOEDA", 1                       , NIL}}
                                
	// Select da pesquisa do fechamento por produto
	cQuery := "Select SZ0.Z0_CDREC AS RECURSO, "
	cQuery += "       AFU.AFU_COD  AS PRODUTO, "
	cQuery += "       Sum(CONVERT(INT,(SubString(SZ0.Z0_HRTOT,1,PATINDEX('%:%',SZ0.Z0_HRTOT)-1)))+((CONVERT(INT,(Right(SZ0.Z0_HRTOT,2)))/0.6)/100)) AS TOTALHORAS "
	cQuery += "  From " + RetSqlname("SZ0") + " SZ0, "
	cQuery +=             RetSqlname("AFU") + " AFU, "
	cQuery +=             RetSqlname("SB1") + " SB1  "
	cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
	cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 	
	cQuery += "       SZ0.Z0_CDREC     = '" + TMP->RECURSO                                      + "'  And " 
	cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
	cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 		
	cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                          And "
	cQuery += "       AFU.AFU_FILIAL   = '" + xFilial("AFU")                                    + " ' And " 
	cQuery += "       AFU.AFU_DOCUME   = SZ0.Z0_NUMOS                                                 And "
	cQuery += "       AFU.D_E_L_E_T_   = ' '                                                          And "
	cQuery += "       SB1.B1_FILIAL    = '" + xFilial("SB1")                                    + " ' And " 
	cQuery += "       SB1.B1_COD       = AFU.AFU_COD                                                  And "
	cQuery += "       SB1.B1_PRV1      > 0                                                            And "
	cQuery += "       SB1.D_E_L_E_T_   = ' '                                                              " 
	cQuery += "Group By SZ0.Z0_CDREC,AFU.AFU_COD "
	cQuery += "Order By SZ0.Z0_CDREC,AFU.AFU_COD "

	TcQuery cQuery Alias "TMPC7" New

	TMPC7->(DbGotop())  // vai para o início do arquivo
	Do While TMPC7->(!Eof())  // percorre todo o arquivo
                                
		_cItem := _cItem + 1  // incrementa contador de linhas
                        
		// Recupera dados do produto
		DbSelectArea("SB1")  // seleciona arquivo de produtos
		SB1->(DbSetOrder(1))  // muda ordem do índice
		SB1->(DbSeek(xFilial("SB1")+TMPC7->PRODUTO))  // posiciona registro
		
		// define array do itens do pedido de compra                                                                                                
		aLinhaSC7 := {}  // define array dos itens do pedido de venda		
		AaDd(aLinhaSC7, {"C7_ITEM"   , StrZero(_cItem,4)                      , NIL})
		AaDd(aLinhaSC7, {"C7_PRODUTO", TMPC7->PRODUTO                         , NIL})
		AaDd(aLinhaSC7, {"C7_UM"     , SB1->B1_UM                             , NIL})
		AaDd(aLinhaSC7, {"C7_QUANT"  , TMPC7->TOTALHORAS                      , NIL})
		AaDd(aLinhaSC7, {"C7_PRECO"  , SA2->A2_VLHORAS                        , NIL})
		AaDd(aLinhaSC7, {"C7_TOTAL"  , (TMPC7->TOTALHORAS*SA2->A2_VLHORAS)    , NIL})		
		AaDd(aLinhaSC7, {"C7_DINICQ" , CToD("01/"+_GLMmv_par01)               , NIL})		
		AaDd(aLinhaSC7, {"C7_DINITRA", CToD("01/"+_GLMmv_par01)               , NIL})		
		AaDd(aLinhaSC7, {"C7_DINICOM", CToD("01/"+_GLMmv_par01)               , NIL})				
		AaDd(aLinhaSC7, {"C7_DATPRF" , CToD("01/"+_GLMmv_par01)               , NIL})
		AaDd(aLinhaSC7, {"C7_LOCAL"  , SB1->B1_LOCPAD                         , NIL})
		AaDd(aLinhaSC7, {"C7_DESCRI" , SB1->B1_DESC                           , NIL})		
		AaDd(aLinhaSC7, {"C7_IPIBRUT", "B"                                    , NIL})		
		AaDd(aLinhaSC7, {"C7_FLUXO"  , "S"                                    , NIL})				
		AaDd(aLinhaSC7, {"C7_CONAPRO", "L"                                    , NIL})						
		AaDd(aLinhaSC7, {"C7_USER"   , __CUSERID                              , NIL})								
		AaDd(aLinhaSC7, {"C7_TES"    , SB1->B1_TE                             , NIL})				
		AaDd(aLinhaSC7, {"C7_PENDEN" , "N"                                    , NIL})						
		AaDd(aLinhaSC7, {"C7_POLREPR", "N"                                    , NIL})								
		AaDd(aLinhaSC7, {"C7_RATEIO" , "2"                                    , NIL})										
		AaDd(aLinhaSC7, {"C7_ACCPROC", "2"                                    , NIL})												
		AaDd(aLinhaSC7, {"C7_ALQCSL" , 1                                      , NIL})														
		AaDd(aLinhaSC7, {"C7_FISCORI", xFilial("SC7")                         , NIL})																
		AaDd(aLinhaSC7, {"C7_CONTATO", SA2->A2_NREDUZ                         , NIL})																
		AaDd(aLinhaSC7, {"C7_EMISSAO", CToD("01/"+_GLMmv_par01)               , NIL})																
		AaDd(aLinhaSC7, {"C7_MOEDA"  , 1                                      , NIL})																
		AaDd(aLinhaSC7, {"C7_TXMOEDA", 1                                      , NIL})																

		AaDd(aItemSC7,aLinhaSC7)		
                                
		TMPC7->(DbSkip())  // incrementa contador de registros
		
	EndDo
		
	TMPC7->(DbCloseArea())			                                    
    
    If !Empty(aItemSC7)  // se possuir itens a faturar    
		Begin Transaction    
			lMSErroAuto := .F.
			MSExecAuto({|x,y,z,w|Mata120(x,y,z,w)},1,aCabSC7,aItemSC7,3)  // Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}         		
			If lMsErroAuto == .T.  // se existe erro na transação
				DisarmTransaction()
	            Break
			EndIf
		End Transaction                         
	EndIf	      	    

	TMP->(DbSkip())  // incrementa contador de registro

EndDo

TMP->(DbCloseArea())  // fecha arquivo temporário                               

/*
// Atualiza flag de fechamento mensal
cQuery := "  Update " + RetSqlname("SZ0") + " SZ0 "                          
cQuery += "     Set SZ0.Z0_FECHA = 'S'"
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                              "

TCSQLExec(cQuery)             
TCSQLExec("Commit")  // executa commit
*/

// Atualiza flag de fechamento mensal
cQuery := "Select SZ0.Z0_NUMOS As NUMOS "
cQuery += "  From " + RetSqlname("SZ0") + " SZ0 "
cQuery += " Where SZ0.Z0_FILIAL    = '" + xFilial("SZ0")                                    + " ' And " 
cQuery += "       SZ0.Z0_DTEMIS Like '" + SubStr(_GLMmv_par01,4,4)+SubStr(_GLMmv_par01,1,2) + "%' And " 
cQuery += "       SZ0.Z0_APROV     = 'S'                                                          And " 
cQuery += "       SZ0.Z0_FECHA    <> 'S'                                                          And " 
cQuery += "       SZ0.D_E_L_E_T_   = ' '                                                              "

TcQuery cQuery Alias "TMP" New

TMP->(DbGotop())  // vai para o início do arquivo
Do While TMP->(!Eof())  // percorre todo o arquivo

	DbSelectArea("SZ0")  // seleciona arquivo de cabeçalho da ordem de serviço
	SZ0->(DbSetOrder(1))  // muda ordem do índice
	If SZ0->(DbSeek(xFilial("SZ0")+TMP->NUMOS))  // posiciona registro
		RecLock("SZ0",.F.)  // se bloquear registro                                              
		SZ0->Z0_FECHA := "S"  // flag de fechamento mensal
		MsUnLock()  // libera registro bloqueado                                                 
	EndIf

	TMP->(DbSkip())  // incrementa contador de registro

EndDo

TMP->(DbCloseArea())  // fecha arquivo temporário                               


MsgBox("Fechamento mensal realizado com sucesso !!!")
   
Return  // retorno da função
**************************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do ¡ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","Mês/Ano Fechamento"    ,"Mês/Ano Fechamento"    ,"Mês/Ano Fechamento"    ,"mv_ch1","C",07,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})			

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