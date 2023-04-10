/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�tica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (TMK) - M�dulo de Call Center                              ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gTMKM000  � Autor � George AC Gon�alves � Data � 04/06/14  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gTMKM000   � Autor � George AC Gon�alves � Data � 04/06/14 ���
���Fun��es   � fCodCargo  � Autor � George AC Gon�alves � Data � 04/06/14 ���
���Fun��es   � fGravaCargo� Autor � George AC Gon�alves � Data � 04/06/14 ���
���Fun��es   � fCodConsult� Autor � George AC Gon�alves � Data � 04/06/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa cadastro de prospect�s                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico: Projeto de call center                         ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu - Rotina gTMKM000                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                               
#Include "rwmake.ch"
#include "Topconn.ch"      

User Function gTMKM000()  // Importa cadastro de prospect�s

Local cArqNovo := "\SPOOL\PROSPECT.DBF"

Public _cCdCargo   := ""  // c�digo do cargo
Public _cCdCargo1  := ""  // c�digo do cargo
Public _cCdCargo2  := ""  // c�digo do cargo
Public _cDsCargo   := ""  // descri��o do cargo
Public _cCdConsult := ""  // c�digo do concorrente
Public _cDsConsult := ""  // descri��o do concorrente

If Aviso("ATEN��O" , "Confirma importa��o da planilha de prospects ?", {"Sim","N�o"}) == 2
	MsgBox("Importa��o do cadastro de prospects n�o realizada !!!")
	Return  // retorno da fun��o
EndIf

Use (cArqNovo) Alias PROSPECT Exclusive New        
Index On US_COD To Indice
Set Index To Indice       

DbSelectArea("PROSPECT")  // seleciona arquivo de prospect         
PROSPECT->(DbGoTop())  // posiciona no primeiro registro

