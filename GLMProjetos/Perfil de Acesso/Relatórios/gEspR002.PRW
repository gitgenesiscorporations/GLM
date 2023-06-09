/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspR002 � Autor � George AC. Gon�alves � Data � 15/01/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspR002  � Autor � George AC. Gon�alves � Data � 21/01/09 ���
���          � GeralRel  � Autor � George AC. Gon�alves � Data � 15/01/09 ���
���          � MontaCabec� Autor � George AC. Gon�alves � Data � 15/01/09 ���
���          � MontaItem � Autor � George AC. Gon�alves � Data � 15/01/09 ���
���          � MontaArq  � Autor � George AC. Gon�alves � Data � 15/01/09 ���
���          � ValidPerg � Autor � George AC. Gon�alves � Data � 15/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Perfil de Acesso por M�dulo/Perfil            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Sele��o da op��o verifica��o perfil acesso - Rotina gEWF001���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "Topconn.ch"      

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function gEspR002()  // Rela��o de Perfil de Acesso por m�dulo/perfil

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,CPERG,NLASTKEY,LI")
SetPrvt("CABEC1,CABEC2,TAMANHO,NOMEPROG,M_PAG")

//+--------------------------------------------------------------+
//� Define Variaveis.                                            �
//+--------------------------------------------------------------+
titulo   := "Rela��o de Perfil de Acesso"
cDesc1   := "Este programa ir� emitir o relat�rio de perfil de acesso"
cDesc2   := "por m�dulo/perfil"
cDesc3   := ""
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
nLastKey := 0
nomeprog := "gEspR002"
m_pag    := 1                                              
tamanho  := "G"                                       
cabec1   := OemToAnsi("|MENU                          |                 FUNCIONALIDADES                  |      PROGRAMA      |    ACESSO   | PESQUISAR | VISUALIZAR | INCLUIR | ALTERAR | EXCLUIR |")
cabec2   := ""
nlin     := 9999
LcPath   := GetNewPar("MV_RELT","\SPOOL\")
LcNmArq  := "PERFILMODULO"
cPerg    := "CFGR99"

// define v�rias privates
Private cArqTxt := LcPath+LcNmArq
Private cEOL    := "CHR(13)+CHR(10)"
Private cLin    := ""
Private nHdl

//+--------------------------------------------------------------+
//� Verifica as perguntas selecionadas                           �
//+--------------------------------------------------------------+
ValidPerg()  // chamada a fun��o de valida��o de grupo de perguntas

//+---------------------------------------------+
//� Variaveis utilizadas para parametros        �
//� mv_par01  // Id do M�dulo				    �
//� mv_par02  // C�digo do Perfil			    �
//+---------------------------------------------+ 
///Pergunte(cPerg,.F.)  // chamada a fun��o de grupo de perguntas

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT.                       �
//+--------------------------------------------------------------+
///If gFlagParam == .T.  // se selecionar par�metros
///	wnrel := SetPrint(,nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
///Else	
///	wnrel := SetPrint(,nomeprog,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
///EndIf

///If LastKey() == 27 .Or. nLastKey == 27
///   #IFNDEF WINDOWS
///      RestScreen(3,0,24,79,cSavScr1)
///   #ENDIF
///   Return///EndIf

///SetDefault(aReturn,cString)
 
///If LastKey() == 27 .Or. nLastKey == 27
///   #IFNDEF WINDOWS
///      RestScreen(3,0,24,79,cSavScr1)
///   #ENDIF
///   Return
///EndIf

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif
              
RptStatus({|| MontaCabec()},,"Gerando Relat�rio... " + Time())

fClose(nHdl)

cQuery := "  DELETE " + RetSqlname("ZZZ") + " WHERE ZZZ_USU = '" + AllTrim(Upper(SubStr(cUsuario,7,15))) + "' " 

TCSQLExec(cQuery)
TCSQLExec("Commit")  // executa commit
	
///Set Filter To
Set Device To Screen  // define dispositivo para v�deo           

//+------------------------------------------------------------------+
//� Se impressao em Disco, chama Spool.                              �
//+------------------------------------------------------------------+
If aReturn[5] == 1
   Set Printer To 
   OurSpool(wnrel)
EndIf

//+------------------------------------------------------------------+
//� Libera relatorio para Spool da Rede.                             �
//+------------------------------------------------------------------+
FT_PFLUSH() 

Return  // retorno da fun��o      
***************************************************************************************************************************************************

Static Function MontaCabec()  // fun��o para montagem do cabe�alho do relat�rio

U_gLeXML3(mv_par01,mv_par02)  // chamada a fun��o de leitura do arquivo de menu padr�o XML

cQuery := "    SELECT ZZZ.ZZZ_MOD   AS MODULO,  "
cQuery += "           ZZZ.ZZZ_NIV1  AS NIVEL1,  "
cQuery += "           ZZZ.ZZZ_NIV2  AS NIVEL2,  "
cQuery += "           ZZZ.ZZZ_NIV3  AS NIVEL3,  "
cQuery += "           ZZZ.ZZZ_NIV4  AS NIVEL4,  "
cQuery += "           ZZZ.ZZZ_NIV5  AS NIVEL5,  "
cQuery += "           ZZZ.ZZZ_ARQ   AS ARQUIVO, "	   
cQuery += "           ZZZ.ZZZ_ACESS AS ACESSO   "	   
cQuery += "      FROM " + RetSqlname("ZZZ") + " ZZZ "
cQuery += "     WHERE ZZZ.ZZZ_FILIAL = '" + xFilial("ZZZ")                        + "' And " 
cQuery += "           ZZZ.ZZZ_USU    = '" + Upper(AllTrim(SubStr(cUsuario,7,15))) + "' And " 	
cQuery += "           ZZZ.D_E_L_E_T_ = ' '                                                 "
cQuery += "GROUP BY ZZZ.ZZZ_MOD, ZZZ.ZZZ_NIV1, ZZZ.ZZZ_NIV2, ZZZ.ZZZ_NIV3, ZZZ.ZZZ_NIV4, ZZZ.ZZZ_NIV5, ZZZ.ZZZ_ARQ, ZZZ.ZZZ_ACESS"
                                
TCQUERY cQuery Alias TMP NEW                                      

cQuery1 := "    SELECT DISTINCT ZZZ.ZZZ_MOD AS MODULO, "
cQuery1 += "                    ZZZ.ZZZ_ARQ AS ARQUIVO "
cQuery1 += "      FROM " + RetSqlname("ZZZ") + " ZZZ "                                 
cQuery1 += "     WHERE ZZZ.ZZZ_FILIAL = '" + xFilial("ZZZ") + "' And "                 
cQuery1 += "           ZZZ.ZZZ_USU    = '" + Upper(AllTrim(SubStr(cUsuario,7,15))) + "' And " 	
cQuery1 += "           ZZZ.D_E_L_E_T_ = ' '                          "
cQuery1 += "ORDER BY ZZZ.ZZZ_MOD, ZZZ.ZZZ_ARQ"
                                
TCQUERY cQuery1 Alias TMP1 NEW                                      

cModAnt  := ""
cArqAnt  := ""
lMod     := .F.
aArquivo := {}

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

gCabec1 :=  "N�VEL 1" +";" + ;
			"N�VEL 2" +";" + ;
		    "N�VEL 3" +";" + ;
		    "N�VEL 4" +";" + ;
 	    	"N�VEL 5"            

DbSelectArea("TMP1")  // seleciona arquivo de trabalho
TMP1->(DbGotop())  // vai para o in�cio do arquivo
Do While !TMP1->(Eof())  // percorre todo o arquivo  

	If cModAnt <> TMP1->MODULO .And. lMod == .T.

		gCabec1 := gCabec1 + cEOL

		If Empty(cModAnt)  // se vazio
			cModAnt := TMP1->MODULO
		EndIf              
		
		cDescMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(cModAnt)})][3]  // recupera descri��o do m�dulo
				                                   
		DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil de acesso
		ZZC->(DbSetOrder(1))  // muda ordem do �ndice
		If ZZC->(DbSeek(xFilial("ZZC")+mv_par01+mv_par02))  // posiciona registro
			cDescPerf := Alltrim(ZZC->ZZC_DSPERF)  // descri��o do perfil
		EndIf
				
		nHdl := fCreate(cArqTxt+"-"+AllTrim(cModAnt)+"-"+mv_par02+"-"+AllTrim(cDescMod)+"-"+cDescPerf+".CSV")	
		If nHdl <> -1
		
			If fWrite(nHdl,gCabec1,Len(gCabec1)) != Len(gCabec1)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					TMP1->(DbCloseArea())	
					TMP->(DbCloseArea())					
					Return
				Endif
			Endif
		 
			gCabec2 := ";;;;"
			
			For wgN := 1 To Len(aArquivo)                         
				gCabec2 := gCabec2 + ";" + "P;V;I;A;E;"				
			Next			

			gCabec2 := gCabec2 + cEOL			
			
			If fWrite(nHdl,gCabec2,Len(gCabec2)) != Len(gCabec2)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					TMP1->(DbCloseArea())	
					TMP->(DbCloseArea())					
					Return
				Endif
			Endif
			
			MontaItem(cModAnt)	
			
		EndIf

		aArquivo := {}				
		
	EndIf

	If cModAnt+cArqAnt <> TMP1->MODULO+TMP1->ARQUIVO
		gCabec1 := gCabec1 + ";" + AllTrim(TMP1->ARQUIVO) + ";;;;;"
	EndIf	                                   

	Aadd(aArquivo, AllTrim(TMP1->ARQUIVO))		
	cModAnt := TMP1->MODULO
	cArqAnt := TMP1->ARQUIVO
	lMod    := .T.
		    
	TMP1->(DbSkip())    
        
