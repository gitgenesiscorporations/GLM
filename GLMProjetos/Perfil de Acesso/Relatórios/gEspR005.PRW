/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Empresa   � GLM Assessoria em Inform�rica Ltda.                        ���
�������������������������������������������������������������������������Ŀ��
���M�dulo    � (ESP) - Espec�fico                                         ���
�������������������������������������������������������������������������Ŀ��
���Programa  � gEspR005  � Autor � George AC. Gon�alves � Data � 26/06/09 ���
�������������������������������������������������������������������������Ĵ��
���Fun��es   � gEspR005  � Autor � George AC. Gon�alves � Data � 26/06/09 ���
���          � Executa   � Autor � George AC. Gon�alves � Data � 26/06/09 ���
���          � ImpCompl  � Autor � George AC. Gon�alves � Data � 26/06/09 ���
���          � ValidPerg � Autor � George AC. Gon�alves � Data � 26/06/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Perfil de Acesso por Menu                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fio: Projeto de concess�o de acesso                  ���
��������������������������������������������������������������������������ٱ�
���Partida   � Chamada Via Menu                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function gEspR005()  // Rela��o de Perfil de Acesso por Menu

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
cDesc2   := "por menu"
cDesc3   := ""
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
nLastKey := 0
nomeprog := "gCFGR005"
m_pag    := 1                                              
tamanho  := "G"                                       
cabec1   := OemToAnsi("|MENU                          |                 FUNCIONALIDADES                  |      PROGRAMA      |    ACESSO   | PESQUISAR | VISUALIZAR | INCLUIR | ALTERAR | EXCLUIR |")
cabec2   := ""
nlin     := 9999
LcPath   := GetNewPar("MV_RELT","\SPOOL\")
LcNmArq  := "PERFIL_ACESSO_MENU.CSV"
cLin     := ""
cPerg    := "CFGR05"

// define v�rias privates
Private cArqTxt := LcPath+LcNmArq
Private cEOL    := "CHR(13)+CHR(10)"
                   
//+--------------------------------------------------------------+
//� Verifica as perguntas selecionadas                           �
//+--------------------------------------------------------------+
ValidPerg()  // chamada a fun��o de valida��o de grupo de perguntas

//+---------------------------------------------+
//� Variaveis utilizadas para parametros        �
//� mv_par01  // Id do M�dulo Inicial		    �
//� mv_par02  // ID do M�dulo Final	    		�
//+---------------------------------------------+ 
Pergunte(cPerg,.F.)  // chamada a fun��o de grupo de perguntas

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
	MsgStop("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
Else	
	cCabec := "M�DULO"     +";" + ;
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
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
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
	Ferase(c1ArqRec+ GetDBExtension())
	Ferase(c1ArqRec+OrdBagExt())
	
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

U_gLeXML(mv_par01,mv_par02)  // chamada a fun��o de leitura do arquivo de menu padr�o XML

cArqAnt  := ""
cNiv1Ant := ""
cNiv2Ant := ""
cNiv3Ant := ""
cNiv4Ant := ""

aDescModulos := RetModName(.T.)  // array com os dados dos m�dulos

DbSelectArea("TRB")  // seleciona arquivo de trabalho
DbSetIndex(c1ArqRec+OrdBagExt())  // muda ordem do �ndice
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

	If nlin > 65 .Or. cArqAnt <> TRB->ID_ARQ  // se quebra de p�gina
		nlin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIf(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
	EndIf

	If cNiv1Ant <> TRB->ID_NIV1    
		nlin := nlin + 1           	
		@ nlin,000 PSAY "|" + TRB->ID_ARQ
		@ nlin,031 PSAY "|" + TRB->ID_NIV1
		@ nlin,082 PSAY "|"
		@ nlin,103 PSAY "|"
		@ nlin,117 PSAY "|"
		@ nlin,129 PSAY "|"
		@ nlin,142 PSAY "|"
		@ nlin,152 PSAY "|"
		@ nlin,162 PSAY "|"	
		@ nlin,172 PSAY "|"	    		
	EndIf	

	If cNiv1Ant+cNiv2Ant <> TRB->ID_NIV1+TRB->ID_NIV2	
		nlin := nlin + 1           
		@ nlin,000 PSAY "|" + TRB->ID_ARQ
		@ nlin,031 PSAY "|   " + TRB->ID_NIV2
	EndIf	

	If !Empty(TRB->ID_NIV3)            
	    If cNiv1Ant+cNiv2Ant <> TRB->ID_NIV1+TRB->ID_NIV2
			@ nlin,082 PSAY "|"
			@ nlin,103 PSAY "|"
			@ nlin,117 PSAY "|"
			@ nlin,129 PSAY "|"
			@ nlin,142 PSAY "|"
			@ nlin,152 PSAY "|"
			@ nlin,162 PSAY "|"	
			@ nlin,172 PSAY "|"	    	
		EndIf	                                                               
		nlin := nlin + 1	
		@ nlin,000 PSAY "|" + TRB->ID_ARQ
		If cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3
			@ nlin,031 PSAY "|      " + TRB->ID_NIV3
		EndIf	
	Else
		If !Empty(TRB->ID_NIV2) .And. Empty(TRB->ID_NIV3) .And. !Empty(TRB->ID_PRG)	    
			ImpCompl()  // chamada a fun��o de complemento da impress�o	
		EndIf	
	EndIf
	
	If !Empty(TRB->ID_NIV4)     
	    If cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3	
			@ nlin,082 PSAY "|"
			@ nlin,103 PSAY "|"
			@ nlin,117 PSAY "|"
			@ nlin,129 PSAY "|"
			@ nlin,142 PSAY "|"
			@ nlin,152 PSAY "|"
			@ nlin,162 PSAY "|"	
			@ nlin,172 PSAY "|"	    	       
		EndIf	                
		If !Empty(cNiv4Ant) .And. (cNiv1Ant+cNiv2Ant+cNiv3Ant+cNiv4Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3+TRB->ID_NIV4)
		    If cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3			
				nlin := nlin + 1			    
				@ nlin,000 PSAY "|" + TRB->ID_ARQ				
			EndIf	
			@ nlin,031 PSAY "|         " + TRB->ID_NIV4		
		Else
		    If cNiv1Ant+cNiv2Ant+cNiv3Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3					
				nlin := nlin + 1	
				@ nlin,000 PSAY "|" + TRB->ID_ARQ
			EndIf	
			If cNiv1Ant+cNiv2Ant+cNiv3Ant+cNiv4Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3+TRB->ID_NIV4
				@ nlin,031 PSAY "|         " + TRB->ID_NIV4
			EndIf	
		EndIf	
	Else     
		If !Empty(TRB->ID_NIV2) .And. !Empty(TRB->ID_NIV3) .And. Empty(TRB->ID_NIV4) .And. !Empty(TRB->ID_PRG)
			ImpCompl()  // chamada a fun��o de complemento da impress�o	
		EndIf	
	EndIf

	If !Empty(TRB->ID_NIV5)     
	    If cNiv1Ant+cNiv2Ant+cNiv3Ant+cNiv4Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3+TRB->ID_NIV4	
			@ nlin,082 PSAY "|"
			@ nlin,103 PSAY "|"
			@ nlin,117 PSAY "|"
			@ nlin,129 PSAY "|"
			@ nlin,142 PSAY "|"
			@ nlin,152 PSAY "|"
			@ nlin,162 PSAY "|"	
			@ nlin,172 PSAY "|"	    	       
		EndIf	
		If cNiv1Ant+cNiv2Ant+cNiv3Ant+cNiv4Ant <> TRB->ID_NIV1+TRB->ID_NIV2+TRB->ID_NIV3+TRB->ID_NIV4
			nlin := nlin + 1	
			@ nlin,000 PSAY "|" + TRB->ID_ARQ             
			@ nlin,031 PSAY "|            " + TRB->ID_NIV5			    
			ImpCompl()  // chamada a fun��o de complemento da impress�o				
		Else	
			@ nlin,031 PSAY "|            " + TRB->ID_NIV5                          
			ImpCompl()  // chamada a fun��o de complemento da impress�o							
		EndIf	
	Else     
		If !Empty(TRB->ID_NIV2) .And. !Empty(TRB->ID_NIV3) .And. !Empty(TRB->ID_NIV4) .And. Empty(TRB->ID_NIV5) .And. !Empty(TRB->ID_PRG)
			ImpCompl()  // chamada a fun��o de complemento da impress�o	
		EndIf	
	EndIf

	cArqAnt  := TRB->ID_ARQ                                                                                    
	cNiv1Ant := TRB->ID_NIV1	
	cNiv2Ant := TRB->ID_NIV2	
	cNiv3Ant := TRB->ID_NIV3
	cNiv4Ant := TRB->ID_NIV4

/*	
	DbSelectArea("SX5")  // seleciona arquivo de tabela padr�o
	SX5->(DbSetOrder(1))  // muda ordem do �ndice
	If SX5->(DbSeek(xFilial("SX5")+"Z3"+TRB->ID_MOD))  // posiciona registro
		cDescMod := SX5->X5_DESCRI
	Else                          
		cDescMod := ""
	EndIf
*/

	cDescMod := aDescModulos[Ascan(aDescModulos,{|X| X[1] = Val(TRB->ID_MOD)})][3]  // recupera descri��o do m�dulo
		
	cLin := cDescMod                             + ";" + ;
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
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif

	TRB->(DbSkip())
	
Enddo

Return  // retorno da fun��o
***************************************************************************************************************************************************

Static Function ImpCompl()  // fun��o de complemento da impress�o	

@ nlin,082 PSAY "|" + AllTrim(TRB->ID_PRG)

If Left(_cAcess,1) == "E"
	@ nlin,103 PSAY "|     " + "Sim"
Else
	@ nlin,103 PSAY "|     " + "N�o"
Endif
	
If _cPesq == "X"
	@ nlin,117 PSAY "|    " + "Sim"
Else
	@ nlin,117 PSAY "|    " + "N�o"
Endif
	
If _cVisu == "X"
	@ nlin,129 PSAY "|    " + "Sim"
Else
	@ nlin,129 PSAY "|    " + "N�o"
Endif
	
If _cIncluir == "X"
	@ nlin,142 PSAY "|   " + "Sim"
Else
	@ nlin,142 PSAY "|   " + "N�o"
Endif
	
If _cAlterar == "X"
	@ nlin,152 PSAY "|   " + "Sim"
Else
	@ nlin,152 PSAY "|   " + "N�o"
Endif
	
If _cExcluir == "X"
	@ nlin,162 PSAY "|   " + "Sim"
Else
	@ nlin,162 PSAY "|   " + "N�o"
Endif

@ nlin,172 PSAY "|"

Return  // Retorno da fun��o
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do �ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05                                                                  
	Aadd(aRegs,{cPerg,"01","ID do M�dulo    ","ID do M�dulo    ","ID do M�dulo   ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZZJb"  ,"","","","",""})
	Aadd(aRegs,{cPerg,"02","ID do M�dulo    ","ID do M�dulo    ","ID do M�dulo   ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","ZZJb"  ,"","","","",""})		

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