/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ GLM Assessoria em Informárica Ltda.                        ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Módulo    ³ (ESP) - Específico                                         ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ gEspR001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 05/01/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funções   ³ gEspR001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±³          ³ GeralRel ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±³          ³ gERel001 ³ Autor ³ George AC. Gonçalves ³ Data ³ 25/06/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Relatório de Perfil de Acesso por Usuário                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Específio: Projeto de concessão de acesso                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Partida   ³ Seleção da opção verificação perfil acesso-Rotina gEspG007 ³±±
±±³Partida   ³ Chamada Via Menu                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "Topconn.ch"      

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function gEspR001()  // Relatório de Perfil de Acesso por Usuário

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,CPERG,NLASTKEY,LI")
SetPrvt("CABEC1,CABEC2,TAMANHO,NOMEPROG,M_PAG")

//+--------------------------------------------------------------+
//¦ Define Variaveis.                                            ¦
//+--------------------------------------------------------------+
titulo   := "Relação de Perfil de Acesso por Usuário"
cDesc1   := "Este programa irá emitir o relatório de perfil de "
cDesc2   := "acesso por usuário"
cDesc3   := ""
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
nLastKey := 0
nomeprog := "gEspR001"
m_pag    := 1                                              
tamanho  := "G"                                       
cabec1   := OemToAnsi("USUÁRIO           NOME COMPLETO                              DEPARTAMENTO           CARGO/FUNÇÃO           SUPERIOR               PERFIL                 MENU´s                                               STATUS ARQUIVO    BLOQUEADO    DT ULT ALTERAÇÃO    E-MAIL")
cabec2   := ""
li       := 9999
lFlag    := .F.                    
LcPath   := GetNewPar("MV_RELT","\SPOOL\")
LcNmArq  := "PERFIL_ACESSO_USUARIOS.CSV"
aDbStru	 := {}
aTamSX3  := {}
cUsuAnt  := ""
cLin     := ""
cPerg    := "CFGR01"

// define várias privates
Private _nCont1
Private _nCont2
Private aUsers  := AllUsers(.T.)
Private aGroups := AllGroups()
Private cArqTxt := LcPath+LcNmArq
Private cEOL    := "CHR(13)+CHR(10)"

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
ValidPerg()  // chamada a função de validação de grupo de perguntas

//+---------------------------------------------+
//¦ Variaveis utilizadas para parametros        ¦
//¦ mv_par01  // Código de Usuário Inicial	    ¦
//¦ mv_par02  // Código de Usuário Final	    ¦
//¦ mv_par03  // Departamento Inicial           ¦
//¦ mv_par04  // Departamento Final             ¦
//¦ mv_par05  // Cargo/Função Inicial     	    ¦
//¦ mv_par06  // Cargo/Função Final     	    ¦
//¦ mv_par07  // Superior Inicial          	    ¦
//¦ mv_par08  // Superior Final          	    ¦
//¦ mv_par09  // Perfil de Acesso Inicial       ¦
//¦ mv_par10  // Perfil de Acesso Final         ¦ 
//¦ mv_par11  // Status Usuário				    ¦
//+---------------------------------------------+ 
///Pergunte(cPerg,.F.)  // chamada a função de grupo de perguntas

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT.                       ¦
//+--------------------------------------------------------------+
If gFlagParam == .T.  // se selecionar parâmetros
	wnrel := SetPrint(,nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
Else	
	wnrel := SetPrint(,nomeprog,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
EndIf
	
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

RptStatus({|| GeraRel()},,"Gerando Relatório... " + Time())

Set Device To Screen  // define dispositivo para vídeo           

//+------------------------------------------------------------------+
//¦ Se impressao em Disco, chama Spool.                              ¦
//+------------------------------------------------------------------+
If aReturn[5] == 1
   Set Printer To 
   OurSpool(wnrel)
EndIf

//+------------------------------------------------------------------+
//¦ Libera relatorio para Spool da Rede.                             ¦
//+------------------------------------------------------------------+
FT_PFLUSH() 

Return  // retorno da função      
****************************************************************************************************************************************************

Static Function GeraRel()  // gerando relatório

SetRegua(Len(aUsers)-1)

DbSelectArea("ZZY")  // seleciona arquivo de perfil de usuário

For _nCont1 := 1 To Len(aUsers)  // percorre todo o array de usuários

	IncRegua()
	
	If aUsers[_nCont1,1,1] <> '000000'  // se usuário não for o administrador
	
		If AllTrim(aUsers[_nCont1,1,1]) < AllTrim(mv_par01) .Or. AllTrim(aUsers[_nCont1,1,1]) > AllTrim(mv_par02)  // se registro fora do intervalo de ID do usuário 
			Loop  // pega próximo registro
		EndIf
		If Upper(AllTrim(aUsers[_nCont1,1,12])) < Upper(AllTrim(mv_par03)) .Or. Upper(AllTrim(aUsers[_nCont1,1,12])) > Upper(AllTrim(mv_par04))  // se registro fora do intervalo de Departamento
			Loop  // pega próximo registro
		EndIf		
		If Upper(AllTrim(aUsers[_nCont1,1,13])) < Upper(AllTrim(mv_par05)) .Or. Upper(AllTrim(aUsers[_nCont1,1,13])) > Upper(AllTrim(mv_par06))  // se registro fora do intervalo de Cargo/Função
			Loop  // pega próximo registro
		EndIf				   
		Do Case
			Case ValType(mv_par11) == "C" .And. mv_par11 == "1"  // se usuários liberados
				If aUsers[_nCont1,1,17] == .T.  // usuário bloqueado
					Loop
				EndIf
			Case ValType(mv_par11) == "C" .And. mv_par11 == "2"  // se usuários bloqueados
				If aUsers[_nCont1,1,17] == .F.  // usuário liberados
					Loop
				EndIf			
		EndCase	
		
		If !Empty(aUsers[_nCont1,1,11]) 		
			PswOrder(1)
			If PswSeek(aUsers[_nCont1,1,11],.T.)				
				inf := PswRet()
				If Upper(AllTrim(inf[1,4])) < Upper(AllTrim(mv_par07)) .Or. Upper(AllTrim(inf[1,4])) > Upper(AllTrim(mv_par08))  // se registro fora do intervalo de Superior
					Loop  // pega próximo registro
				EndIf								
			EndIf	
		Else
			If !Empty(mv_par07)
				Loop  // pega próximo registro
			EndIf
		EndIf	

		If Len(aUsers[_nCont1,1,10]) > 0				
           	For gLn := 1 To Len(aUsers[_nCont1,1,10]) 
				If Type("aGroups["+StrZero(Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]}),6)+",2]") == "A"  
				
					If Upper(AllTrim(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2])) < Upper(AllTrim(mv_par09)) .Or. Upper(AllTrim(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2])) > Upper(AllTrim(mv_par10))  // se registro fora do intervalo de Perfil
						Loop  // pega próximo registro
					EndIf								
				
					For _nCont2 := 1 To Len(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2])
						If SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],3,1) <> "X"

							RecLock("ZZY",.T.)		                                                
							ZZY->ZZY_FILIAL := xFilial("ZZY")							
							ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))
							ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
							ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
							ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
							ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
							ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
							If !Empty(aUsers[_nCont1,1,11]) 		
								PswOrder(1)
								If PswSeek(aUsers[_nCont1,1,11],.T.)				
									inf := PswRet()
									ZZY->ZZY_SUPER := inf[1,4]
								EndIf	
							EndIf	
							ZZY->ZZY_PERFIL := aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][1][2]
							ZZY->ZZY_MENU   := Upper(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50))
							If File(AllTrim(SubStr(aGroups[Ascan(aGroups,{|X| X[1][1] = aUsers[_nCont1,1,10,gLn]})][2][_nCont2],4,50)))        							
								ZZY->ZZY_STATUS := "ARQ OK"
							Else                           
								ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
							EndIf
							ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"NÃO")
							ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]									
							MsUnLock()
						EndIf	
					Next _nCont2
				Else 
					For _nCont2 := 1 To Len(aUsers[_nCont1,3])         
					
						If !Empty(mv_par09)
							Loop  // pega próximo registro
						EndIf
										
						If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
							RecLock("ZZY",.T.)
							ZZY->ZZY_FILIAL := xFilial("ZZY")							
							ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))							
							ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
							ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
							ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
							ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
							ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
							If !Empty(aUsers[_nCont1,1,11]) 		
								PswOrder(1)
								If PswSeek(aUsers[_nCont1,1,11],.T.)				
									inf := PswRet()
									ZZY->ZZY_SUPER := inf[1,4]
								EndIf	
							EndIf	
							ZZY->ZZY_MENU := Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))
							If File(AllTrim(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))        
								ZZY->ZZY_STATUS := "ARQ OK"
							Else                           
								ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
							EndIf
							ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"NÃO")							
							ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]																
							MsUnLock()
						EndIf	
					Next _nCont2				
				EndIf
			Next gLn	
		Else
			For _nCont2 := 1 To Len(aUsers[_nCont1,3])

				If !Empty(mv_par09)
					Loop  // pega próximo registro
				EndIf			
			
				If SubStr(aUsers[_nCont1,3,_nCont2],3,1) <> "X"
					RecLock("ZZY",.T.)        
					ZZY->ZZY_FILIAL := xFilial("ZZY")					   
					ZZY->ZZY_USU    := Upper(SubStr(cUsuario,7,15))												
					ZZY->ZZY_CDUSUA := aUsers[_nCont1,1,2]
					ZZY->ZZY_IDUSUA := aUsers[_nCont1,1,1]
					ZZY->ZZY_NMUSUA := aUsers[_nCont1,1,4]				
					ZZY->ZZY_DEPTO  := aUsers[_nCont1,1,12]				
					ZZY->ZZY_CARGO  := aUsers[_nCont1,1,13]		
					If !Empty(aUsers[_nCont1,1,11]) 		
						PswOrder(1)
						If PswSeek(aUsers[_nCont1,1,11],.T.)				
							inf := PswRet()
							ZZY->ZZY_SUPER := inf[1,4]
						EndIf	
					EndIf	
					ZZY->ZZY_MENU := Upper(SubStr(aUsers[_nCont1,3,_nCont2],4,50))
					If File(AllTrim(SubStr(aUsers[_nCont1,3,_nCont2],4,50)))        
						ZZY->ZZY_STATUS := "ARQ OK"
					Else                           
						ZZY->ZZY_STATUS := "ARQ INEXISTENTE"
					EndIf
					ZZY->ZZY_BLOQ   := If(aUsers[_nCont1,1,17]==.T.,"SIM" ,"NÃO")					
					ZZY->ZZY_EMAIL  := aUsers[_nCont1,1,14]														
					MsUnLock()
				EndIf	
			Next _nCont2
		EndIf	
	EndIf			