EndDo
    
gCabec1 := gCabec1 + cEOL

cDescMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(cModAnt)})][3]  // recupera descri��o do m�dulo
				       
DbSelectArea("ZZC")  // seleciona arquivo de m�dulo/perfil de acesso
ZZC->(DbSetOrder(1))  // muda ordem do �ndice
If ZZC->(DbSeek(xFilial("ZZC")+mv_par01+mv_par02))  // posiciona registro
	cDescPerf := Alltrim(ZZC->ZZC_DSPERF)  // descri��o do perfil
EndIf
				
nHdl := fCreate(cArqTxt+"-"+AllTrim(cModAnt)+"-"+mv_par02+"-"+AllTrim(cDescMod)+"-"+cDescPerf+".CSV")					
If nHdl <> -1
	If fWrite(nHdl,gCabec1,Len(gCabec1)) != Len(gCabec1)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			TMP1->(DbCloseArea())	
			TMP->(DbCloseArea())	
			Return
		Endif
	Endif
	
	gCabec2 := ";;;;"
	For wgN := 1 To Len(aArquivo)                         
		gCabec2 := gCabec2 + ";" + "P;V;I;A;E;"				
	Next			
	gCabec2 := gCabec2 + cEOL			
	
	If fWrite(nHdl,gCabec2,Len(gCabec2)) != Len(gCabec2)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			TMP1->(DbCloseArea())	
			TMP->(DbCloseArea())			
			Return
		Endif
	Endif	
	
	MontaItem(cModAnt)	