Do While PROSPECT->(!Eof())  // percorre todo o arquivo

	// defini��o da regi�o
	_cRegiao := ""  // sem regi�o definida
	Do Case
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio ES"
			_cRegiao := "G10"  // "Escrit�rio ES"
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio Go"
			_cRegiao := "G20"  // "Escrit�rio GO"
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio MG"
			_cRegiao := "G30"  // "Escrit�rio MG"          
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio Nordeste"
			_cRegiao := "G40"  // "Escrit�rio Nordeste"
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio Norte"
			_cRegiao := "G50"  // "Escrit�rio Norte"			
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio RJ"
			_cRegiao := "G60"  // "Escrit�rio RJ"          			
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio SP"
			_cRegiao := "G70"  // "Escrit�rio SP"          			                                   
		Case AllTrim(PROSPECT->US_REGIAO) == "Escrit�rio SUL"
			_cRegiao := "G80"  // "Escrit�rio SUL"          			
	EndCase
                          
	// defini��o dos campos de endere�o
	_aCampos := {}        
	_cPartes := AllTrim(PROSPECT->US_END)
	For _Ln := 1 To Len(_cPartes)
		If At("#",_cPartes) > 0                
			_cCampo  := AllTrim(Upper(SubStr(_cPartes,1,At("#",_cPartes)-1)))
			_cPartes := AllTrim(SubStr(_cPartes,At("#",_cPartes)+1,999))
		Else                   
			If !Empty(_cPartes)                                  
				Aadd(_aCampos, {_cPartes})  // monta estrutura de endere�o			
			EndIf
			Exit
		EndIf        
		Aadd(_aCampos, {_cCampo})  // monta estrutura de endere�o
	Next        
	If Len(_aCampos) > 1 .And. Len(_aCampos) < 4
		Aadd(_aCampos, {""})  // monta estrutura de endere�o	
	EndIf
                                       
	// defini��o dos campos de data/hora da visita
	If At("-",PROSPECT->US_DTVISIT) > 0                
		_cDtVisit := AllTrim(SubStr(PROSPECT->US_DTVISIT,1,At("-",PROSPECT->US_DTVISIT)-1))
		_cHrVisit := SubStr(AllTrim(SubStr(PROSPECT->US_DTVISIT,At("-",PROSPECT->US_DTVISIT)+1,999)),1,5)
	Else
		_cDtVisit := ""
		_cHrVisit := ""
	EndIf
                    
	// defini��o do vendedor                                          
	_cCdVend := ""  // sem vendedor definido
	Do Case
		Case Alltrim(PROSPECT->US_VEND) == "George"
			_cCdVend := "000001"  // "George"
		Case AllTrim(PROSPECT->US_VEND) == "Paulo"
			_cCdVend := "000002"  // "Paulo"
		Case AllTrim(PROSPECT->US_VEND) == "Rodrigo"
			_cCdVend := "000003"  // "Rodrigo"
	EndCase

	// defini��o de cliente
	_cCdCli    := ""   // sem cliente definido	
	_cLjCli    := ""   // sem loja definida                  
	_cTipo     := "F"  // tipo do cliente	                 
	_cNome     := ""   // nome do cliente	                
	_cCnpj     := ""   // cgc do cliente	                               
	_cInsc     := ""   // inscri��o estadual do cliente	
	_cStatus   := "1"  // status = classificado	
	_cTpPessoa := ""   // sem pessoa definida
	_cTransl   := ""   // sem translado definido
	_cCNAE     := ""   // CNAE do cliente
		
	Do Case
		Case AllTrim(PROSPECT->US_NOME) == "HOTELPLUS RESTAURANT&CATERING PLUSLINK COMERCIAL LTDA"
			_cCdCli := "000001"  // HOTELPLUS RESTAURANT&CATERING PLUSLINK COMERCIAL LTDA
		Case AllTrim(PROSPECT->US_NOME) == "Zahil Vinhos RJ"
			_cCdCli := "000002"  // Zahil Vinhos RJ
		Case AllTrim(PROSPECT->US_NOME) == "Estopa Pinheiro"
			_cCdCli := "000004"  // Estopa Pinheiro
		Case AllTrim(PROSPECT->US_NOME) == "PLASTVAL"
			_cCdCli := "000005"  // PLASTVAL
		Case AllTrim(PROSPECT->US_NOME) == "Colch�es Ortobom"
			_cCdCli := "000006"  // Colch�es Ortobom
		Case AllTrim(PROSPECT->US_NOME) == "EBSE-EMPRESA BRAS. DE SOLDA ELETRICA S/A"
			_cCdCli := "000007"  // EBSE-EMPRESA BRAS. DE SOLDA ELETRICA S/A
		Case AllTrim(PROSPECT->US_NOME) == "DESK M�VEIS Escolares e Produtos Pl�sticos Ltda"
			_cCdCli := "000008"  // DESK M�VEIS Escolares e Produtos Pl�sticos Ltda
		Case AllTrim(PROSPECT->US_NOME) == "TRANSPORTES FS LTDA"
			_cCdCli := "000009"  // TRANSPORTES FS LTDA           
		Case AllTrim(PROSPECT->US_NOME) == "N�MADE RIO"
			_cCdCli := "000010"  // N�MADE RIO
	EndCase	
	    
	If !Empty(_cCdCli)  // se cliente
		DbSelectArea("SA1")  // seleciona arquivo de clientes
		SA1->(DbSetOrder(1))  // muda ordem do �ndice
		If SA1->(DbSeek(xFilial("SA1")+_cCdCli+"01"))  // se posiciona registro
			_cLjCli    := "01"             // loja do cliente
			_cTipo     := SA1->A1_TIPO     // tipo do cliente
			_cNome     := SA1->A1_NOME     // nome do cliente
			_cCnpj     := SA1->A1_CGC      // cgc do cliente
			_cInsc     := SA1->A1_INSCR    // inscri��o estadual do cliente
			_cStatus   := "6"              // status = cliente
			_cTpPessoa := "CI"             // com�rcio/ind�stria			
			_cTransl   := SA1->A1_HRTRANS  // hora de translado para o cliente
			_cCNAE     := SA1->A1_CNAE     // CNAE do cliente
		EndIf
	EndIf

	// define c�digo do prospect
	_cCdProspect := StrZero(Val(PROSPECT->US_COD),6)  // c�digo do prospect
	
	// define c�digo de cargo 1
	_cDsCargo := AllTrim(Upper(PROSPECT->US_CARGO))
	If !Empty(_cDsCargo)  // se cargo preenchido
		_cCdCargo := fGravaCargo()  // chamada da fun��o que grava arquivo de cargos			
	EndIf
	
	// define c�digo de cargo 2
	_cDsCargo  := AllTrim(Upper(PROSPECT->US_CARGO1))
	If !Empty(_cDsCargo)  // se cargo preenchido	
		_cCdCargo1 := fGravaCargo()  // chamada da fun��o que grava arquivo de cargos			
	EndIf
	
	// define c�digo de cargo 3
	_cDsCargo  := AllTrim(Upper(PROSPECT->US_CARGO2))
	If !Empty(_cDsCargo)  // se cargo preenchido	
		_cCdCargo2 := fGravaCargo()  // chamada da fun��o que grava arquivo de cargos				
	EndIf
	
	// define c�digo de concorrentes                        		
	_cDsConsult := AllTrim(Upper(PROSPECT->US_CONSULT))
               
	If !Empty(_cDsConsult)  // se consultoria preenchida
		DbSelectArea("AC3")  // seleciona arquivo de concorrentes
		AC3->(DbSetOrder(2))  // muda ordem do �ndice
		If AC3->(!DbSeek(xFilial("AC3")+_cDsConsult))  // posiciona registro
			_cCdConsult := fCodConsult()  // chamada da fun��o que recupera �ltimo c�digo de concorrentes
	
			RecLock("AC3",.T.)  //  bloqueia registro		
			AC3->AC3_FILIAL := xFilial("AC3")  // c�digo da filial
			AC3->AC3_CODCON := _cCdConsult     // c�digo do concorrente
			AC3->AC3_NOME   := _cDsConsult     // nome do concorrente
			AC3->AC3_NREDUZ := _cDsConsult     // nome reduzido do concorrente
			MsUnLock()                                             		
		Else
			_cCdConsult := AC3->AC3_CODCON  // c�digo do concorrente	
		EndIf
    EndIf
                            		
	// grava��o do arquivo de cadastro de prospects
	DbSelectArea("SUS")  // seleciona arquivo de cadastro de prospect
	SUS->(DbSetOrder(1))  // muda a ordem do �ndice
	If SUS->(!DbSeek(xFilial("SUS")+_cCdProspect))  // se n�o existir par�metro
		RecLock("SUS",.T.)  //  bloqueia registro
		SUS->US_FILIAL  := xFilial("SUS")                                    // c�digo da filial
		SUS->US_COD     := _cCdProspect                                      // c�digo do prospect
		SUS->US_LOJA    := "01"                                              // loja do prospect		
		SUS->US_NOME    := AllTrim(Upper(PROSPECT->US_NOME))                 // nome do prospect		
		SUS->US_NREDUZ  := AllTrim(Upper(PROSPECT->US_NOME))                 // nome reduzido do prospect				
		SUS->US_TIPO    := _cTipo                                            // tipo do prospect						
		SUS->US_PAIS    := "105"                                             // c�digo do pa�s do prospect								
		SUS->US_DDI     := "55"                                              // DDI do pa�s do prospect								
		If Len(_aCampos) > 0
			SUS->US_END     := _aCampos[1][1]                                // endere�o do prospect				
			SUS->US_BAIRRO  := _aCampos[2][1]                                // bairro do prospect				
			SUS->US_MUN     := _aCampos[3][1]                                // munic�pio do prospect						
			SUS->US_CEP     := _aCampos[4][1]                                // CEP do prospect				
		EndIf
		SUS->US_EST     := SubStr(PROSPECT->US_EST,1,2)                      // estado do prospect		
		SUS->US_CONTAT  := AllTrim(Upper(PROSPECT->US_CONTAT))               // nome do 1o contato
		SUS->US_CARGO   := _cCdCargo                                         // c�digo do cargo do 1o contato
		SUS->US_DDD     := AllTrim(PROSPECT->US_DDD)                         // DDD do 1o telefone de contato
		SUS->US_TEL     := AllTrim(PROSPECT->US_TEL)                         // 1o telefone de contato
		SUS->US_CEL     := AllTrim(PROSPECT->US_CEL)                         // 1o celular de contato
		SUS->US_EMAIL   := AllTrim(Lower(PROSPECT->US_EMAIL))                // e-mail do 1o contato		
		SUS->US_CONTAT1 := AllTrim(Upper(PROSPECT->US_CONTAT1))              // nome do 2o contato
		SUS->US_CARGO1  := _cCdCargo1                                        // c�digo do cargo do 2o contato
		SUS->US_DDD1    := AllTrim(PROSPECT->US_DDD1)                        // DDD do 2o telefone de contato
		SUS->US_TEL1    := AllTrim(PROSPECT->US_TEL1)                        // 2o telefone de contato
		SUS->US_CEL1    := AllTrim(PROSPECT->US_CEL1)                        // 2o celular de contato        
		SUS->US_EMAIL1  := AllTrim(Lower(PROSPECT->US_EMAIL1))               // e-mail do 2o contato		
		SUS->US_CONTAT2 := AllTrim(Upper(PROSPECT->US_CONTAT2))              // nome do 3o contato
		SUS->US_CARGO2  := _cCdCargo2                                        // c�digo do cargo do 3o contato		
		SUS->US_DDD2    := AllTrim(PROSPECT->US_DDD2)                        // DDD do 3o telefone de contato
		SUS->US_TEL2    := AllTrim(PROSPECT->US_TEL2)                        // 3o telefone de contato
		SUS->US_CEL2    := AllTrim(PROSPECT->US_CEL2)                        // 3o celular de contato
		SUS->US_EMAIL2  := AllTrim(Lower(PROSPECT->US_EMAIL2))               // e-mail do 3o contato		
		SUS->US_URL     := AllTrim(Lower(PROSPECT->US_URL))                  // homepage do prospect
		SUS->US_CODCLI  := _cCdCli                                           // c�digo de cliente do prospect
		SUS->US_LOJACLI := _cLjCli                                           // loja de cliente do prospect		
		SUS->US_DESCCLI := _cNome                                            // nome de cliente do prospect
		SUS->US_CGC     := _cCnpj                                            // CNPJ de cliente do prospect
		SUS->US_INSCR   := _cInsc                                            // inscri��o estadual de cliente do prospect
		SUS->US_STATUS  := _cStatus                                          // status do prospect
		SUS->US_VEND    := _cCdVend                                          // c�digo do vendedor de contato com o prospect						
		SUS->US_REGIAO  := _cRegiao                                          // c�digo da regi�o de venda
		SUS->US_SISTEMA := IIf(AllTrim(PROSPECT->US_ULTVIS)=="Sim","0","9")  // c�digo do sistema utilizado no cliente
		SUS->US_CONSULT := _cCdConsult                                       // c�digo da consultoria que presta servi�o atual ao prospect	
		SUS->US_ULTVIS  := CToD(SubStr(PROSPECT->US_ULTVIS,1,10))            // data do �ltimo contato com o prospect
		SUS->US_RETCONT := CToD(SubStr(PROSPECT->US_RETCONT,1,10))           // data para retornar contato com o prospect
		SUS->US_CONTTEL := CToD(SubStr(PROSPECT->US_CONTTEL,1,10))           // data do conbtato telef�nico com o prospect		
		SUS->US_ENVAPR  := CToD(SubStr(PROSPECT->US_ENVAPR,1,10))            // data do envio da carta de apresenta��o para o prospect				
		SUS->US_DTVISIT := CToD(_cDtVisit)                                   // data da marca��o da visita para apresenta��o ao prospect										
		SUS->US_HRVISIT := _cHrVisit                                         // hora da marca��o da visita para apresenta��o ao prospect												
		SUS->US_ENVPROP := CToD(SubStr(PROSPECT->US_ENVPROP,1,10))           // data do envio da proposta para o prospect				
		SUS->US_ORIGEM  := "1"                                               // origem do contato do prospect
		SUS->US_TPESSOA := _cTpPessoa                                        // tipo de pessoa do prospect
		SUS->US_TRASLA  := _cTransl                                          // hora de translado ao prospect		
		SUS->US_CNAE    := _cCNAE                                            // CNAE do prospect				

		MSMM(,TamSX3("US_HISTMK")[1],,PROSPECT->US_HISTMK,1,,,"SUS","US_CODHIST")  // hist�rico de contato com o prospect
		
		ConfirmSX8("SUS","US_COD")  // grava c�digo do prospect
				
		MsUnLock()                                             
		
	EndIf
                                                             
	DbSelectArea("PROSPECT")  // seleciona arquivo de prospect         
   
	PROSPECT->(DbSkip())  // incrementa contador de registros
   
