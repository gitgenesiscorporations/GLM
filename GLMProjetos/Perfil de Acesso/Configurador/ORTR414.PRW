#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#Include "Ap5Mail.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ORTR414  � Autor � George Gon�alves   � Data �  17/09/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Selecao de clientes para envio de WorkFlow                 ���
�������������������������������������������������������������������������͹��
���Uso       � WorkFlow                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������	
*/                                                                      

User Function ORTR414()  // Selecao de clientes para envio de WorkFlow

Private oTela       := nil
Private oBmp

Private cLabCliI    := "Cliente/Loja De"
Private cGetCliI    := SPACE(6)
Private oGetCliI

Private cLabLojaI   := ""
Private cGetLojaI   := SPACE(2)
Private oGetLojaI

Private cLabCliF    := "Cliente/Loja Ate"
Private cGetCliF    := "ZZZZZZ"
Private oGetCliF

Private cLabLojaF   := ""
Private cGetLojaF   := "ZZ"
Private oGetLojaF

Private cLabVendI   := "Vendedor De"
Private cGetVendI   := SPACE(6)
Private oGetVendI

Private cLabVendF   := "Vendedor Ate"
Private cGetVendF   := "ZZZZZZ"
Private oGetVendF

Private cLabGerI    := "Gerente De"
Private cGetGerI    := SPACE(6)
Private oGetGerI

Private cLabGerF    := "Gerente Ate"
Private cGetGerF    := "ZZZZZZ"
Private oGetGerF

Private cLabRotI    := "Roteiro De"
Private cGetRotI    := SPACE(1)
Private oGetRotI

Private cLabRotF    := "Roteiro Ate"
Private cGetRotF    := "Z"
Private oGetRotF

Private cLabUFI     := "Unidade Federativa De"
Private cGetUFI     := SPACE(2)
Private oGetUFI

Private cLabUFF    := "Unidade Federativa Ate"
Private cGetUFF    := "ZZ"
Private oGetUFF

Private cLabCamp    := "Campanha"
Private cGetCamp    := SPACE(06)
Private oGetCamp
Private oGetArq     := nil
Private cGetArq     := ""

Private cLabArea    := "Segmento"
Private cGetArea    := ""
Private oGetArea

Private cLabClass   := "Classificacao"
Private aGetClass   := {"", "P = Pulverizado","E = Especiais","S = Superverticais"}
Private oGetClass        
Private cGetClass   := ""

Private cLabAss     := "Assunto"
Private cGetAss     := SPACE(70)
Private oGetAss

Private cLabIIDC    := "Imprime Destinatario"
Private aGetIIDC    := {"", "S = Sim", "N = Nao"}
Private oGetIIDC
Private cGetIIDC    := ""

Private cLabStat    := "Status"
Private aGetStat    := {"", "A = Ativo", "I = Inativo"}
Private oGetStat
Private cGetStat    := ""

Private cLabCTexto  := "Texto Antes Imagem"
Private cGetCTexto  := ""
Private oMemoCTexto

Private cLabRTexto  := "Texto Apos Imagem"
Private cGetRTexto  := ""
Private oMemoRTexto

Private cArquivo := ""
Private aArquivo := {}

///Private oFont := tfont():new("lucida console",,-11,.t.)

DEFINE MSDIALOG oTela TITLE "Selecao de Clientes" FROM 0,0 TO 560,680 PIXEL

@ 005,010 SAY   cLabCliI    PIXEL                                                                                   
@ 005,070 MsGet oGetCliI    Var cGetCliI  PICTURE "@!" Size 035,008 F3 "SA1" Valid fValCli(cGetCliI,"01")      Pixel
@ 005,105 SAY   "/"         PIXEL                                                                                   
@ 005,108 MsGet oGetLojaI   Var cGetLojaI PICTURE "@!" Size 015,008          Valid fValCli(cGetCliI,cGetLojaI) Pixel

@ 005,160 SAY   cLabCliF    PIXEL
@ 005,220 MsGet oGetCliF    Var cGetCliF  PICTURE "@!" Size 035,008 F3 "SA1" Valid fValCli(cGetCliF,"01")      Pixel
@ 005,255 SAY   "/"         PIXEL                                                                                   
@ 005,258 MsGet oGetLojaF   Var cGetLojaF PICTURE "@!" Size 015,008          Valid fValCli(cGetCliF,cGetLojaF) Pixel

@ 020,010 SAY   cLabVendI   PIXEL
@ 020,070 MsGet oGetVendI   Var cGetVendI PICTURE "@!" Size 035,008 F3 "SA3" Valid fValVend(cGetVendI)         Pixel

@ 020,160 SAY   cLabVendF   PIXEL
@ 020,220 MsGet oGetVendF   Var cGetVendF PICTURE "@!" Size 035,008 F3 "SA3" Valid fValVend(cGetVendF)         Pixel

@ 035,010 SAY   cLabGerI    PIXEL
@ 035,070 MsGet oGetGerI    Var cGetGerI  PICTURE "@!" Size 035,008 F3 "SA3" Valid fValGer(cGetGerI)           Pixel

@ 035,160 SAY   cLabGerF    PIXEL
@ 035,220 MsGet oGetGerF    Var cGetGerF  PICTURE "@!" Size 035,008 F3 "SA3" Valid fValGer(cGetGerF)           Pixel
                           
@ 050,010 SAY   cLabRotI    PIXEL
@ 050,070 MsGet oGetRotI    Var cGetRotI  PICTURE "@!" Size 010,008                                            Pixel
                           