EndIf

TMP1->(DbCloseArea())	
TMP->(DbCloseArea())	

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function MontaItem(cMod)  // fun��o para montagem dos itens do relat�rio

cNiv1 := ""
cNiv2 := ""
cNiv3 := ""
cNiv4 := ""
cNiv5 := ""

nCont := 0

DbSelectArea("TMP")  // seleciona arquivo de trabalho
Do While TMP->(!Eof()) .And. TMP->MODULO == cMod   // percorre todo o arquivo       

	nCont++
	
	cNiv1 := TMP->NIVEL1
	cNiv2 := TMP->NIVEL2
	cNiv3 := TMP->NIVEL3
	cNiv4 := TMP->NIVEL4
	cNiv5 := TMP->NIVEL5		
	cAces := TMP->ACESSO
		
	_cPesq    := Upper(SubStr(TMP->ACESSO,1,1))
	_cVisu    := Upper(SubStr(TMP->ACESSO,2,1))
	_cIncluir := Upper(SubStr(TMP->ACESSO,3,1))
	_cAlterar := Upper(SubStr(TMP->ACESSO,4,1))
	_cExcluir := Upper(SubStr(TMP->ACESSO,5,1))
            
	cLin := TMP->NIVEL1 + ";" + ;			
			TMP->NIVEL2 + ";" + ;
			TMP->NIVEL3 + ";" + ;
			TMP->NIVEL4 + ";" + ;
			TMP->NIVEL5

	If ASCAN(aArquivo, AllTrim(TMP->ARQUIVO)) <> nCont
		For wgN := nCont To (ASCAN(aArquivo, AllTrim(TMP->ARQUIVO))-1)
			cLin := cLin + ";;;;;;"
		Next	                                      
		nCont := ASCAN(aArquivo, AllTrim(TMP->ARQUIVO))		
	EndIf			

	cLin := cLin      + ";" + ;						
			_cPesq    + ";" + ;
			_cVisu    + ";" + ;
			_cIncluir + ";" + ;
			_cAlterar + ";" + ;			
			_cExcluir + ";"

	TMP->(DbSkip())    
				
	MontaArq(TMP->MODULO,cNiv1,cNiv2,cNiv3,cNiv4,cNiv5,nCont)			
    
	cLin := cLin + cEOL // Variavel para criacao da linha do registros para gravacao

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif

	nCont := 0