Enddo  
          
MsgBox("Importa��o do cadastro de prospects realizada com sucesso !!!")

Return  // retorno da fun��o                                                  
**************************************************************************************************************************************************************

Static Function fCodCargo()  // Fun��o que recupera �ltimo c�digo de cargos			

cQuery := "Select Max (SUM.UM_CARGO) As CARGO " 
cQuery += "  From " + RetSqlname("SUM") + " SUM "
cQuery += " Where SUM.UM_FILIAL = '" + xFilial("SUM") + "' And " 
cQuery += "       SUM.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

If TMP->(!Eof())
	_cCdCargo := StrZero(Val(TMP->CARGO)+1,6)
Else                                                                 
	_cCdCargo := "000001"
EndIf                                  

TMP->(DbCloseArea())	
                                              
Return  // retorno da fun��o
**************************************************************************************************************************************************************

Static Function fGravaCargo()  // Fun��o que grava arquivo de cargos			
       
_cCdCargo := ""

DbSelectArea("SUM")  // seleciona arquivo de cargos
SUM->(DbSetOrder(2))  // muda ordem do �ndice
If SUM->(!DbSeek(xFilial("SUM")+_cDsCargo))  // posiciona registro
	fCodCargo()  // chamada da fun��o que recupera �ltimo c�digo de cargos			
	
	RecLock("SUM",.T.)  //  bloqueia registro		
	SUM->UM_FILIAL  := xFilial("SUM")  // c�digo da filial
	SUM->UM_CARGO   := _cCdCargo       // c�digo do cargo
	SUM->UM_DESC    := _cDsCargo       // descri��o do cargo em portugu�s
	SUM->UM_DESC_I  := _cDsCargo       // descri��o do cargo em ingl�s
	SUM->UM_DESC_E  := _cDsCargo       // descri��o do cargo em espanhol
	MsUnLock()              
Else
	_cCdCargo := SUM->UM_CARGO  // c�digo do cargo	                               		
EndIf
                            
Return _cCdCargo  // retorno da fun��o                                                                                                                                  
**************************************************************************************************************************************************************

Static Function fCodConsult()  // Fun��o que recupera �ltimo c�digo de concorrente
               
_cCdConsult := ""

cQuery := "Select Max (AC3.AC3_CODCON) As CONCORRENTE " 
cQuery += "  From " + RetSqlname("AC3") + " AC3 "
cQuery += " Where AC3.AC3_FILIAL = '" + xFilial("AC3") + "' And " 
cQuery += "       AC3.D_E_L_E_T_ = ' '                          "

TCQUERY cQuery Alias TMP NEW                                      

TMP->(DbGoTop())

If TMP->(!Eof())
	_cCdConsult := StrZero(Val(TMP->CONCORRENTE)+1,6)
Else                                                                 
	_cCdConsult := "000001"
EndIf                                  

TMP->(DbCloseArea())	
                                              
Return _cCdConsult  // retorno da fun��o