@ 050,160 SAY   cLabRotF    PIXEL
@ 050,220 MsGet oGetRotF    Var cGetRotF  PICTURE "@!" Size 010,008          Valid fValRot()                   Pixel

@ 065,010 SAY   cLabUFI     PIXEL
@ 065,070 MsGet oGetUFI     Var cGetUFI   PICTURE "@!" Size 012,008 F3 "12"  Valid fValUF(cGetUFI)             Pixel

@ 065,160 SAY   cLabUFF     PIXEL
@ 065,220 MsGet oGetUFF     Var cGetUFF   PICTURE "@!" Size 012,008 F3 "12"  Valid fValUF(cGetUFF)             Pixel

@ 080,010 SAY   cLabArea    PIXEL
@ 080,070 MsGet oGetArea    Var cGetArea  Picture "@!" Size 032,008 Valid F3Areas()                            Pixel
@ 080,102 SAY   "ENTER-Selecao areas"                                                                          PIXEL                                                                                   

@ 080,160 SAY      cLabClass PIXEL
@ 080,220 Combobox oGetClass Var cGetClass ITEMS aGetClass Size 060,008                                        Pixel

@ 095,010 SAY   cLabCamp    PIXEL
@ 095,070 MsGet oGetCamp    Var cGetCamp  Picture "@!" Size 025,008 Valid F3Campanha()                         Pixel
@ 095,095 SAY   "ENTER-Selecao imagens"                                                                         PIXEL                                                                                   
@ 095,160 MsGet oGetArq     Var cGetArq                Size 160,008 when .F.                                                            Pixel

@ 110,010 SAY   cLabAss     PIXEL
@ 110,070 MsGet oGetAss     Var cGetAss   Picture "@!" Size 250,008                                            Pixel

@ 125,010 Say      cLabIIDC PIXEL
@ 125,070 ComboBox oGetIIDC Var cGetIIDC Items aGetIIDC size 060,008                                           Pixel

@ 125,160 Say      cLabStat PIXEL
@ 125,220 ComboBox oGetStat Var cGetStat Items aGetStat size 060,008                                           Pixel

@ 140,010 SAY  cLabCTexto   PIXEL
@ 140,070 Get  oMemoCTexto  Var cGetCTexto MEMO        Size 250,055                                            Pixel

@ 200,010 SAY  cLabRTexto   PIXEL
@ 200,070 Get  oMemoRTexto  Var cGetRTexto MEMO        Size 250,055                                            Pixel

@ 262,160 BUTTON "&OK"       PIXEL SIZE 40,12 OF oTela ACTION Processa( {|| fSelecao(), oTela:End() }, "Aguarde...", "Selecionando...",.F.)
@ 262,210 BUTTON "&Cancelar" PIXEL SIZE 40,12 OF oTela ACTION oTela:End()
@ 262,260 BUTTON "&Anexar"   PIXEL SIZE 40,12 OF oTela ACTION Processa( {|| fAnexo() }, "Aguarde...", "Anexando...",.F.)

ACTIVATE MSDIALOG oTela CENTERED

Return()  // retorno da funcao
******************************************************************************************************

Static Function fValCli(_cCli,_cLoja)  // VALIDA CODIGO DO CLIENTE

Local aArea := GetARea()
Local lRet := .T.

If !(Empty(_cCli) .Or. _cCli == "ZZZZZZ")
	DBSELECTAREA("SA1")  // seleciona arquivo de cliente
	SA1->(DBSETORDER(1))  // muda ordem do indice
	IF SA1->(!DBSEEK(XFILIAL("SA1")+_cCli+_cLoja))  // posiciona registro
		Aviso("Atencao","Este codigo de cliente nao pode ser utilizado para esta operacao!", {"Ok"} )			
		lRet := .F.
	ENDIF
EndIf	

RestARea(aArea)

Return lRet  // retorno da funcao
******************************************************************************************************

Static Function fValVend(_cVend)  // VALIDA CODIGO DO VENDEDOR

Local aArea := GetARea()
Local lRet := .T.

If !(Empty(_cVend) .Or. _cVend == "ZZZZZZ")
	DBSELECTAREA("SA3")  // seleciona arquivo de vendedores
	SA3->(DBSETORDER(1))  // muda ordem do indice
	IF SA1->(!DBSEEK(XFILIAL("SA3")+_cVend))  // posiciona registro
		Aviso("Atencao","Este codigo de vendedor nao pode ser utilizado para esta operacao!", {"Ok"} )			
		lRet := .F.
	ENDIF
EndIf

RestARea(aArea)

Return lRet  // retorno da funcao
******************************************************************************************************

Static Function fValGer(_cGer)  // VALIDA CODIGO DO GERENTE

Local aArea := GetARea()
Local lRet := .T.

If !(Empty(_cGer) .Or. _cGer == "ZZZZZZ")
	DBSELECTAREA("SA3")  // seleciona arquivo de vendedores
	SA3->(DBSETORDER(1))  // muda ordem do indice
	IF SA1->(!DBSEEK(XFILIAL("SA3")+_cGer))  // posiciona registro
		Aviso("Atencao","Este codigo de gerente nao pode ser utilizado para esta operacao!", {"Ok"} )			
		lRet := .F.
	ENDIF
EndIf

RestARea(aArea)

Return lRet  // retorno da funcao
******************************************************************************************************