EndDo

cLin := cNiv1 + ";" + ;			
		cNiv2 + ";" + ;
		cNiv3 + ";" + ;
		cNiv4 + ";" + ;
		cNiv5

If !Empty(cNiv1) .And. !Empty(TMP->MODULO)
	MontaArq(cMod,cNiv1,cNiv2,cNiv3,cNiv4,cNiv5)		

	cLin := cLin + cEOL // Variavel para criacao da linha do registros para gravacao

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Return
		Endif
	Endif

EndIf
   
gCabec1 := "N�VEL 1" +";" + ;
		   "N�VEL 2" +";" + ;
		   "N�VEL 3" +";" + ;
		   "N�VEL 4" +";" + ;
 	       "N�VEL 5"            

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function MontaArq(gMod,gNiv1,gNiv2,gNiv3,gNiv4,gNiv5,nCont)  // fun��o de montagem do arquivo

Do While TMP->(!Eof()) .And. TMP->MODULO+TMP->NIVEL1+TMP->NIVEL2+TMP->NIVEL3+TMP->NIVEL4+TMP->NIVEL5 == gMod+gNiv1+gNiv2+gNiv3+gNiv4+gNiv5  // percorre todo o arquivo

	nCont++
	
	_cPesq    := Upper(SubStr(TMP->ACESSO,1,1))
	_cVisu    := Upper(SubStr(TMP->ACESSO,2,1))
	_cIncluir := Upper(SubStr(TMP->ACESSO,3,1))
	_cAlterar := Upper(SubStr(TMP->ACESSO,4,1))
	_cExcluir := Upper(SubStr(TMP->ACESSO,5,1))
                                
	If ASCAN(aArquivo, AllTrim(TMP->ARQUIVO)) <> nCont
		For wgN := nCont To (ASCAN(aArquivo, AllTrim(TMP->ARQUIVO))-1)
			cLin := cLin + ";;;;;;"
		Next	                                      
		nCont := ASCAN(aArquivo, AllTrim(TMP->ARQUIVO))		
	EndIf			

	cLin := cLin      + ";" + ;			
			_cPesq    + ";" + ;
			_cVisu    + ";" + ;
			_cIncluir + ";" + ;
			_cAlterar + ";" + ;			
			_cExcluir + ";"    
		
	TMP->(DbSkip())    
        
EndDo                                 

Return  // retorno da fun��o                                                                                                  
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do �ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","ID do M�dulo    ","ID do M�dulo    ","ID do M�dulo   ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZZJb"  ,"","","","",""})
	Aadd(aRegs,{cPerg,"02","C�digo do Perfil","C�digo do Perfil","ID M�dulo Final","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","PERFRE","","","","",""})

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

Return  // Retorno da fun��o