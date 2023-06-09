/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspR004 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspR004 � Autor � George AC. Gon�alves � Data � 25/06/09  ���
���          � GeralRel � Autor � George AC. Gon�alves � Data � 25/06/09  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Revis�o Peri�dica de Acesso                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada via menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function gEspR004()  // Relat�rio de Revis�o Peri�dica de Acesso

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
titulo   := "Relat�rio de Revis�o Peri�dica de Acesso"
cDesc1   := "Este programa ir� emitir o relat�rio de revis�o peri�dica"
cDesc2   := "de acesso"
cDesc3   := ""
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
nLastKey := 0
nomeprog := "gEspR004"
m_pag    := 1                                              
tamanho  := "G"                                       
cabec1   := OemToAnsi("|USU�RIO        |PERFIL              |MENU                          |                 FUNCIONALIDADES                  |      PROGRAMA      |    ACESSO   | PESQUISAR | VISUALIZAR | INCLUIR | ALTERAR | EXCLUIR |")
cabec2   := ""
nlin     := 9999
LcPath   := GetNewPar("MV_RELT","\SPOOL\")
LcNmArq  := "REVISAO_PERIODICA_ACESSO.CSV"
cLin     := ""
cPerg    := ""

// define v�rias privates
Private cArqTxt := LcPath+LcNmArq
Private cEOL    := "CHR(13)+CHR(10)"

// Variaveis utilizadas para parametros        
mv_par01 := ""                      // C�digo de Usu�rio Inicial	    
mv_par02 := "ZZZZZZ"                // C�digo de Usu�rio Final	    
mv_par03 := ""                      // Perfil de Acesso Inicial       
mv_par04 := "ZZZZZZZZZZZZZZZZZZZZ"  // Perfil de Acesso Final         
mv_par05 := ""                      // ID M�dulo Inicial  	   	    
mv_par06 := "ZZ"                    // ID M�dulo Final  	   		    

//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT.                       �
//+--------------------------------------------------------------+
wnrel := SetPrint(,nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
   #IFNDEF WINDOWS
      RestScreen(3,0,24,79,cSavScr1)
   #ENDIF
   Return
EndIf

SetDefault(aReturn,cString)
 
If LastKey() == 27 .Or. nLastKey == 27
   #IFNDEF WINDOWS
      RestScreen(3,0,24,79,cSavScr1)
   #ENDIF
   Return
EndIf

Private nHdl := fCreate(cArqTxt)

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgStop("O arquivo de nome "+cArqTxt+" n�o pode ser executado! Verifique os par�metros.","Aten��o!")
Else	
	cCabec := "USU�RIO"    +";" + ;
	          "PERFIL"     +";" + ;	
	          "M�DULO"     +";" + ;
	          "MENU"       +";" + ;		          	          
              "N�VEL 1"    +";" + ;
              "N�VEL 2"    +";" + ;
              "N�VEL 3"    +";" + ;
              "N�VEL 4"    +";" + ;
              "N�VEL 5"    +";" + ;              
              "PROGRAMA"   +";" + ;                                                        
              "ACESSO"     +";" + ;
              "PESQUISAR"  +";" + ;
              "VISUALIZAR" +";" + ;
              "INCLUIR"    +";" + ;
              "ALTERAR"    +";" + ;
              "EXCLUIR"    + ;
		      cEOL
		
	If fWrite(nHdl,cCabec,Len(cCabec)) != Len(cCabec)
		If !MsgAlert("Ocorreu um erro na grava��o do arquivo. Continua?","Aten��o!")
			Return
		Endif
	Endif

	RptStatus({|| Executa()},,"Gerando Relat�rio... " + Time())

	fClose(nHdl)

	//_cExec := AllTrim(GetMv("PATCHEXCEL"))
	//_cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq	

	//WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL
	
   _cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq
   _cExec := u_ProcuraExcel()
 	
   If Aviso("ATEN��O" , "Deseja gerar planilha em excel ?", {"Sim" , "N�o" } )  =  1
  	   WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL
   EndIf  
	
	dbSelectArea("TRB")
	Set Filter To
	dbCloseArea()
	Ferase(cArqRec1+ GetDBExtension())
	Ferase(cArqRec1+OrdBagExt())
	
EndIf
	
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

Static Function Executa()

local _cArqXnu 	:= CriaTrab(NIL,.F.)
local _cAlias	:= Alias()

U_gLeXML1(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06)  // chamada a fun��o de leitura do arquivo de menu padr�o XML

cUsuAnt  := ""
cPerfAnt := ""
cArqAnt  := ""
cNiv1Ant := ""
cNiv2Ant := ""
cNiv3Ant := ""
cNiv4Ant := ""

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

DbSelectArea("TRB")  // seleciona arquivo de trabalho
DbSetIndex(cArqRec1 + OrdBagExt())  // muda ordem do �ndice
TRB->(DbGoTop())  // vai para o in�cio do arquivo

SetRegua(TRB->(RecCount())-1)

Do While TRB->(!Eof())  // percorre todo o arquivo

	IncRegua()

	_cAcess   := Upper(TRB->ID_ACESS)
	_cPesq    := Upper(SubStr(TRB->ID_ACESS,1,1))
	_cVisu    := Upper(SubStr(TRB->ID_ACESS,2,1))
	_cIncluir := Upper(SubStr(TRB->ID_ACESS,3,1))
	_cAlterar := Upper(SubStr(TRB->ID_ACESS,4,1))
	_cExcluir := Upper(SubStr(TRB->ID_ACESS,5,1))

	If nlin > 65 .Or. cUsuAnt <> TRB->ID_USUA  // se quebra de p�gina
		nlin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIf(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
	EndIf

	If cUsuAnt+cPerfAnt+cNiv1Ant <> TRB->ID_USUA+TRB->ID_PERF+TRB->ID_NIV1    
		nlin := nlin + 1           	
		@ nlin,000 PSAY "|" + TRB->ID_USUA
		@ nlin,016 PSAY "|" + TRB->ID_PERF
		@ nlin,037 PSAY "|" + TRB->ID_ARQ
		@ nlin,068 PSAY "|" + TRB->ID_NIV1
		@ nlin,119 PSAY "|"
		@ nlin,140 PSAY "|"
		@ nlin,154 PSAY "|"
		@ nlin,166 PSAY "|"
		@ nlin,179 PSAY "|"
		@ nlin,189 PSAY "|"
		@ nlin,199 PSAY "|"	
		@ nlin,209 PSAY "|"	    		
	EndIf	

	If cUsuAnt+cPerfAnt+cNiv1Ant+cNiv2Ant <> TRB->ID_USUA+TRB->ID_PERF+TRB->ID_NIV1+TRB->ID_NIV2	
		nlin := nlin + 1                     
		@ nlin,000 PSAY "|" + TRB->ID_USUA
		@ nlin,016 PSAY "|" + TRB->ID_PERF
		@ nlin,037 PSAY "|" + TRB->ID_ARQ
		@ nlin,068 PSAY "|   " + TRB->ID_NIV2
	EndIf	

	If !Empty(TRB->ID_NIV3)            
	    If cUsuAnt+cPerfAnt+cNiv1Ant+cNiv2Ant <> TRB->ID_USUA+TRB->ID_PERF+TRB->ID_NIV1+TRB->ID_NIV2
			@ nlin,119 PSAY "|"
			@ nlin,140 PSAY "|"
			@ nlin,154 PSAY "|"
			@ nlin,166 PSAY "|"
			@ nlin,179 PSAY "|"
			@ nlin,189 PSAY "|"
			@ nlin,199 PSAY "|"	
			@ nlin,209 PSAY "|"	    		
		EndIf	
		nlin := nlin + 1	
		@ nlin,000 PSAY "|" + TRB->ID_USUA
		@ nlin,016 PSAY "|" + TRB->ID_PERF		
		@ nlin,037 PSAY "|" + TRB->ID_ARQ			
		If cUsuAnt+cPerfAnt+cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_USUA+TRB->ID_PERF+TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3
			@ nlin,068 PSAY "|      " + TRB->ID_NIV3
		EndIf	
	Else
		If !Empty(TRB->ID_NIV2) .And. Empty(TRB->ID_NIV3) .And. !Empty(TRB->ID_PRG)	    
			ImpCompl()  // chamada a fun��o de complemento da impress�o	
		EndIf	
	EndIf
	
	If !Empty(TRB->ID_NIV4)     
	    If cUsuAnt+cPerfAnt+cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_USUA+TRB->ID_PERF+TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3	
			@ nlin,119 PSAY "|"
			@ nlin,140 PSAY "|"
			@ nlin,154 PSAY "|"
			@ nlin,166 PSAY "|"
			@ nlin,179 PSAY "|"
			@ nlin,189 PSAY "|"
			@ nlin,199 PSAY "|"	
			@ nlin,209 PSAY "|"	    		
		EndIf	
		nlin := nlin + 1		
		@ nlin,000 PSAY "|" + TRB->ID_USUA
		@ nlin,016 PSAY "|" + TRB->ID_PERF
		@ nlin,037 PSAY "|" + TRB->ID_ARQ			
		@ nlin,068 PSAY "|         " + TRB->ID_NIV4
	Else     
		If !Empty(TRB->ID_NIV2) .And. !Empty(TRB->ID_NIV3) .And. Empty(TRB->ID_NIV4) .And. !Empty(TRB->ID_PRG)
			ImpCompl()  // chamada a fun��o de complemento da impress�o	
		EndIf	
	EndIf

	cUsuAnt  := TRB->ID_USUA
	cPerfAnt := TRB->ID_PERF                                                                                   
	cArqAnt  := TRB->ID_ARQ                                                                                    		
	cNiv1Ant := TRB->ID_NIV1	
	cNiv2Ant := TRB->ID_NIV2	
	cNiv3Ant := TRB->ID_NIV3
	cNiv4Ant := TRB->ID_NIV4

	cDescMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(TRB->ID_MOD)})][3]  // recupera descri��o do m�dulo

	cLin := TRB->ID_USUA                         + ";" + ;
			TRB->ID_PERF                         + ";" + ;
			cDescMod                             + ";" + ;
			TRB->ID_ARQ                          + ";" + ;
			TRB->ID_NIV1                         + ";" + ;			
			TRB->ID_NIV2                         + ";" + ;
			TRB->ID_NIV3                         + ";" + ;
			TRB->ID_NIV4                         + ";" + ;
			TRB->ID_NIV5                         + ";" + ;			
			TRB->ID_PRG                          + ";" + ;			
			If(Left(_cAcess,1)=="E","Sim","N�o") + ";" + ;
			If(_cPesq=="X","Sim","N�o")          + ";" + ;
			If(_cVisu=="X","Sim","N�o")          + ";" + ;
			If(_cIncluir=="X","Sim","N�o")       + ";" + ;
			If(_cAlterar=="X","Sim","N�o")       + ";" + ;			
			If(_cExcluir=="X","Sim","N�o")       + ; 	
			cEOL // Variavel para criacao da linha do registros para gravacao

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na grava��o do arquivo. Continua?","Aten��o!")
			Exit
		Endif
	Endif

	TRB->(DbSkip())
	
Enddo

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function ImpCompl()  // fun��o de complemento da impress�o	

@ nlin,119 PSAY "|" + AllTrim(TRB->ID_PRG)

If Left(_cAcess,1) == "E"
	@ nlin,140 PSAY "|     " + "Sim"
Else
	@ nlin,140 PSAY "|     " + "N�o"
Endif
	
If _cPesq == "X"
	@ nlin,154 PSAY "|    " + "Sim"
Else
	@ nlin,154 PSAY "|    " + "N�o"
Endif
	
If _cVisu == "X"
	@ nlin,166 PSAY "|    " + "Sim"
Else
	@ nlin,166 PSAY "|    " + "N�o"
Endif

If _cIncluir == "X"
	@ nlin,179 PSAY "|   " + "Sim"
Else
	@ nlin,179 PSAY "|   " + "N�o"
Endif
	
If _cAlterar == "X"
	@ nlin,189 PSAY "|   " + "Sim"
Else
	@ nlin,189 PSAY "|   " + "N�o"
Endif
	
If _cExcluir == "X"
	@ nlin,199 PSAY "|   " + "Sim"
Else
	@ nlin,199 PSAY "|   " + "N�o"
Endif

@ nlin,209 PSAY "|"

Return  // Retorno da fun��o