Static Function fValRot()  // VALIDA ROTEIRO

Local aArea := GetARea()
Local lRet := .T.

If cGetRotF < cGetRotI
	Aviso("Atencao","Roteiro seleciona final menor que o inicial!", {"Ok"} )			
	lRet := .F.
ENDIF

RestARea(aArea)

Return lRet  // retorno da funcao
******************************************************************************************************

Static Function fValUF(_cUF)  // VALIDA CODIGO DA UNIDADE FEDERATIVA

Local aArea := GetARea()
Local lRet := .T.

If !(Empty(_cUF) .Or. _cUF == "ZZ")
	DBSELECTAREA("Sx5")  // seleciona arquivo de tabelas
	SX5->(DBSETORDER(1))  // muda ordem do indice
	IF SX5->(!DBSEEK(XFILIAL("SX5")+"12"+_cUF))  // posiciona registro
		Aviso("Atencao","Este codigo de unidade federativa nao pode ser utilizado para esta operacao!", {"Ok"} )			
		lRet := .F.
	ENDIF
EndIf

RestARea(aArea)

Return lRet  // retorno da funcao
******************************************************************************************************

Static Function fValCamp(_Camp)  // VALIDA CODIGO DA CAMPANHA

Local aArea := GetARea()
Local lRet := .T.

cQry := "Select Count(*) As CAMP "
cQry += "  From CAMPMALA"
cQry += " Where CAMPANHA = '" + _Camp + "'"	  

If Select("QRY") > 0  ; (DbCloseArea())  ; Endif
TcQuery cQry Alias "QRY" New
  
If !(QRY->CAMP > 0)  // se existir registro no banco
	Aviso("Atencao","Este codigo de campanha nao pode ser utilizado para esta operacao!", {"Ok"} )			
	lRet := .F.
EndIf

QRY->(DbCloseArea())

RestARea(aArea)

Return lRet  // retorno da funcao
*******************************************************************************************************

Static Function fSelecao()  // faz selecao dos registros

// � necess�rio utilizar esta vari�vel para a marca��o ser feita com um x gr�fico                     
Private cMarca     := GetMark()                             
Private lInverte   := .F.
Private aRotina    := {}
Private cCadastro  := "Selecao de Clientes"

// Estrutura Arquivo Temporario
cEstrutura := {{"MARCA"   , "C", 02, 0},;
               {"CLIENTE" , "C", 06, 0},;    
               {"LOJA"    , "C", 02, 0},; 
               {"NOMECLI" , "C", 40, 0},; 
               {"CONTATO" , "C", 40, 0},;                
               {"EMAIL"   , "C", 80, 0},;                
               {"UF"      , "C", 02, 0},;                               
               {"VENDEDOR", "C", 06, 0},; 
               {"NOMEVEND", "C", 40, 0},;                
               {"GERENTE" , "C", 06, 0},; 
               {"NOMEGER" , "C", 40, 0},;                
               {"ROTEIRO" , "C", 01, 0}}            

// Estrutura para montagem do browse              
aCampos := {}
AAdd(aCampos, {"MARCA"   , "", ""                  , ""  })
AAdd(aCampos, {"CLIENTE" , "", "Cliente"           , "@!"})  
AAdd(aCampos, {"LOJA"    , "", "Loja"              , "@!"})  
AAdd(aCampos, {"NOMECLI" , "", "Razao Social"      , "@!"})
AAdd(aCampos, {"CONTATO" , "", "Nome Contato"      , "@!"})
AAdd(aCampos, {"EMAIL"   , "", "e-Mail"            , "@!"})
AAdd(aCampos, {"UF"      , "", "Unidade Federativa", "@!"})
AAdd(aCampos, {"VENDEDOR", "", "Vendedor"          , "@!"})
AAdd(aCampos, {"NOMEVEND", "", "Nome"              , "@!"})
AAdd(aCampos, {"GERENTE" , "", "Gerente"           , "@!"})
AAdd(aCampos, {"NOMEGER" , "", "Nome"              , "@!"})
AAdd(aCampos, {"ROTEIRO" , "", "Roteiro"           , "@!"})

// Cria Nome e Arquivos Temporarios                         
AAdd(aRotina, {'Preview'      , 'U_fPreview()', 0, 1})
AAdd(aRotina, {'Enviar e-Mail', 'U_egMarcaM()' , 0, 2})

// Segmento
_Area := AllTrim(cGetArea)
_Seg  := ""
For _Ln := 1 To Len(_Area)
	nPos := AT(",",_Area)
	If nPos > 0
		_Seg  += "'"+SubStr(_Area,1,nPos-1)+"',"
		_Area := SubStr(_Area,nPos+1,Len(_Area)) 
	Else	                                     
		_Seg  += "'"+SubStr(_Area,1,Len(_Area))+"'"	
		_Area := ""
	EndIf		
	If Empty(_Area)
		Exit
	EndIf
Next

// Cria e abre Arquivo Temporario 
cArqTrab := CriaTrab(cEstrutura,.T.)  
DBUSEAREA(.T.,,cArqTrab,"gTEMP",.T.)                  
Index on NOMECLI+CLIENTE+LOJA to (cArqTrab) 