Next _nCont1

Private nHdl := fCreate(cArqTxt)

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgStop("O arquivo de nome "+cArqTxt+" não pode ser executado! Verifique os parâmetros.","Atenção!")
Else	
	cCabec := "COD USUÁRIO"      +";" + ;
              "NOME DO USUÁRIO"  +";" + ;
              "DEPARTAMENTO"     +";" + ;              
              "CARGO/FUNÇÃO"     +";" + ;                            
              "NOME SUPERIOR"    +";" + ;              
              "PERFIL DE ACESSO" +";" + ;              
              "MENU DE ACESSO"   +";" + ;              
              "STATUS ARQUIVO"   +";" + ;                            
              "BLOQUEADO"        +";" + ;
              "DT ULT ALTERAÇÃO" +";" + ;
              "E-MAIL"           +";" + ;
              "EMPRESAS"         +      ;                            
		      cEOL
		
	If fWrite(nHdl,cCabec,Len(cCabec)) != Len(cCabec)
		If !MsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
			Return
		Endif
	Endif

Endif

DbSelectArea("ZZY")  // seleciona arquivo de perfil de usuário
ZZY->(DbSetOrder(2))  // muda ordem do índice
ZZY->(DbGoTop())  // vai para o início do arquivo
Do While !ZZY->(Eof())  // percorre todo o arquivo      

	If AllTrim(Upper(ZZY->ZZY_USU)) <> AllTrim(Upper(SubStr(cUsuario,7,15)))
		ZZY->(DbSkip())  // incrementa contador de registros	
		Loop  // pega próximo registro
	EndIf
	
	// valida cancelamento pelo operador
	#IFNDEF WINDOWS
		If LASTKEY() == 286 .Or. LASTKEY() == 27             
			@ PROW()+1, 001 Psay "CANCELADO PELO OPERADOR"
			Exit 
		EndIf
	#ENDIF

	If li > 65  // se quebra de página
		li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIf(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
	EndIf   

	If !Empty(cUsuAnt) .And. cUsuAnt <> ZZY->ZZY_CDUSUA
		li := li + 1  // incrementa contador de linhas                              	               	
	EndIf

	@ li, 000 Psay ZZY->ZZY_CDUSUA  // display do ID do usuário
	@ li, 018 Psay ZZY->ZZY_NMUSUA  // display do nome do usuário
	@ li, 061 Psay ZZY->ZZY_DEPTO   // display do departamento
	@ li, 084 Psay ZZY->ZZY_CARGO   // display do cargo/função
	@ li, 107 Psay ZZY->ZZY_SUPER   // display do superior
	@ li, 130 Psay ZZY->ZZY_PERFIL  // display do perfil de acesso
	@ li, 153 Psay ZZY->ZZY_MENU    // display do menu
	@ li, 206 Psay ZZY->ZZY_STATUS  // display do status do arquivo de menu  
	@ li, 224 Psay ZZY->ZZY_BLOQ    // display do bloqueio do usuário
	
	cDtUltAlt := ""  // Data da última alteração
	cEmpresas := ""  // empresas/filiais
	
	PSWORDER(2)  // muda ordem de índice
	If PswSeek(ZZY->ZZY_CDUSUA) == .T.  // se encontrar usuário no arquivo
		aArray    := PSWRET()
		cDtUltAlt := DToC(aArray[1][16])  // Data da última alteração
		For y = 1 To Len(aArray[2][6])  
			If "@" $ aArray[2][6][y] 
				cEmpresas += IIf(Empty(cEmpresas),"@@@@",'|'+"@@@@")
			Else   
			    cEmpresas += IIf(Empty(cEmpresas),StrZero(Val(aArray[2][6][y]),4),'|'+StrZero(Val(aArray[2][6][y]),4))
			EndIf		   		
		Next y		
	EndIf

	@ li, 235 Psay cDtUltAlt        // display da data da última alteração
	@ li, 255 Psay ZZY->ZZY_EMAIL   // display do e-mail do usuário	
	
	li := li + 1  // incrementa contador de linhas                              	               
	cUsuAnt := ZZY->ZZY_CDUSUA
                     
	cLin := ZZY->ZZY_CDUSUA + ";" + ;
			ZZY->ZZY_NMUSUA + ";" + ;
			ZZY->ZZY_DEPTO  + ";" + ;
			ZZY->ZZY_CARGO  + ";" + ;
			ZZY->ZZY_SUPER  + ";" + ;			
			ZZY->ZZY_PERFIL + ";" + ;
			ZZY->ZZY_MENU   + ";" + ;															
			ZZY->ZZY_STATUS + ";" + ;																		
			ZZY->ZZY_BLOQ   + ";" + ; 	        
			cDtUltAlt       + ";" + ; 	        
			ZZY->ZZY_EMAIL  + ";" + ; 	        
			cEmpresas       +       ;			
			cEOL // Variavel para criacao da linha do registros para gravacao
			
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravação do arquivo. Continua?","Atenção!")
			Exit
		Endif
	Endif

	ZZY->(DbSkip())  // incrementa contador de registros
    	  	
EndDo                                                         

fClose(nHdl)

//_cExec := AllTrim(GetMv("PATCHEXCEL"))
//_cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq
  
//WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL

_cDoc1 := AllTrim(GetMv("PATCH_REDE"))+LcPath+LcNmArq
_cExec := u_ProcuraExcel()
 	
If Aviso("ATENÇÃO" , "Deseja gerar planilha em excel ?", {"Sim" , "Não" } )  =  1
  	WinExec(_cExec + " " + _cDoc1)  // abre planilha no EXCEL
EndIf  
	
cQuery := "  DELETE " + RetSqlname("ZZY") + " WHERE ZZY_USU = '" + AllTrim(Upper(SubStr(cUsuario,7,15))) + "' " 

TCSQLExec(cQuery)
TCSQLExec("Commit")  // executa commit

Set Filter To

Return  // retorno da função
***************************************************************************************************************************************************

Static Function ValidPerg()  // Valida pergunta (SX1)

aRegs := {}
                                                
DbSelectArea("SX1")  // seleciona o arquivo de grupo de perguntas       
SX1->(DbSetOrder(1))  // muda a ordem do ¡ndice
If !SX1->(DbSeek(cPerg))  // posiciona ponteiro

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg,"01","ID Usuário Inicial"    ,"ID Usuário Inicial"    ,"ID Usuário Inicial"    ,"mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	Aadd(aRegs,{cPerg,"02","ID Usuário Final"      ,"ID Usuário Final"      ,"ID Usuário Final"      ,"mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	Aadd(aRegs,{cPerg,"03","Departamento Inicial"  ,"Departamento Inicial"  ,"Departamento Inicial"  ,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"04","Departamento Final"    ,"Departamento Final"    ,"Departamento Final"	 ,"mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"05","Cargo/Função Inicial"  ,"Cargo/Função Inicial"  ,"Cargo/Função Inicial"	 ,"mv_ch5","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"06","Cargo/Função Final"    ,"Cargo/Função Final"    ,"Cargo/Função Final"	 ,"mv_ch6","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"07","Superior Inicial"      ,"Superior Inicial"      ,"Superior Inicial"	     ,"mv_ch7","C",20,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"08","Superior Final"        ,"Superior Final"        ,"Superior Final"	     ,"mv_ch8","C",20,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"09","Perfil Acesso Inicial" ,"Perfil Acesso Inicial" ,"Perfil Acesso Inicial" ,"mv_ch9","C",20,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"10","Perfil Acesso Final"   ,"Perfil Acesso Final"   ,"Perfil Acesso Final"	 ,"mv_chA","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"11","Status Usuário"        ,"Status Usuário"        ,"Status Usuário"	     ,"mv_chB","C",01,0,0,"C","","mv_par11","Liberados","Liberados","Liberados","","","Bloqueados","Bloqueados","Bloqueados","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","","","","",""})	

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
****************************************************************************************************************************************************

User Function gERel001()  // Relatório de Perfil de Acesso por Usuário

Public gFlagParam := .T.  // determina seleção de parâmetros: .T. = seleciona, .F. = não seleciona

Public mv_par01 := ""                      // Código de Usuário Inicial	    
Public mv_par02 := "999999"                // Código de Usuário Final
Public mv_par03 := ""                      // Departamento Inicial
Public mv_par04 := "ZZZZZZZZZZZZZZZZZZZZ"  // Departamento Final
Public mv_par05 := ""                      // Cargo/Função Inicial
Public mv_par06 := "ZZZZZZZZZZZZZZZZZZZZ"  // Cargo/Função Final
Public mv_par07 := ""                      // Superior Inicial
Public mv_par08 := "ZZZZZZZZZZZZZZZZZZZZ"  // Superior Final
Public mv_par09 := ""                      // Perfil de Acesso Inicial
Public mv_par10 := "ZZZZZZZZZZZZZZZZZZZZ"  // Perfil de Acesso Final
Public mv_par11 := "3"                     // Status Usuário

U_gEspR001()  // Relatório de Perfil de Acesso por Usuário			
				
Return  // Retorno da função