cQuery := "  Select SZH.ZH_CLIENTE As CLIENTE,      "
cQuery += "         SZH.ZH_LOJA    As LOJA,         "
cQuery += "         SA1.A1_NOME    As NOME,         "
cQuery += "         SA1.A1_CONTATO As CONTATO,      "
cQuery += "         SA1.A1_XEMAILC As EMAIL,        "
cQuery += "         SA1.A1_EST     As UF,           "
cQuery += "         SA1.A1_XCODGRU As GRUPO,        "
cQuery += "         SZH.ZH_VEND    As VENDEDOR,     "
cQuery += "         SA3a.A3_NREDUZ As NOMEVENDEDOR, "       
cQuery += "         SA3a.A3_GEREN  As GERENTE,      "    
cQuery += "         SA3b.A3_NREDUZ As NOMEGERENTE,  "  
cQuery += "         SZH.ZH_ITINER  As ROTEIRO,      "          
cQuery += "         SA1.A1_ULTCOM  As ULT_COMPRA    "
cQuery += "    From " + RETSQLNAME("SZH") + " SZH,  "
cQuery +=               RETSQLNAME("SA1") + " SA1,  "	
cQuery +=               RETSQLNAME("SA3") + " SA3a, "	
cQuery +=               RETSQLNAME("SA3") + " SA3b  "	
cQuery += "   WHERE SZH.D_E_L_E_T_       = ' '                                        "	
cQuery += "     AND SZH.ZH_FILIAL        = '" + xFilial("SZH")                    + "'"	  
cQuery += "     AND SZH.ZH_CLIENTE BetWeen '" + cGetCliI  + "' And '" + cGetCliF  + "'"	
cQuery += "     AND SZH.ZH_LOJA    BetWeen '" + cGetLojaI + "' And '" + cGetLojaF + "'"	
cQuery += "     AND SZH.ZH_VEND    BetWeen '" + cGetVendI + "' And '" + cGetVendF + "'"	
cQuery += "     AND SZH.ZH_ITINER  BetWeen '" + cGetRotI  + "' And '" + cGetRotF  + "'"	
If !Empty(_Seg)
	cQuery += "     AND SZH.ZH_SEGMENT      In (" + _Seg + ") "
EndIf	
cQuery += "     AND SA1.D_E_L_E_T_       = ' '                                         "
cQuery += "     AND SA1.A1_FILIAL        = '" + xFilial("SA1")                     + "'"	  
cQuery += "     AND SA1.A1_COD           = SZH.ZH_CLIENTE                              "
cQuery += "     AND SA1.A1_LOJA          = SZH.ZH_LOJA                                 "
cQuery += "     AND SA1.A1_XEMAILC    LIKE '%@%'                                       "
cQuery += "     AND SA1.A1_EST     BetWeen '" + cGetUFI   + "' And '" + cGetUFF    + "'"	
If !Empty(AllTrim(cGetClass))
	cQuery += "     AND SA1.A1_XTPCLI        = '" + AllTrim(cGetClass)             + "'"	  
EndIf	
cQuery += "     AND SA1.A1_ULTCOM       <> ' '                                         "
cQuery += "     AND SA3a.D_E_L_E_T_      = ' '                                         "
cQuery += "     AND SA3a.A3_FILIAL       = '" + xFilial("SA3")                     + "'"	  
cQuery += "     AND SA3a.A3_COD          = SZH.ZH_VEND                                 "
cQuery += "     AND SA3b.D_E_L_E_T_      = ' '                                         "
cQuery += "     AND SA3b.A3_FILIAL       = '" + xFilial("SA3")                     + "'"	  
cQuery += "     AND SA3b.A3_COD          = SA3a.A3_GEREN                               "
cQuery += "     AND SA3b.A3_COD    BetWeen '" + cGetGerI  + "' And '" + cGetGerF   + "' "	  
cQuery += "Order By SA1.A1_XCODGRU, SA1.A1_NOME, SZH.ZH_CLIENTE, SZH.ZH_LOJA"
                          
If Select("QRY1") > 0  ; (DbCloseArea())  ; Endif 

TcQuery cQuery Alias "QRY1" New

u_fUserMWrite("ORTR414a.sql",cQuery)		

_cGrupoAnt := ""
QRY1->(DbGoTop())
Do While QRY1->(!Eof())  // percorre todo o arquivo

	// Aplica regra de cliente ativo/inativo
	If AllTrim(cGetStat) == "A"
		If (dDataBase - SToD(QRY1->ULT_COMPRA)) > 60
			QRY1->(DbSkip())  // incrementa contador de registro			
			Loop
		EndIf
	ElseIf AllTrim(cGetStat) == "I"
		If (dDataBase - SToD(QRY1->ULT_COMPRA)) <= 60
			QRY1->(DbSkip())  // incrementa contador de registro			
			Loop
		EndIf
	EndIf

	// Aplica regra de agrupamento de cliente
	If _cGrupoAnt <> QRY1->GRUPO
		RecLock("gTEMP",.T.)  // se bloquear registro      
		Replace gTEMP->MARCA    With cMarca              // Marca
		Replace gTEMP->CLIENTE  With QRY1->CLIENTE       // codigo do cliente
		Replace gTEMP->LOJA     With QRY1->LOJA          // loja do cliente
		Replace gTEMP->NOMECLI  With QRY1->NOME          // razao social do cliente
		Replace gTEMP->CONTATO  With QRY1->CONTATO       // nome do contato do cliente	
		Replace gTEMP->EMAIL    With QRY1->EMAIL         // e-mail do cliente	
		Replace gTEMP->UF       With QRY1->UF            // unidade federativa do cliente		
		Replace gTEMP->VENDEDOR With QRY1->VENDEDOR      // codigo do vendedor
		Replace gTEMP->NOMEVEND With QRY1->NOMEVENDEDOR  // nome do vendedor
		Replace gTEMP->GERENTE  With QRY1->GERENTE       // codigo do gerente
		Replace gTEMP->NOMEGER  With QRY1->NOMEGERENTE   // nome do gerente
		Replace gTEMP->ROTEIRO  With QRY1->ROTEIRO       // roteiro
		MsUnLock()  // libera registro bloqueado
	EndIf	
	
	_cGrupoAnt :=  QRY1->GRUPO	
	
	QRY1->(DbSkip())  // incrementa contador de registro
	
EndDo   

DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo

MarkBrowse("gTEMP", "MARCA",, aCampos, lInverte, cMarca)

gTEMP->(DbCloseArea())    
QRY1->(DbCloseArea())    

Return .T.  // retorno da fun��o
***************************************************************************************************************************************************

User Function egMarcaM()  // Seleciona empresas

nReEnv := 2
DbSelectArea("gTEMP")  // seleciona arquivo empor�rio
gTEMP->(DbGoTop())  // vai para o in�cio do arquivo
Do While gTEMP->(!Eof())  // percorre todo o arquivo
///	If Marked("MARCA")  // se documento marcado
	If AllTrim(gTEMP->MARCA) <> AllTrim(cMarca)

		cQuery := "Select Count(*) QTD"
		cQuery += "  From MALADIR MALA "
		cQuery += " Where MALA.CLIENTE  = '" + gTEMP->CLIENTE            + "'"	  
		cQuery += "   And MALA.CAMPANHA = '" + cGetCamp                  + "'"	  
		cQuery += "   And MALA.DTENV Like '" + SubStr(DToS(Date()),1,6) + "%'"	  

		If Select("QRY2") > 0  ; (DbCloseArea())  ; Endif
		TcQuery cQuery Alias "QRY2" New

		u_fUserMWrite("ORTR414b.sql",cQuery)		

		If QRY2->QTD > 0 .And. nReEnv == 2
			nReEnv := Aviso("A T E N � � O ! ! !","Ja enviado e-Mail desta campanha para o cliente este mes. Deseja re-enviar assim mesmo ? (em caso afirmativo esta mensagem nao mais sera apresentada)",{"SIM","N�O"})				
			If nReEnv == 1	
		
				EnviaWF()  // chamada a funcao de emissao do WorkFlow

				// Atualiza tabela de log
				cQuery := "INSERT INTO MALADIR (USUARIO, CLIENTE, ASSUNTO, DTENV, CAMPANHA)"
				cQuery += "     VALUES ('" + AllTrim(SubStr(cUsuario,7,15)) + "','" + gTEMP->CLIENTE + "','" + AllTrim(cGetAss) + "','" + DTOS(Date()) + "','" + AllTrim(cGetCamp) + "')"
				TCSQLExec(cQuery)
				TCSQLExec("COMMIT")
			EndIf
		EndIf

		EnviaWF()  // chamada a funcao de emissao do WorkFlow				
		
		// Atualiza tabela de log
		cQuery := "INSERT INTO MALADIR (USUARIO, CLIENTE, ASSUNTO, DTENV, CAMPANHA)"
		cQuery += "     VALUES ('" + AllTrim(SubStr(cUsuario,7,15)) + "','" + gTEMP->CLIENTE + "','" + AllTrim(cGetAss) + "','" + DTOS(Date()) + "','" + AllTrim(cGetCamp) + "')"
		TCSQLExec(cQuery)
		TCSQLExec("COMMIT")
		
	EndIf
	gTEMP->(Dbskip())  // incrementa contador de registro
Enddo   

CloseBrowse()  // fecha markbrowse

Return  // retorno da funcao
***************************************************************************************************************************************************

Static Function EnviaWF()  // Funcao de emissao do WorkFlow

///Public cTo      := AllTrim(gTEMP->EMAIL)  // para
///Public cTo      := "rdf@ortobom.com.br"  // para
Public cTo      := "george.goncalves@glminformatica.com"  // para
Public cSubject := cGetAss        // Assunto da mensagem
Public cAnexo   := ""             // Caminho e nome do arquivo a ser enviado como anexo
Public cBody    := gEWFC001()     // chamada a funcao de montagem da mensagem para workflow

For _Ln := 1 To Len(aArquivo)
	cAnexo += aArquivo[_Ln][1] +";"
Next

cAnexo := SubStr(cAnexo,1,Len(cAnexo)-1)

gEspEWF(cTo,cBody,cSubject,cAnexo)  // chamada a fun��o de envio de workflow      

Return  // retorno da funcao
***************************************************************************************************************************************************

Static Function gEWFC001()  // Confeccao de mensagem para envio de workflow

// Montagem do cabecalho da mensagem
_cCabec := '<html><title>' + AllTrim(cGetAss) + '</title>'
_cCabec += '<style type = "text/css">'
_cCabec += 'p {font: 12pt courier new, courier;}'
_cCabec += '</style><body><p>'
_cCabec += '<br>'
_cCabec += '<br>'

// se imprime identificacao cliente
If AllTrim(cGetIIDC) == "S"  
	_cCabec += AllTrim(SM0->M0_CIDCOB)+', ' + AllTrim(STR(Day(dDatabase))) + ' de ' + MesExtenso(Month(dDataBase)) + ' de ' + AllTrim(STR(Year(dDataBase)))
	_cCabec += '<br>'
	_cCabec += '<br>'
	_cCabec += 'A'   
	_cCabec += '<br>'
	_cCabec += '<b>' + AllTrim(gTEMP->NOMECLI) + '</b>'
	_cCabec += '<br>'
	_cCabec += 'Att: ' + AllTrim(gTEMP->CONTATO)
	_cCabec += '<br>'
	_cCabec += '<br>'
EndIf
                                       
// Assunto
_cCabec += Replicate("&nbsp",10)+'<b>' + AllTrim(cGetAss)+ '</b>'
_cCabec += '<br>'
_cCabec += '<br>'

// Texto de Cabecalho - antes da imagem
_cRet  := ""
_cBite := Space(01)
For _Ln := 1 To Len(cGetCTexto)
	_cBite := SubStr(cGetCTexto,_Ln,1)
	If _cBite <> Chr(10) .And. _cBite <> CHR(13)
		_cRet += _cBite
	Else
		If !Empty(_cRet)
			_cCabec += AllTrim(_cRet)
			_cCabec += '<br>'			
			_cRet  := ""
			_cBite := Space(01)
		ElseIf Empty(_cRet) .And. _cBite == Chr(13)
			_cCabec += '<br>'			
		EndIf	
	EndIf
Next
If !Empty(_cRet)
	_cCabec += AllTrim(_cRet)
EndIf	
_cCabec += '<br>'
_cCabec += '<br>'

// Imagem da campanha
For _Ln := 1 To Len(cGetArq)
	nPos := AT("\",cGetArq)
	If nPos > 0
		cGetArq := SubStr(cGetArq,1,nPos-1)+"/"+SubStr(cGetArq,nPos+1,Len(cGetArq))
	EndIf		
Next

_cCabec += '<img src="http://bo.ortobom.com.br' + AllTrim(cGetArq) + '">'
_cCabec += '<br>'
_cCabec += '<br>'

// Texto de Rodape - apos a imagem
_cRet  := ""
_cBite := Space(01)
For _Ln := 1 To Len(cGetRTexto)
	_cBite := SubStr(cGetRTexto,_Ln,1)
	If _cBite <> Chr(10) .And. _cBite <> CHR(13)
		_cRet += _cBite
	Else
		If !Empty(_cRet)
			_cCabec += AllTrim(_cRet)
			_cCabec += '<br>'			
			_cRet  := ""
			_cBite := Space(01)
		ElseIf Empty(_cRet) .And. _cBite == Chr(13)
			_cCabec += '<br>'			
		EndIf	
	EndIf
Next
If !Empty(_cRet)
	_cCabec += AllTrim(_cRet)
EndIf	
_cCabec += '<br>'
_cCabec += '<br>'

_cRodape := '<img src="http://bo.ortobom.com.br/campanhas/logo_ortobom_com_slogan.jpg">'
///_cRodape := '<img src="http://bo.ortobom.com.br/campanhas/Assinaturas' + cEmpAnt + '.jpg">'
_cRodape += '</body>'
_cRodape += '</html>'

cBody := _cCabec + _cRodape  // Corpo da mensagem

Return cBody  // retorno da fun��o                                    
***************************************************************************************************************************************************

Static Function gEspEWF(cTo,cBody,cSubject,cAnexo)  // Fun��o de envio de workflow

// Par�metros:
// MV_RELSERV  - Servidor de email
// MV_RELACNT  - Conta de envio
// MV_RELPSW   - Senha da Conta de envio
// MV_RELFROM  - Remetente ( e-mail )
// MV_RELAUTH  - Se o servidor de e-mail precisa de autentica��o

ConOut( "*****************************" )
ConOut( "Enviando e-mail para : " + cTo )
ConOut( "*****************************" )               
	
// Conecta com o Servidor SMTP
CONNECT SMTP SERVER GetMV("MV_RELSERV") ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW") RESULT lOk
	
If lOk
	ConOut(cSubject)    
	                                       
	// Autentica a conex�o com o servidor de e-mail (Caso seja necess�rio)
	If GetMV("MV_RELAUTH")
		MAILAUTH(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
	EndIf
	   
	If pCount() < 4    // Verifica se n�o foi passado o parametro de anexo      
		// Envia o e-mail
		SEND MAIL From GetMV('MV_RELFROM') TO cTo SUBJECT cSubject BODY cBody RESULT lOk   
	Else // caso tenha sida passado o parametro de anexo
		// Envia o e-mail
		SEND MAIL From GetMV('MV_RELFROM') TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAnexo RESULT lOk   
	EndIf	             
	
	If lOk   
		ConOut( 'Para:  '+ cTo )
		ConOut( 'Com sucesso' )
	Else  
		Get MAIL ERROR cSmtpError
		ConOut( "Erro de envio : " + cSmtpError )
	Endif    
	
	// Desconecta do Servidor   
	DISCONNECT SMTP SERVER    
	
Else
	Get MAIL ERROR cSmtpError
	ConOut( "Erro de conex�o : " + cSmtpError )   
Endif
	
Return lOk  // retorno da fun��o              
***************************************************************************************************************************************************

Static Function fAnexo()  // Funcao de anexar arquivos

cArquivo := cGetFile("*.*",OemToAnsi("Selecione arquivo para anexo"))

AaDd(aArquivo,{cArquivo})

Return  // retorno da funcao
***************************************************************************************************************************************************

Static Function F3Campanha()  // F3-Selecao de Campanha

If !Empty(cGetCamp)  // se validar campanha
	// Imagem da campanha
	cQry := "Select *"
	cQry += "  From CAMPMALA"
	cQry += " Where CAMPANHA = '" + cGetCamp + "'"	  

	If Select("QRY") > 0  ; (DbCloseArea())  ; Endif
	TcQuery cQry Alias "QRY" New
   
	cGetArq := AllTrim(QRY->ARQ)

	QRY->(DbCloseArea())
Else
	Private aVetor := {}
	Private nOpc   := 0
	Private oLbx

	aSalvAmb := GetArea()
	cTitulo  := "Selecao de Imagens de Campanha"

	cQry := "  Select * "
	cQry += "    From CAMPMALA "
	cQry += "Order By DESCRICAO "

	If Select("QRY") > 0  ; (DbCloseArea())  ; Endif
	TcQuery cQry Alias "QRY" New
   
	QRY->(DbGoTop())
	Do While !Eof()                          
		AaDd(aVetor,{QRY->CAMPANHA,QRY->DESCRICAO,QRY->ARQ})
		DbSkip()
	EndDo

	QRY->(DbCloseArea())    

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlgA TITLE cTitulo FROM 0,0 TO 400,650 PIXEL // DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO ALTURA,LARGURA PIXEL
	
	@ 10,10 LISTBOX oLbx FIELDS HEADER "Campanha", "Descricao","Arquivo" SIZE 150,160 OF oDlgA PIXEL ON CHANGE(U_EditList(oLbx:nAt))  // SIZE LARGURA,ALTURA OF oDlg PIXEL

	//define com qual vetor devera trabalhar
	oLbx:SetArray(aVetor)

	//lista o conteudo dos vetores, variavel nAt eh a linha pintada (foco) e o numero da coluna
	oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;  // Campanha
						aVetor[oLbx:nAt,2],;  // Descricao
	                    aVetor[oLbx:nAt,3]}}  // Arquivo

	oBmp  := TBitMap():New(10,170,150,160,,aVetor[oLbx:nAt,3],.T.,oDlgA,,,,,,,,,.T.,,,,.T.)
	oBmp:lStretch := .t. 
	oBMP:Load(,aVetor[oLbx:nAt,3])	

	DEFINE SBUTTON FROM 180,010 TYPE 1 ACTION ( fOk() = 1, oDlgA:End() ) ENABLE OF oDlgA  //DEFINE SBUTTON FROM LINHA,COLUNA
	ACTIVATE MSDIALOG oDlgA CENTER

	RestArea( aSalvAmb )
	
EndIf	

Return .T.  // retorno da fun��o
***************************************************************************************************************************************************

Static Function fOk()

nOpc := 1

cGetCamp := aVetor[oLbx:nAt,1]
cGetArq  := aVetor[oLbx:nAt,3]

oDlgA:Refresh()
aVetor := {}

Return nOpc  // retorno da fun��o
***************************************************************************************************************************************************

Static Function F3Areas()  // F3-Selecao de Areas

Local cAreaT := GetArea()
 
// � necess�rio utilizar esta vari�vel para a marca��o ser feita com um x gr�fico                     
Private cMarca    := GetMark()                             
Private lInverte  := .F.
Private aRotina   := {}
Private cCadastro  := "Selecao de Areas"

// Estrutura Arquivo Temporario
cEstrutura := {{"MARCA", "C", 02, 0},;
            	{"ITEM" , "C", 01, 0},;
                {"AREA" , "C", 25, 0}}            

// Estrutura para montagem do browse              
aCampos := {}
AAdd(aCampos, {"MARCA", "", ""    , ""  })
AAdd(aCampos, {"ITEM" , "", "Item", "@!"})
AAdd(aCampos, {"AREA" , "", "Area", "@!"})

// Cria Nome e Arquivos Temporarios
Private aRotina  := {{'OK', 'U_aMarcaM()', 0, 1}}
Private _OpcArea := {}

AAdd(_OpcArea, {"Comercial Consignado"})
AAdd(_OpcArea, {"Comercial"})
AAdd(_OpcArea, {"Industrial"})
AAdd(_OpcArea, {"Loja"})
AAdd(_OpcArea, {"Loja Exclusiva"})
AAdd(_OpcArea, {"Ortoclass - Comercial"})
AAdd(_OpcArea, {"Ortoclass - Industrial"})

// Cria e abre Arquivo Temporario 
cArqTrab := CriaTrab(cEstrutura,.T.)  
DBUSEAREA(.T.,,cArqTrab,"aTEMP",.T.)                  
Index on ITEM to (cArqTrab) 

For _aLn := 1 To Len(_OpcArea)
	RecLock("aTEMP",.T.)                         // se bloquear registro      
	Replace aTEMP->MARCA With ""  //cMarca             // Marca
	Replace aTEMP->ITEM  With StrZero(_aLn,1)    // Item
	Replace aTEMP->AREA  With _OpcArea[_aLn][1]  // Area	
	MsUnLock()                                   // libera registro bloqueado
Next

DbSelectArea("aTEMP")  // seleciona arquivo empor�rio
aTEMP->(DbGoTop())  // vai para o in�cio do arquivo

MarkBrowse("aTEMP", "MARCA",, aCampos, lInverte, cMarca)

aTEMP->(DbCloseArea())    
        
RestArea(cAreaT)        

Return .T.  // retorno da fun��o
***************************************************************************************************************************************************

User Function aMarcaM()  // Seleciona areas

cGetArea := ""
DbSelectArea("aTEMP")  // seleciona arquivo empor�rio
aTEMP->(DbGoTop())  // vai para o in�cio do arquivo
Do While aTEMP->(!Eof())  // percorre todo o arquivo
	If AllTrim(aTEMP->MARCA) == AllTrim(cMarca)
		cGetArea := cGetArea + "," + aTEMP->ITEM
	EndIf
	aTEMP->(Dbskip())  // incrementa contador de registro
Enddo   

If !Empty(cGetArea)  // se existir empresa/filial selecionada
	cGetArea := SubStr(cGetArea,2,Len(cGetArea)-1)
EndIf	

CloseBrowse()  // fecha markbrowse
                                     
Return  // retorno da fun��o
***************************************************************************************************************************************************

User Function EditList()

//lista o conteudo dos vetores, variavel nAt eh a linha pintada (foco) e o numero da coluna
oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;  // Campanha
					aVetor[oLbx:nAt,2],;  // Descricao
                    aVetor[oLbx:nAt,3]}}  // Arquivo

oBMP:Load(,aVetor[oLbx:nAt,3])	

Return  // retorno da fun��o                                      
***************************************************************************************************************************************************

User Function fPreview()  // Preview do e-Mail

nLin    := 100
oFnt12n := TFont():New("Courier New",,12,,.T.,,,,,.F.)
   
oPrn := TMSPrinter():New(AllTrim(cGetAss))
oPrn:SetPortrait()
oPrn:StartPage() 

// se imprime identificacao cliente
If AllTrim(cGetIIDC) == "S"
	oPrn:Say(nLin:=nLin+000,0100,AllTrim(SM0->M0_CIDCOB)+', ' + AllTrim(STR(Day(dDatabase))) + ' de ' + MesExtenso(Month(dDataBase)) + ' de ' + AllTrim(STR(Year(dDataBase))) ,oFnt12n,,,,0)
	oPrn:Say(nLin:=nLin+120,0100,"A" ,oFnt12n,,,,0)
	oPrn:Say(nLin:=nLin+060,0100, AllTrim(gTEMP->NOMECLI) ,oFnt12n,,,,0)
	oPrn:Say(nLin:=nLin+060,0100, "Att: " + AllTrim(gTEMP->CONTATO) ,oFnt12n,,,,0) 
EndIf

// Assunto
oPrn:Say(nLin:=nLin+120,0400, AllTrim(cGetAss) ,oFnt12n,,,,0)

// Texto de Cabecalho - antes da imagem
nLin   := nLin + 60
_cRet  := ""
_cBite := Space(01)
For _Ln := 1 To Len(cGetCTexto)
	_cBite := SubStr(cGetCTexto,_Ln,1)
	If _cBite <> Chr(10) .And. _cBite <> CHR(13)
		_cRet += _cBite
	Else
		If !Empty(_cRet)
			 oPrn:Say(nLin:=nLin+060,0100, AllTrim(_cRet) ,oFnt12n,,,,0)		
			_cRet  := ""
			_cBite := Space(01)
		ElseIf Empty(_cRet) .And. _cBite == Chr(13)
			 oPrn:Say(nLin:=nLin+060,0100, Space(01) ,oFnt12n,,,,0)				
		EndIf	
	EndIf
Next
If !Empty(_cRet)
	 oPrn:Say(nLin:=nLin+060,0100, AllTrim(_cRet) ,oFnt12n,,,,0)		
EndIf	

// Imagem da campanha
oPrn:SayBitmap(nLin:=nLin+120, 0100, AllTrim(cGetArq), 800, 600)

// Texto de Rodape - apos a imagem
nLin   := nLin + 600
_cRet  := ""
_cBite := Space(01)
For _Ln := 1 To Len(cGetRTexto)
	_cBite := SubStr(cGetRTexto,_Ln,1)
	If _cBite <> Chr(10) .And. _cBite <> CHR(13)
		_cRet += _cBite
	Else
		If !Empty(_cRet)
			 oPrn:Say(nLin:=nLin+060,0100, AllTrim(_cRet) ,oFnt12n,,,,0)				
			_cRet  := ""
			_cBite := Space(01)
		ElseIf Empty(_cRet) .And. _cBite == Chr(13)
			 oPrn:Say(nLin:=nLin+060,0100, Space(01) ,oFnt12n,,,,0)		
		EndIf	
	EndIf
Next
If !Empty(_cRet)
	 oPrn:Say(nLin:=nLin+060,0100, AllTrim(_cRet) ,oFnt12n,,,,0)				
EndIf	

// Rodape
oPrn:Say(nLin:=nLin+120,0100, "Sem mais para o momento subscrevemo-nos." ,oFnt12n,,,,0)				
oPrn:Say(nLin:=nLin+120,0100, "Atenciosamente," ,oFnt12n,,,,0)				

///oPrn:SayBitmap(nLin:=nLin+120, 0100, "Assinaturas" + cEmpAnt + ".jpg", 600, 400)
oPrn:SayBitmap(nLin:=nLin+120, 0100, "logo_ortobom_com_slogan.jpg", 600, 400)

///_cRodape := '<img src="http://bo.ortobom.com.br/campanhas/Assinaturas' + cEmpAnt + '.jpg">'

oPrn:EndPage()                   
oPrn:Preview()                   

Return  // retorno da fun��o